data "launchdarkly_project" "critical-updates" {
  key = "${var.project-key}"
}

resource "launchdarkly_feature_flag" "remove-static-queries" {
  project_key = "${data.launchdarkly_project.critical-updates.key}"
  key = "${var.key}"
  name = "${var.name}"
  description = "${var.description}"
  custom_properties = [{
    key = "activation-date"
    name = "Activation Date"
    value = ["${var.activation_date}"]
  }, {
    key = "online-help-url"
    name = "Online Help URL"
    value = ["${var.online_help_url}"]
  }]
}
