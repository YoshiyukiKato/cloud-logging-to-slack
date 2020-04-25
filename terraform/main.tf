resource "google_logging_project_sink" "log_sink" {
  project = var.project_name
  name = "${var.log_name}-pubsub-sink"
  destination = "pubsub.googleapis.com/projects/${var.project_name}/topics/${var.log_name}"
  filter = var.log_filter
  unique_writer_identity = true
}

resource "google_pubsub_topic" "log_topic" {
  project = var.project_name
  name = var.log_name
}

resource "google_pubsub_topic_iam_member" "log_topic_iam" {
  project = var.project_name
  topic  = google_pubsub_topic.log_topic.name
  role   = "roles/pubsub.publisher"
  member = google_logging_project_sink.log_sink.writer_identity

  depends_on = [
    google_pubsub_topic.log_topic,
    google_logging_project_sink.log_sink,
  ]
}

resource "google_storage_bucket" "bucket" {
  project = var.project_name
  name = "cloud-logging-to-slack-${var.env_name}"
}

data "archive_file" "function" {
  type        = "zip"
  source_dir = "../function"
  output_path = "../function.zip"
}

resource "google_storage_bucket_object" "archive" {
  name   = "${var.log_name}.${data.archive_file.function.output_base64sha256}.zip"
  bucket = google_storage_bucket.bucket.name
  source = "../function.zip"
}

resource "google_cloudfunctions_function" "function" {
  project               = var.project_name
  name                  = "${var.log_name}-to-slack"
  available_memory_mb   = 128
  region         = "asia-northeast1"
  runtime = "nodejs10"
  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.archive.name
  
  event_trigger {
    event_type = "providers/cloud.pubsub/eventTypes/topic.publish"
    resource   = google_pubsub_topic.log_topic.name
  }

  timeout     = 80
  entry_point = "sendToSlack"

  environment_variables = {
    SLACK_ACCESS_TOKEN = var.slack_access_token
    SLACK_CHANNEL_ID = var.slack_channel_id
  }
}