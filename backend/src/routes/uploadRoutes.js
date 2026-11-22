import express from "express";
import { upload } from "../middleware/uploadMiddleware.js";
import { uploadAvatar } from "../controllers/uploadController.js";

const router = express.Router();

/**
 * @openapi
 * /upload/avatar:
 *   post:
 *     tags: [Upload]
 *     summary: Upload a user avatar to Cloudinary
 *     requestBody:
 *       required: true
 *       content:
 *         multipart/form-data:
 *           schema:
 *             type: object
 *             properties:
 *               avatar:
 *                 type: string
 *                 format: binary
 *     responses:
 *       200:
 *         description: Avatar uploaded successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message: { type: string }
 *                 url: { type: string, format: uri }
 *       400:
 *         description: Bad request (no file or invalid file type)
 *         content:
 *           application/json:
 *             schema: { $ref: '#/components/schemas/Error' }
 *       500:
 *         description: Internal server error
 */
router.post("/avatar", upload.single("avatar"), uploadAvatar);

export default router;
