## Next

## [1.3.0] - 16/01/2017

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
