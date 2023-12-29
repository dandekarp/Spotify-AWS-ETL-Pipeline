CREATE OR REPLACE SCHEMA SPOTIFY;

create or replace table tblAlbum (
album_sk int,
album_id varchar(100),
album_name varchar(100),
album_release_date date,
album_total_tracks numeric,
album_url varchar(300)
);

create or replace table tblArtist (
artist_sk int,
artist_id varchar(100),
artist_name varchar(100),
external_url varchar(300)
);

create or replace table tblSong (
song_sk int,
song_id varchar(100),
song_name varchar(100),
duration_ms numeric,
url varchar(300),
popularity numeric,
song_added date,
album_id varchar(100),
artist_id varchar(100)
);

-- Creating external stage (create your own bucket)
CREATE OR REPLACE STAGE DW_COURSE_DB.SPOTIFY.spotify_aws_stage
    url='s3://spotify-etl-bucket-pd/transformed_data/'
    credentials=(aws_key_id='your_aws_key' aws_secret_key='your_secret_key');

list @spotify_aws_stage;

CREATE OR REPLACE FILE FORMAT dw_course_db.spotify.CSV
TYPE = CSV,
FIELD_DELIMITER = ","
SKIP_HEADER = 1;

alter file format csv
set FIELD_OPTIONALLY_ENCLOSED_BY = '"';

drop file format dw_course_db.spotify.CSV;

-- create snowpipes for each every individual folders in Amazon S3:

create or replace pipe album_pipe
    auto_ingest = TRUE
    AS
    copy into tblalbum
    from @spotify_aws_stage/album_data
    file_format = CSV;

create or replace pipe artist_pipe
    auto_ingest = TRUE
    AS
    copy into tblartist
    from @spotify_aws_stage/artist_data
    file_format = CSV;

create or replace pipe song_pipe
    auto_ingest = TRUE
    AS
    copy into tblsong
    from @spotify_aws_stage/songs_data
    file_format = CSV;