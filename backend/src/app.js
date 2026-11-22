import express from "express";
import cors from "cors";
import morgan from "morgan";
import helmet from "helmet";
import swaggerUi from "swagger-ui-express";
import swaggerSpec from "./config/swagger.js";
import pool, { initializeDatabase } from "./config/db.js";
import apiRoutes from "./routes/index.js";
import arcjetMiddleware from "./middleware/arcjetMiddleware.js";
import errorMiddleware from "./middleware/errorMiddleware.js";
import AppError from "./utils/AppError.js";
import logger from "./utils/logger.js";

const app = express();

// Middleware
// 1. Security HTTP headers
app.use(helmet());

// 2. Body parser & CORS
app.use(cors());
app.use(express.json({ limit: "10kb" }));

// 3. Development logging
if (process.env.NODE_ENV === "development") {
  app.use(morgan("dev"));
}

// 4. Arcjet security (Handles Rate Limiting, Bot Detection, Shield)
app.use(arcjetMiddleware);

// Routes
app.use("/api", apiRoutes);

// Swagger UI
app.use("/api-docs", swaggerUi.serve, swaggerUi.setup(swaggerSpec));

// Base route
app.get("/", (req, res) => {
  res.json({
    message: "API running",
    docs: "/api-docs",
  });
});

// Handle undefined routes
app.use((req, res, next) => {
  next(new AppError(`Can't find ${req.originalUrl} on this server!`, 404));
});

// Global Error Handler
app.use(errorMiddleware);

// Test database connection and initialize tables on startup
const startDb = async () => {
  try {
    await pool.query("SELECT NOW()");
    await initializeDatabase();
  } catch (err) {
    logger.error(
      "Initial Database Connection or Initialization Failed:",
      err.message,
    );
  }
};
startDb();

export default app;
