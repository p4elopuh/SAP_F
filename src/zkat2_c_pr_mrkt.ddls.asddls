@EndUserText.label: 'Projection CDS View for ProductMarket'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Search.searchable: true

@ObjectModel.semanticKey: ['Mrktid']

define view entity ZKAT2_C_PR_MRKT
  //provider contract transactional_query
  as projection on ZKAT2_I_PR_MRKT
{
  key ProdUuid,
  key MrktUuid,

      @Search.defaultSearchElement: true
      @EndUserText.label: 'Market'
      @ObjectModel.text.element: ['MarketName']
      @Consumption.valueHelpDefinition: [{entity : {name: 'ZKAT2_I_MARKET', element: 'Mrktid'} }]
      Mrktid,
      _Market.Mrktname as MarketName,

      @Search.defaultSearchElement: true
      @EndUserText.label: 'Confirmed?'
      Status,

      StatusCriticality,
      
      @EndUserText.label: 'ISO-Code'
      Isocode,
      
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Start Date'
      Startdate,

      @Search.defaultSearchElement: true
      @EndUserText.label: 'End Date'
      Enddate,

      @Semantics.imageUrl: true
      _Market.ImageUrl as ImageUrl,
      
      @EndUserText.label: 'Total Quantity'
      TotalQuantity,

      @EndUserText.label: 'Total NetAmount'
      TotalNetamount,

      @EndUserText.label: 'Total GrossAmount'
      TotalGrossamount,

      Amountcurr,

      CreatedBy,

      CreationTime,

      ChangedBy,

      ChangeTime,

      /* Associations */
      _Market,
      _MarketOrderAggr,
      _MarketOrder : redirected to composition child ZKAT2_C_MRKT_ORD,
      _Product     : redirected to parent zkat2_c_product
}
