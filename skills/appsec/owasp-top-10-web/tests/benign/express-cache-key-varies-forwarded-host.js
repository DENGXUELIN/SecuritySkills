// Benign: origin-influencing host and locale inputs are either fixed at the
// edge, included in the cache key, or represented in Vary/cache-control policy.

const express = require("express");
const app = express();

const cachePolicy = {
  layer: "cdn",
  keyInputs: ["method", "host", "path", "query:campaign", "header:accept-language"],
  ignoredHeaders: [],
  normalization: "cdn-and-origin-normalize-path-and-query",
};

const allowedHosts = new Set(["shop.internal.invalid"]);

app.get("/product/:sku", (req, res) => {
  const host = req.headers.host;
  if (!allowedHosts.has(host)) {
    res.status(400).send("invalid host");
    return;
  }

  const locale = (req.get("Accept-Language") || "en").slice(0, 2);
  const campaign = req.query.campaign || "default";

  res.set("Cache-Control", "public, max-age=600");
  res.set("Vary", "Host, Accept-Language");
  res.set("X-CDN-Cache-Key", `${req.method}:${host}:${req.path}:${campaign}:${locale}`);

  res.send(`<!doctype html>
    <html lang="${locale}">
      <head>
        <link rel="canonical" href="https://${host}${req.path}">
        <script src="/assets/${campaign}.js"></script>
      </head>
      <body>Product ${req.params.sku}</body>
    </html>`);
});

module.exports = { app, cachePolicy };
