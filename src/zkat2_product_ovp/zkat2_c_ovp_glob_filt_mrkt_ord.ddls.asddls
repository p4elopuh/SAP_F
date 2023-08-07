@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cons CDS view Mrkt Order for OVP GF'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZKAT2_c_ovp_glob_filt_MRKT_ORD
  as select from zkat2_i_ovp_mrkt_ord
{
      @UI.hidden: true
  key ProdUuid,
      @UI.hidden: true
  key MrktUuid,
      @UI.hidden: true
  key OrderUuid,
      //      Orderid,
      //      Prodid,
      @UI:{
           selectionField: [{ position: 10 }]
         }
      @Consumption.valueHelpDefinition: [{
                                           entity: { name:    'zkat2_c_pg_vh',
                                                     element: 'Pgname' }
                                        }]
      ProductName,

      @UI:{
            selectionField: [{ position: 20 }]
          }
      @Consumption.valueHelpDefinition: [{
                                           entity: { name:    'zkat2_c_market_vh',
                                                     element: 'Mrktname'}
                                        }]
      CountryName,

      @UI:{
            selectionField: [{ position: 50 }]
          }
      @Consumption.valueHelpDefinition: [{ entity: { name:    'zkat2_c_phase_vh',
                                                     element: 'Phase'}
                                        }]
      PhaseName,

      @Consumption.filter: { selectionType:      #INTERVAL ,
                             multipleSelections:  false      }
      @UI:{            selectionField: [{ position: 30 }]          }
      DeliveryDate,

      Amountcurr,

      @UI:{           selectionField: [{ position: 40 }]          }
      @Semantics.amount.currencyCode : 'Amountcurr'
      GrossIncom,

      /* Associations */
      _Product,
      _ProductMarket
}
