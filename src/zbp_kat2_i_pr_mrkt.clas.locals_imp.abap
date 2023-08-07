CLASS lhc_ProductMarket DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    CONSTANTS:
      BEGIN OF status_confirmation,
        needed TYPE c LENGTH 1  VALUE ' ', "confirmation needed
        stated TYPE c LENGTH 1 VALUE 'X', "confirmed
      END OF status_confirmation.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR ProductMarket RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR ProductMarket RESULT result.

    METHODS Confirm FOR MODIFY
      IMPORTING keys FOR ACTION ProductMarket~Confirm RESULT result.

    METHODS ValidateMarket FOR VALIDATE ON SAVE
      IMPORTING keys FOR ProductMarket~ValidateMarket.

    METHODS CheckDuplicates FOR VALIDATE ON SAVE
      IMPORTING keys FOR ProductMarket~CheckDuplicates.

    METHODS ValidateStartDate FOR VALIDATE ON SAVE
      IMPORTING keys FOR ProductMarket~ValidateStartDate.

    METHODS ValidateEndDate FOR VALIDATE ON SAVE
      IMPORTING keys FOR ProductMarket~ValidateEndDate.

    METHODS SetIsoCode FOR DETERMINE ON SAVE
      IMPORTING keys FOR ProductMarket~SetIsoCode.



ENDCLASS.

CLASS lhc_ProductMarket IMPLEMENTATION.

  METHOD get_instance_features.

    "Read the status of existing product

    READ ENTITIES OF zkat2_I_product IN LOCAL MODE
        ENTITY ProductMarket
          FIELDS ( Status ) WITH CORRESPONDING #( keys )
        RESULT DATA(markets)
        FAILED failed.

    result =
      VALUE #(
        FOR market IN markets
          LET is_confirmed =   COND #( WHEN market-Status = status_confirmation-stated
                                      THEN if_abap_behv=>fc-o-disabled
                                      ELSE if_abap_behv=>fc-o-enabled  )

          IN
            ( %tky                 = market-%tky
              %action-Confirm = is_confirmed

             ) ).


  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD Confirm.

    MODIFY ENTITIES OF zkat2_i_product IN LOCAL MODE
      ENTITY ProductMarket
         UPDATE
           FIELDS ( Status )
           WITH VALUE #( FOR key IN keys
                           ( %tky         = key-%tky
                             Status = status_confirmation-stated
                              ) )
      FAILED failed
      REPORTED reported.

    READ ENTITIES OF zkat2_i_product IN LOCAL MODE
      ENTITY ProductMarket
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(markets).

    result = VALUE #( FOR market IN markets
                        ( %tky   = market-%tky
                          %param = market ) ).

  ENDMETHOD.

  METHOD ValidateMarket.

    READ ENTITIES OF zkat2_I_product IN LOCAL MODE
        ENTITY ProductMarket
          FIELDS ( Mrktid )
          WITH CORRESPONDING #( keys )
        RESULT DATA(productmarkets).

    DATA: markets TYPE SORTED TABLE OF zkat2_i_market WITH UNIQUE KEY Mrktid.

    markets = CORRESPONDING #( productmarkets DISCARDING DUPLICATES MAPPING Mrktid = Mrktid EXCEPT * ).
    DELETE markets WHERE Mrktid IS INITIAL.

    IF markets IS NOT INITIAL.
      SELECT FROM zkat2_i_market FIELDS Mrktid
        FOR ALL ENTRIES IN @markets
        WHERE Mrktid = @markets-Mrktid
        INTO TABLE @DATA(market_db).
    ENDIF.


    LOOP AT productmarkets INTO DATA(productmarket).
      IF productmarket-Mrktid IS INITIAL.
        " Raise message for empty market
        APPEND VALUE #( %tky                   = productmarket-%tky )
         TO failed-productmarket.
        APPEND VALUE #( %tky                   = productmarket-%tky
                        %state_area = 'VALIDATE_MARKET'
                        %msg                   = NEW zcm_kat2_products(
                                                        textid    = zcm_kat2_products=>mrkt_empty
                                                        severity  = if_abap_behv_message=>severity-error )
                        %element-mrktid = if_abap_behv=>mk-on
                        %path                  = VALUE #(  Product-%is_draft = productmarket-%is_draft
                                                Product-ProdUuid = productmarket-ProdUuid )
                      ) TO reported-productmarket.
      ELSEIF NOT line_exists( market_db[ mrktid = productmarket-Mrktid ] ).
        " Raise message for not existing market
        APPEND VALUE #( %tky                   = productmarket-%tky ) TO failed-productmarket.
        APPEND VALUE #( %tky                   = productmarket-%tky
                        %state_area = 'VALIDATE_MARKET'
                        %msg                   = NEW zcm_kat2_products(
                                                        textid    = zcm_kat2_products=>mrkt_unknown
                                                        severity  = if_abap_behv_message=>severity-error )
                        %element-mrktid = if_abap_behv=>mk-on
                        %path                  = VALUE #(  Product-%is_draft = productmarket-%is_draft
                                                Product-ProdUuid = productmarket-ProdUuid )
                      ) TO reported-productmarket.
      ENDIF.
    ENDLOOP.


  ENDMETHOD.

  METHOD CheckDuplicates.

    READ ENTITIES OF zkat2_I_product IN LOCAL MODE
          ENTITY ProductMarket
            FIELDS ( ProdUuid Mrktid )
            WITH CORRESPONDING #( keys )
          RESULT DATA(productmarkets).

    DATA: markets TYPE SORTED TABLE OF zkat2_i_pr_mrkt WITH UNIQUE KEY Mrktid.

    markets = CORRESPONDING #( productmarkets DISCARDING DUPLICATES MAPPING Mrktid = Mrktid
                                                                            ProdUuid = ProdUuid EXCEPT * ).
    DELETE markets WHERE Mrktid IS INITIAL.

    IF markets IS NOT INITIAL.
      SELECT FROM zkat2_i_pr_mrkt FIELDS Mrktid, ProdUuid
        FOR ALL ENTRIES IN @markets
        WHERE Mrktid = @markets-Mrktid AND ProdUuid = @markets-ProdUuid

        INTO TABLE @DATA(market_db).
    ENDIF.


    LOOP AT productmarkets INTO DATA(productmarket).

      IF line_exists( market_db[ mrktid = productmarket-Mrktid ProdUuid = productmarket-ProdUuid ] ).
        " Raise message for duplicated market
        APPEND VALUE #( %tky                   = productmarket-%tky ) TO failed-productmarket.
        APPEND VALUE #( %tky                   = productmarket-%tky
                        %state_area = 'CHECK_DUPLICATES'
                        %msg                   = NEW zcm_kat2_products(
                                                        textid    = zcm_kat2_products=>mrkt_duplicated
                                                        severity  = if_abap_behv_message=>severity-error
                                                        )
                        %element-mrktid = if_abap_behv=>mk-on
                        %path                  = VALUE #(  Product-%is_draft = productmarket-%is_draft
                                                Product-ProdUuid = productmarket-ProdUuid )
                      ) TO reported-productmarket.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.



  METHOD ValidateStartDate.

    " Read relevant instance data
    READ ENTITIES OF zkat2_I_product IN LOCAL MODE
      ENTITY ProductMarket
        FIELDS (
*        Produuid
        Startdate ) WITH CORRESPONDING #( keys )
      RESULT DATA(markets).

    LOOP AT markets INTO DATA(market).
      " Clear state messages that might exist
      APPEND VALUE #(  %tky        = market-%tky
                       %state_area = 'VALIDATE_START_DATE' )
        TO reported-productmarket.

      IF market-Startdate IS INITIAL.
        APPEND VALUE #( %tky               = market-%tky ) TO failed-productmarket.
        APPEND VALUE #( %tky               = market-%tky
                        %state_area        = 'VALIDATE_START_DATE'
                        %msg               = NEW zcm_kat2_products(
                                                 severity  = if_abap_behv_message=>severity-error
                                                 textid    = zcm_kat2_products=>start_date_absent
*                                                 startdate = market-Startdate
                                                 )
                        %element-startdate = if_abap_behv=>mk-on
                        %path       = VALUE #( Product-%is_draft = market-%is_draft
                                                Product-ProdUuid = market-ProdUuid )
                        ) TO reported-productmarket.

      ELSEIF market-Startdate < cl_abap_context_info=>get_system_date( ).
        APPEND VALUE #( %tky               = market-%tky ) TO failed-productmarket.
        APPEND VALUE #( %tky               = market-%tky
                        %state_area        = 'VALIDATE_START_DATE'
                        %msg               = NEW zcm_kat2_products(
                                                 severity  = if_abap_behv_message=>severity-error
                                                 textid    = zcm_kat2_products=>start_date_before_system_date
*                                                 startdate = market-Startdate
                                                 )
                        %element-startdate = if_abap_behv=>mk-on
                        %path       = VALUE #( Product-%is_draft = market-%is_draft
                                                Product-ProdUuid = market-ProdUuid )
                        ) TO reported-productmarket.
      ENDIF.
    ENDLOOP.



  ENDMETHOD.

  METHOD ValidateEndDate.
    " Read relevant instance data
    READ ENTITIES OF zkat2_I_product IN LOCAL MODE
      ENTITY ProductMarket
        FIELDS ( Startdate Enddate ) WITH CORRESPONDING #( keys )
      RESULT DATA(markets).

    LOOP AT markets INTO DATA(market).
      " Clear state messages that might exist
      APPEND VALUE #(  %tky        = market-%tky
                       %state_area = 'VALIDATE_END_DATE' )
        TO reported-productmarket.

      IF market-Enddate IS NOT INITIAL.
        IF market-Enddate <=  market-Startdate.
*                      cl_abap_context_info=>get_system_date( ).
          APPEND VALUE #( %tky               = market-%tky ) TO failed-productmarket.
          APPEND VALUE #( %tky               = market-%tky
                          %state_area        = 'VALIDATE_END_DATE'
                          %msg               = NEW zcm_kat2_products(
                                                   severity  = if_abap_behv_message=>severity-error
                                                   textid    = zcm_kat2_products=>end_date_before_start_date
*                                                 startdate = market-Startdate
                                                   )
                        %element-enddate = if_abap_behv=>mk-on
                          %path       = VALUE #( Product-%is_draft = market-%is_draft
                                                  Product-ProdUuid = market-ProdUuid )
                          ) TO reported-productmarket.
        ENDIF.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD SetIsoCode.

    READ ENTITIES OF zkat2_I_product IN LOCAL MODE
            ENTITY ProductMarket
              FIELDS ( Mrktid Isocode ) WITH CORRESPONDING #( keys )
            RESULT DATA(market).

    LOOP AT market ASSIGNING FIELD-SYMBOL(<fs_market>).
      SELECT SINGLE FROM zkat2_d_market
      FIELDS mrktname
*      FIELDS code
      WHERE mrktid = @<fs_market>-Mrktid
      INTO @DATA(lv_country_code).

      TRY.
          DATA(destination) = cl_soap_destination_provider=>create_by_url(
                  i_url = 'http://webservices.oorsprong.org/websamples.countryinfo/CountryInfoService.wso' ).


          DATA(proxy) = NEW zkat2_co_country_info_service(
                          destination = destination      ).

          DATA(request) = VALUE zkat2_country_isocode_soap_req( s_country_name = lv_country_code ).

          proxy->country_isocode(
            EXPORTING
              input = request
            IMPORTING
              output = DATA(response)
          ).


          "handle response
        CATCH cx_soap_destination_error.
          "handle error
        CATCH cx_ai_system_fault.
          "handle error
      ENDTRY.

*    ENDLOOP.

      IF response-country_isocode_result NE 'No country found by that name'
      AND (  <fs_market>-Isocode IS INITIAL OR <fs_market>-Isocode NE response-country_isocode_result ).
        MODIFY ENTITIES OF zkat2_I_product IN LOCAL MODE
        ENTITY ProductMarket
        UPDATE FIELDS ( Isocode ) WITH VALUE #(
        FOR key IN keys ( %tky = <fs_market>-%tky
        Isocode = response-country_isocode_result )
         ).

      ELSEIF  response-country_isocode_result EQ 'No country found by that name'

      AND <fs_market>-Isocode NE space

*    AND <fs_market>-Isocode IS NOT INITIAL
      .
        MODIFY ENTITIES OF zkat2_I_product IN LOCAL MODE
        ENTITY ProductMarket
        UPDATE FIELDS ( Isocode ) WITH VALUE #(
        FOR key IN keys ( %tky = <fs_market>-%tky
        Isocode = space )
         ).

      ENDIF.

    ENDLOOP.

*    READ ENTITIES OF zkat2_I_product IN LOCAL MODE
*                ENTITY ProductMarket
**                  FIELDS ( Mrktid Isocode ) WITH CORRESPONDING #( keys )
**                RESULT DATA(new_market).
*
*                ALL FIELDS WITH CORRESPONDING #( keys )
*      RESULT DATA(new_market).




  ENDMETHOD.

ENDCLASS.
