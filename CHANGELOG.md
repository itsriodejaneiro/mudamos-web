## Next

* [PR #141]: Fixing past versions popover order and layout (issue 140)
* [PR #137]: Fixing app's protocol configuration
* [PR #135]: Adding metatag for itunes smart banner (issue 133)
 - Set `MOBILE_API_ID_IOS`
* [PR #131]: New petition's page (Issue 96)
* [PR #132]: Fixing remaining days on phase (issue 30)
* [PR #123]: Petition widget (issue 97)
 - Configure a cron to update the cache of the petitions information
 - Set `API_CACHE_EXPIRES_IN`
* [PR #114]: Changing order of the petitions past versions on the views (issue 114)

## [1.4.0] - 27/01/2017

* [PR #122]: Adding plip_url to the plip api (issue 121)
 - Set the `APP_DEFAULT_HOST` environment variable
 - Set the `APP_DEFAULT_SCHEME` environment variable
* [PR #117]: Adding synchronization of the petitions to the mobile api (issue 117)
 - Configure queue `PETITION_PUBLISHER_QUEUE`
 - Configure queue `PETITION_MOBILE_SYNC_QUEUE`
 - Set `MOBILE_API_URL` environment var
 - Set `MOBILE_API_TIMEOUT` environment var (optional)
 - Run `rake db:migrate`
* [PR #105]: Adding remaining days to the petition page (issue 105)
* [PR #106]: Fixing system handling of cycle creation when some plugin is not selected by the user
* [PR #113]: Fixing blog post creation
* [PR #104]: Sending message for user synchronization with the mobile platform (Issue 98) 
 - Configure `USER_SYNC_QUEUE` queue

## [1.3.0] - 17/01/2017

* [PR #112]: Fixing detail past version bug and fixing migrations order
* [PR #94]: Improving test suite Issue 94
* [PR #93]: Access to old petition versions (Issue 82 and 92)
* [PR #91]: Removing strikethrough from the markdown editor (Issue 90)
* [PR #89]: Petition automatic pdf upload (Issue 81)
  - Run `rake db:migrate`
  - Deploy shoryuken
  - Configure aws queues
* [PR #88]: Improvements on README file
* [PR #87]: Issue 80
  - Run `rake db:migrate`
* [PR #84]: Adding missing fields to the plips api
* [PR #77]: Renaming menu label TEMAS to CICLOS

## [1.2.0] - 05/01/2017

* [PR #58]: Logo change
* [PR #59]: Edition of Petition information on admin
  - Run `rake db:migrate`
* [PR #60]: Fixing the exhibition of the information on the end user's petition page
* [PR #66]: Fixing the cycle page when it's already finished
* [PR #67]: Removing https from the hardcoded links to plataformabrasil.org.br
* [PR #68]: Removing the link from the lead text from the home page
* [PR #69]: Inverting the order of the about and highlights
* [PR #70]: Adding Github Option to social links
* [PR #72]: Removing mock from the plips api
* [PR #74]: Changing labels with ciclos to temas

## [1.1.0] - 10/11/2016

### Features

* [PR 37]: Add new project setup script
* [PR 38]: Add new petition plugin
  - Run `rake plugins:sync`
* [PR 39]: Add admin petition page
* [PR 40]: Add 'saiba mais' petition page to the site
* [PR 41]: Add Plip api
* [PR 42]: Add social sharing to the petition page
* [PR 43]: Allow users to sign a petition
  - Run `rake db:migrate`
* [PR 44]: Sync project with production commits
* [PR 46]: Add mocked PLIP id to the entity response
* [PR 47]: Export user data to a json format
