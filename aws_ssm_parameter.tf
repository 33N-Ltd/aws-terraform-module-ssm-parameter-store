/**
 * aws_ssm_parameter_store module
 * This module defines read and write actions from parameter store.
 *
 */

resource "aws_ssm_parameter" "default" {
  count           = "${var.enabled == "true" ? length(var.write_parameter) : 0}"
  name            = "${lookup(var.write_parameter[count.index], "name")}"
  description     = "${lookup(var.write_parameter[count.index], "description", lookup(var.write_parameter[count.index], "name"))}"
  type            = "${lookup(var.write_parameter[count.index], "type", "SecureString")}"
  key_id          = "${lookup(var.write_parameter[count.index], "type", "SecureString") == "SecureString" && length(var.kms_arn) > 0 ? var.kms_arn : ""}"
  value           = "${lookup(var.write_parameter[count.index], "value")}"
  overwrite       = "${lookup(var.write_parameter[count.index], "overwrite", "false")}"
  allowed_pattern = "${lookup(var.write_parameter[count.index], "allowed_pattern", "")}"
  tags            = "${var.tags}"
}

data "aws_ssm_parameter" "read" {
  count = "${var.enabled == "true" ? length(var.read_parameter) : 0}"
  name  = "${element(var.read_parameter, count.index)}"
}

data "aws_ssm_parameter" "read_map" {
  count = "${var.enabled == "true" ? length(var.read_parameter_map) : 0}"
  name  = "${element(values(var.read_parameter_map), count.index)}"
}
