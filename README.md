# Spotify-AWS-ETL-Pipeline

## Overview:

The goal of this project is to build an automated data pipeline that extracts raw data from the Spotify API into Amazon S3 bucket, transforms and store into Amazon S3 and load into Snowflake using SnowPipe to build analysis using PowerBI

## Architecture Diagram
<img src="spotify_aws_etl.jpeg">

## Tools 

- ### Python
   
- ### Dataset- [Spotify API](https://spotipy.readthedocs.io/en/2.22.1/)

- ### Amazon Web Services

     1. Amazon S3 (Simple Storage Services): **Storage**
        - Amazon S3 provides scalable object storage, like a virtual hard drive in cloud.
          
     2. Amazon Cloudwatch: **Monitoring**
        - This AWS service is for collecting and tracking metrics, monitoring log files, and setting alarms.
          
     3. AWS Lambda: **Serverless Computing**
        - Allows you to run code without provisioning or managing servers, responding to events anf automatically scaling.
          
     4. SnowPipe: **Discovery**
        - Snowpipe enables loading of data into Snowflake tables automatically and continuously from Amazon S3 buckets.
          
     5. Snowflake: **Cloud datawarehouse**
        - Enables you to analyze data stored in Snowflake tables using standard SQL queries.

## Execution Process

 + ### Extract data from Spotify API and integrate it with Python
    
    - Here the data is getting extracted from Spotify API using a Python library called Spotipy. The data once extracted is then subdivided into 3 different Dataframes of Artists, Albums and Songs
    - The purpose of creating Dataframes is because the data extracted from APIs are never in readable form, they come in key-vlaue pair format.
    - So the data is categorized in different Dataframes as, a Dataframe is a 2-D data structure in which data is aligned in a tabular fashion in rows and columns.
    - Each Dataframe is created so that it gets easy reading data for analysis purpose.

      
+ ### Deploy code on AWS Lambda to extract API data
  
    - The complete code is well tested and verified to be deployed to AWS Lambda. Lambda is the first stage to enter into AWS.
    - We create the first Lambda function to extract data from API and to store the extracted data we use **S3**, for that S3 bucket is created.
    - The timeout should be increased from a default of 3 seconds or else the function might run into runtime error.
    - As many customs libraries might not be present in AWS similarly in this case *Spotipy* had to be manually uploaded to **Lambda Layer**.
    - S3 bucket is a container to store different objects in S3 as inside our bucket we have two different folders created- transformed_data and raw_data_spotify.
    - We store the raw data extacted from the API into raw_data_spotify so to be utilized later for transformation.
    - AWS capability to interact Lambda with S3 is fulfilled by **boto3** client.
      
+ ### Create another Lambda function for transformation
  
    - Now the transformation is done on the extarcted data so that cleansed and proper formatted data is loaded to S3.
    - Here the DATE data is transformed into it's proper *datetime* format.
    - Lambda function gives you freedom to add logic as to how you want your data to look and as per the data we extract from other sources we can transform it the way we want.
      
+ ### Add triggers for continuous extraction from Spotify
  
    - The API is integrated and data is extracted but to keep extracting the data at a particular rate, **AWS Cloudwatch** can be used.
    - Cloudwatch is used here as trigger to extract data let's say on daily basis
      
+ ### Store files in Amazon S3
  
    - The three dataframes created will now be used to store data in S3, the data after transformation is now made to store in form of CSV files inside our S3 bucket folder- transformed_data.
    - Inside that there are three folders named- album_data, artist_data and songs_data are created which will store the dataframe data.
    - Another trigger can be added to our tranformation Lambda function to store the data coming in on daily basis, this way the data storage is automated.
       
+ ### Load data into Snowflake using SnowPipe
  
    - Create Tables in Snowflake - Use CREATE TABLE statements to define tblAlbum, tblArtist and tblSongs tables in a database/schema according to the data that will be loaded from S3 files. Define appropriate columns and data types.
    - Configure External Stage - Create an external stage that points to the S3 location. Define file format and credentials for accessing S3 files. Test connectivity.
    - Validate Data Loads - Use COPY INTO command to load sample files from the S3 stage to validate data loading into Snowflake tables. Confirm data was loaded correctly.
    - Define Snowpipe Pipes - Create 3 separate Snowpipe objects using CREATE PIPE statements, one for each table - album, artist and songs. Configure loading parameters like file pattern, file format, etc.
    - Trigger Test Runs - Manually add/copy new files into the monitored S3 locations for each pipe. Snowpipe will automatically pick up and load the files through the pipeline into respective tables.
    - Validate pipeline - After test runs complete, validate that all files were loaded to proper tables. Check counts, data quality to confirm Snowpipe processed successfully end to end.