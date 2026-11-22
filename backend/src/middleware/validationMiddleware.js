import { ZodError } from "zod";
import AppError from "../utils/AppError.js";
import logger from "../utils/logger.js";

const validateRequest = (schema) => {
  return (req, res, next) => {
    try {
      if (schema.body) {
        req.body = schema.body.parse(req.body);
      }
      if (schema.query) {
        req.query = schema.query.parse(req.query);
      }
      if (schema.params) {
        req.params = schema.params.parse(req.params);
      }
      next();
    } catch (error) {
      if (error instanceof ZodError) {
        // Create a formatted list of errors
        const formattedErrors = error.errors.map((err) => ({
          field: err.path.join("."),
          message: err.message,
        }));

        logger.warn("Validation error", { errors: formattedErrors });

        return res.status(400).json({
          status: "fail",
          message: "Validation failed",
          errors: formattedErrors,
        });
      }
      next(error);
    }
  };
};

export default validateRequest;
