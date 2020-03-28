Laradhoc
===

Laradhoc is a Docker-based basic PHP development environment designed for Laravel applications.

## Features
* Nginx
* PHP 7.4 with OPCache
* MySql 8
* phpMyAdmin
* Mailhog
* Redis
* Custom domain name (es. `http://laradhoc.test`)  

## Requirements

* MacOS, Linux or Windows with WSL
* Docker

## Installation

Just clone this repo.

```bash
git@github.com:eleftrik/laradhoc.git
```

## Configuration

Create an `.env` file from `.env.example`
```bash
cp .env.example .env

# Customize every variable according to your needs
# See comments to each variable in .env.example file
```

According to the value of `${APP_HOST}`, add your test domain (e.g. `laradhoc.test`) to your hosts file
```bash
sudo /bin/bash -c 'echo -e "127.0.0.1 laradhoc.test" >> /etc/hosts'
```

Build all Docker containers and start them
```bash
 .docker/scripts/start --build
```

New Laravel project from scratch? No problem, just run:
```bash
./.docker/scripts/install-laravel
```
A fresh Laravel app will be downloaded in `${APP_SRC}`, configured and available at [http://${APP_HOST}]()

Do you have an existing Laravel Project in `${APP_SRC}`? Just run:
```bash
./.docker/scripts/init-laravel
```

Laradhoc will update your Laravel `.env` with the env variables (please backup it first)

Finished working? Just stop everything:
```bash
./.docker/scripts/stop
```

<b>N.B.</b> Nginx will proxy all request from /socket.io to laravel-echo container

## Updates

When updating from a previous version, follow these steps:
- update your code
    - via `git pull` if you're still referencing this repository, a fork or a private one
    - manually downloading the desired [release](https://github.com/eleftrik/laradhoc/releases)
    
    In both cases, the `src/` folder won't be affected 
- see `CHANGELOG.md`
- update your `./.env` file according to `./.env.example`
  (new variables may have been introduced)
- launch `.docker/scripts/start --build`

## Scripts

Laradhoc provides some useful scripts, located in `.docker/scripts`:

### start

```bash
.docker/scripts/start
```

It's a shortcut to 
```bash
docker-compose up -d
```
You can add the flag `--build` if you want to build the images, otherwise
```bash
.docker/scripts/start
```
is enough to bring up the environment

### stop
Tired of working? Stop the environment
```bash
.docker/scripts/stop
```

### install-laravel
It's useful to bring up a new Laravel project.
It will prepare a fresh Laravel app in your `${APP_SRC}`,
create a `${APP_SRC}/.env` file holding the same values which are in the main `./env` file

```bash
.docker/scripts/install-laravel
```

### init-laravel
Update the Laravel `.env` with the environment values coming from
the main `.env` file
```bash
.docker/scripts/init-laravel
```

### artisan
It will execute an artisan command inside the php-fpm container.
For example:
```bash
.docker/scripts/artisan make:migration create_example_table
``` 

### composer
It will execute a Composer command through the composer container.
For example:
```bash
.docker/scripts/composer install
``` 
### node
It will execute commands through the Node container.
For example:
```bash
./node yarn run production
``` 

## Accessing the database

### Via phpMyAdmin
You can use phpMyAdmin: [http://${APP_HOST}:${PHPMYADMIN_PORT}]()

For example: [http://laradhoc.test:8080]()

### Via client
You can connect to your database via command line or using a tool.

For example, from the command line:
```bash
source .env
mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -h127.0.0.1 $MYSQL_DATABASE
```
I bet you prefer to use your favorite tool, for example:
- TablePlus
- SequelPro
- HeidiSQL

etc.

Just use the parameters stored in your .env file.

## MailHog

To catch all outgoing emails via MailHog, configure your Laravel `.env` file
with these parameters:

```dotenv
MAIL_HOST=mailhog
MAIL_PORT=1025
MAIL_USERNAME=
MAIL_PASSWORD=
```

MailHog web interface is available at

[http://${APP_HOST}:${MAILHOG_PORT}]()

For example: [http://laradhoc.test:8081]()

## Contributing
Suggestions, reviews, bug reports are very welcome.
We never stop learning :-)

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## Thanks

Thanks to [Mauro Cerone](https://github.com/ceronem) for the inspiration

## License
[MIT](https://choosealicense.com/licenses/mit/)
