@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Basic CDS view Market-Order'


define view entity ZKAT2_I_MRKT_ORD
  as select from zkat2_d_mrkt_ord as MarketOrder
  association        to parent ZKAT2_I_PR_MRKT     as _ProductMarket   on  $projection.MrktUuid = _ProductMarket.MrktUuid
                                                                       and $projection.ProdUuid = _ProductMarket.ProdUuid
  //association  [1..1] to zkat2_i_pr_mrkt as _ProductMarket on  $projection.MrktUuid = _ProductMarket.MrktUuid
  //                                                                 and $projection.ProdUuid = _ProductMarket.ProdUuid
  association [1..1] to zkat2_I_product            as _Product         on  $projection.ProdUuid = _Product.ProdUuid
  association [0..1] to ZKAT2_I_CURRENCY           as _Currency        on  $projection.Amountcurr = _Currency.Currency
  association [0..1] to zkat2_i_business_partner_c as _BusinessPartner on  $projection.BussPartner = _BusinessPartner.BusinessPartner

{
  key prod_uuid          as ProdUuid,
  key mrkt_uuid          as MrktUuid,
  key order_uuid         as OrderUuid,
      orderid            as Orderid,
      quantity           as Quantity,
      calendar_year      as CalendarYear,
      delivery_date      as DeliveryDate,
      @Semantics.amount.currencyCode : 'Amountcurr'
      netamount          as Netamount,
      @Semantics.amount.currencyCode : 'Amountcurr'
      grossamount        as Grossamount,
      amountcurr         as Amountcurr,

      busspartner        as BussPartner,
      busspartnercompany as BPCompany,
      busspartneremail   as BPEmail,
      busspartnerphone   as BPPhone,

      status             as Status,

      case status
              when 'X'  then 3    -- 'yes'     | 3: green
              else  1             -- 'no'      | 1: red
              end        as StatusCriticality,

      @Semantics.user.createdBy: true
      created_by         as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      @Semantics.dateTime: true
      creation_time      as CreationTime,
      @Semantics.user.lastChangedBy: true
      changed_by         as ChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      @Semantics.dateTime: true
      change_time        as ChangeTime,


      _ProductMarket, // Make association public
      _Product,
      _Currency,
      _BusinessPartner
}
