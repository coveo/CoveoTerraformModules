/**
 * Copyright (c) 2011 - 2022, Coveo Solutions Inc.
 */

resource "aws_globalaccelerator_accelerator" "global_accelerator" {
    name  = "${var.env}-${ join("_", keys(var.endpoint_group_map))}"
    ip_address_type = "IPV4"

    tags = {
        regions_covered = join(",", keys(var.endpoint_group_map))
    }
 }

resource "aws_globalaccelerator_listener" "global_accelerator_listener" {
    accelerator_arn = aws_globalaccelerator_accelerator.global_accelerator.id
    client_affinity = "NONE"
    protocol = "TCP"
    
    port_range  {
       from_port = 80
       to_port = 80
    }

    port_range {
      from_port = 443
      to_port = 443
    }
}


resource "aws_globalaccelerator_endpoint_group" "endpoint_group" {
    for_each = var.endpoint_group_map

    listener_arn = aws_globalaccelerator_listener.global_accelerator_listener.id
    endpoint_group_region = each.key
    health_check_interval_seconds = each.value.health_check_interval_in_seconds
    health_check_path = each.value.health_check_path
    health_check_port = each.value.health_check_port
    health_check_protocol = each.value.health_check_protocol
    threshold_count = each.value.threshold_count

    endpoint_configuration {
      endpoint_id = each.value.alb_arn
    }
}