// Vulnerable: CDN cache key is path-only, but the origin uses X-Forwarded-Host
// to build cacheable canonical URLs and script URLs served to other users.

const express = require("express");
const app = express();

const cachePolicy = {
  layer: "cdn",
  keyInputs: ["method", "path"],
  ignoredHeaders: ["Host", "X-Forwarded-Host", "Accept-Language"],
  normalization: "cdn-lowercases-path-origin-does-not",
};

app.get("/product/:sku", (req, res) => {
  const forwardedHost = req.get("X-Forwarded-Host") || req.headers.host;
  const language = req.get("Accept-Language") || "en";
  const campaign = req.query.campaign || "default";

  res.set("Cache-Control", "public, max-age=600");
  res.set("X-CDN-Cache-Key", `${req.method}:${req.path}`);

  res.send(`<!doctype html>
    <html lang="${language.slice(0, 2)}">
      <head>
        <link rel="canonical" href="https://${forwardedHost}${req.originalUrl}">
        <script src="https://${forwardedHost}/assets/${campaign}.js"></script>
      </head>
      <body>Product ${req.params.sku}</body>
    </html>`);
});

module.exports = { app, cachePolicy };
