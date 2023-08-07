@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Basic CDS view Product for ALP'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define view entity ZKAT2_I_OVP_PRODUCT
  as select from zkat2_d_product as Product
  
  association [1..1] to zkat2_i_ovp_prod_gr    as _ProductGroup on $projection.Pgid = _ProductGroup.Pgid
  association [1..1] to zkat2_i_ovp_phase as _Phase        on $projection.Phaseid = _Phase.Phaseid
  
{
  key prod_uuid            as ProdUuid,
      prodid               as Prodid,
      
      @ObjectModel.text.element: ['Pgname']
      pgid                 as Pgid,
      _ProductGroup.Pgname as Pgname,

      @ObjectModel.text.element: ['Phase']
      phaseid              as Phaseid,
      _Phase.Phase         as Phase,

//      case Product.phaseid
//        when 1 then 1 -- PLAN | 1 - red
//        when 2 then 2 -- DEV  | 2 - yellow
//        when 3 then 3 -- PROD | 3 - green
//                else 0 -- OUT | 0 - unknown
//      end                  as PhaseCriticality,

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

      size_uom as SizeUom,
      
      @Semantics.amount.currencyCode : 'PriceCurrency'
      @Aggregation.default: #NONE
      price                as Price,
      price_currency       as PriceCurrency,
      
//      @Semantics.quantity.unitOfMeasure: 'Percentage'
      taxrate              as Taxrate,
      
//      @Semantics.unitOfMeasure: true
//      cast('%' as abap.unit( 3 )) as Percentage,

      /* associations */

      _ProductGroup,
      _Phase

}
