@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Basic CDS view Product-Market for ALP'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED}
@Analytics.dataCategory: #DIMENSION

define view entity zkat2_i_alp_pr_mrkt
  as select from zkat2_d_pr_mrkt as ProductMarket
  
  association [1] to zkat2_i_alp_market as _Market on $projection.Mrktid = _Market.Mrktid
//  association [0..1] to zkat2_i_alp_market as _Market on $projection.Mrktid = _Market.Mrktid
{
  key prod_uuid as ProdUuid,
  key mrkt_uuid as MrktUuid,
      mrktid    as Mrktid,
      _Market.Country as Country,
      status    as Status,

//      case status
//        when 'X'  then 3    -- 'yes'     | 3: green
//        else  1             -- 'no'      | 1: red
//        end     as StatusCriticality,

      isocode   as Isocode,
      startdate as Startdate,
      enddate   as Enddate,

       
      /*Associations*/
      
      _Market
      
}
