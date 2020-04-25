# cloud logging to slack

Forward cloud logging log items to slack.

## development

Copy example file and edit.

```sh
cp function/index.example.js function/index.js
```

## deploy

Deploy to GCP. Please authorize gcloud before exec command.

```sh
terraform init \
  -reconfigure\
  -backend-config="bucket={BACKEND_BUCKET_NAME}"\
  -backend-config="prefix={LOG_NAME}"

terraform apply -var 'env_name={ENV_NAME}' \
 -var 'project_name={GCP_PROJECT_NAME}'\
 -var 'log_name={LOG_NAME}'\
 -var 'log_filter={LOG_FILTER}'\
 -var 'slack_access_token={SLACK_ACCESS_TOKEN}'\
 -var 'slack_channel_id={SLACK_CHANNEL_ID}'
```
