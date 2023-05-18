CLASS zcm_kat2_products DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CONSTANTS:
      BEGIN OF pg_unknown,
        msgid TYPE symsgid VALUE 'ZKAT2_RAP_MSG',
        msgno TYPE symsgno VALUE '001',
        attr1 TYPE scx_attrname VALUE 'PGID',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF pg_unknown ,

      BEGIN OF prodid_exist,
        msgid TYPE symsgid VALUE 'ZKAT2_RAP_MSG',
        msgno TYPE symsgno VALUE '002',
        attr1 TYPE scx_attrname VALUE 'PRODID',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF prodid_exist ,

      BEGIN OF start_date_before_system_date,
        msgid TYPE symsgid VALUE 'ZKAT2_RAP_MSG',
        msgno TYPE symsgno VALUE '003',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF
      start_date_before_system_date,

      BEGIN OF end_date_before_start_date,
        msgid TYPE symsgid VALUE 'ZKAT2_RAP_MSG',
        msgno TYPE symsgno VALUE '004',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF
      end_date_before_start_date,

      BEGIN OF start_date_absent,
        msgid TYPE symsgid VALUE 'ZKAT2_RAP_MSG',
        msgno TYPE symsgno VALUE '005',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF
      start_date_absent,

      BEGIN OF mrkt_unknown,
        msgid TYPE symsgid VALUE 'ZKAT2_RAP_MSG',
        msgno TYPE symsgno VALUE '006',
        attr1 TYPE scx_attrname VALUE 'MRKTID',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF mrkt_unknown,

      BEGIN OF mrkt_empty,
        msgid TYPE symsgid VALUE 'ZKAT2_RAP_MSG',
        msgno TYPE symsgno VALUE '007',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF mrkt_empty,

      BEGIN OF mrkt_duplicated,
        msgid TYPE symsgid VALUE 'ZKAT2_RAP_MSG',
        msgno TYPE symsgno VALUE '008',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF mrkt_duplicated,

      BEGIN OF not_confirmed,
        msgid TYPE symsgid VALUE 'ZKAT2_RAP_MSG',
        msgno TYPE symsgno VALUE '009',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF not_confirmed ,

      BEGIN OF end_date_absent,
        msgid TYPE symsgid VALUE 'ZKAT2_RAP_MSG',
        msgno TYPE symsgno VALUE '010',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF end_date_absent ,

      BEGIN OF start_date_before,
        msgid TYPE symsgid VALUE 'ZKAT2_RAP_MSG',
        msgno TYPE symsgno VALUE '011',
        attr1 TYPE scx_attrname VALUE 'STARTDATE',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF start_date_before ,

      BEGIN OF end_date_before,
        msgid TYPE symsgid VALUE 'ZKAT2_RAP_MSG',
        msgno TYPE symsgno VALUE '012',
        attr1 TYPE scx_attrname VALUE 'ENDDATE',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF end_date_before,

      BEGIN OF no_markets,
        msgid TYPE symsgid VALUE 'ZKAT2_RAP_MSG',
        msgno TYPE symsgno VALUE '013',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF no_markets,

      BEGIN OF markets_not_completed,
        msgid TYPE symsgid VALUE 'ZKAT2_RAP_MSG',
        msgno TYPE symsgno VALUE '014',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF markets_not_completed



      .

    INTERFACES if_abap_behv_message .
    INTERFACES if_t100_message .
    INTERFACES if_t100_dyn_msg .

    METHODS constructor
*      IMPORTING
*        !textid   LIKE if_t100_message=>t100key OPTIONAL
*        !previous LIKE previous OPTIONAL .
      IMPORTING
        severity TYPE if_abap_behv_message=>t_severity DEFAULT if_abap_behv_message=>severity-error
        textid   LIKE if_t100_message=>t100key OPTIONAL
        previous TYPE REF TO cx_root OPTIONAL
        startdate  TYPE zkat2_start_date OPTIONAL
        enddate    TYPE zkat2_end_date OPTIONAL
        mrktid   TYPE zkat2_market_id OPTIONAL
        prodid   TYPE zkat2_product_id OPTIONAL
        pgid     TYPE zkat2_pg_id OPTIONAL.

    DATA pgid TYPE string READ-ONLY.
    DATA prodid TYPE string READ-ONLY.
    DATA mrktid TYPE string READ-ONLY.
    DATA startdate TYPE string READ-ONLY.
    DATA enddate TYPE string READ-ONLY.


  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcm_kat2_products IMPLEMENTATION.


  METHOD constructor  ##ADT_SUPPRESS_GENERATION.
    CALL METHOD super->constructor
      EXPORTING
        previous = previous.
    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.

    me->if_abap_behv_message~m_severity = severity.
    me->startdate = startdate.
    me->enddate = enddate.
    me->mrktid = |{ mrktid ALPHA = OUT }|.
    me->pgid = |{ pgid ALPHA = OUT }|.
    me->prodid = |{ prodid ALPHA = OUT }|.
*  Note: The alpha conversion is used for all parameters of type NUMC.

  ENDMETHOD.

ENDCLASS.
