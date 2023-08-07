@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cons CDS view Mrkt Order for OVP Cards'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

@UI.headerInfo: { //StackCard  Orders List
                  typeName:       'Order',
                  typeNamePlural: 'Orders',
                  imageUrl:       'IconUrl',
                  title:         { label: 'Order ID', value: 'Orderid' },
                  description:   { type:   #STANDARD, value: 'PhaseName' }
                }
@UI.chart: [
            { //Chart  Total Quantity of Orders:
                //Tab1   by Country
              qualifier:             'OrdQuanByCountry',
              title:                 'By Countrys',
              chartType:              #COLUMN,
              dimensions:          [ 'CountryName'],
              measures:            [ 'CountByCountry'],
              dimensionAttributes: [{ dimension: 'CountryName',  role: #CATEGORY }],
              measureAttributes:   [{ measure:   'CountByCountry', role: #AXIS_1 }]
            },
            {   //Tab2   by Product Groups
              qualifier:             'OrdQuanByProdGr',
              title:                 'By Product Groups',
              chartType:              #COLUMN,
              dimensions:          [ 'ProductName'],
              measures:            [ 'CountByProdGrp'],
              dimensionAttributes: [{ dimension: 'ProductName',  role: #CATEGORY }],
              measureAttributes:   [{ measure:   'CountByProdGrp', role: #AXIS_1 }]
            },
            
           ------------------
            { //Chart AVG Income by Countries
              qualifier:            'AVGIncomeCountry',
              title:                'by Countries',
              chartType:             #DONUT,
              dimensions:          ['CountryName'],
              measures:            ['GrossIncomPercentage'],
              dimensionAttributes: [{ dimension: 'CountryName' } ],
              measureAttributes:   [{ measure:   'GrossIncomPercentage', role: #AXIS_1 }]
            }
           ]

-----------------------------

@UI.presentationVariant: [
                          { //Chart  Total Quantity of Orders:
                              //Tab1   by Country
                            qualifier:      'pvOrdQuanByCountry',
                            visualizations: [{
                                              type:      #AS_CHART,
                                               qualifier: 'OrdQuanByCountry'
                                            }],
                            sortOrder:      [{ by: 'CountryName', direction: #ASC }]
                          },
                          {   //Tab2   by Product Groups
                            qualifier:      'pvOrdQuanByProdGr',
                            visualizations: [{
                                               type:      #AS_CHART,
                                               qualifier: 'OrdQuanByProdGr'
                                            }],
                            sortOrder:      [{ by: 'ProductName', direction: #ASC }]
                          },

                         --------------

                          { //Chart AVG Income by Countries
                            qualifier:      'pvAVGIncomeCountry',
                            visualizations: [{
                                               type:      #AS_CHART,
                                               qualifier: 'AVGIncomeCountry'
                                            }],
                            sortOrder:      [{ by: 'CountryName',          direction: #ASC },
                                             { by: 'GrossIncomPercentage', direction: #DESC}]
                          },

                         --------------

                          { //ListCard  Orders List
                            qualifier:      'pvOrdersList',
                            visualizations: [{
                                               type:      #AS_LINEITEM,
                                               qualifier: 'OrdersList'
                                            }],
                            sortOrder: [
                                        {by: 'GrossIncomPercentage', direction: #DESC},
                                        {by: 'Orderid',              direction: #ASC }
                                       ]
                          }
                         ]

define view entity ZKAT2_c_ovp_cards_MRKT_ORD
  as select from zkat2_i_ovp_mrkt_ord
{

      @UI.facet: [//StackCard  Orders List
                    {
                      isSummary:        true,
                      qualifier:       'StackOrdersList',
                      label:           'StackOrdersListGenInf',
                      type:             #FIELDGROUP_REFERENCE,
                      targetQualifier: 'StackOrdersListGenInf'
                    } ,
                    {
                      isSummary:        true,
                      qualifier:       'StackOrdersList',
                      label:           'StackOrdersListFD',
                      type:             #FIELDGROUP_REFERENCE,
                      targetQualifier: 'StackOrdersListFD'
                    }
                   ]

  key ProdUuid,
  key MrktUuid,
  key OrderUuid,

//      @UI: {
//              lineItem:        [{ //ListCard  Orders List
//                                  qualifier: 'OrdersList',
//                                  type:       #AS_DATAPOINT,
//                                  position:   20,
//                                  importance: #HIGH
//                               }],
//              dataPoint.title:   'Order ID',
//              identification: [{ //StackCard  Orders List
//                                 qualifier:            'FaceSide',
//                                 position:              10,
//                                 label:                'Product ID'//,
//      //                                semanticObjectAction: 'listreportaction',
//      //                                type:                  #FOR_INTENT_BASED_NAVIGATION
//                              }]
//            }
//            
            @UI: {
             lineItem:        [{ //ListCard  Orders List
                                 qualifier: 'OrdersList',
                                 type:       #AS_DATAPOINT,
                                 position:   20,
                                 importance: #HIGH
                              }],
             dataPoint.title:   'Order ID',
             identification: [{ //StackCard  Orders List
                                qualifier:            'FaceSide',
                                position:              10,
                                label:                'Product ID',
                                semanticObjectAction: 'manage',
                                type:                  #FOR_INTENT_BASED_NAVIGATION
                             }]
           }
//      @Consumption.semanticObject: 'zpip_products_git'
            
      Orderid,
      Prodid,
      
      @UI: {

             lineItem:   [{ //ListCard  Orders List
                            qualifier: 'OrdersList',  
                            position:   10,
                            importance: #HIGH
                         }],
             fieldGroup: [{ //StackCard  Orders List
                            qualifier: 'StackOrdersListGenInf',
                            position:   10,  
                            label:     'Product Name'
                         }]
           }
      @UI.identification: [{ //StackCard  Orders List
                             qualifier:            'FlipSide',
                             semanticObjectAction: 'manage',
                             type:                  #FOR_INTENT_BASED_NAVIGATION,
                             position:              10
                          }]

//      @Consumption.semanticObject: 'zpip_products_git'
      ProductName,
      
      //Chart Tab2 Total Quantity of Orders
      @UI.dataPoint: {
                       qualifier:               'dpOrdQuanByProdGr',
                       criticalityCalculation: { improvementDirection: #MAXIMIZE,
                                                 deviationRangeLowValue: 10,
                                                 toleranceRangeLowValue: 15 }
                     }
      @Aggregation.default: #SUM
      @EndUserText.label: 'Quantity by Product Groups'
      CountByProdGrp,
      
      @UI: {
             lineItem:   [{ //ListCard  Orders List
                            qualifier: 'OrdersList',  
                            position:   20,
                            importance: #HIGH
                         }],
             fieldGroup: [{ //StackCard  Orders List
                            qualifier: 'StackOrdersListGenInf',  
                            label:     'Market',
                            position:   20
                         }]
           }
      CountryName,
      CountryName2,
      
       //Chart Tab1 Total Quantity of Orders
      @UI.dataPoint: {
                       qualifier:               'dpOrdQuanByCountry',
                       criticalityCalculation: { improvementDirection: #MAXIMIZE,
                                                 deviationRangeLowValue: 10,
                                                 toleranceRangeLowValue: 15 }
                     }
      @Aggregation.default: #SUM
      @EndUserText.label: 'Quantity by Countries'
      CountByCountry,
      PhaseName,
      
      @UI.fieldGroup: [{ //StackCard  Orders List
                         qualifier: 'StackOrdersListGenInf',  
                         position:   30,
                         label:     'Year of Issue'
                      }]
      CalendarYear,
      
      @UI.fieldGroup: [{ //SrackCard  Orders List
                         qualifier: 'StackOrdersListGenInf',  
                         position:   40,
                         label: 'Delivery'
                      }]
      DeliveryDate,
      
       @UI.fieldGroup: [{ //StackCard  Orders List
                         qualifier: 'StackOrdersListFD',  
                         position:   10,
                         label: 'Quantity, pieces'
                      }]
      Quantity,
      
      @UI.fieldGroup: [{ //StackCard  Orders List
                         qualifier: 'StackOrdersListFD',  
                         position:   20,
                         label: 'Net Amount'
                      }]
                      @Semantics.amount.currencyCode : 'Amountcurr'
      Netamount,
      
      @UI.fieldGroup: [{ //StackCard  Orders List
                         qualifier: 'StackOrdersListFD',  
                         position:   30,
                         label: 'Gross Amount'
                      }]
                      @Semantics.amount.currencyCode : 'Amountcurr'
      Grossamount,
      Amountcurr,
      
      @UI:  {
              lineItem: [{ //ListCard  Orders List
                           qualifier: 'OrdersList',  
                           position: 10,
                           type: #AS_DATAPOINT,
                           importance: #HIGH 
                        }],
              dataPoint: {
                           valueFormat.numberOfFractionalDigits: 2,
                           valueFormat.scaleFactor: 1000000
                         },
               fieldGroup: [{ //StackCard  Orders List
                             qualifier: 'StackOrdersListFD',  
                             position:   40,
                            label: 'Gross Income'
                          }]
            }
            @Semantics.amount.currencyCode : 'Amountcurr'
      GrossIncom,
      
      @UI:{

            dataPoint: { //Chart AVG Income by Countries (KPI)

                         qualifier: 'dpAVGIncomeCountry',

                         valueFormat.numberOfFractionalDigits: 1 ,

                         criticalityCalculation: { improvementDirection: #MAXIMIZE,

                                                   deviationRangeLowValue: 25,

                                                   toleranceRangeLowValue: 30 },

                         trendCalculation:       { referenceValue:'TargetGrossIncomPercentage',

                                                   downDifference: 0,

                                                   upDifference: 0 }

                       },

            

            fieldGroup: [{ //StackCard  Orders List

                           qualifier: 'StackOrdersListFD',  

                           position:   50,

                           label: 'Gross Income Percentage'

                        }]

          }

      @EndUserText.label:   'Average Gross Income Percentage'

      @Aggregation.default: #AVG

      @Semantics.quantity.unitOfMeasure:'Percentage'
      
      GrossIncomPercentage,
      
//      @Semantics.unitOfMeasure:true
      Percentage,
      
      @Semantics.quantity.unitOfMeasure:'Percentage'
      TargetGrossIncomPercentage,
      
      @UI: {

             lineItem:  [{ //ListCard  Orders List

                           qualifier: 'OrdersList',

                           position:   10,

                           importance: #HIGH,

                           type:       #AS_DATAPOINT

                        }],

             dataPoint: {

                          criticalityCalculation: { improvementDirection: #MAXIMIZE,

                                                    deviationRangeLowValue: 40,

                                                    toleranceRangeLowValue: 50 }

                        }

           }    

      @Semantics.quantity.unitOfMeasure:'Percentage'
      GrossIncomPercentageList,
      
      @UI.dataPoint: { //ListCard  Orders List (KPI)

                       qualifier: 'dpAVGIncomeCountryList',

                       valueFormat.numberOfFractionalDigits: 1 ,

                       criticalityCalculation: { improvementDirection: #MAXIMIZE,

                                                 deviationRangeLowValue: 40,

                                                 toleranceRangeLowValue: 50 },

                       trendCalculation:       { referenceValue:'TargetGrIncPercKPI' ,

                                                 downDifference: 0,

                                                 upDifference:   0 }

                     }

      @Aggregation.default: #MAX

      @Semantics.quantity.unitOfMeasure:'Percentage'
      GrIncPercKPI,
      
      @Semantics.quantity.unitOfMeasure:'Percentage'
      TargetGrIncPercKPI,
      
      @UI.identification: [{ //StackCard  Orders List

                             type:       #WITH_URL,

                             qualifier: 'FlipSide',

                             label:     'EPAM Global',

                             url:       'WebAddress',

                             position:   20

                          }]

      'https://www.epam.com/'     as WebAddress,

     

      @UI.identification: [{ //StackCard  Orders List

                             type:       #WITH_URL,

                             qualifier: 'FlipSide',

                             label:     'EPAM BY',

                             url:       'WebAddress2',

                             position:   30

                          }]

      'https://careers.epam.by/'  as WebAddress2,

     

      //StackCard  Orders List

      'sap-icon://order-status'   as IconUrl,
      
      
      /* Associations */
      _Product,
      _ProductMarket
      
      
}
