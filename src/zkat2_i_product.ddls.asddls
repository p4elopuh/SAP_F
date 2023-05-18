@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Basic CDS view Product'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity zkat2_I_product
  as select from zkat2_d_product as Product
  composition [0..*] of ZKAT2_I_PR_MRKT  as _ProductMarket
  //association [0..*] of zkat2_I_pr_mrkt  as _ProductMarket on $projection.ProdUuid = _ProductMarket.ProdUuid
  association [0..1] to zkat2_I_pg       as _ProductGroup on $projection.Pgid = _ProductGroup.Pgid
  association [0..1] to zkat2_i_phase    as _Phase        on $projection.Phaseid = _Phase.Phaseid
  association [0..1] to ZKAT2_I_UOM      as _UOM          on $projection.SizeUom = _UOM.Msehi
  association [1..1] to ZKAT2_I_CURRENCY as _Currency     on $projection.PriceCurrency = _Currency.Currency

  association [0..*] to ZKAT2_I_MRKT_ORD as _MarketOrder  on $projection.ProdUuid = _MarketOrder.ProdUuid
{
  key prod_uuid                                           as ProdUuid,
      prodid                                              as Prodid,
      pgid                                                as Pgid,
      phaseid                                             as Phaseid,

      case Product.phaseid
        when 1 then 1 -- PLAN | 1 - red
        when 2 then 2 -- DEV  | 2 - yellow
        when 3 then 3 -- PROD | 3 - green
                else 0 -- OUT | 0 - unknown
      end                                                 as PhaseCriticality,

      @Semantics.quantity.unitOfMeasure: 'SizeUom'
      height                                              as Height,
      @Semantics.quantity.unitOfMeasure: 'SizeUom'
      depth                                               as Depth,
      @Semantics.quantity.unitOfMeasure: 'SizeUom'
      width                                               as Width,
//      @Semantics.quantity.unitOfMeasure: 'SizeUom'
      concat_with_space( concat_with_space( concat_with_space(cast(height as abap.char(20)), 'x', 1),
                                            concat_with_space(cast(depth as abap.char(20)), 'x', 1), 1),
                         cast(width as abap.char(20)), 1) as Measure,

      size_uom                                            as SizeUom,
      @Semantics.amount.currencyCode : 'PriceCurrency'
      price                                               as Price,
      price_currency                                      as PriceCurrency,
      taxrate                                             as Taxrate,

      /*-- Admin data --*/
      @Semantics.user.createdBy: true
      created_by                                          as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      @Semantics.dateTime: true
      creation_time                                       as CreationTime,
      @Semantics.user.lastChangedBy: true
      changed_by                                          as ChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      @Semantics.dateTime: true
      change_time                                         as ChangeTime,

      /* associations */

      _ProductMarket,
      _ProductGroup,
      _MarketOrder,
      _Phase,
      _UOM,
      _Currency
}
