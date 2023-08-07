@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Basic CDS view Market-Order for OVP'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED}



define view entity zkat2_i_ovp_mrkt_ord
  as select from zkat2_d_mrkt_ord as MarketOrder

  association [0..1] to ZKAT2_I_OVP_PRODUCT as _Product       on $projection.ProdUuid = _Product.ProdUuid
  association [0..*] to ZKAT2_I_OVP_PR_MRKT as _ProductMarket on $projection.MrktUuid = _ProductMarket.MrktUuid

  //  association [1..*] to zkat2_i_ovp_product as _Product       on $projection.ProdUuid = _Product.ProdUuid
  //    association [1..1] to zkat2_i_ovp_pr_mrkt as _ProductMarket on $projection.MrktUuid = _ProductMarket.MrktUuid
{
  key prod_uuid                                               as ProdUuid,
  key mrkt_uuid                                               as MrktUuid,
  key order_uuid                                              as OrderUuid,
      orderid                                                 as Orderid,
      _Product.Prodid                                         as Prodid,

      _Product._ProductGroup.Pgname                           as ProductName,
      1                                                       as CountByProdGrp,

      _ProductMarket._Market.Country                          as CountryName,
      _ProductMarket.CountryName                              as CountryName2,
      1                                                       as CountByCountry,
      _Product._Phase.Phase                                   as PhaseName,

      calendar_year                                           as CalendarYear,
      delivery_date                                           as DeliveryDate,

      quantity                                                as Quantity,

      @Semantics.amount.currencyCode : 'Amountcurr'
      netamount                                               as Netamount,
      @Semantics.amount.currencyCode : 'Amountcurr'
      grossamount                                             as Grossamount,
      //      @Semantics.currencyCode: true
      amountcurr                                              as Amountcurr,

      @Semantics.amount.currencyCode: 'Amountcurr'
      @EndUserText.label: 'Gross Incom'
      grossamount - netamount                                 as GrossIncom,

      @Semantics.quantity.unitOfMeasure:'Percentage'

      division(( cast((grossamount - netamount) as abap.dec( 15, 2 ))) * 100, 
      ( cast(netamount as abap.dec( 15, 2 )) ), 2) as GrossIncomPercentage,
      
//      division((grossamount - netamount) * 100, netamount, 2) as GrossIncomPercentage,



//      @Semantics.unitOfMeasure:true

      cast(' % ' as abap.unit(3))                             as Percentage,



      @Semantics.quantity.unitOfMeasure:'Percentage'

      30                                                      as TargetGrossIncomPercentage,

      @Semantics.quantity.unitOfMeasure:'Percentage'

      division(( cast((grossamount - netamount) as abap.dec( 15, 2 ))) * 100, 
      ( cast(netamount as abap.dec( 15, 2 )) ), 2) as GrossIncomPercentageList,
//      division((grossamount - netamount) * 100, netamount, 2) as GrossIncomPercentageList,



      @Semantics.quantity.unitOfMeasure:'Percentage'

      division(( cast((grossamount - netamount) as abap.dec( 15, 2 ))) * 100, 
      ( cast(netamount as abap.dec( 15, 2 )) ), 2) as GrIncPercKPI,



      @Semantics.quantity.unitOfMeasure:'Percentage'

      50                                                      as TargetGrIncPercKPI,

      //      @Semantics.amount.currencyCode: 'Amountcurr'
      //      @EndUserText.label: 'Average Gross Incom'
      //      grossamount - netamount                  as GrossIncomAvg,
      //
      //      @Semantics.amount.currencyCode: 'Amountcurr'
      //      @EndUserText.label: 'Maximum Gross Incom'
      //      grossamount - netamount                  as GrossIncomMax,
      //
      //      @Semantics.amount.currencyCode: 'Amountcurr'
      //      @EndUserText.label: 'Minimum Gross Incom'
      //      grossamount - netamount                  as GrossIncomMin,
      //
      //
      //      ------Target Value for KPIs
      //      @Semantics.amount.currencyCode: 'Amountcurr'
      //      cast( 15000000 as abap.dec( 15, 2 ))     as KPITargGrossAmount,
      //
      //      @Semantics.amount.currencyCode: 'Amountcurr'
      //      cast( 8000000      as abap.dec( 15, 2 )) as KPITargGrossIncome,
      //      //
      //      ////      @Semantics.amount.currencyCode: 'Amountcurr'
      //      //
      //      //      15000000                                                as KPITargGrossAmount,
      //      //
      //      //
      //      //
      //      ////      @Semantics.amount.currencyCode: 'Amountcurr'
      //      //
      //      //      8000000                                                 as KPITargGrossIncome,

      /*associations*/

      _ProductMarket, // Make association public
      _Product
}
