const { S3Client, GetObjectCommand, PutObjectCommand } = require("@aws-sdk/client-s3");

exports.handler = async (event) => {
  const bucketName = process.env.BUCKET_NAME;
  const objectName = process.env.OBJECT_NAME;
  const s3Client = new S3Client();

  try {
    const command = new GetObjectCommand({
      Bucket: bucketName,
      Key: objectName
    });

    const response = await s3Client.send(command);
    data = await response.Body.transformToString();
    data += "\n// Appended text";

    const putCommand = new PutObjectCommand({
      Bucket: bucketName,
      Key: objectName,
      Body: data
    });
    await s3Client.send(putCommand);
  } catch (err) {
    console.error("Error appending to S3 object:", err);
    throw err;
  }

  return {
    statusCode: 200,
    headers: { "Content-Type": "text/plain" },
    body: JSON.stringify({ message: "Appended!", bucketName, objectName })
  };
};
