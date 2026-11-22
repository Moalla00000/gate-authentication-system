import pool from "../config/db.js";
import admin from "../config/firebase.js";
import logger from "../utils/logger.js";

export const syncUserData = async (
  uid,
  email,
  tokenName,
  tokenPicture,
  providedName,
  providedPicture,
) => {
  let name = providedName || tokenName;
  let picture = providedPicture || tokenPicture;

  // Fallback: If still missing, fetch latest from Admin SDK
  if (!name) {
    try {
      const userRecord = await admin.auth().getUser(uid);
      name = userRecord.displayName;
      picture = picture || userRecord.photoURL;
      logger.info(`Fetched missing data from Admin SDK for UID: ${uid}`);
    } catch (e) {
      logger.warn(`Could not fetch user record for ${uid}: ${e.message}`);
    }
  }

  try {
    const result = await pool.query(
      `INSERT INTO users (firebase_uid, email, display_name, photo_url, updated_at, deleted_at)
           VALUES ($1, $2, $3, $4, CURRENT_TIMESTAMP, NULL)
           ON CONFLICT (firebase_uid)
           DO UPDATE SET
             email = EXCLUDED.email,
             display_name = EXCLUDED.display_name,
             photo_url = EXCLUDED.photo_url,
             updated_at = CURRENT_TIMESTAMP,
             deleted_at = NULL
           RETURNING *`,
      [uid, email || null, name || null, picture || null],
    );
    return result.rows[0];
  } catch (err) {
    if (err.code === "23505") {
      // Unique violation
      logger.error(`Sync conflict for UID ${uid}: ${err.detail}`);
      // If it's an email conflict, it means another UID already has this email
      if (err.constraint === "users_email_key") {
        throw new Error(
          "This email is already associated with another account.",
        );
      }
    }
    throw err;
  }
};

export const getUserProfile = async (uid) => {
  const result = await pool.query(
    "SELECT * FROM users WHERE firebase_uid = $1 AND deleted_at IS NULL",
    [uid],
  );
  return result.rows.length > 0 ? result.rows[0] : null;
};

export const updateUserProfile = async (uid, { displayName, photoURL }) => {
  // 1. Update Firebase Admin SDK
  const updateData = {};
  if (displayName !== undefined) updateData.displayName = displayName;
  if (photoURL !== undefined) updateData.photoURL = photoURL;

  if (Object.keys(updateData).length > 0) {
    await admin.auth().updateUser(uid, updateData);
  }

  // 2. Update PostgreSQL
  const result = await pool.query(
    `UPDATE users
         SET display_name = COALESCE($2, display_name),
             photo_url = COALESCE($3, photo_url),
             updated_at = CURRENT_TIMESTAMP
         WHERE firebase_uid = $1 AND deleted_at IS NULL
         RETURNING *`,
    [uid, displayName || null, photoURL || null],
  );

  return result.rows[0];
};

export const deleteUserData = async (uid) => {
  const result = await pool.query(
    "UPDATE users SET deleted_at = CURRENT_TIMESTAMP WHERE firebase_uid = $1 RETURNING *",
    [uid],
  );
  return result.rows.length > 0;
};
