/**
 * Copyright (c) 2011 - 2017, Coveo Solutions Inc.
 */

output "name" {
  value = "${mysql_user.user.user}"
}

output "host" {
  value = "${mysql_user.user.host}"
}

output "schema_name" {
  value = "${mysql_database.schema.name}"
}
