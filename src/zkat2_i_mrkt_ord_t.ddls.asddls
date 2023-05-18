@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Agreggated Data for Market-Order'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZKAT2_I_MRKT_ORD_T
  as select from ZKAT2_I_MRKT_ORD
{
      //    key ProdUuid,
  key MrktUuid,
      //    key OrderUuid,
      sum(Quantity)    as TotalQuantity,

      @Semantics.amount.currencyCode: 'Amountcurr'
      sum(Netamount)   as TotalNetamount,

      @Semantics.amount.currencyCode: 'Amountcurr'
      sum(Grossamount) as TotalGrossamount,

      Amountcurr

}
group by
  MrktUuid,
  Amountcurr
