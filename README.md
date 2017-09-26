# README

## Spelling Backend

This API provides an easy way to implement a game similar to spelling bees, where you listen to a word and then you provide its spelling.

Main things to cover in this README:

* Ruby version
* System dependencies
* Configuration
* Database creation
* Database initialization
* How to run the test suite
* Deployment instructions
* API documentation

### Ruby Version
`ruby 2.3.1p112 (2016-04-26 revision 54768) [x86_64-darwin15]`

### System Dependencies

- Bundler
- PostgreSQL
- Rails (`Rails 5.1.4`)

### Configuration

If running the application locally, PostgreSQL server should be running on port 5432 by default.
Seed data need to be added to the db. Run `rails db:seed` to insert all the seed data.

### Database creation

Run `rails db:create` to create a local database.

### Database initialization

Run `rails db:migrate` to run all db migrations and `rails db:seed` to insert seed data.

### How to run the test suite

To run the test suite make sure there is a testing database already created, or simply run `rails db:test:prepare`.
Then run all the specs by running `bundle exec rspec spec`

### Deployment instructions

This application is deployed to heroku. To deploy it make sure you have the heroku toolbelt cli. Then make sure you have the heroku remote `https://git.heroku.com/ancient-beach-49570.git`. After that run `heroku push origin master` and the deployment process will start. The application will be deployed to `https://ancient-beach-49570.herokuapp.com`

> NOTE: To deploy the application locally make sure you have the `foreman` gem installed and after configuring the database and creating the seed data, run `foreman start`. This will start the application server on  `localhost:5000`.

### API documentation

This application exposes two endpoints `/next_exercise` and `/evaluate_exercise`.

#### `/next_exercise`

This endpoint responds to the HTTP GET method. It accepts two optional parameters `last_word_id` (string uuid) and `solved_words` (array of strings).

> When passing `last_word_id` the API will return any other word except the one that matches the `last_word_id`.

> When passing `solved_words` the API will return any other word except the one that matches all the ids passed inside the `solved_words` array.

The result is a json text which looks like the following:

```
{
  "word_id": "ad7216c4-685a-4ad4-8aee-b144335d7da3",
  "original_word": "disadvantage",
  "scrambled": [
    "g",
    "v",
    "n",
    "d",
    "s",
    "t",
    "e",
    "a",
    "i",
    "a",
    "a",
    "d"
  ]
}
```

#### `/evaluate_exercise`

This endpoint responds to the HTTP GET method. It accepts two required parameters `word_id` (string uuid) and `answer` (string).

> `word_id` is used to let the system know which word we are trying to solve and `answer` is what is used to do the evaluation.
> The result will be an analysis of the user's answer and can return something like the following:

```
{
  "message": "You got it right, Congrats!",
  "correctness_percentage": 100,
  "wrong_letters_indexes": []
}
```
Or something like this when the user failed the exercise:

```
{
  "message": "You only missed 2 letter(s)",
  "correctness_percentage": 80,
  "wrong_letters_indexes": [
    8,
    9
  ]
}
```
