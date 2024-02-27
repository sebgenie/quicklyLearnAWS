#!/bin/bash

# can create the bucket using aws cli but let's do it in the console
# e.g:

export S3_BUCKET=s3-drseb-website

# check if bucket already exist
if 
  aws s3api head-bucket --bucket "$S3_BUCKET" 2>/dev/null;  
then  
  aws s3 sync ./website_1/ "s3://$S3_BUCKET" 
fi

# add the bucket ACL to your bucket to allow object to be public
aws s3api put-bucket-policy --bucket $S3_BUCKET --policy file://bucket_policy.json
 