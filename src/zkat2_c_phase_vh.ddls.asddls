@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'VH for Phase of Product'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.resultSet.sizeCategory: #XS
@UI.presentationVariant: [{
                            sortOrder: [{ by: 'Phaseid', direction: #ASC  }]
                         }]

define view entity zkat2_c_phase_vh as select from zkat2_i_phase
{
    @ObjectModel.text.element: ['Phase'] 
    key Phaseid,
    Phase
}
