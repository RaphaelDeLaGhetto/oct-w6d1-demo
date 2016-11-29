# recyclefreedom 

Salvage app.

# Install dependencies

In `bash`:

```
gem install bundler
bundle install
```

# Install the Sinatra runner

In `bash`:

```
mkdir -p ~/workspace/.c9/runners/; wget https://gist.githubusercontent.com/kvirani/2d816e0f8e3fea328e8d/raw/01c2eddf2dcece5f3f14e85c70dffb8bcef62c77/Sinatra.run -O ~/workspace/.c9/runners/Sinatra.run
```

# Start server

From your Cloud9 menu bar:

```
Run > Run With > Sinatra
```

# Set up sample database

The base table migration is found in `db/migrate`. It creates the tables
required to model a simple blog (i.e.: _users_, _posts_, _comments_, and
_likes_).

Create:

```
bundle exec rake db:create
```

Migrate:

```
bundle exec rake db:migrate
```

Seed:

```
bundle exec rake db:seed
```

# Heroku

From the `bash` commandline, install the CLI:

```
wget -O- https://toolbelt.heroku.com/install-ubuntu.sh | sh
```

Assuming you've already opened a Heroku account:

```
heroku login
heroku create
```

This will produce to URLs:

1. Your new web address
2. A git repository

Make note of them both.

Commit any changes:

```
git commit -am "Get changes"
```

Push your local repository to Heroku:

```
git push heroku
```

Migrate the database.

```
heroku run bundle exec rake db:migrate
```

If there are any problems with migrating, try this:

```
heroku addons:create heroku-postgresql
```

You can make sure the database has been added to the project like this:

```
heroku config
```

### Reset database

```
heroku pg:reset DATABASE --confirm recyclefreedom
```
