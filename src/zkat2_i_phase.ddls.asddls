@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface CDS View for Phase'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.resultSet.sizeCategory: #XS -- drop down menu for value help
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zkat2_i_phase
  as select from zkat2_d_phase as Phase
{
      @ObjectModel.text.element: ['Phase']
  key phaseid as Phaseid,
      phase   as Phase
}
