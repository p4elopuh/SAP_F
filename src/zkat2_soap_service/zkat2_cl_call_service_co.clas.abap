CLASS zkat2_cl_call_service_co DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zkat2_cl_call_service_co IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

  try.
    data(destination) = cl_soap_destination_provider=>create_by_url(
            i_url = 'http://webservices.oorsprong.org/websamples.countryinfo/CountryInfoService.wso' ).


*    create_by_comm_arrangement(
*                          comm_scenario  = '<Communication Scenario Name>'
**                          service_id     = '<Outbound Service>'
**                          comm_system_id = '<Communication System Identifier>'
*                        ).


    data(proxy) = new zkat2_co_country_info_service(
                    destination = destination
                  ).
*    data(request) = value zkat2_list_of_continents_by_n1( ).
    DATA(request) = VALUE zkat2_country_isocode_soap_req( s_country_name = 'example' ).

*    proxy->list_of_continents_by_name(
*      exporting
*        input = request
*      importing
*        output = data(response)
*    ).
    proxy->country_isocode(
      exporting
        input = request
      importing
        output = data(response)
    ).

    out->write(  response-country_isocode_result ).
*    out->write( |{ response-res_msg_type-price } { response-res_msg_type-currency }| ).



    "handle response
  catch cx_soap_destination_error.
    "handle error
  catch cx_ai_system_fault.
    "handle error
endtry.



  ENDMETHOD.
ENDCLASS.
