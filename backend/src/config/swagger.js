import swaggerJsdoc from "swagger-jsdoc";
import { APP_NAME } from "./constants.js";

const options = {
  definition: {
    openapi: "3.0.0",
    info: {
      title: `${APP_NAME} API`,
      version: "1.0.0",
      description: "API documentation for the backend application",
    },
    servers: [
      {
        url: "http://localhost:5000/api",
        description: "Development server",
      },
    ],
    tags: [
      { name: "Users", description: "User management and profile sync" },
      { name: "Upload", description: "Image and file upload services" },
      { name: "Health", description: "System status and health checks" },
    ],
    components: {
      securitySchemes: {
        bearerAuth: {
          type: "http",
          scheme: "bearer",
          bearerFormat: "JWT",
        },
      },
      schemas: {
        User: {
          type: "object",
          properties: {
            id: { type: "integer" },
            firebase_uid: { type: "string" },
            email: { type: "string", format: "email" },
            display_name: { type: "string" },
            photo_url: { type: "string", format: "uri" },
            created_at: { type: "string", format: "date-time" },
            updated_at: { type: "string", format: "date-time" },
          },
        },
        Error: {
          type: "object",
          properties: {
            status: { type: "string", example: "fail" },
            message: { type: "string" },
          },
        },
        ApiResponse: {
          type: "object",
          properties: {
            message: { type: "string" },
            data: { type: "object" },
          },
        },
      },
    },
  },
  apis: ["./src/routes/*.js", "./src/app.js"], // Paths to files containing OpenAPI definitions
};

const swaggerSpec = swaggerJsdoc(options);

export default swaggerSpec;
