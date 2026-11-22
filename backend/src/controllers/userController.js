import * as userService from "../services/userService.js";
import admin from "../config/firebase.js";
import catchAsync from "../utils/catchAsync.js";
import AppError from "../utils/AppError.js";
import logger from "../utils/logger.js";
import { successResponse } from "../utils/responseHandler.js";
import cacheService from "../services/cacheService.js";

export const syncUser = catchAsync(async (req, res, next) => {
  const { uid, email, name: tokenName, picture: tokenPicture } = req.user;
  const { displayName, photoURL } = req.body;

  logger.info(`Syncing user: ${email || "Guest"} (${uid})`);

  const user = await userService.syncUserData(
    uid,
    email,
    tokenName,
    tokenPicture,
    displayName,
    photoURL,
  );

  // Invalidate cache after sync
  await cacheService.del(`user:profile:${uid}`);

  successResponse(res, 200, "User synced successfully", { user });
});

export const getProfile = catchAsync(async (req, res, next) => {
  const { uid } = req.user;
  const cacheKey = `user:profile:${uid}`;

  const user = await cacheService.withCache(cacheKey, () =>
    userService.getUserProfile(uid),
  );

  if (!user) {
    return next(new AppError("User not found", 404));
  }

  successResponse(res, 200, "User profile retrieved successfully", { user });
});

export const updateProfile = catchAsync(async (req, res, next) => {
  const { displayName, photoURL } = req.body;
  const { uid } = req.user;

  const user = await userService.updateUserProfile(uid, {
    displayName,
    photoURL,
  });

  // Invalidate cache on update
  await cacheService.del(`user:profile:${uid}`);

  successResponse(res, 200, "Profile updated successfully", { user });
});

export const deleteProfile = catchAsync(async (req, res, next) => {
  const { uid } = req.user;

  // 1. Delete from PostgreSQL
  const deleted = await userService.deleteUserData(uid);

  if (!deleted) {
    return next(new AppError("User not found in database", 404));
  }

  // 2. Disable user in Firebase Admin SDK (Soft Delete)
  await admin.auth().updateUser(uid, {
    disabled: true,
  });

  // 3. Invalidate cache
  await cacheService.del(`user:profile:${uid}`);

  successResponse(res, 204, "User profile deleted");
});
