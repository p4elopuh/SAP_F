@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'VH for Markets (Countries)'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.resultSet.sizeCategory: #XS
@UI.presentationVariant: [{
                            sortOrder: [{ by: 'Mrktname', direction: #ASC  }]
                         }]

define view entity zkat2_c_market_vh as select from ZKAT2_I_MARKET
{
    @ObjectModel.text.element: ['Mrktname']
    key Mrktid,
    Mrktname,
    Code
}
