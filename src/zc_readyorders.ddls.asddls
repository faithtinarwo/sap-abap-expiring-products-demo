@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@EndUserText.label: 'Ready-to-Serve Orders CDS View'
@UI.headerInfo: {
  typeName: 'Order',
  typeNamePlural: 'Ready Orders',
  title: { value: 'dish_name' }
}
define root view entity ZC_READYORDERS
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

