const AWS = require('aws-sdk');

AWS.config.update({
  accessKeyId: 'AKIAYQO3FBNYSIWS7Q5I',// process.env.AWS_ACCESS_KEY_ID,
  secretAccessKey: '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',
  region: 'us-east-1'
});

const s3 = new AWS.S3();

module.exports = {s3: s3}