@EndUserText.label: 'VH for Product Group'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.resultSet.sizeCategory: #XS
@UI.presentationVariant: [{
                            sortOrder: [{ by: 'Pgid', direction: #ASC  }]
                         }]


define view entity zkat2_c_pg_vh as select from zkat2_I_pg
{
    @ObjectModel.text.element: ['Pgname']
    key Pgid,
    Pgname
}
