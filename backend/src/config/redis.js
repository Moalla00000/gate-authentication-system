import { Redis } from "@upstash/redis";
import dotenv from "dotenv";
import logger from "../utils/logger.js";

dotenv.config();

let redis;

try {
  redis = new Redis({
    url: process.env.UPSTASH_REDIS_REST_URL,
    token: process.env.UPSTASH_REDIS_REST_TOKEN,
  });
  logger.info("Upstash Redis client initialized");
} catch (error) {
  logger.error("Failed to initialize Upstash Redis client:", error.message);
}

export default redis;
