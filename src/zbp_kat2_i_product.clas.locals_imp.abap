CLASS lhc_Product DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    TYPES tt_product_update TYPE TABLE FOR UPDATE zkat2_I_product.

    CONSTANTS:
      BEGIN OF phase_out,
        out TYPE c LENGTH 1  VALUE '4', "OUT
      END OF phase_out.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Product RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Product RESULT result.

    METHODS MakeCopy FOR MODIFY
      IMPORTING keys FOR ACTION Product~MakeCopy RESULT result.

    METHODS MoveToNextPhase FOR MODIFY
      IMPORTING keys FOR ACTION Product~MoveToNextPhase RESULT result.

    METHODS SetFirstPhase FOR DETERMINE ON SAVE
      IMPORTING keys FOR Product~SetFirstPhase.

    METHODS ValidateProdID FOR VALIDATE ON SAVE
      IMPORTING keys FOR Product~ValidateProdID.

    METHODS ValidatePG FOR VALIDATE ON SAVE
      IMPORTING keys FOR Product~ValidatePG.

    METHODS CalculateProdID FOR DETERMINE ON SAVE
      IMPORTING keys FOR Product~CalculateProdID.

    METHODS GetPgnameTransl FOR MODIFY
      IMPORTING keys FOR ACTION Product~GetPgnameTransl RESULT result.

    METHODS SetPgnameTranslation FOR DETERMINE ON SAVE
      IMPORTING keys FOR Product~SetPgnameTranslation.

ENDCLASS.

CLASS lhc_Product IMPLEMENTATION.

  METHOD get_instance_features.
    "Read the phase of existing product

    READ ENTITIES OF zkat2_I_product IN LOCAL MODE
        ENTITY Product
          FIELDS ( Phaseid ) WITH CORRESPONDING #( keys )
        RESULT DATA(products)
        FAILED failed.

    result =
      VALUE #(
        FOR product IN products
          LET is_outed =   COND #( WHEN product-Phaseid = phase_out-out
                                      THEN if_abap_behv=>fc-o-disabled
                                      ELSE if_abap_behv=>fc-o-enabled  )

          IN
            ( %tky                 = product-%tky
              %action-MoveToNextPhase = is_outed
              %action-GetPgnameTransl = if_abap_behv=>fc-o-disabled
             ) ).

  ENDMETHOD.

  METHOD get_instance_authorizations.

  ENDMETHOD.

  METHOD MakeCopy.
    DATA lt_product TYPE TABLE FOR CREATE zkat2_i_product\\product.
    DATA(lv_user)  = cl_abap_context_info=>get_user_alias( ).
    DATA(lv_date) = cl_abap_context_info=>get_system_time( ).

    TRY.
        DATA(lv_produuid)  = cl_system_uuid=>create_uuid_x16_static( ).
      CATCH cx_uuid_error .
    ENDTRY.

    READ ENTITIES OF zkat2_I_product IN LOCAL MODE
    ENTITY Product
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(product_read)
    FAILED failed
    REPORTED reported.

    LOOP AT keys INTO DATA(key).
      DATA(lv_prodid) = key-%param.
*      CALL METHOD lhc_Product->validateprodid EXPORTING parameter = key-%param.
    ENDLOOP.

    LOOP AT product_read ASSIGNING FIELD-SYMBOL(<product>).
      APPEND VALUE #(
*     %cid     = keys[ 1 ]-%cid_ref
                      %data    = CORRESPONDING #( <product> EXCEPT ProdUuid Prodid ) )
        TO lt_product ASSIGNING FIELD-SYMBOL(<new_product>).

      <new_product>-ProdUuid = lv_produuid.
      <new_product>-Prodid = lv_prodid.
      <new_product>-Phaseid  = '1'.
      <new_product>-CreatedBy = lv_user.
      <new_product>-CreationTime = lv_date.
      <new_product>-ChangedBy = lv_user.
      <new_product>-ChangeTime = lv_date.

    ENDLOOP.

    MODIFY ENTITIES OF zkat2_i_product IN LOCAL MODE
      ENTITY Product
        CREATE FIELDS (
                        ProdUuid
                        Prodid
                        Pgid
                        Phaseid
                        Height
                        Depth
                        Width
                        SizeUom
                        Price
                        PriceCurrency
                        Taxrate
                        CreatedBy
                        CreationTime
                        ChangedBy
                        ChangeTime

                        )
          WITH lt_product

      MAPPED mapped
      FAILED DATA(failed_create)
      REPORTED DATA(reported_create).

    result = VALUE #( FOR product IN lt_product INDEX INTO idx
                      (
                        %tky   = keys[ idx ]-%tky
                        %param = CORRESPONDING #( product )
                      )
                  ) .

  ENDMETHOD.


  METHOD MoveToNextPhase.

    DATA lt_phase TYPE TABLE FOR UPDATE zkat2_i_product\\Product.
    DATA lv_status TYPE zkat2_mrkt_status.
    DATA lv_phaseid TYPE zkat2_phase_id.
    DATA lv_enddate TYPE zkat2_end_date.

    "Read the phase of existing product
    READ ENTITIES OF zkat2_I_product IN LOCAL MODE
        ENTITY Product
          FIELDS ( Phaseid ) WITH CORRESPONDING #( keys )
        RESULT DATA(products)
        FAILED failed
        REPORTED reported.

*  Var 1
**********************************************************************
*    LOOP AT products ASSIGNING FIELD-SYMBOL(<product>).
*
*      CASE <product>-Phaseid.
*
*        WHEN 1.
*
*          "Insert conditions for child entity!!!!!
*          READ ENTITIES OF zkat2_I_product IN LOCAL MODE
*          ENTITY Product BY \_ProductMarket
*          FIELDS ( Mrktid ProdUuid ) WITH CORRESPONDING #( keys )
*          RESULT DATA(markets)
*          FAILED failed.
*
*          IF markets IS NOT INITIAL.
*            <product>-Phaseid += 1.
*          ELSE.
*            APPEND VALUE #(  %tky = <product>-%tky ) TO failed-product.
*
*            APPEND VALUE #(  %tky        = <product>-%tky
*                             %state_area = 'NO_MARKETS'
*                             %msg        = NEW zcm_kat2_products(
*                                               severity   = if_abap_behv_message=>severity-error
*                                               textid     = zcm_kat2_products=>no_markets )
*                             %element-PhaseId = if_abap_behv=>mk-on
*                              )
*              TO reported-product.
*          ENDIF.
*
*
*        WHEN 2.
*
*          "Insert conditions for child entity!!!!!
*          READ ENTITIES OF zkat2_I_product IN LOCAL MODE
*          ENTITY Product BY \_ProductMarket
*          FIELDS ( Status ) WITH CORRESPONDING #( keys )
*          RESULT DATA(statuses)
*          FAILED failed.
*
*          LOOP AT statuses ASSIGNING FIELD-SYMBOL(<status>).
*            IF <status>-Status EQ 'X'.
**              DATA(lv_status) = 'X'.
*              lv_status = 'X'.
*              EXIT.
*            ENDIF.
*          ENDLOOP.
*          IF lv_status = 'X'.
*
*            <product>-Phaseid += 1.
*          ELSE.
*            APPEND VALUE #(  %tky = <product>-%tky ) TO failed-product.
*
*            APPEND VALUE #(  %tky        = <product>-%tky
*                             %state_area = 'NOT_CONFIRMED'
*                             %msg        = NEW zcm_kat2_products(
*                                               severity   = if_abap_behv_message=>severity-error
*                                               textid     = zcm_kat2_products=>not_confirmed )
*                             %element-PhaseId = if_abap_behv=>mk-on
*                              )
*              TO reported-product.
*          ENDIF.
*
*        WHEN 3.
*
*          DATA(lv_date) = cl_abap_context_info=>get_system_date( ).
*
*          "Insert conditions for child entity!!!!!
*          READ ENTITIES OF zkat2_I_product IN LOCAL MODE
*          ENTITY Product BY \_ProductMarket
*          FIELDS ( Enddate ) WITH CORRESPONDING #( keys )
*          RESULT DATA(enddates)
*          FAILED failed.
*
*          LOOP AT enddates ASSIGNING FIELD-SYMBOL(<enddate>).
*            IF <enddate>-Enddate > lv_date.
*              DATA(lv_enddate) = 'X'.
*              EXIT.
*            ENDIF.
*          ENDLOOP.
*
*          IF lv_enddate NE 'X'.
*            <product>-Phaseid += 1.
*          ELSE.
*            APPEND VALUE #(  %tky = <product>-%tky ) TO failed-product.
*
*            APPEND VALUE #(  %tky        = <product>-%tky
*                             %state_area = 'MARKETS_NOT_COMPLETED'
*                             %msg        = NEW zcm_kat2_products(
*                                               severity   = if_abap_behv_message=>severity-error
*                                               textid     = zcm_kat2_products=>markets_not_completed )
*                             %element-PhaseId = if_abap_behv=>mk-on
*                              )
*              TO reported-product.
*          ENDIF.
*
*      ENDCASE.
*
*      APPEND VALUE #(
*             %tky             = <product>-%tky
*             PhaseID          = <product>-PhaseId
*             %control-PhaseID = if_abap_behv=>mk-on ) TO lt_phase.
*
*    ENDLOOP.
**********************************************************************
*  Var 2
**********************************************************************
    lv_phaseid = products[ 1 ]-Phaseid.

* LOOP AT products ASSIGNING FIELD-SYMBOL(<product>).

    CASE lv_phaseid.

      WHEN 1.

        "Insert conditions for child entity!!!!!
        READ ENTITIES OF zkat2_I_product IN LOCAL MODE
        ENTITY Product BY \_ProductMarket
        FIELDS ( Mrktid ProdUuid ) WITH CORRESPONDING #( keys )
        RESULT DATA(markets)
        FAILED failed.

        IF markets IS NOT INITIAL.
          lv_phaseid += 1.
        ELSE.
          APPEND VALUE #(  %tky = products[ 1 ]-%tky )  TO failed-product.

          APPEND VALUE #(  %tky        = products[ 1 ]-%tky
                           %state_area = 'NO_MARKETS'
                           %msg        = NEW zcm_kat2_products(
                                             severity   = if_abap_behv_message=>severity-error
*                                             severity   = if_abap_behv_message=>severity-information
                                             textid     = zcm_kat2_products=>no_markets )
                           %element-PhaseId = if_abap_behv=>mk-on
*                           %action-MoveToNextPhase = if_abap_behv=>mk-on
                            )
            TO reported-product.
        ENDIF.


      WHEN 2.

        "Insert conditions for child entity!!!!!
        READ ENTITIES OF zkat2_I_product IN LOCAL MODE
        ENTITY Product BY \_ProductMarket
        FIELDS ( Status ) WITH CORRESPONDING #( keys )
        RESULT DATA(statuses)
        FAILED failed.

        LOOP AT statuses ASSIGNING FIELD-SYMBOL(<status>).
          IF <status>-Status EQ 'X'.

            lv_status = 'X'.
            EXIT.
          ENDIF.
        ENDLOOP.
        IF lv_status = 'X'.

          lv_phaseid += 1.
        ELSE.
          APPEND VALUE #(  %tky = products[ 1 ]-%tky ) TO failed-product.

          APPEND VALUE #(  %tky        = products[ 1 ]-%tky
                           %state_area = 'NOT_CONFIRMED'
                           %msg        = NEW zcm_kat2_products(
                                             severity   = if_abap_behv_message=>severity-error
                                             textid     = zcm_kat2_products=>not_confirmed
                                              )
                           %element-PhaseId = if_abap_behv=>mk-on
                            )
            TO reported-product.
        ENDIF.

      WHEN 3.

        DATA(lv_date) = cl_abap_context_info=>get_system_date( ).


        "Insert conditions for child entity!!!!!
        READ ENTITIES OF zkat2_I_product IN LOCAL MODE
        ENTITY Product BY \_ProductMarket
        FIELDS ( Enddate ) WITH CORRESPONDING #( keys )
        RESULT DATA(enddates)
        FAILED failed.

        LOOP AT enddates ASSIGNING FIELD-SYMBOL(<enddate>).
          IF <enddate>-Enddate > lv_date.
*              DATA(lv_enddate) = 'X'.
            lv_enddate = 'X'.
            EXIT.
          ENDIF.
        ENDLOOP.

        IF lv_enddate NE 'X'.
          lv_phaseid += 1.
        ELSE.
          APPEND VALUE #(  %tky = products[ 1 ]-%tky ) TO failed-product.

          APPEND VALUE #(  %tky        = products[ 1 ]-%tky
                           %state_area = 'MARKETS_NOT_COMPLETED'
                           %msg        = NEW zcm_kat2_products(
                                             severity   = if_abap_behv_message=>severity-error
                                             textid     = zcm_kat2_products=>markets_not_completed )
                           %element-PhaseId = if_abap_behv=>mk-on
                            )
            TO reported-product.
        ENDIF.

    ENDCASE.
**********************************************************************
    IF lv_phaseid NE products[ 1 ]-Phaseid.

      APPEND VALUE #(
             %tky             = products[ 1 ]-%tky
             PhaseID          = lv_phaseid
             %control-PhaseID = if_abap_behv=>mk-on ) TO lt_phase.




      " Set the new Phase
      MODIFY ENTITIES OF zkat2_I_product IN LOCAL MODE
        ENTITY Product
           UPDATE
             FIELDS ( Phaseid )
             WITH lt_phase
      FAILED failed
      REPORTED reported
        .

      " Fill the response table
      READ ENTITIES OF zkat2_I_product IN LOCAL MODE
        ENTITY Product
          ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(new_products).

      result = VALUE #( FOR product IN new_products
                          ( %tky   = product-%tky
                            %param = product ) ).

      "add success MESSAGE at the END of the action
      APPEND VALUE #( %tky        = products[ 1 ]-%tky
                      %msg = NEW zcm_kat2_products(
                               textid        = zcm_kat2_products=>action_successful
                               severity      = if_abap_behv_message=>severity-success  )
                      %element-PhaseId = if_abap_behv=>mk-on
                      %action-MoveToNextPhase    = if_abap_behv=>mk-on
               ) TO reported-product.

    ENDIF.

  ENDMETHOD.



  METHOD SetFirstPhase.

    " Read relevant product instance data
    READ ENTITIES OF zkat2_I_product IN LOCAL MODE
        ENTITY Product
          FIELDS ( Phaseid ) WITH CORRESPONDING #( keys )
        RESULT DATA(products).

    " Remove all product instance data with defined phase
    DELETE products WHERE Phaseid IS NOT INITIAL.
    CHECK products IS NOT INITIAL.

    " Set default exhibition status
    MODIFY ENTITIES OF zkat2_I_product IN LOCAL MODE
    ENTITY product
      UPDATE
        FIELDS ( Phaseid )
*        WITH VALUE #( FOR product IN products
*                      ( %tky         = product-%tky
*                        Phaseid = '1' ) )  "Plan
        WITH VALUE #( FOR key IN keys
                      ( %tky         = key-%tky
                        Phaseid = '1' ) )  "Plan


    REPORTED DATA(update_reported).

    reported = CORRESPONDING #( DEEP update_reported ).

  ENDMETHOD.


  METHOD ValidateProdID.
    " Read relevant product instance data
    READ ENTITIES OF zkat2_I_product IN LOCAL MODE
        ENTITY Product
          FIELDS ( Prodid ) WITH CORRESPONDING #( keys )
        RESULT DATA(products).

    DATA productid TYPE SORTED TABLE OF zkat2_d_product WITH UNIQUE KEY prodid.

    productid = CORRESPONDING #(  products DISCARDING DUPLICATES MAPPING prodid = Prodid EXCEPT * ).
    DELETE productid WHERE prodid IS INITIAL.

    IF productid IS NOT INITIAL.
      SELECT FROM zkat2_d_product FIELDS prodid
      FOR ALL ENTRIES IN @productid
      WHERE prodid = @productid-prodid
      INTO TABLE @DATA(lt_productid).
    ENDIF.

    LOOP AT products INTO DATA(product).
      " Clear state messages that might exist
      APPEND VALUE #(  %tky               = product-%tky
                       %state_area        = 'VALIDATE_PODUCTID' )
        TO reported-product.

      IF line_exists( lt_productid[ prodid = product-Prodid ] ).
        APPEND VALUE #( %tky = product-%tky ) TO failed-product.

        APPEND VALUE #( %tky        = product-%tky

                        %state_area = 'VALIDATE_PODUCTID'
                        %msg        = NEW zcm_kat2_products(
                                          severity = if_abap_behv_message=>severity-error
                                          textid   = zcm_kat2_products=>prodid_exist
                                          prodid = product-Prodid )
                        %element-Prodid = if_abap_behv=>mk-on
                         )
          TO reported-product.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.




  METHOD ValidatePG.
    " Read relevant product instance data
    READ ENTITIES OF zkat2_I_product IN LOCAL MODE
        ENTITY Product
          FIELDS ( Pgid ) WITH CORRESPONDING #( keys )
        RESULT DATA(products).

    DATA prodgroup TYPE SORTED TABLE OF zkat2_d_prod_gr WITH UNIQUE KEY pgid.

    prodgroup = CORRESPONDING #( products DISCARDING DUPLICATES MAPPING pgid = Pgid EXCEPT * ).
    DELETE prodgroup WHERE Pgid IS INITIAL.

    IF prodgroup IS NOT INITIAL.
      SELECT FROM zkat2_d_prod_gr FIELDS pgid
      FOR ALL ENTRIES IN @prodgroup
      WHERE pgid = @prodgroup-pgid
      INTO TABLE @DATA(lt_prodgroup).
    ENDIF.

    LOOP AT products INTO DATA(product).
      " Clear state messages that might exist
      APPEND VALUE #(  %tky               = product-%tky
                       %state_area        = 'VALIDATE_PG' )
        TO reported-product.

      IF product-Pgid IS INITIAL OR NOT line_exists( lt_prodgroup[ pgid = product-Pgid ] ).
        APPEND VALUE #( %tky = product-%tky ) TO failed-product.

        APPEND VALUE #( %tky        = product-%tky
                        %state_area = 'VALIDATE_PG'
                        %msg        = NEW zcm_kat2_products(
                                          severity = if_abap_behv_message=>severity-error
                                          textid   = zcm_kat2_products=>pg_unknown
                                          pgid = product-Pgid )
                        %element-Pgid = if_abap_behv=>mk-on )
          TO reported-product.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.



  METHOD CalculateProdID.
  ENDMETHOD.

  METHOD GetPgnameTransl.

  ENDMETHOD.

  METHOD SetPgnameTranslation.

    DATA lv_pgname_translated TYPE zkat2_d_product-pgname_trans.
    DATA lt_pgname_up TYPE TABLE FOR UPDATE zkat2_i_product\\Product.

    READ ENTITIES OF zkat2_i_product IN LOCAL MODE
      ENTITY Product
        FIELDS ( Pgname TransCode ) WITH CORRESPONDING #( keys )
    RESULT DATA(lt_pgname).

    DATA(lv_pgname)    = lt_pgname[ 1 ]-Pgname.
    DATA(lv_transcode) = lt_pgname[ 1 ]-TransCode.

    " insert calling corresponding class
**********************************************************************
     zkat2_cl_call_external_api=>get_translation(
                        EXPORTING
                          ip_pgname = lv_pgname
                          ip_trans_code = lv_transcode
                        IMPORTING
                          ep_pgname_translated = lv_pgname_translated
                      ).

**********************************************************************
    MODIFY ENTITIES OF zkat2_i_product IN LOCAL MODE
            ENTITY Product
              UPDATE
                FIELDS ( PgnameTrans )
                WITH VALUE #(
*                FOR ls_pgname IN lt_pgname
                              ( %tky        = lt_pgname[ 1 ]-%tky
                                PgnameTrans = lv_pgname_translated ) )
*                 WITH VALUE #( FOR key IN keys
*                      ( %tky         = key-%tky
*                        PgnameTrans = lv_pgname_translated ) )  "
            REPORTED DATA(update_reported).

    reported = CORRESPONDING #( DEEP update_reported ).


ENDMETHOD.

ENDCLASS.
