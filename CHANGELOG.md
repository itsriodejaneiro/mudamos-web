## Next

* [PR #253]: Add home main video (Issue 251)
  - Set `MUDAMOS_VIDEO_BUCKET`
  - Run `rake settings:add_home_main_video`
* [PR #247]: Add tools block mock design (Issue 242)
* [PR #245]: Add new home blocks (Issue 244)
  - Run `rake settings:add_new_home_blocks`
* [PR #239]: Improves the petition page layout (Issue 202)
* [PR #238]: Issue 196 complete form (Issue 196)
* [PR #236]: Add new reset password modals (Issue 196)
* [PR #235]: Add new login design (Issue 196)
* [PR #234]: Add new sign up design (Issue 196)
* [PR #233]: New signatures pdf list design (Issue 200)
* [PR #231]: Add new signature validation design (Issue 230)
* [PR #229]: Add new document verification layout (Issue 198)
* [PR #227]: Fetch petition past versions from the mobile api (Issue 222)
  - Configure crontab `rake petitions:past_versions` to every 10 minutes. This will update the cache.
* [PR #226]: Remove Faraday net_http_persistent adapter (Issue 225)
* [PR #223]: Add mobile api secret (Issue 219)
  - Set `MOBILE_API_SECRET`
* [PR #220]: Add petition video (Issue 217)
  - Run `rake db:migrate`

## [1.5.0] - 10/03/2017

* [PR #216]: Closing both login and registration forms during petition sign (Issue 215)
* [PR #213]: New sign api with pre signature email (Issue 193, 206)
* [PR #211]: Extension was missing on the smart banner icon (issue 212)
* [PR #209]: Parsing a hexadecimal string representing the signature (Issue 208)
* [PR #207]: Fix oauth lookup by the user email (Issue 201)
* [PR #203]: Handle mobile api validation errors on /signatures (Issue 192)
* [PR #191]: Revisar login - RETORNO bizarro textarea (Issue 188)
* [PR #190]: Add mobile api namespace (Issue 189)
* [PR #187]: Add petition name to the petition register payload (Issue 184)
* [PR #186]: Fix profile and birthday not being required (Issue 185)
* [PR #177]: Page to list petition's signatures pdf (Issue 110)
* [PR #176]: Page to verify signatures (Issue 160)
* [PR #181]: Change petition info api path (Issue 180)
* [PR #179]: Setting cache store to memory on stagging and production (Issue 178)
  - Run `heroku addons:create memcachier:dev`
* [PR #175]: Adding page for verifying petition pdfs (Issue 158)
* [PR #172]: Fixing final date on phases (issue 171)
 - rake phases:ends_on_the_end_of_the_day
* [PR #174]: Hiding the pre signature button when the phase is not in progress (issue 173)
* [PR #170]: Adjustments to the signers widget (Issue 169)
* [PR #168]: Extension was missing on the petition widget watermark image (issue 167)
* [PR #165]: Adding limit to plips api (Issue 161)
* [PR #163]: Requesting missing information from the user on plugin interaction (Issue 144)
* [PR #164]: Fixing the exhibition of the petition information (Issue 159)
* [PR #149]: New petition's pdf (Issue 149)
* [PR #124]: Petition widget builder (Issue 124)
* [PR #155]: Creating smartbanner for the platform and adding it to the petition's page (issue 134)
 - Set `MOBILE_APP_STORE_PAGE_ANDROID`
 - Set `MOBILE_APP_STORE_PAGE_IOS`
* [PR #152]: Date of the current version is now the date which the document was upated on the blockchain (issue 33)
* [PR #147]: Adding a partner api for user creation (issue 146)
* [PR #151]: Adding page url on the payload to the petition mobile api synchronization (issue 150)
* [PR #145]: Adding signers widget on petition's page (Issue 109)
 - Configure a cron to update the cache of the petition's signers
* [PR #143]: Adding oath authentication for partners API (Issue 127)
 - Run `rake db:migrate`
* [PR #142]: Removing user field requirements (Issue 126)
* [PR #141]: Fixing past versions popover order and layout (issue 140)
* [PR #137]: Fixing app's protocol configuration
* [PR #135]: Adding metatag for itunes smart banner (issue 133)
 - Set `MOBILE_API_ID_IOS`
* [PR #131]: New petition's page (Issue 96)
* [PR #132]: Fixing remaining days on phase (issue 30)
* [PR #123]: Petition widget (issue 97)
 - Configure a cron to update the cache of the petition's information
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
