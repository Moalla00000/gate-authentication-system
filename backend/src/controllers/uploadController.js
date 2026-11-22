import cloudinary from "../config/cloudinary.js";
import catchAsync from "../utils/catchAsync.js";
import AppError from "../utils/AppError.js";
import { successResponse } from "../utils/responseHandler.js";

export const uploadAvatar = catchAsync(async (req, res, next) => {
  if (!req.file) {
    return next(new AppError("No image file provided", 400));
  }

  // Wrap the cloudinary upload stream in a Promise since it's event-based
  const uploadPromise = new Promise((resolve, reject) => {
    const uploadStream = cloudinary.uploader.upload_stream(
      {
        folder: "gate/avatars", // Organizer folder in Cloudinary
        allowed_formats: ["jpg", "png", "jpeg", "webp"],
        transformation: [
          { width: 400, height: 400, crop: "fill", gravity: "face" }, // Optimize for avatars instantly
          { quality: "auto", fetch_format: "auto" }, // Serve the most efficient format
        ],
      },
      (error, result) => {
        if (error) reject(error);
        else resolve(result);
      },
    );

    // Pipe the multer memory buffer to Cloudinary
    uploadStream.end(req.file.buffer);
  });

  const result = await uploadPromise;

  successResponse(res, 200, "Avatar uploaded successfully", {
    url: result.secure_url,
  });
});
