@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Basic CDS View Product Groups'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.resultSet.sizeCategory: #XS -- drop down menu for value help
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zkat2_I_pg
  as select from zkat2_d_prod_gr as ProductGroup
{
      @ObjectModel.text.element: ['Pgname']
  key pgid     as Pgid,
      pgname   as Pgname,
      imageurl as Imageurl
}
