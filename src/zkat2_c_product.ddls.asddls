@EndUserText.label: 'Projection CDS View for Product'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true

//this annotation is transferred to MDE, as well as all @UI
//@UI: {
//headerInfo: { typeName: 'Product',
//typeNamePlural: 'Products',
//title: { type: #STANDARD, value: 'Prodid'} } }

@Search.searchable: true

@ObjectModel.semanticKey: ['Prodid']

define root view entity zkat2_c_product
  provider contract transactional_query
  as projection on zkat2_I_product
{
      //      @UI.facet: [{ id: 'Product',
      //      purpose: #STANDARD,
      //      type: #IDENTIFICATION_REFERENCE,
      //      label: 'Product',
      //      position: 10 }]

      //      @UI.hidden: true
  key ProdUuid,

      //      @UI: {
      //      lineItem: [{position: 10, importance: #HIGH }],
      //      identification: [{position: 10, label: 'Product ID [1,...,99999999]' }]}
      @Search.defaultSearchElement: true
      Prodid,

      //      @UI: {
      //      lineItem: [{position: 20, importance: #HIGH }],
      //      identification: [{position: 20 }],
      //      selectionField: [{position: 20 }] }
      @EndUserText.label: 'Product Group'
      @Consumption.valueHelpDefinition: [{entity: {name: 'zkat2_i_pg', element: 'Pgid' }}]
      @ObjectModel.text.element: ['Pgname']
      @Search.defaultSearchElement: true
      Pgid,
      Pgname,

      //      @UI: {
      //      lineItem: [{position: 30, importance: #HIGH }],
      //      identification: [{position: 30 }],
      //      selectionField: [{position: 30 }] }
      @EndUserText.label: 'Phase'
      @Consumption.valueHelpDefinition: [{entity: {name: 'zkat2_i_phase', element: 'Phaseid' }}]
      @ObjectModel.text.element: ['Phase']
      @Search.defaultSearchElement: true
      Phaseid,
      //      @UI.hidden: true
      _Phase.Phase           as Phase,

      PhaseCriticality,

      //      @UI: {
      //            lineItem: [{position: 40, importance: #HIGH }],
      //            identification: [{position: 40 }]
      //            //,
      //            //selectionField: [{position: 40 }]
      //            }
      //      @Semantics.quantity.unitOfMeasure: 'SizeUom'
      Height,
      //      @UI: {
      //            lineItem: [{position: 50, importance: #HIGH }],
      //            identification: [{position: 50 }]
      //            //,
      //            //selectionField: [{position: 50 }]
      //            }
      //      @Semantics.quantity.unitOfMeasure: 'SizeUom'
      Depth,
      //      @UI: {
      //            lineItem: [{position: 60, importance: #HIGH }],
      //            identification: [{position: 60 }]
      //            //,
      //            //selectionField: [{position: 60 }]
      //            }
      //      @Semantics.quantity.unitOfMeasure: 'SizeUom'
      Width,
      @EndUserText.label: 'Size Dimensions'
      Measure,
      //      @UI: {
      //            lineItem: [{position: 70, importance: #HIGH }],
      //            identification: [{position: 70 }]
      //            //,
      //            //selectionField: [{position: 70 }]
      //            }
      @Consumption.valueHelpDefinition: [{ entity : {name: 'zkat2_i_uom' , element: 'Msehi' } }]
      SizeUom,
      //      @UI: {
      //            lineItem: [{position: 80, importance: #MEDIUM }],
      //            identification: [{position: 80, label: 'Price' }]
      //            //,
      //            //selectionField: [{position: 80 }]
      //            }
      @EndUserText.label: 'Net Price'
      @Semantics.amount.currencyCode: 'PriceCurrency'
      @Search.defaultSearchElement: true
      Price,
      @Consumption.valueHelpDefinition: [{entity: {name: 'zkat2_i_currency', element: 'Currency'} }]
      PriceCurrency,

      //      @UI: {
      //            lineItem: [{position: 90, importance: #HIGH }],
      //            identification: [{position: 90 }]
      //            //,
      //            //selectionField: [{position: 90 }]
      //            }
      @EndUserText.label: 'Tax Rate'
      Taxrate,

      @Semantics.imageUrl: true
      _ProductGroup.Imageurl as ImageUrl,

      
      PgnameTrans,
      
      @Consumption.valueHelpDefinition: [{ 
                                           entity : { name:    'zkat2_c_trans_code_vh', 
                                                      element: 'LanguageISOCode' } 
                                        }]
      
      TransCode,
      
      
      //      @UI.hidden: true
      CreatedBy,
      //      @UI.hidden: true
      CreationTime,

      //      @UI.hidden: true
      ChangedBy,

      //      @UI.hidden: true
      ChangeTime,

      _ProductGroup,
      _Phase,
      _UOM,
      _Currency,
            _ProductMarket : redirected to composition child ZKAT2_C_PR_MRKT



}
