variable "rds_subnet" {
  default = "subnet-f39e6094"
}


#password
resource "random_id" "boss" {
  byte_length = 8
}

#instances
resource "aws_db_instance" "boss" {
  identifier = "${var.name["rds_boss"]}"
  name       = "${var.tags["service"]}"
  username   = "${var.tags["service"]}"
  password   = "${random_id.boss.hex}"

  vpc_security_group_ids = ["${var.sg["itachi"]}"]

  engine               = "${var.mysql_boss["engine"]}"
  engine_version       = "${var.mysql_boss["version"]}"
## parameter_group_name = "${aws_db_parameter_group.master.id}"

  instance_class            = "db.t2.mirco"
  storage_type              = "gp2"
  allocated_storage         = "${var.mysql_boss["storage"]}"
  multi_az                  = "${var.tags["env"] == "production" ? "true" : "false"}"
  db_subnet_group_name      = "${var.rds_subnet}"
  storage_encrypted         = true
  final_snapshot_identifier = "${var.name["rds_boss"]}-finalsnap"

  auto_minor_version_upgrade = false
  backup_retention_period    = 1
  apply_immediately          = true

  # format: ddd:hh:mm-ddd:hh:mm
  # it need at least 30 minutes
  maintenance_window = "${var.mysql_boss["maintenance_window"]}"

  # format: hh:mm-hh:mm
  backup_window = "${var.mysql_boss["backup_window"]}"

  tags = {
    Service = "${var.tags["service"]}"

  }
}
