# Mudamos

[Mudamos](mudamos.org) is a web platform built with [Rails](https://github.com/rails/rails) framework.

### Requirements
 -  `Ruby-2.1.1` - *check your ruby version run* `ruby -v`
 -  [PostgresSQL](https://www.postgresql.org/download/)  *by default*

For database changes check `database.yml` file.

### Project setup

Local development can be configured using a `dotenv` file. The is a `.env.sample` that can be used to setup the initial one.

- `cp .env.sample .env.development`

If the sample env file does not require any change, you can just run the setup script, which will copy the file for you.

Run  In order to installs dependencies and prepares the database

- `bin/setup`


#### Accessing the admin area

In order to access the admin area, an admin user must be created.

- `rake users:create_admin_user`

Follow the instructions, and use the created user to access the admin area on Go to `http://localhost:3000/admin`.

### Running the web server
This command will start a development server at `localhost:3000`

- `rails s`

### Testing emails on development

 1 - Run `gem install mailcatcher`
 2 - Run `mailcatcher`
 3 - Go to `http://localhost:1080/`

### Troubleshooting

After completing the  `bin/setup`  command, access `localhost:3000` if an `ActiveRecord:RecordNotFound` error occurs when loading the page, follow these steps:

Type the following comands on the terminal:
 1. `rake db:drop`
 2.  `bin/setup`
