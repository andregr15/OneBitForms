# OneBitForms

Ruby on Rails Api for OneBitForms Client (Google Forms Clone)

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### With Docker

#### Prerequisites

You must have docker and docker-compose installed

```
For more information, please see https://docs.docker.com/install/ 
```

#### Installing

Access the project folder in your terminal enter the following

```
$ docker-compose build
```

```
$ docker-compose run --rm app bundle install
```

```
$ docker-compose run --rm app bundle exec rails db:create
```

```
$ docker-compose run --rm app bundle exec rails db:migrate
```

After that for test the installation enter the following to up the server

```
$ docker-compose up
```

Open your browser and access localhost:3000 to see the home page

### Running the tests

To run the tests run the following in your terminal

```
$ docker-compose run --rm app bundle exec rspec
```

### Without Docker

#### Prerequisites

You must have ruby and bundler gem installed

```
For more information, please see https://www.ruby-lang.org/en/documentation/installation/
```

#### Installing

Access the project folder in your terminal enter the following

```
$ bundle install
```

```
$ bundle exec rails db:create
```

```
$ bundle exec rails db:migrate
```

After that for test the installation enter the following to up the server

```
$ bundle exec rails s
```

Open your browser and access localhost:3000 to see the home page

#### Running the tests

To run the tests run the following in your terminal

```
$ bundle exec rspec
```


## Built With

* [Ruby on Rails](https://rubyonrails.org/) - The web framework used
* [Devise Token Auth](https://github.com/lynndylanhurley/devise_token_auth) - Authentication Token
* [Rack Cors](https://github.com/cyu/rack-cors) - Cross-Origin Resource Sharing (CORS) for Rack compatible web applications.
* [Rack Attack](https://github.com/mperham/sidekiq) - Rack middleware for blocking & throttling abusive requests
* [Friendly Id](https://github.com/moove-it/sidekiq-scheduler) - "Swiss Army bulldozer" of slugging and permalink plugins for Active Record
* [OmniAuth](https://github.com/omniauth/omniauth) - Standardizes multi-provider authentication for web applications
* [PostgreSQL](https://www.postgresql.org/) - SGDB
* [Rspec Rails](https://github.com/rspec/rspec-rails) - RSpec testing framework to Ruby on Rails as a drop-in alternative to its default testing framework, Minitest.
* [Factory Bot Rails](https://github.com/thoughtbot/factory_bot_rails) - Fixtures replacement with a straightforward definition syntax
* [FFaker](https://github.com/ffaker/ffaker) - Easily generate fake data 

## Authors

* **André Gonçalves Rodrigues** - [andregr15](https://github.com/andregr15)

## License

This project is licensed under the MIT License
