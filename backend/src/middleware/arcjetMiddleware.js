import aj from "../config/arcjet.js";
import logger from "../utils/logger.js";

const arcjetMiddleware = async (req, res, next) => {
  // Bypass Arcjet in development/localhost
  if (process.env.NODE_ENV === "development") {
    return next();
  }

  try {
    const decision = await aj.protect(req);

    if (decision.isDenied()) {
      if (decision.reason.isRateLimit()) {
        return res.status(429).json({ message: "Too Many Requests" });
      } else if (decision.reason.isBot()) {
        return res.status(403).json({ message: "No bots allowed" });
      } else {
        return res.status(403).json({ message: "Forbidden" });
      }
    }

    // If the decision is to allow, continue to the next middleware
    next();
  } catch (error) {
    logger.error("Arcjet error:", error);
    // In case of error, we default to allowing the request to avoid blocking legitimate users
    // if the security service is down.
    next();
  }
};

export default arcjetMiddleware;
