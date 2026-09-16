@AbapCatalog.sqlViewName: 'ZVEXPPROD'
@EndUserText.label: 'Expiring Products CDS View'
define view Z_C_ExpiringProd as select from zexpiring_prod {
  key product_id,
  product_name,
  expiry_date,
  quantity
} where expiry_date <= '20261016'
