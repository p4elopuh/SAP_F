@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Basic CDS View Phases for ALP'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Analytics.dataCategory: #DIMENSION

define view entity zkat2_i_alp_phase
  as select from zkat2_d_phase as Phase
{
      @ObjectModel.text.element: ['Phase']
  key phaseid as Phaseid,
      @Semantics.text: true
      @EndUserText.label: 'Product Life Cycle Phase'
      phase   as Phase
}
