variable "project-key" {
  description = "The key for the project containing critical updates."
}

variable "key" {
  description = "The unique key for the critical update."
}

variable "name" {
  description = "The name for the critical update (visible to customers)."
}

variable "description" {
  description = "Short description of the critical update (visible to customers)."
}

variable "activation_date" {
  description = "The date at which we will automatically activate the critical update (YYYY-MM-DD)"
}

variable "online_help_url" {
  description = "The URL for the online help topic describing the critical update."
}
