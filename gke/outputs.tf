output cloudsql_ip_address {
  value = "${google_sql_database_instance.primary.ip_address.0.ip_address}"
}
