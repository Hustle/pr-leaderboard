[![Build Status](https://travis-ci.org/viewthespace/pr-leaderboard.svg)](https://travis-ci.org/viewthespace/pr-leaderboard)
[![Circle CI](https://circleci.com/gh/viewthespace/pr-leaderboard.svg?style=svg)](https://circleci.com/gh/viewthespace/pr-leaderboard)

If you do all of your bug fixes and features on branches, you need engineers to review each others code.  We noticed that some engineers on our team were code reviewing titans and we wanted to highlight them each sprint.

![image of pr leaderboard](https://vts-monosnap.s3.amazonaws.com/PR_Leader_Board_2016-01-29_15-57-37__6nseo.png)

### Delete Code Leaderboard

After your project has been around a while, you may notice a buildup of code that's just not needed anymore.  As others have noted, this is a liability.  While this project was not created to track deleted code, it was too easy for us to not just add it to this project as it had all of the necessary github ingrendients.

![image of delete code leaderboard](https://vts-monosnap.s3.amazonaws.com/Delete_Code_Leader_Board_2016-01-29_17-32-28__8bqsb.png)

### Installation instruction

This is a simple rails 4 project.  We run it on Heroku but it can be run on anywhere with access to ruby 2.X+ and postgres 9.4+.  Since it's easy to set up on heroku, the instructions below will assume Heroku.  The commands below clone the repo, create a heroku app, push the project to the heroku app, and create the database.

```
git clone https://github.com/viewthespace/pr-leaderboard.git 
cd pr-leaderboard
heroku apps:create pr-leaderboard-readme-example
git push heroku master
heroku run rake db:migrate --app pr-leaderboard-readme-example
```

#### Retreiving Github Commits and Pull Requests

Github only allows your to query 300 events at a time so we need to store all events locally.  There are two methods for retreiving data.  

##### Using the API

Probably the simplest is to just set up a script to run every 10 minutes that checks for new events.  Unless there are more than 300 events in 10 minutes, you should be getting everything.  The only issue is, since your access token is personal, it will report on all of your projects.  Not sure if there is a way around this.  This is not a problem with webhooks.

You'll need a personal GITHUB_ACCESS_TOKEN env var set to retreive git events from the github api and store in your database.  You can create one [here](https://github.com/settings/tokens).

```
heroku config:set GITHUB_ACCESS_TOKEN=<your-github-access-token> --app pr-leaderboard-readme-example
```
Now set up the scheduled job within heroku scheduler.  First create the add on:

```
heroku addons:create scheduler:standard --app pr-leaderboard-readme-example
heroku addons:open scheduler --app pr-leaderboard-readme-example
```

Then schedule this command to run every 10 minutes:

```
rails r "Event.add_events!"
```

That's it.  Now every 10 minutes, the job will grab the last 100 github events and persist any new ones.

##### Webhooks

Webhooks can be configured on github at the organization level under settings -> webhooks:

https://github.com/organizations/<your-org>/settings/hooks

![Web hook configuration](https://vts-monosnap.s3.amazonaws.com/Add_webhook_2016-01-29_17-54-47__6stde.png)

Notice the webhook url on your app is available at /github_webhooks and we are set to receive all events.  Pick a good secret key and set it on your app:

```
heroku config GITHUB_WEBHOOK_SECRET=<shared-webhook-secret> -a pr-leaderboard-readme-example
```

Now the app should be receiving updates.

Both polling for events and web hook updates work.  I honestly have both running and for redundancy.

### Setting sprint start

Both Leader Boards restart after 2 week sprints.  In order to know when the first sprint started, we need to set another environment variable.  

```
heroku config:set SPRINT_START=2015-10-05 --app pr-leaderboard-readme-example
```

### Accessing the leader boards

Assuming the rails app has been started, the PR leader board is accessible at the default root path '/'.  The Delete Code leader board is available at '/delete_code_leader_board/'

In order to see past sprints, pass in a date parameter which can be any date within a previous sprint.  For example:

[http://pr-leaderboard.readme-example.herokuapp.com?date=2016-01-23](http://pr-leaderboard.readme-example.herokuapp.com?date=2016-01-23)

or

[http://pr-leaderboard.readme-example.herokuapp.com//delete_code_leader_board?date=2016-01-23](http://pr-leaderboard.readme-example.herokuapp.com//delete_code_leader_board?date=2016-01-23)
    
## TODO
* Add variable length sprints.  Currently hard coded to two weeks.
* Add drop down for selecting sprints
* Add navigation



