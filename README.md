[![Build Status](https://travis-ci.org/viewthespace/pr-leaderboard.svg)](https://travis-ci.org/viewthespace/pr-leaderboard)
[![Circle CI](https://circleci.com/gh/viewthespace/pr-leaderboard.svg?style=svg)](https://circleci.com/gh/viewthespace/pr-leaderboard)

If you do all of your bug fixes and features on branches, you need engineers to review each others code.  We noticed that some engineers on our team were code reviewing titans and we wanted to highlight them each sprint.

![https://vts-monosnap.s3.amazonaws.com/PR_Leader_Board_2016-01-29_15-57-37__6nseo.png](image of leader board)

### Delete Code Leaderboard

After your project has been around a while, you may notice a buildup of code that's just not needed anymore.  As others have noted, this is a liability.  While this project was not created to track deleted code, it was too easy for us to not just add it to this project as it had all of the necessary github ingrendients.

![https://vts-monosnap.s3.amazonaws.com/Delete_Code_Leader_Board_2016-01-29_16-04-17__mkq1v.png])(image of delete code leaderboard)

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

Github only allows your to query 300 events at a time so we need to store all events locally.  There are two methods for retreiving data.  Probably the simplest is to just set up a script to run every 10 minutes that checks for new events.  Unless there are more than 300 events in 10 minutes, you should be getting everything.

You'll need a personal GITHUB_ACCESS_TOKEN env var set to retreive git events from the github api and store in your database.  You can create one [here](https://github.com/settings/tokens).

```
heroku config:set GITHUB_ACCESS_TOKEN=<your-github-access-token> --app pr-leaderboard-readme-example

```
Now set up the scheduled job within heroku scheduler




