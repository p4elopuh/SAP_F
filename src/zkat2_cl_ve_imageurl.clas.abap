CLASS zkat2_cl_ve_imageurl DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

*    INTERFACES if_sadl_exit .
    INTERFACES if_sadl_exit_calc_element_read .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zkat2_cl_ve_imageurl IMPLEMENTATION.


 METHOD if_sadl_exit_calc_element_read~calculate.

    DATA orders TYPE STANDARD TABLE OF zkat2_c_mrkt_ord WITH DEFAULT KEY.
    orders = CORRESPONDING #( it_original_data ).

    LOOP AT orders ASSIGNING FIELD-SYMBOL(<order>).
*      <order>-CustImageURL = 'https://twitter.com/kadabrus/status/1645118911434686464/photo/1'.
      <order>-CustImageURL = 'https://dribbble.com/shots/1696376-Circle-wave?list=shots&sort=popular&timeframe=now&offset=15'.
    ENDLOOP.

    ct_calculated_data = CORRESPONDING #(  orders ).
  ENDMETHOD.

  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
  ENDMETHOD.




ENDCLASS.
