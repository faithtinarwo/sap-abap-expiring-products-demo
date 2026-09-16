@EndUserText.label: 'Ready-to-Serve Orders CDS View'
define root view entity ZC_ReadyOrders
  as select from zrestaurant_orde
{
  key order_id,
  @UI.lineItem: [{ position: 10 }]
  dish_name,
  @UI.lineItem: [{ position: 20 }]
  table_number,
  @UI.lineItem: [{ position: 30 }]
  status
}
where status = 'READY'
