# Mudamos

Mudamos is a web platform built with [Rails](https://github.com/rails/rails) framework.

### Project setup

Local development can be configured using a `dotenv` file. The is a `.env.sample` that can be used to setup the initial one.

- `cp .env.sample .env.development`

If the sample env file does not require any change, you can just run the setup script, which will copy the file for you.

- `bin/setup` -- installs dependencies and prepares the database

#### Dependencies

Mudamos depends on the following softwares:

  - ImageMagick: used by the pdf cover generation
    - Project info: https://www.imagemagick.org/script/index.php
    - Tested version: 6.9.x
    - on Mac install via: `brew install imagemagick`
    - on Heroku add the following build pack `https://github.com/ello/heroku-buildpack-imagemagick`

#### Accessing the admin area

In order to access the admin area, an admin user must be created.

- `rake users:create_admin_user`

Follow the instructions, and use the created user to access the admin area.

### Running the web server

- `rails s`

### Testing emails on development

 1 - Run `gem install mailcatcher`
 2 - Run `mailcatcher`
 3 - Go to `http://localhost:1080/`

### Environment variables

  - 'PETITION_PUBLISHER_QUEUE': Name of the sqs queue used for publishing the petitions
  - 'PETITION_PUBLISHER_PRIORITY': The priority of the sqs queue for the publication the petitions
  - 'USER_SYNC_QUEUE': Name of the sqs queue used for the user synchronization with the mobile platform
  - 'PETITION_MOBILE_SYNC_QUEUE': Name of the sqs queue used for the synchronization of the petitions versions with the mobile api
  - 'PETITION_MOBILE_SYNC_QUEUE_PRIORITY': The priority of the sqs queue for the synchronization of the petitions versions with the mobile api
  - 'PETITION_PDF_GENERATION_QUEUE': Name of the sqs queue used for the generation of the PDFs of the petitions
  - 'PETITION_PDF_GENERATION_QUEUE_PRIORITY': The priority of the sqs queue for the generation of the PDFs of the petitions
  - 'PETITION_PDF_BUCKET': Name of the bucket where the petition's pdfs are stored
  - 'PETITION_NOTIFIER_QUEUE': Name of the bucket where push messages are sent
  - 'PETITION_NOTIFIER_QUEUE_PRIORITY': The priority of the notifier queue
  - 'AWS_ACCESS_KEY_ID': AWS access key id used to access the aws resources
  - 'AWS_SECRET_ACCESS_KEY': AWS secret access key used to access the aws resources
  - 'AWS_REGION': The region where the AWS resources are
  - `APP_DEFAULT_HOST`: Which url the application is hosted
  - `APP_DEFAULT_SCHEME`: Which scheme the application uses (http or https)
  - 'MOBILE_API_URL': The Mobile API url
  - 'MOBILE_API_SECRET': The Mobile secret key
  - 'MOBILE_API_TIMEOUT': The ammount in seconds the system will use as timeout when trying to communicate with the Mobile API 
  - 'ONESIGNAL_API_KEY': The one signal api key (push message)
  - 'ONESIGNAL_APP_ID': The one signal app id (push message)
  - `API_CACHE_EXPIRES_IN`: The ammount in minutes that the system will use to expire requests from the Mobile API
  - `MOBILE_API_ID_IOS`: The iOs Mobile app id
  - 'MUDAMOS_VIDEO_BUCKET': mudamos video bucket
  - 'DB_POOL': database pool
  - 'RAILS_MAX_THREADS': web server max threads
  - 'RAILS_MIN_THREADS': web server min threads
  - 'RACK_TIMEOUT': request timeout forced by middleware in seconds
  - 'WEB_CONCURRENCY': number of web server workers

### Partners api

Patners can access information on this platform. in order to do so, an oauth applciation must be created by an admin user.

- as an admin access: `oauth/applications` and create a new partner application
- Patners can use both the client id (application id) and client secret to issue a request for an access token

#### Getting an access token

Partners should call like bellow:

- ` curl -XPOST "http://apphost/oauth/token?client_secret={client_secret}&client_id={client_id}&grant_type=client_credentials" -H "Accept: application/json" -d ''`

A valid response would be:

- `{"access_token":"98f46d3a93245a428ec2749fe40cf256bcd9ff81d3cddb08fb28b0fb3515a598","token_type":"bearer","expires_in":7200,"created_at":1488915853}`

Later partners can use the available apis:

- pre signature

##### Pre signature api

This api receives a user which will be pre signing a project.

- `curl -v -XPOST "http://apphost/partners_api/petitions/{petition_id}/pre_sign" -H "Authorization: Bearer 66bffa59da5bf7a14e5a92c1affa8a4a3928195933135ff0fac8550336f65f1e" -H "Accept: application/json" -H "Content-Type: application/json" -d '{"email": "user@mail.com", "name": "A user name"}'`

Where `petition_id` is the id of a project (`PetitionPlugin::DetailVersion`).

A 204 response means a success.

### Queue configurations

## Petition pdf generation

Recommended values:
 * Default Visibility Timeout: 60 secs
 * Message Retention Period: 4 days (SQS default)
 * Maximum Message Size: 256 KB (SQS default)
 * Delivery Delay: 0 secs (SQS default)
 * Receive Message Wait Time: 0 secs (SQS default)

## Petition mobile sync

Recommended values:
 * Default Visibility Timeout: 60 secs
 * Message Retention Period: 4 days (SQS default)
 * Maximum Message Size: 256 KB (SQS default)
 * Delivery Delay: 0 secs (SQS default)
 * Receive Message Wait Time: 0 secs (SQS default)

## Petition publisher

Recommended values:
 * Default Visibility Timeout: 60 secs
 * Message Retention Period: 4 days (SQS default)
 * Maximum Message Size: 256 KB (SQS default)
 * Delivery Delay: 0 secs (SQS default)
 * Receive Message Wait Time: 0 secs (SQS default)

## Petition notifier

Recommended values:
 * Default Visibility Timeout: 60 secs
 * Message Retention Period: 14 days
 * Maximum Message Size: 256 KB (SQS default)
 * Delivery Delay: 15 secs (SQS default)
 * Receive Message Wait Time: 15 secs

### Running the workers

`bundle exec shoryuken -C config/shoryuken.yml -R`

> Remember to export your env vars

### Petition flow

This diagram shows the flow of the petition, from the user creation, to its publication.

```
+--------------------+    +------------------------+    +------------------------+    +-------------------------+    +------------------------+
|                    |    |                        |    |                        |    |                         |    |                        |
|                    |    |                        |    |                        |    |                         |    |                        |
|    Admin User      |    |      Mudamos-Web       |    |           SQS          |    |      Mobile-api         |    |       Blockchain       |
|                    |    |                        |    |                        |    |                         |    |                        |
|                    |    |                        |    |                        |    |                         |    |                        |
+--------------------+    +------------------------+    +------------------------+    +-------------------------+    +------------------------+
        +---+                      +---+                           +---+                          +---+                         +---+
        |   |Creates the petition  |   | Schedule pdf generation   |   |                          |   |                         |   |
        |   +---------------------->   +------------------------>  |   |                          |   |                         |   |
        |   |                      |   |                           |   |                          |   |                         |   |
        |   |                      |   |  Generates the pdf and    |   |                          |   |                         |   |
        |   |                      |   |  stores it on S3          |   |                          |   |                         |   |
        |   |                      |   | <-------------------------+   |                          |   |                         |   |
        |   |                      |   |                           |   |   Register petition on   |   |                         |   |
        |   |                      |   |                           |   |   the mobile api         |   |                         |   |
        |   |                      |   +--------------------------------------------------------->|   |                         |   |
        |   |                      |   |                           |   |                          |   |  Register the petition  |   |
        |   |                      |   |                           |   |                          |   |  on the blockchain      |   |
        |   |                      |   |                           |   |  Schedule the petition   |   +-----------------------> |   |
        |   |                      |   |                           |   |  publication             |   |                         |   |
        |   |                      |   |                           |   |<-------------------------+   |                         |   |
        |   |                      |   |                           |   |                          |   |                         |   |
        |   |                      |   |    Publishes the petition |   |                          |   |                         |   |
        |   |                      |   | <-------------------------+   |                          |   |                         |   |
        |   |                      |   |                           |   |                          |   |                         |   |
        +---+                      +---+                           +---+                          +---+                         +---+

```

## Send a push message


```
$ rake push:message["A title", "A body"]
```
