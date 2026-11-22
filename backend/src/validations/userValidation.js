import { z } from "zod";

export const updateProfileSchema = {
  body: z
    .object({
      displayName: z
        .string()
        .min(2, "Name must be at least 2 characters string")
        .max(50, "Name must be less than 50 characters")
        .optional(),
      photoURL: z.string().url("Must be a valid URL").optional(),
    })
    .refine(
      (data) => data.displayName !== undefined || data.photoURL !== undefined,
      {
        message:
          "At least one field (displayName or photoURL) must be provided to update",
      },
    ),
};
