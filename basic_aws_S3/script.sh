#!/bin/bash

# you can create the bucket using aws cli but let's start by doing it in the console
# NB: do brew install jq, on mac or sudo apt-get install jq on ubuntu


while true; do
    read -p "Please enter the Amazon S3 bucket name for your deployment: "  S3_BUCKET

    if [ "$S3_BUCKET" != "" ]
    then
      # check if bucket already exist
      if 
        aws s3api head-bucket --bucket "$S3_BUCKET" 2>/dev/null;  
      then  

        aws s3 sync ./website_2/ "s3://$S3_BUCKET" 
        # replace bucket name in json file
        jq '.Statement[].Resource="arn:aws:s3:::'$S3_BUCKET'/*"' bucket_policy.json > bucket_policy_to_used.json

        # uncheck the public access denied
           aws s3api put-public-access-block \
        --bucket $S3_BUCKET  \
        --public-access-block-configuration "BlockPublicAcls=false,IgnorePublicAcls=false,BlockPublicPolicy=false,RestrictPublicBuckets=false"
 
        # add the bucket ACL to your bucket to allow object to be public
        aws s3api put-bucket-policy  --bucket $S3_BUCKET \
        --policy file://bucket_policy_to_used.json  

        # Issue the AWS S3 API CLI command to enable your bucket's “Static Website Hosting” property. In this same command, you will also provide the index.html page, which is your bucket URL:
        aws s3 website s3://$S3_BUCKET --index-document index.html
     
        echo "let's check it the website is deployed"
        curl "http://$S3_BUCKET.s3-website.us-east-1.amazonaws.com"

      else
        echo "Bucket doesn't exist!"
      fi

      exit;

    else
      echo "please enter the bucket name"
    fi
done
