import dotenv from "dotenv";
dotenv.config();

import app from "./app.js";
import logger from "./utils/logger.js";

const PORT = process.env.PORT || 5000;

app.listen(PORT, "0.0.0.0", () => {
  logger.info(`Server running on http://0.0.0.0:${PORT}`);
});
