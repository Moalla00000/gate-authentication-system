import winston from "winston";

const { combine, timestamp, printf, colorize, errors, splat, json } =
  winston.format;

const isProduction = process.env.NODE_ENV === "production";

const devFormat = combine(
  colorize(),
  timestamp({ format: "YYYY-MM-DD HH:mm:ss" }),
  errors({ stack: true }),
  splat(),
  printf(({ level, message, timestamp, stack }) => {
    return `[${timestamp}] ${level}: ${message}${stack ? `\n${stack}` : ""}`;
  }),
);

const prodFormat = combine(
  timestamp(),
  errors({ stack: true }),
  splat(),
  json(),
);

const logger = winston.createLogger({
  level: isProduction ? "info" : "debug",
  defaultMeta: { service: "gate-backend" },
  transports: [
    new winston.transports.Console({
      format: isProduction ? prodFormat : devFormat,
    }),
  ],
});

export default logger;
