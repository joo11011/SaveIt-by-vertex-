const { GoogleAuth } = require("google-auth-library");
const fetch = require("node-fetch");

const PROJECT_ID = "saveit-by-vertex"; // Project ID بتاعك
const SESSION_ID = "123456"; // ممكن تخليه ثابت أو ديناميكي حسب المستخدم
const LANGUAGE_CODE = "ar";

// 🟢 اقرأ GOOGLE_CREDENTIALS من الـ Environment Variables
const credentials = JSON.parse(process.env.GOOGLE_CREDENTIALS);

const auth = new GoogleAuth({
  credentials: {
    client_email: credentials.client_email,
    private_key: credentials.private_key.replace(/\\n/g, "\n"),
  },
  projectId: credentials.project_id,
  scopes: ["https://www.googleapis.com/auth/cloud-platform"],
});

module.exports = async (req, res) => {
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader("Access-Control-Allow-Methods", "GET,POST,OPTIONS");
  res.setHeader("Access-Control-Allow-Headers", "Content-Type, Authorization");

  if (req.method === "OPTIONS") {
    return res.status(200).end();
  }

  if (req.method === "POST") {
    try {
      const body = req.body || {};
      const queryText = body?.queryResult?.queryText || "";

      // 🟢 احصل على access token
      const client = await auth.getClient();
      const token = await client.getAccessToken();

      // 🟢 ابعت query لـ Dialogflow
      const response = await fetch(
        `https://dialogflow.googleapis.com/v2/projects/${PROJECT_ID}/agent/sessions/${SESSION_ID}:detectIntent`,
        {
          method: "POST",
          headers: {
            Authorization: `Bearer ${token.token}`,
            "Content-Type": "application/json",
          },
          body: JSON.stringify({
            queryInput: {
              text: { text: queryText, languageCode: LANGUAGE_CODE },
            },
          }),
        }
      );

      const data = await response.json();
      console.log("Dialogflow response:", JSON.stringify(data, null, 2));

      // 🟢 اجمع كل الردود المتاحة
      const messages = data.queryResult?.fulfillmentMessages || [];
      let reply = data.queryResult?.fulfillmentText || "آسف، مش قادر أفهمك.";

      if (messages.length > 0) {
        const texts = messages
          .map((m) => m.text?.text)
          .flat()
          .filter(Boolean);

        if (texts.length > 0) {
          // 🟢 اختار رد عشوائي 🎲
          reply = texts[Math.floor(Math.random() * texts.length)];
        }
      }

      return res.status(200).json({ fulfillmentText: reply });
    } catch (e) {
      console.error("Webhook error:", e);
      return res.status(500).json({ error: e.message || "Internal error" });
    }
  }

  return res.status(405).json({ error: "Method not allowed" });
};
