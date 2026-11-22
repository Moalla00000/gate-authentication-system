import express from "express";
import {
  syncUser,
  getProfile,
  updateProfile,
  deleteProfile,
} from "../controllers/userController.js";
import authMiddleware from "../middleware/authMiddleware.js";
import validateRequest from "../middleware/validationMiddleware.js";
import { updateProfileSchema } from "../validations/userValidation.js";

const router = express.Router();

/**
 * @openapi
 * /users/sync:
 *   post:
 *     tags: [Users]
 *     summary: Sync Firebase user with PostgreSQL
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: User synced successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message: { type: string }
 *                 user: { $ref: '#/components/schemas/User' }
 *       401:
 *         description: Unauthorized
 *         content:
 *           application/json:
 *             schema: { $ref: '#/components/schemas/Error' }
 */
router.post("/sync", authMiddleware, syncUser);

/**
 * @openapi
 * /users/profile:
 *   get:
 *     tags: [Users]
 *     summary: Get user profile
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: User profile
 *         content:
 *           application/json:
 *             schema: { $ref: '#/components/schemas/User' }
 *       401:
 *         description: Unauthorized
 *       404:
 *         description: User not found
 */
router.get("/profile", authMiddleware, getProfile);

/**
 * @openapi
 * /users/profile:
 *   patch:
 *     tags: [Users]
 *     summary: Update user profile
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               displayName: { type: string }
 *               photoURL: { type: string }
 *     responses:
 *       200:
 *         description: Profile updated successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message: { type: string }
 *                 user: { $ref: '#/components/schemas/User' }
 *       401:
 *         description: Unauthorized
 */
router.patch(
  "/profile",
  authMiddleware,
  validateRequest(updateProfileSchema),
  updateProfile,
);

/**
 * @openapi
 * /users/profile:
 *   delete:
 *     tags: [Users]
 *     summary: Soft delete user profile
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       204:
 *         description: Profile soft-deleted and user disabled successfully
 *       401:
 *         description: Unauthorized
 *       404:
 *         description: User not found
 */
router.delete("/profile", authMiddleware, deleteProfile);

export default router;
