@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Basic CDS view Product-Market'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED}

define view entity ZKAT2_I_PR_MRKT
  as select from zkat2_d_pr_mrkt as ProductMarket
  association        to parent zkat2_I_product as _Product on $projection.ProdUuid = _Product.ProdUuid
  composition [0..*] of ZKAT2_I_MRKT_ORD       as _MarketOrder
  //  association [0..*] to zkat2_i_mrkt_ord       as _MarketOrder on $projection.ProdUuid = _MarketOrder.ProdUuid
  //  and $projection.MrktUuid = _MarketOrder.MrktUuid

  association [1..1] to ZKAT2_I_MARKET         as _Market  on $projection.Mrktid = _Market.Mrktid
association [1..1] to ZKAT2_I_MRKT_ORD_T     as _MarketOrderAggr on $projection.MrktUuid = _MarketOrderAggr.MrktUuid
{
  key prod_uuid     as ProdUuid,
  key mrkt_uuid     as MrktUuid,
      mrktid        as Mrktid,
      status        as Status,

      case status
        when 'X'  then 3    -- 'yes'     | 3: green
        else  1             -- 'no'      | 1: red
        end         as StatusCriticality,

      isocode as Isocode,
      startdate     as Startdate,
      enddate       as Enddate,
      
      _MarketOrderAggr.TotalQuantity    as TotalQuantity,
      @Semantics.amount.currencyCode: 'Amountcurr'
      _MarketOrderAggr.TotalNetamount   as TotalNetamount,
      @Semantics.amount.currencyCode: 'Amountcurr'
      _MarketOrderAggr.TotalGrossamount as TotalGrossamount,
      _MarketOrderAggr.Amountcurr       as Amountcurr,
      
      @Semantics.user.createdBy: true
      created_by    as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      @Semantics.dateTime: true
      creation_time as CreationTime,
      @Semantics.user.lastChangedBy: true
      changed_by    as ChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      @Semantics.dateTime: true
      change_time   as ChangeTime,

      _Product, // Make association public
      _Market,
      _MarketOrder,
      _MarketOrderAggr
}
