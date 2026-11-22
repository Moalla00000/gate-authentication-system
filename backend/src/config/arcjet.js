import arcjet, { detectBot, fixedWindow, shield } from "@arcjet/node";
import dotenv from "dotenv";

dotenv.config();

const aj = arcjet({
  key: process.env.ARCJET_KEY,
  characteristics: ["ip.src"], // Track requests by IP address
  rules: [
    // Shield protects against common attacks like SQL injection, XSS, etc.
    shield({
      mode: "LIVE",
    }),
    // Create a bot detection rule
    detectBot({
      mode: "LIVE", // Blocks known bad bots and allows unknown bots
      // Block all bots except search engines.
      // See https://docs.arcjet.com/bot-detection/concepts#allow-list
      allow: [
        "CATEGORY:SEARCH_ENGINE", // Google, Bing, etc
      ],
    }),
    // Create a token bucket rate limit
    fixedWindow({
      mode: "LIVE",
      window: "60s", // 60 second fixed window
      max: 100, // Allow 100 requests per window
    }),
  ],
});

export default aj;
