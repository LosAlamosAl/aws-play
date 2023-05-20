try {
  // This comes from the deployed lambda layer
  const { createCanvas } = require("canvas");
} catch (e) {
  if (e instanceof Error && e.code === "MODULE_NOT_FOUND")
    return "Fail: can't load the lambda layer!";
  else return "Success: lambda layer present";
}
exports.handler = async (event, context) => {
  return "Fail: should never get here!";
};
