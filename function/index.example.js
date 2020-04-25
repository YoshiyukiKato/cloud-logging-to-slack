const { WebClient } = require("@slack/web-api");
const severityColors = {
  NOTICE: "039BE5",
  WARNING: "FBC02D",
  ERROR: "F44336",
  ALERT: "F44336",
  CRITICAL: "F44336",
};

exports.sendToSlack = async (event, context) => {
  const web = new WebClient(process.env.SLACK_ACCESS_TOKEN);
  const {
    jsonPayload: { message },
    timestamp,
    severity,
  } = JSON.parse(Buffer.from(event.data, "base64").toString());
  const data = {
    channel: process.env.SLACK_CHANNEL_ID,
    text: "",
    attachments: [
      {
        fallback: message,
        color: severityColors[severity],
        text: message,
        ts: Math.floor(new Date(timestamp).getTime() / 1000).toString(),
      },
    ],
  };
  await web.chat.postMessage(data);
};
