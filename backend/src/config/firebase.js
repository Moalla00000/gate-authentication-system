import admin from "firebase-admin";
import { readFile } from "fs/promises";
import path from "path";
import { fileURLToPath } from "url";
import logger from "../utils/logger.js";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

let firebaseApp;

const initializeFirebase = async () => {
  try {
    let serviceAccount;

    if (process.env.FIREBASE_SERVICE_ACCOUNT) {
      logger.info("Loading Firebase credentials from environment variable");
      serviceAccount = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT);
    } else {
      const serviceAccountPath = path.resolve(
        __dirname,
        "../../serviceAccountKey.json",
      );
      logger.info(
        `Loading Firebase credentials from local file: ${serviceAccountPath}`,
      );
      serviceAccount = JSON.parse(await readFile(serviceAccountPath, "utf8"));
    }

    firebaseApp = admin.initializeApp({
      credential: admin.credential.cert(serviceAccount),
    });

    logger.info("Firebase Admin SDK initialized successfully");
  } catch (error) {
    logger.error("Firebase Admin SDK initialization failed:", error.message);
    logger.warn(
      "Authentication middleware will fail until valid credentials are provided via FIREBASE_SERVICE_ACCOUNT or serviceAccountKey.json.",
    );
  }
};

initializeFirebase();

export default admin;
