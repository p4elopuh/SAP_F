@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Basic CDS view Markets'
@Metadata.ignorePropagatedAnnotations: true
//@ObjectModel.resultSet.sizeCategory: #XS -- drop down menu for value help
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Analytics.dataCategory: #DIMENSION

define view entity zkat2_i_alp_market
  as select from zkat2_d_market as Market
{
  @ObjectModel.text.element: ['Country']
  key mrktid   as Mrktid,
      mrktname as Country,
      code     as Code,
      imageurl as ImageUrl
}
