@EndUserText.label: 'Custom Entity for VH Business Partner'
@ObjectModel.query.implementedBy: 'ABAP:ZKAT2_CL_BP_QUERY_PROVIDER'
define custom entity zkat2_i_business_partner_c
  // with parameters parameter_name : parameter_type
{
      @ObjectModel.text.element: ['CompanyName']
  key BusinessPartner : abap.char( 10 );
      // BusinessPartnerRole : abap.char( 3 ) ;
      // Currency : abap.char( 5 ) ;
      CompanyName     : abap.char( 80 );
      // LegalForm : abap.char( 10 ) ;
      EmailAddress    : abap.char( 255 );
      // FaxNumber : abap.char( 30 ) ;
      PhoneNumber     : abap.char( 30 );
      // URL : abap.string( 0 ) ;
      // CreationDateTime : tzntstmpl ;
      // LastChangedDateTime : tzntstmpl ;
      // BuPaApprovalStatus : abap.char( 1 ) ;
      // CreatedBySystemUser : abap.char( 12 ) ;
      // LastChangedBySystemUser : abap.char( 12 ) ;
      // CityName : abap.char( 40 ) ;
      // PostalCode : abap.char( 10 ) ;
      // StreetName : abap.char( 60 ) ;
      // HouseNumber : abap.char( 10 ) ;
      // Country : abap.char( 3 ) ;

}
