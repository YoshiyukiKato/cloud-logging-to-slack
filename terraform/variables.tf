variable "project_name" {
  description = "project ID of gcp"
}

variable "env_name" {
  description = "environment name"
}

variable "log_name" {
  description = "log name on cloud logging"
}

variable "log_filter" {
  description = "log filtering condition"
}

variable "slack_access_token" {
  description = "slack app access token"
}

variable "slack_channel_id" {
  description = "slack channel id"
}