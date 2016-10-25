# Mudamos

Mudamos is a web platform built with [Rails](https://github.com/rails/rails) framework.

### Project setup

Local development can be configured using a `dotenv` file. The is a `.env.sample` that can be used to setup the initial one.

- `cp .env.sample .env.development`

If the sample env file does not require any change, you can just run the setup script, which will copy the file for you.

- `bin/setup` -- installs dependencies and prepares the database

#### Accessing the admin area

In order to access the admin area, an admin user must be created.

- `rake users:create_admin_user`

Follow the instructions, and use the created user to access the admin area.

### Running the web server

- `rails s`
