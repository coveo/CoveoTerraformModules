/**
 * Copyright (c) 2011 - 2022, Coveo Solutions Inc.
 */

 output "global_accelerator_id" {
    value = "${aws_globalaccelerator_accelerator.global_accelerator.id}"
}