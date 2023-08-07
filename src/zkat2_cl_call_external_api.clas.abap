CLASS zkat2_cl_call_external_api DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

*    INTERFACES if_oo_adt_classrun .

    CLASS-METHODS:
      get_translation
        IMPORTING
          ip_pgname            TYPE zkat2_d_prod_gr-pgname
          ip_trans_code        TYPE zkat2_d_product-trans_code
        EXPORTING
          ep_pgname_translated TYPE zkat2_d_product-pgname_trans.


  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zkat2_cl_call_external_api IMPLEMENTATION.





  METHOD get_translation.

    " API key dict.1.1.20230722T233543Z.3562e3507a826844.900306df7ad6b850ce8940ffc04cd14e93ea070d
    " https://dictionary.yandex.net/api/v1/dicservice.json/lookup?key=API-ключ&lang=en-ru&text=time
    DATA lv_url TYPE string .
    DATA lv_api_key TYPE string.
    DATA lv_trans_code TYPE zkat2_d_product-trans_code.
    DATA lv_pgname TYPE zkat2_d_product-pgname_trans.

    TYPES:
      BEGIN OF ls_trans,
        text TYPE string,
        pos  TYPE string,
      END OF ls_trans,
      lt_trans_table TYPE STANDARD TABLE OF ls_trans WITH EMPTY KEY,

      BEGIN OF ls_def,
        text TYPE string,
        pos  TYPE string,
        ts   TYPE string,
        tr   TYPE lt_trans_table,
      END OF ls_def,
      lt_result_table TYPE STANDARD TABLE OF ls_def WITH EMPTY KEY,

      BEGIN OF ls_complete_result_structure,
        head TYPE string,
        def  TYPE lt_result_table,
      END OF ls_complete_result_structure.

    DATA: ls_json TYPE ls_complete_result_structure.


*lv_url = 'https://dictionary.yandex.net/api/v1/dicservice.json/lookup?key=dict.1.1.20230722T233543Z.3562e3507a826844.900306df7ad6b850ce8940ffc04cd14e93ea070d&lang=en-ru&text=time'
    .
    lv_url = 'https://dictionary.yandex.net/api/v1/dicservice.json/lookup?key=' .
    lv_api_key = 'dict.1.1.20230722T233543Z.3562e3507a826844.900306df7ad6b850ce8940ffc04cd14e93ea070d' .
*lv_trans_code = ip_trans_code.

    lv_trans_code = to_lower( ip_trans_code ) .
*lv_pgname = ip_pgname.
*REPLACE ALL OCCURRENCES OF ` ` IN lv_pgname WITH '%20'.

*CONCATENATE lv_url lv_api_key '&lang=en-' lv_trans_code '&text='  lv_pgname INTO  lv_url.

    CONCATENATE lv_url lv_api_key '&lang=en-' lv_trans_code '&text='  ip_pgname INTO  lv_url.

    REPLACE ALL OCCURRENCES OF ` ` IN lv_url WITH '%20'.

    TRY.

        DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination(
        i_destination = cl_http_destination_provider=>create_by_url( i_url = lv_url ) ).

        DATA(lo_request) = lo_http_client->get_http_request(  ).

*DATA(lo_response) = lo_http_client->execute( i_method = if_web_http_client=>get ).

        DATA(lo_response) = lo_http_client->execute( i_method = if_web_http_client=>get )->get_text(  ).




        CALL METHOD /ui2/cl_json=>deserialize
          EXPORTING
*           json         = lo_response->get_text( )
            json         = lo_response
            pretty_name  = /ui2/cl_json=>pretty_mode-camel_case
            assoc_arrays = abap_true
          CHANGING
            data         = ls_json.

        CHECK ls_json IS NOT INITIAL.

        ep_pgname_translated  = ls_json-def[ 1 ]-tr[ 1 ]-text.

        TRANSLATE ep_pgname_translated+0(1) TO UPPER CASE.




      CATCH cx_web_http_client_error cx_http_dest_provider_error.
    ENDTRY.

  ENDMETHOD.

ENDCLASS.
