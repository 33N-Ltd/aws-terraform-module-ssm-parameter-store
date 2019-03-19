# Splitting and joining, and then compacting a list to get a normalised list
locals {
  name_list      = "${compact(concat(split("${var.split_delimiter}",join("${var.split_delimiter}", aws_ssm_parameter.default.*.name)), split("${var.split_delimiter}",join("${var.split_delimiter}", data.aws_ssm_parameter.read.*.name))))}"
  value_list     = "${compact(concat(split("${var.split_delimiter}",join("${var.split_delimiter}", aws_ssm_parameter.default.*.value)), split("${var.split_delimiter}",join("${var.split_delimiter}", data.aws_ssm_parameter.read.*.value))))}"
  name_list_map  = "${compact(concat(split("${var.split_delimiter}",join("${var.split_delimiter}", aws_ssm_parameter.default.*.name)), split("${var.split_delimiter}",join("${var.split_delimiter}", data.aws_ssm_parameter.read_map.*.name))))}"
  value_list_map = "${compact(concat(split("${var.split_delimiter}",join("${var.split_delimiter}", aws_ssm_parameter.default.*.value)), split("${var.split_delimiter}",join("${var.split_delimiter}", data.aws_ssm_parameter.read_map.*.value))))}"
}

output "names" {
  value       = "${local.name_list}"
  description = "A list of all of the parameter names"
}

output "values" {
  description = "A list of all of the parameter values"
  value       = "${local.value_list}"
}

output "map" {
  description = "A map of the names and values created"
  value       = "${zipmap(local.name_list, local.value_list)}"
}

output "map_names" {
  description = "A list of all of the parameter names"
  value       = "${local.name_list_map}"
}

output "map_values" {
  value       = "${local.value_list_map}"
  description = "A list of all of the parameter names"
}

output "kv" {
  description = "A map of the names and values created"
  value       = "${zipmap(coalescelist(keys(var.read_parameter_map), local.name_list),
                          coalescelist(local.value_list_map, local.value_list))}"
}
