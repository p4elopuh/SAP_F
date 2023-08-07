@EndUserText.label: 'Projection CDS View for MarketOrder'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Search.searchable: true

@ObjectModel.semanticKey: ['Orderid']



define view entity ZKAT2_C_MRKT_ORD
  as projection on ZKAT2_I_MRKT_ORD
{
  key     ProdUuid,
  key     MrktUuid,
  key     OrderUuid,
          @Search.defaultSearchElement: true
          Orderid,
          @Search.defaultSearchElement: true
          Quantity,
          @Search.defaultSearchElement: true
          @EndUserText.label: 'Year'
          CalendarYear,
          @Search.defaultSearchElement: true
          DeliveryDate,
          @Search.defaultSearchElement: true
          @EndUserText.label: 'Net Amount'
          //@Semantics.amount.currencyCode: 'Amountcurr'
          Netamount,
          @Search.defaultSearchElement: true
          //@Semantics.amount.currencyCode: 'Amountcurr'
          Grossamount,
          @Search.defaultSearchElement: true
          Amountcurr,

          //          @ObjectModel.text.element: ['BussPartnerName']
          @ObjectModel.text.element: ['BPCompany']
          @EndUserText.label: 'Business Partner'
          @Consumption.valueHelpDefinition: [{
                                           entity : {
                                                      name:    'zkat2_i_business_partner_c',
                                                      element: 'BusinessPartner'
                                                    },

                                           additionalBinding: [
                                                               { localElement: 'BPCompany',  element: 'CompanyName' },
                                                               { localElement: 'BPEmail', element: 'EmailAddress' },
                                                               { localElement: 'BPPhone', element: 'PhoneNumber' }
                                                              ]
                                        }]
          @Search.defaultSearchElement: true

          BussPartner,
          //          BussPartnerName,
          //          @EndUserText.label: 'Business Partner Group'
          //          BussPartnerGroup,
          @EndUserText.label: 'Business Partner Company'
          BPCompany,
          @EndUserText.label: 'Business Partner Email'
          BPEmail,
          @EndUserText.label: 'Business Partner Phone'
          BPPhone,

          @Search.defaultSearchElement: true
          @EndUserText.label: 'OS Confirmed?'
          Status,

          StatusCriticality,


          @Semantics.imageUrl: true
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZKAT2_CL_VE_IMAGEURL'
  virtual CustImageURL : abap.string( 256 ),
          CreatedBy,
          CreationTime,
          ChangedBy,
          ChangeTime,
          /* Associations */
          _Currency,
          _Product       : redirected to zkat2_c_product,
          _ProductMarket : redirected to parent ZKAT2_C_PR_MRKT
}
