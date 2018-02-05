## Next

* [PR 420]: Bump gems with known CVEs

## [1.22.0] - 24/11/2017

* [PR 416]: Return empty pdf signature list if national cause
* [PR 414]: Add a high limit for now when listing plips
* [PR 412]: Hide pdf signature list link when national cause
* [PR 409]: Handle national cause goals (Issue 408)
* [PR 406]: Allow national cause creation (statewide) (Issue 403, 405)
* [PR 402]: Return national causes on the plips api (Issue 400)
* [PR 399]: Allow creating national cause plips (Issue 396)
* [PR 398]: Show user location if present (Issue 397)
* [PR 394]: Send location info to the blockchain api (Issue 392)

## [1.21.0] - 25/10/2017

* [PR 395]: Do not send push message when creating a new plip (Issue 393)

## [1.20.0] - 25/08/2017

* [PR #391]: Notify users on all scope coverages (Issue 390)

## [1.19.0] - 23/08/2017

* [PR #388]: Return lib folder (Issue 387)

## [1.18.0] - 21/07/2017

* [PR #386]: Add option to fetch all plips (Issue 385)

## [1.17.0] - 08/06/2017

* [PR #379]: Only notify users when it is a nationwide plip (Issue 378)

## [1.16.0] - 15/05/2017

* [PR #370]: Format the plip’s metrics (Issue 369)
* [PR #368]: Expose plip signature goals (Issue 363)
* [PR #367]: Changes the current goal algorithm to increase by a 25% ratio (Issue 365)
* [PR #366]: Change petition days remaining message (Issue 364)

## [1.15.0] - 11/05/2017

* [PR #361]: Auto increase the signatures goal (Issue 346)
  - Run `rake db:migrate`
  - Run `rake petitions:fetch_info` in order to build new caches
* [PR #360]: Remove your account (Issue 349)
* [PR #359]: New favicon (no optimizations) (Issue 224)
* [PR #358]: Redirect “/ajuda” to the help form (Issue 357)
* [PR #356]: Redirect temporarily `envie-sua-ideia` (Issue 355)

## [1.14.0] - 26/04/2017

* [PR #352]: Add scope coverage (nationwide, statewide, citywide) to the petition (Issue 345)
  - Run `rake db:migrate`
* [PR #351]: Add petition push message notifier (Issue 307)
  - Set env `ONESIGNAL_API_KEY`
  - Set env `ONESIGNAL_APP_ID`
  - Set env `PETITION_NOTIFIER_QUEUE` with the push message queue
* [PR #348]: Revert TEMPFIX hack (issue 347)

## [1.13.1] - 12/04/2017

* [PR #344]: TEMP FIX using cycle final date to calculate remaining days (Issue 343)

## [1.13.0] - 12/04/2017

* [PR #341]: Hide “incorporar” share if not on a desktop (Issue 340)
* [PR #339]: Do not show the landing page if it is the petition page (Issue 338)
* [PR #337]: Parsing mobile api timestamps in the BRST zone (Issue 336)
* [PR #335]: Fix typo on footer (Issue 334)

## [1.12.2] - 11/04/2017

* [PR #333]: Change cycles order (Issue 332)

## [1.12.1] - 11/04/2017

* [PR #331]: Fix js error (Issue 330)

## [1.12.0] - 11/04/2017

* [PR #329]: Melhora na apresentação do modal do compartilhar
* [PR #328]: Correção dos termos públicos de Petição para Projeto de Lei
* [PR #325]: Fix “Incorporar” css issues (Issue 324)
* [PR #323]: Simplify the pre signature process (Issue 322)
  - Run `rake db:migrate`
* [PR #321]: Fix wrong signatures count progress bar (Issue 320)
* [PR #319]: Change petition label and video position (Issue 318)
* [PR #317]: Force hide “Informe-se” in the cycle menu (Issue 316)
* [PR #315]: Fix pdf generation with hardcoded data (Issue 314)

## [1.11.0] - 10/04/2017

* [PR #313]: Some layout changes for the app launch (Issue 312)

## [1.10.0] - 10/04/2017

* [PR #311]: App landing now appears on every route (Issue 310)

## [1.9.0] - 07/04/2017

* [PR #309]: Fix landing scroll after animations (Issue 308)
* [PR #306]: Add animations to the app landing page (Issue 287)
* [PR #305]: Add cycles to home (Issue 294)
* [PR #304]: Glue the solution home block to the tools together (Issue 299)
* [PR #303]: Fix app landing scroll (Issue 285)
* [PR #302]: Add app landing cookie as secure and httponly (Issue 301)
* [PR #300]: New drop menu colors and fixed mobile interaction (Issue 289, 290)
* [PR #298]: Add new solution and tools home block design (Issue 293)
* [PR #297]: Remove verify document link from the menu (Issue 292)
* [PR #296]: Changed the app store link (Issue 288)
  - Set `MOBILE_APP_STORE_PAGE_IOS` to `https://itunes.apple.com/br/app/mudamos/id1214485690?ls=1&mt=8`
* [PR #295]: Show the app landing page only once (Issue 286)
* [PR #284]: Fix report broken link (Issue 252)
* [PR #283]: Center cycle home description when single phased (Issue 218)
* [PR #282]: Add “scroll to” functionality to the home blocks (Issue 270)

## [1.8.0] - 30/03/2017

* [PR #273]: Adjust scroll anchor on home page (Issue 268)
* [PR #272]: Header assets now have the full viewport height (Issue 267)
* [PR #271]: Improves the homepage layout
* [PR #263]: Add lead logo settings (Issue 263)
  - Run `rake settings:add_home_lead_logo`

## [1.7.0] - 29/03/2017

* [PR #260]: Changes the upper navbar layout (Issue 246)
* [PR #259]: Add petition pdf signatures rake which will refresh the cache (Issue 228)
  - Configure crontab `rake petitions:fetch_petition_pdf_signatures` to every 10 minutes. This will update the cache.
* [PR #258]: Changes the static page layout (Issue 257)

## [1.6.1] - 28/03/2017

* [Hotfix]: Cycle menu won't work

## [1.6.0] - 28/03/2017

* [PR #256]: Changes the homepage layout (Issue 197)
* [PR #253]: Add home main video (Issue 251)
  - Set `MUDAMOS_VIDEO_BUCKET`
  - Run `rake db:migrate`
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
