@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Basic CDS View Product Groups for ALP'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED}
@Analytics.dataCategory: #DIMENSION
define view entity zkat2_i_alp_prod_gr
  as select from zkat2_d_prod_gr as ProductGroup
{
      @ObjectModel.text.element: ['Pgname']
  key pgid     as Pgid,
      pgname   as Pgname,
      imageurl as Imageurl
}
