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

If you're using a Posgres docker, you need to set `PGGSSENCMODE=disable`

- `PGGSSENCMODE=disable rails s`

### Testing emails on development

 1 - Run `gem install mailcatcher`
 2 - Run `mailcatcher`
 3 - Go to `http://localhost:1080/`

### Environment variables

  - `API_CACHE_EXPIRES_IN`: The ammount in minutes that the system will use to expire requests from the Mobile API
  - `APP_DEFAULT_HOST`: Which url the application is hosted
  - `APP_DEFAULT_SCHEME`: Which scheme the application uses (http or https)
  - 'AWS_ACCESS_KEY_ID': AWS access key id used to access the aws resources
  - 'AWS_REGION': The region where the AWS resources are
  - 'AWS_SECRET_ACCESS_KEY': AWS secret access key used to access the aws resources
  - 'DB_POOL': database pool
  - 'GOOGLE_ACCOUNT_TYPE': Type of google account(used by gem 'googleauth')
  - 'GOOGLE_CLIENT_EMAIL': E-mail of google account(used by gem 'googleauth')
  - 'GOOGLE_PRIVATE_KEY': Private key of google account(used by gem 'googleauth')
  - 'IBGE_CITIES_LIST_URL': IBGE url which returns all cities in Brazil
  - 'IBGE_CITIES_POPULATION_URL': IBGE url which returns the city population sensus
  - `MOBILE_API_ID_IOS`: The iOs Mobile app id
  - 'MOBILE_API_SECRET': The Mobile secret key
  - 'MOBILE_API_TIMEOUT': The ammount in seconds the system will use as timeout when trying to communicate with the Mobile API
  - 'MOBILE_API_URL': The Mobile API url
  - 'MUDAMOS_VIDEO_BUCKET': mudamos video bucket
  - 'ONESIGNAL_API_KEY': The one signal api key (push message)
  - 'ONESIGNAL_APP_ID': The one signal app id (push message)
  - 'PETITION_MOBILE_SYNC_QUEUE': Name of the sqs queue used for the synchronization of the petitions versions with the mobile api
  - 'PETITION_MOBILE_SYNC_QUEUE_PRIORITY': The priority of the sqs queue for the synchronization of the petitions versions with the mobile api
  - 'PETITION_NOTIFIER_QUEUE': Name of the bucket where push messages are sent
  - 'PETITION_NOTIFIER_QUEUE_PRIORITY': The priority of the notifier queue
  - 'PETITION_PDF_BUCKET': Name of the bucket where the petition's pdfs are stored
  - 'PETITION_PDF_GENERATION_QUEUE': Name of the sqs queue used for the generation of the PDFs of the petitions
  - 'PETITION_PDF_GENERATION_QUEUE_PRIORITY': The priority of the sqs queue for the generation of the PDFs of the petitions
  - 'PETITION_PUBLISHER_QUEUE': Name of the sqs queue used for publishing the petitions
  - 'PETITION_PUBLISHER_PRIORITY': The priority of the sqs queue for the publication the petitions
  - 'PLIP_CHANGED_SYNC_QUEUE': The queue which announces plip changes to the mobile api
  - 'RACK_TIMEOUT': request timeout forced by middleware in seconds
  - 'RAILS_MAX_THREADS': web server max threads
  - 'RAILS_MIN_THREADS': web server min threads
  - 'USER_SYNC_QUEUE': Name of the sqs queue used for the user synchronization with the mobile platform
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
        |   |                      |   |                           |   |  publication (async, SQS)|   |                         |   |
        |   |                      |   |                           |   |<-------------------------+   |                         |   |
        |   |                      |   |                           |   |                          |   |                         |   |
        |   |                      |   |    Publishes the petition |   |                          |   |                         |   |
        |   |                      |   | <-------------------------+   |                          |   |                         |   |
        |   |                      |   |                           |   |                          |   |                         |   |
        |   |                      |   |                           |   |                          |   |                         |   |
        |   |                      |   |  Schedule share link      |   |                          |   |                         |   |
        |   |                      |   |  generation               |   |                          |   |                         |   |
        |   |                      |   +------------------------>  |   |                          |   |                         |   |
        |   |                      |   |                           |   |                          |   |                         |   |
        |   |                      |   |  Generate share link and  |   |                          |   |                         |   |
        |   |                      |   |  stores it                |   |                          |   |                         |   |
        |   |                      |   | <-------------------------+   |                          |   |                         |   |
        |   |                      |   |                           |   |                          |   |                         |   |
        |   |                      |   |                           |   |                          |   |                         |   |
        |   |                      |   | Schedule sync petition    |   |                          |   |                         |   |
        |   |                      |   +-------------------------> |   |                          |   |                         |   |
        |   |                      |   |                           |   |                          |   |                         |   |
        |   |                      |   |  Start the petition sync  |   |                          |   |                         |   |
        |   |                      |   | <-------------------------+   |                          |   |                         |   |
        |   |                      |   |                           |   |  Sync petition info      |   |                         |   |
        |   |                      |   |                           |   |  on the mobile api       |   |                         |   |
        |   |                      |   +--------------------------------------------------------> |   |                         |   |
        |   |                      |   |                           |   |                          |   |                         |   |
        +---+                      +---+                           +---+                          +---+                         +---+

```

## Send a push message


```
$ rake push:message["A title", "A body"]
```

## Release

Inorder to build a new app image version, you need to provide the script both APP_VERSION and HUB_APP_URI.

ps. aws cli v1 required.

- APP_VERSION: the version to build eg. 4.56.99
- HUB_APP_URI: the image repository eg. xpto.dkr.ecr.a-region.amazonaws.com/image-name

This command below will build the image and apply the version, staging and latest tags.
The version tag will be pushed to the HUB (image repository).

```
$ APP_VERSION=x.xx.x HUB_APP_URI=some-uri ./bin/release
```

In order to push the staging image do:

```
$ HUB_APP_URI=some-uri ./bin/push-staging
```

In order to push the latest image (production).


```
$ HUB_APP_URI=some-uri ./bin/push-latest
```

## Troubleshoting
If libv8 and therubyracer fails to install on mac, try:

```
$ brew install v8@3.15
$ bundle config build.libv8 --with-system-v8
$ bundle config build.therubyracer --with-v8-dir=$(brew --prefix v8@3.15)
```
