#Dream places
 
Dream Places is about not having regrets. The world is beautiful and full of amazing places and people that many of us just wish we could go and explore.
Dream Places helps you do just that.

Dream Places helps you create their perfect trips or weekend. With recommendations from friends, you get advice from people who have been there. Your plan is built on advice that you can trust, ensuring the most awesome experience.

## Heroku URL
http://pure-anchorage-6231.herokuapp.com/

## Technologies used

* Ruby on Rails
* PostgreSQL
* jQuery
* Google Maps API
* MailGun API
* Amazon S3 API to store picture
* Gems used: bcrypt, carrierwave, gon

## Deployment instructions

Download and install by running:
```
bundle install
```
Install the database by running:
```
rake db:create db:migrate
```
Create environment variables (in a file called `local_env.yml` in the config folder for example):
* GOOGLE_MAP_API_KEY
* MAILGUN_DOMAIN (domain of your account on MailGun)
* MAILGUN_API_KEY (API key of your account on MailGun)
* AWS_ACCESS_KEY_ID (for Amazon S3 service)
* AWS_SECRET_ACCESS_KEY (for Amazon S3 service)
* AWS_BUCKET_NAME for Amazon S3 service)

Run the server with:
```
rails s
```
Go on the app, create a user and log in


##Contributors:
* Valentine
* Coen
