import admin from "../config/firebase.js";
import AppError from "../utils/AppError.js";
import catchAsync from "../utils/catchAsync.js";
import logger from "../utils/logger.js";

const authMiddleware = catchAsync(async (req, res, next) => {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    return next(new AppError("Unauthorized: No token provided", 401));
  }

  const idToken = authHeader.split("Bearer ")[1];

  try {
    const decodedToken = await admin.auth().verifyIdToken(idToken);
    req.user = decodedToken;
    next();
  } catch (error) {
    logger.error("Error verifying Firebase ID token:", error);
    next(new AppError("Unauthorized: Invalid token", 403));
  }
});

export default authMiddleware;
