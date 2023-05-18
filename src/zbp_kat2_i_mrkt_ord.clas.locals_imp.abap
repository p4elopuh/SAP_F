CLASS lhc_marketorder DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS calculateAmount FOR DETERMINE ON MODIFY
      IMPORTING keys FOR MarketOrder~calculateAmount.

    METHODS calculateOrderID FOR DETERMINE ON SAVE
      IMPORTING keys FOR MarketOrder~calculateOrderID.

    METHODS setCalendarYear FOR DETERMINE ON MODIFY
      IMPORTING keys FOR MarketOrder~setCalendarYear.

    METHODS validateDeliveryDate FOR VALIDATE ON SAVE
      IMPORTING keys FOR MarketOrder~validateDeliveryDate.

    METHODS recalcAmount FOR MODIFY
      IMPORTING keys FOR ACTION MarketOrder~recalcAmount.

ENDCLASS.

CLASS lhc_marketorder IMPLEMENTATION.

  METHOD calculateAmount.

    MODIFY ENTITIES OF zkat2_i_product IN LOCAL MODE
    ENTITY MarketOrder
    EXECUTE recalcAmount
    FROM CORRESPONDING #( keys )
    REPORTED DATA(execute_reported).
    reported = CORRESPONDING #( DEEP execute_reported ).

  ENDMETHOD.

  METHOD calculateOrderID.

    DATA max_orderid TYPE zkat2_order_id.
    DATA update_db TYPE TABLE FOR UPDATE zkat2_i_product\\MarketOrder.

    READ ENTITIES OF zkat2_i_product IN LOCAL MODE
    ENTITY MarketOrder BY \_ProductMarket
      FIELDS ( MrktUuid )
      WITH CORRESPONDING #( keys )
      RESULT DATA(markets).

    LOOP AT markets INTO DATA(market).
      READ ENTITIES OF zkat2_i_product IN LOCAL MODE
        ENTITY ProductMarket BY \_MarketOrder
          FIELDS ( OrderID )
        WITH VALUE #( ( %tky = market-%tky ) )
        RESULT DATA(orders).

      max_orderid = 0.
      LOOP AT orders INTO DATA(order).
        IF order-Orderid > max_orderid.
          max_orderid = order-Orderid.
        ENDIF.
      ENDLOOP.

      LOOP AT orders INTO order WHERE Orderid IS INITIAL.
        max_orderid += 1.
        APPEND VALUE #( %tky      = order-%tky
                        Orderid = max_orderid
                      ) TO update_db.
      ENDLOOP.
    ENDLOOP.

    MODIFY ENTITIES OF zkat2_i_product IN LOCAL MODE
    ENTITY MarketOrder
      UPDATE FIELDS ( Orderid ) WITH update_db
    REPORTED DATA(update_reported).

    reported = CORRESPONDING #( DEEP update_reported ).

  ENDMETHOD.


  METHOD setCalendarYear.

    DATA lv_year TYPE zkat2_year.

    READ ENTITIES OF zkat2_i_product IN LOCAL MODE
          ENTITY MarketOrder
          FIELDS ( DeliveryDate ) WITH CORRESPONDING #( keys )
      RESULT DATA(deliverydates).

    LOOP AT deliverydates ASSIGNING FIELD-SYMBOL(<deliverydate>).
      lv_year = <deliverydate>-DeliveryDate+0(4).


      MODIFY ENTITIES OF zkat2_i_product IN LOCAL MODE
      ENTITY MarketOrder
        UPDATE
          FROM VALUE #( FOR year IN deliverydates INDEX INTO i (
            %tky                  = year-%tky
            CalendarYear          = lv_year
            %control-CalendarYear = if_abap_behv=>mk-on ) )
      REPORTED DATA(update_reported).

      reported = CORRESPONDING #( DEEP update_reported ).
    ENDLOOP.

  ENDMETHOD.


  METHOD validateDeliveryDate.

    READ ENTITIES OF zkat2_i_product IN LOCAL MODE
      ENTITY ProductMarket
        FIELDS ( Startdate Enddate ) WITH CORRESPONDING #( keys )
      RESULT DATA(marketdates).

    LOOP AT marketdates INTO DATA(marketdate).
      READ ENTITIES OF zkat2_i_product IN LOCAL MODE
    ENTITY ProductMarket BY \_MarketOrder
      FIELDS ( DeliveryDate ) WITH VALUE #( ( %tky = marketdate-%tky ) )
    RESULT DATA(orderdates).

      LOOP AT orderdates INTO DATA(orderdate).

        APPEND VALUE #(  %tky        = orderdate-%tky
                         %state_area = 'VALIDATE_DELIVERY_DATE' )
          TO reported-marketorder.

        IF orderdate-DeliveryDate <= marketdate-Startdate.
          APPEND VALUE #( %tky = orderdate-%tky ) TO failed-marketorder.
          APPEND VALUE #(  %tky        = orderdate-%tky
                           %state_area = 'VALIDATE_DELIVERY_DATE'
                           %path       = VALUE #( Product-%is_draft = orderdate-%is_draft
                                                  ProductMarket-%is_draft = orderdate-%is_draft
                                                  Product-ProdUuid = orderdate-ProdUuid
                                                  ProductMarket-ProdUuid = orderdate-ProdUuid )
                           %msg        = NEW zcm_kat2_products(
                                             severity   = if_abap_behv_message=>severity-error
                                             textid     = zcm_kat2_products=>start_date_before
                                             startdate = marketdate-Startdate )
                           %element-DeliveryDate = if_abap_behv=>mk-on )
            TO reported-marketorder.

        ELSEIF marketdate-Enddate is not initial and orderdate-DeliveryDate > marketdate-Enddate.
          APPEND VALUE #( %tky = orderdate-%tky ) TO failed-marketorder.
          APPEND VALUE #(  %tky        = orderdate-%tky
                           %state_area = 'VALIDATE_DELIVERY_DATE'
                           %path       = VALUE #( Product-%is_draft = orderdate-%is_draft
                                                  ProductMarket-%is_draft = orderdate-%is_draft
                                                  Product-ProdUuid = orderdate-ProdUuid
                                                  ProductMarket-ProdUuid = orderdate-ProdUuid )
                           %msg        = NEW zcm_kat2_products(
                                             severity   = if_abap_behv_message=>severity-error
                                             textid     = zcm_kat2_products=>end_date_before
                                             enddate = marketdate-Enddate )
                           %element-DeliveryDate = if_abap_behv=>mk-on )
            TO reported-marketorder.

        ENDIF.
      ENDLOOP.
    ENDLOOP.

  ENDMETHOD.

  METHOD recalcAmount.



*  METHOD recalcTotalFee.

*    TYPES: BEGIN OF ty_amount_per_currencycode,
*             amount        TYPE zkat2_exh_fee,
*             currency_code TYPE zkat2_exh_curr, "/dmo/currency_code,
*           END OF ty_amount_per_currencycode.
*
*    DATA: amount_per_currencycode TYPE STANDARD TABLE OF ty_amount_per_currencycode.
*
*    " Read all relevant exh instances.
*    READ ENTITIES OF zi_kat2_exh IN LOCAL MODE
*          ENTITY Exhibition
*             FIELDS ( ExhFee CurrencyCode )
*             WITH CORRESPONDING #( keys )
*          RESULT DATA(exhibitions).
*
*    DELETE exhibitions WHERE CurrencyCode IS INITIAL.
*
*    LOOP AT exhibitions ASSIGNING FIELD-SYMBOL(<exhibition>).
*      " Set the start for the calculation by adding the exh fee.
*      amount_per_currencycode = VALUE #( ( amount        = <exhibition>-ExhFee
*                                           currency_code = <exhibition>-CurrencyCode ) ).
*      " Read all associated parts and add them to the total price.
*      READ ENTITIES OF ZI_kat2_exh IN LOCAL MODE
*         ENTITY Exhibition BY \_Participation
*            FIELDS ( ExhFee CurrencyCode )
*          WITH VALUE #( ( %tky = <exhibition>-%tky ) )
*          RESULT DATA(participations).
*      LOOP AT participations INTO DATA(participation) WHERE CurrencyCode IS NOT INITIAL.
*        COLLECT VALUE ty_amount_per_currencycode( amount        = participation-ExhFee
*                                                  currency_code = participation-CurrencyCode ) INTO amount_per_currencycode.
*      ENDLOOP.
*
*      CLEAR <exhibition>-TotalFee.
*      LOOP AT amount_per_currencycode INTO DATA(single_amount_per_currencycode).
*        " If needed do a Currency Conversion
*        IF single_amount_per_currencycode-currency_code = <exhibition>-CurrencyCode.
*          <exhibition>-TotalFee += single_amount_per_currencycode-amount.
*        ELSE.
*          /dmo/cl_flight_amdp=>convert_currency(
*             EXPORTING
*               iv_amount                   =  single_amount_per_currencycode-amount
*               iv_currency_code_source     =  single_amount_per_currencycode-currency_code
*               iv_currency_code_target     =  <exhibition>-CurrencyCode
*               iv_exchange_rate_date       =  cl_abap_context_info=>get_system_date( )
*             IMPORTING
*               ev_amount                   = DATA(total_part_fee_per_curr)
*            ).
*          <exhibition>-TotalFee += total_part_fee_per_curr.
*        ENDIF.
*      ENDLOOP.
*    ENDLOOP.
*
*    " write back the modified total_price of travels
*    MODIFY ENTITIES OF zi_kat2_exh IN LOCAL MODE
*      ENTITY Exhibition
*        UPDATE FIELDS ( TotalFee )
*        WITH CORRESPONDING #( exhibitions ).
*
*  ENDMETHOD.

    DATA: lt_amount TYPE TABLE FOR UPDATE zkat2_i_product\\MarketOrder.

    READ ENTITIES OF zkat2_i_product IN LOCAL MODE
          ENTITY Product
             FIELDS ( Price PriceCurrency Taxrate )
             WITH CORRESPONDING #( keys )
          RESULT DATA(product_prices).

    LOOP AT product_prices ASSIGNING FIELD-SYMBOL(<product_price>).

      READ ENTITIES OF zkat2_i_product IN LOCAL MODE
         ENTITY MarketOrder
            FIELDS ( Quantity )
            WITH CORRESPONDING #( keys )
         RESULT DATA(orders).

      CHECK orders IS NOT INITIAL. "check neсessity!!!

      LOOP AT orders ASSIGNING FIELD-SYMBOL(<order>).

        APPEND VALUE #(
               %tky         = <order>-%tky
               Netamount    = <product_price>-Price * <order>-Quantity
               Grossamount  = <product_price>-Price * <order>-Quantity +
                              <product_price>-Price * <order>-Quantity * <product_price>-Taxrate / 100
               Amountcurr   = <product_price>-PriceCurrency
               %control-Netamount = if_abap_behv=>mk-on
               %control-Grossamount = if_abap_behv=>mk-on
               %control-Amountcurr = if_abap_behv=>mk-on
             )    TO lt_amount.

      ENDLOOP.

    ENDLOOP.

    MODIFY ENTITIES OF zkat2_i_product IN LOCAL MODE
           ENTITY MarketOrder
             UPDATE FIELDS ( Netamount
                             Grossamount
                             Amountcurr ) WITH lt_amount
             REPORTED DATA(update_reported).

    reported = CORRESPONDING #( DEEP update_reported ).

  ENDMETHOD.

ENDCLASS.

*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
