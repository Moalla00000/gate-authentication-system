import redis from "../config/redis.js";
import logger from "../utils/logger.js";

class CacheService {
  constructor() {
    this.redis = redis;
    this.defaultTTL = 3600; // 1 hour
  }

  /**
   * Set a value in cache with optional expiration
   * @param {string} key
   * @param {any} value
   * @param {number} ttl Seconds
   */
  async set(key, value, ttl = this.defaultTTL) {
    if (!this.redis) return;
    try {
      const data = JSON.stringify(value);
      await this.redis.set(key, data, { ex: ttl });
    } catch (error) {
      logger.error(`Cache set error [${key}]:`, error.message);
    }
  }

  /**
   * Get a value from cache
   * @param {string} key
   * @returns {Promise<any|null>}
   */
  async get(key) {
    if (!this.redis) return null;
    try {
      const data = await this.redis.get(key);
      if (!data) return null;
      // Upstash REST client might return the object directly if it's already parsed,
      // but usually it's a string if we JSON.stringify'd it.
      return typeof data === "string" ? JSON.parse(data) : data;
    } catch (error) {
      logger.error(`Cache get error [${key}]:`, error.message);
      return null;
    }
  }

  /**
   * Delete a value from cache
   * @param {string} key
   */
  async del(key) {
    if (!this.redis) return;
    try {
      await this.redis.del(key);
    } catch (error) {
      logger.error(`Cache del error [${key}]:`, error.message);
    }
  }

  /**
   * Wrapper for fetch-through-cache pattern
   * @param {string} key
   * @param {Function} fetchFn Function to call on cache miss
   * @param {number} ttl
   */
  async withCache(key, fetchFn, ttl = this.defaultTTL) {
    const cached = await this.get(key);
    if (cached) {
      logger.debug(`Cache hit for [${key}]`);
      return cached;
    }

    logger.debug(`Cache miss for [${key}]`);
    const fresh = await fetchFn();
    if (fresh) {
      await this.set(key, fresh, ttl);
    }
    return fresh;
  }
}

export default new CacheService();
