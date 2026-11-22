import pg from "pg";
import dotenv from "dotenv";

dotenv.config();

const { Pool } = pg;
import logger from "../utils/logger.js";

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
});

pool.on("connect", () => {
  logger.info("Connected to PostgreSQL database");
});

pool.on("error", (err) => {
  logger.error("Unexpected error on idle client", err);
  process.exit(-1);
});

export const initializeDatabase = async () => {
  const createUsersTable = `
        CREATE TABLE IF NOT EXISTS users (
            id SERIAL PRIMARY KEY,
            firebase_uid VARCHAR(255) UNIQUE NOT NULL,
            email VARCHAR(255) UNIQUE,
            display_name VARCHAR(255),
            photo_url TEXT,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            deleted_at TIMESTAMP
        );
    `;
  const migrateEmailColumn = `
        ALTER TABLE users ALTER COLUMN email DROP NOT NULL;
    `;
  const addDeletedAtColumn = `
        ALTER TABLE users ADD COLUMN IF NOT EXISTS deleted_at TIMESTAMP;
    `;
  try {
    await pool.query(createUsersTable);
    // Attempt to drop NOT NULL constraint if it exists (for existing tables)
    await pool.query(migrateEmailColumn).catch(() => {
      // Ignore error if already nullable or other issues
    });
    // Add deleted_at column if it's a legacy table
    await pool.query(addDeletedAtColumn);
    logger.info("Database tables initialized");
  } catch (err) {
    logger.error("Error initializing database:", err);
    throw err;
  }
};

export const query = (text, params) => pool.query(text, params);

export default pool;
