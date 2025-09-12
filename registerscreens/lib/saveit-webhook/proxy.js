const express = require('express');
const app = express();
const localWebhook = require('./api/webhook'); // استدعي ملف webhook.js

app.use(express.json());

// CORS
app.use((req, res, next) => {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET,POST,OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');
  next();
});

// preflight
app.options('/api/webhook', (req, res) => res.sendStatus(200));

// API endpoint
app.post('/api/webhook', localWebhook); // استدعاء مباشر
// أو لو حابب تعمل route منفصل
// app.post('/local-webhook', localWebhook);

app.listen(3000, () => console.log('Proxy running on http://localhost:3000'));
