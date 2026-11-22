import express from "express";
import userRoutes from "./userRoutes.js";
import uploadRoutes from "./uploadRoutes.js";

const router = express.Router();

/**
 * Health check endpoint
 * @openapi
 * /health:
 *   get:
 *     tags: [Health]
 *     summary: Get system health status
 *     responses:
 *       200:
 *         description: System is healthy
 */
router.get("/health", (req, res) => {
  res.json({
    status: "ok",
    time: new Date().toISOString(),
    env: process.env.NODE_ENV,
  });
});

// Mount resource routes
router.use("/users", userRoutes);
router.use("/upload", uploadRoutes);

export default router;
