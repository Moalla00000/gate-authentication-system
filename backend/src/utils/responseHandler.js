export const successResponse = (
  res,
  statusCode = 200,
  message = "Success",
  data = null,
) => {
  res.status(statusCode).json({
    status: "success",
    message,
    ...(data !== null && { data }),
  });
};

export const errorResponse = (
  res,
  statusCode = 500,
  message = "Something went wrong",
  errors = null,
) => {
  res.status(statusCode).json({
    status: "error",
    message,
    ...(errors !== null && { errors }),
  });
};
