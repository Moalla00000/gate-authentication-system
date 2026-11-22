import redis from "./src/config/redis.js";
import logger from "./src/utils/logger.js";

async function testRedis() {
  if (
    !process.env.UPSTASH_REDIS_REST_URL ||
    !process.env.UPSTASH_REDIS_REST_TOKEN
  ) {
    logger.error("Skipping Redis test: Missing environment variables.");
    process.exit(0);
  }

  try {
    logger.info("Testing Redis connection...");
    const result = await redis.ping();
    logger.info(`Redis Ping Result: ${result}`);

    await redis.set("test_key", "hello_redis");
    const val = await redis.get("test_key");
    logger.info(
      `Redis Get/Set Test: ${val === "hello_redis" ? "PASSED" : "FAILED"}`,
    );

    await redis.del("test_key");
    process.exit(0);
  } catch (error) {
    logger.error("Redis Test Failed:", error.message);
    process.exit(1);
  }
}

testRedis();
