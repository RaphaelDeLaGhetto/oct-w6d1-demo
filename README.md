# c9-sinatra-setup

_Hello, world!_ Sinatra app for quick classroom demos on Cloud9

# Clone this repository into a new workspace

```
https://github.com/RaphaelDeLaGhetto/c9-sinatra-setup.git
```

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
