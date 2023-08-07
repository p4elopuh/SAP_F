/********** GENERATED on 07/12/2023 at 13:19:23 by CB9980000665**************/
 @OData.entitySet.name: 'SEPM_I_BusinessPartner_E' 
 @OData.entityType.name: 'SEPM_I_BusinessPartner_EType' 
 define root abstract entity ZKAT2_SEPM_I_BUSINESSPARTNER_E { 
 key BusinessPartner : abap.char( 10 ) ; 
 @Odata.property.valueControl: 'BusinessPartnerRole_vc' 
 BusinessPartnerRole : abap.char( 3 ) ; 
 BusinessPartnerRole_vc : RAP_CP_ODATA_VALUE_CONTROL ; 
 @Odata.property.valueControl: 'Currency_vc' 
 Currency : abap.char( 5 ) ; 
 Currency_vc : RAP_CP_ODATA_VALUE_CONTROL ; 
 @Odata.property.valueControl: 'CompanyName_vc' 
 CompanyName : abap.char( 80 ) ; 
 CompanyName_vc : RAP_CP_ODATA_VALUE_CONTROL ; 
 @Odata.property.valueControl: 'LegalForm_vc' 
 LegalForm : abap.char( 10 ) ; 
 LegalForm_vc : RAP_CP_ODATA_VALUE_CONTROL ; 
 @Odata.property.valueControl: 'EmailAddress_vc' 
 EmailAddress : abap.char( 255 ) ; 
 EmailAddress_vc : RAP_CP_ODATA_VALUE_CONTROL ; 
 @Odata.property.valueControl: 'FaxNumber_vc' 
 FaxNumber : abap.char( 30 ) ; 
 FaxNumber_vc : RAP_CP_ODATA_VALUE_CONTROL ; 
 @Odata.property.valueControl: 'PhoneNumber_vc' 
 PhoneNumber : abap.char( 30 ) ; 
 PhoneNumber_vc : RAP_CP_ODATA_VALUE_CONTROL ; 
 @Odata.property.valueControl: 'URL_vc' 
 URL : abap.string( 0 ) ; 
 URL_vc : RAP_CP_ODATA_VALUE_CONTROL ; 
 @Odata.property.valueControl: 'CreationDateTime_vc' 
 CreationDateTime : tzntstmpl ; 
 CreationDateTime_vc : RAP_CP_ODATA_VALUE_CONTROL ; 
 @Odata.property.valueControl: 'LastChangedDateTime_vc' 
 LastChangedDateTime : tzntstmpl ; 
 LastChangedDateTime_vc : RAP_CP_ODATA_VALUE_CONTROL ; 
 @Odata.property.valueControl: 'BuPaApprovalStatus_vc' 
 BuPaApprovalStatus : abap.char( 1 ) ; 
 BuPaApprovalStatus_vc : RAP_CP_ODATA_VALUE_CONTROL ; 
 @Odata.property.valueControl: 'CreatedBySystemUser_vc' 
 CreatedBySystemUser : abap.char( 12 ) ; 
 CreatedBySystemUser_vc : RAP_CP_ODATA_VALUE_CONTROL ; 
 @Odata.property.valueControl: 'LastChangedBySystemUser_vc' 
 LastChangedBySystemUser : abap.char( 12 ) ; 
 LastChangedBySystemUser_vc : RAP_CP_ODATA_VALUE_CONTROL ; 
 @Odata.property.valueControl: 'CityName_vc' 
 CityName : abap.char( 40 ) ; 
 CityName_vc : RAP_CP_ODATA_VALUE_CONTROL ; 
 @Odata.property.valueControl: 'PostalCode_vc' 
 PostalCode : abap.char( 10 ) ; 
 PostalCode_vc : RAP_CP_ODATA_VALUE_CONTROL ; 
 @Odata.property.valueControl: 'StreetName_vc' 
 StreetName : abap.char( 60 ) ; 
 StreetName_vc : RAP_CP_ODATA_VALUE_CONTROL ; 
 @Odata.property.valueControl: 'HouseNumber_vc' 
 HouseNumber : abap.char( 10 ) ; 
 HouseNumber_vc : RAP_CP_ODATA_VALUE_CONTROL ; 
 @Odata.property.valueControl: 'Country_vc' 
 Country : abap.char( 3 ) ; 
 Country_vc : RAP_CP_ODATA_VALUE_CONTROL ; 
 
 } 
