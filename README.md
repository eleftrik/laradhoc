Laradhoc
===

![Laradhoc](media/images/laradhoc.png)

![GitHub stars](https://img.shields.io/github/stars/eleftrik/laradhoc?style=social)
![GitHub watchers](https://img.shields.io/github/watchers/eleftrik/laradhoc?style=social)
![GitHub issues](https://img.shields.io/github/issues/eleftrik/laradhoc)
![GitHub](https://img.shields.io/github/license/eleftrik/laradhoc)
![GitHub tag (latest by date)](https://img.shields.io/github/v/tag/eleftrik/laradhoc?label=version)

🆕 ✅ *Version **2.5.0** is out - PHP 8.3 support*

**Laradhoc** is a Docker-based basic LEMP development environment designed for [Laravel](https://laravel.com/)
applications.

Looking for a similar Docker environment for [WordPress](https://wordpress.org/)? Then give a try to
[Dockpress](https://github.com/eleftrik/dockpress)!

[Preferisci leggere in italiano? 🇮🇹](README.it.md)

## Features

* Nginx
* PHP (7.2 / 7.3 / 7.4 / 8.0 / 8.1 / 8.2 / 8.3) with OPCache
* Composer 2.0
* MySQL / MariaDB
* MongoDB
* phpMyAdmin
* Mailhog
* Redis
* Custom domain name (es. `http://laradhoc.test` or `https://laradhoc.test`)
* HTTP or HTTPS (with self-signed SSL certificate)
* npm
* gulp (for old projects)

You can choose which version of PHP (for example, `7.4`) to run by setting `$PHP_VERSION` variable in your
`.env` file (see `.env.example` for details).

Likewise, you can choose your database (for example, `MariaDB 10.2`) by setting `$DATABASE_IMAGE` variable in your
`.env` file (see `.env.example` for details)

In case you want to customize your Docker configuration (e.g. adding some mount), just
run `cp docker-compose.yml docker-compose.override.yml` then edit your
`docker-compose.override.yml`. It will be used by Docker.

## Requirements

* MacOS, Linux or Windows with WSL
* Docker
* `openssl` (when using HTTPS)

## Installation

Just clone this repo.

Let's pretend your Laravel application will be accessible at `laradhoc.test`:

```bash
git clone git@github.com:eleftrik/laradhoc.git laradhoc.test
cd laradhoc.test
```

## `laradhoc` command

Before version `2.1.0`, you had to

- `cd` into Laradhoc folder
- invoke `./bin/laradhoc`

Starting from version `2.1.0`, you can invoke `laradhoc` no matter which folder you're in.

**Tip** If you want to invoke `laradhoc` command when you're into your Laravel folder, define an
alias `alias laradhoc='../bin/laradhoc'` (e.g. in your `.bashrc` file).

In this way, when you're using your terminal in the root folder of you Laravel project, you can simply type `laradhoc` (
as if the binary were in the same folder).

## Configuration

### .env

Create an `.env` file from `.env.example`

```bash
cp .env.example .env

# Customize every variable according to your needs
# See comments to each variable in .env.example file
```

### Custom domain

According to the value of `${APP_HOST}`, add your test domain (e.g. `laradhoc.test`) to your hosts file

```bash
sudo /bin/bash -c 'echo -e "127.0.0.1 laradhoc.test" >> /etc/hosts'
```

### HTTPS

Choose if you want to run your application over HTTP or HTTPS.

* HTTPS: set `NGINX_ENABLE_HTTPS=1`
* HTTP: set `NGINX_ENABLE_HTTPS=0`

With HTTPS enabled, a self-signed SSL certificate will be generate.

Under `.docker/images/nginx/ssl` you will find

* `${APP_HOST}.test.crt`
* `${APP_HOST}.test.key`

NOTE: you need to import/install the `.crt` file so it will be trusted by your operating system / browser.

### Let's go

Build all Docker containers and start them

```bash
 ./bin/laradhoc init
```

---

Ok, let's talk now about your Laravel application!

New or existing?

### a. New application

New Laravel project from scratch? No problem, just run:

```bash
./bin/laradhoc install-laravel
```

A fresh Laravel app will be downloaded in `${APP_SRC}`, configured and available at [http://${APP_HOST}]()
or [https://${APP_HOST}]()

### b. Existing application

Do you have an existing Laravel Project?

Just copy it or clone it into `${APP_SRC}` so your Laravel application is inside that directory.

Then run:

```bash
./bin/laradhoc init-laravel
```

Laradhoc will search for an `.env` file (if not found, it will try to copy `.env.example`). Then, it will update your
Laravel `.env` with the values taken from the main `.env` file. After this, it will install Composer dependencies and a
key will be generated by the usual Artisan command.

---

Remember to run manually your migrations / seeds:

```bash
./bin/laradhoc artisan migrate --seed
```

Do whatever your Laravel application needs to run correctly. For example:

* `./bin/laradhoc artisan passport:install --force`
* `./bin/laradhoc node npm install && ./bin/laradhoc node npm run dev`
* etc.

--- 

Finished working? Just stop everything:

```bash
./bin/laradhoc stop
```

Next time you need to run your application, if you haven't changed any setting, just run

```bash
./bin/laradhoc 
```

<b>Please note</b> Nginx will proxy all request from `socket.io` to `laravel-echo` container.

## Updates

When updating from a previous version, follow these steps:

- update your code
    - via `git pull` if you're still referencing this repository, a fork or a private one
    - manually downloading the desired [release](https://github.com/eleftrik/laradhoc/releases)

  In both cases, the `src/` folder won't be affected
- see `CHANGELOG.md`
- update your `./.env` file according to `./.env.example`
  (new variables may have been introduced)
- if you have overridden `docker-compose.yml` using `docker-compose.override.yml`, see
  `docker-compose.yml` to check if something has added, changed or deleted, compared to the previous version
  of `docker-compose.yml` you were using before updating
- launch `./bin/laradhoc start --build`

## Scripts

Laradhoc provides some useful scripts, located in `.docker/scripts`.

Run them from your Laradhoc base folder.

### init

```bash
./bin/laradhoc init
```

It will

* check `openssl` is installed on your host machine (if you set `NGINX_ENABLE_HTTPS=1`)
* create a self-signed certificate (if you set `NGINX_ENABLE_HTTPS=1`)
* build and start the containers

### start | up

```bash
./bin/laradhoc start
```

or

```bash
./bin/laradhoc up
```

It's a shortcut to

```bash
docker-compose up -d
```

### build

If you want to (re)build the images, use

```bash
./bin/laradhoc build
```

### stop | down

Tired of working? Stop the environment

```bash
./bin/laradhoc stop
```

or

```bash
./bin/laradhoc down
```

### install-laravel

It's useful to bring up a new Laravel project. It will prepare a fresh Laravel app in your `${APP_SRC}`, create
a `${APP_SRC}/.env` file holding the same values which are in the main `.env` file

```bash
./bin/laradhoc install-laravel
```

### init-laravel

Update the Laravel `.env` with the environment values coming from the main `.env` file

```bash
./bin/laradhoc init-laravel
```

### artisan

It will execute an artisan command inside the php-fpm container. For example:

```bash
./bin/laradhoc artisan make:migration create_example_table
``` 

### composer

It will execute a *composer* command through the `composer` container. For example:

```bash
./bin/laradhoc composer install
``` 

### node

It will execute commands through the `node` container. For example:

```bash
./bin/laradhoc node yarn run production
``` 

### gulp

Need to run some "old" project still using `gulp`? No problem: this command will run Gulp and compile your assets.

For example:

```bash
./bin/laradhoc gulp watch
``` 

### test

This command will execute PHPUnit tests:

```bash
./bin/laradhoc test
``` 

### ps

This command will show running containers, according to docker-compose file:

```bash
./bin/laradhoc ps
``` 

It's a shortcut to

```bash
docker-compose ps
``` 

### nah

Want to throw away **anything**? This command will stop all containers, delete volumes and the entire `$APP_SRC`.

So, before executing this command, **BE SURE** you understood very well that you're going to lose all your Laravel
codebase and the related database!

```bash
./bin/laradhoc nah
```

To throw away anything and start again from the scratch, use

```bash
./bin/laradhoc nah && ./bin/laradhoc init && ./bin/laradhoc laravel-install
```

### help

This command will show a quick help, listing all available commands:

```bash
./bin/laradhoc help
``` 

## Accessing MySQL/MariaDB database

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

## Accessing MongoDB

MongoDB is listening on port 27017.

In the following examples, of course you have to replace
`user`, `password` and `laradhoc` with the current values of your
`MONGODB_USER`, `MONGODB_PASSWORD` and `MONGODB_DATABASE` environment variables.

If in your host you did install *mongo* CLI, you can access through command line:

```shell script
mongo -u user -p password laradhoc
```

Otherwise, you can access through with your favourite tool, using this connection string:

`mongodb://user:password@localhost/laradhoc`

## MailHog

To catch all outgoing emails via MailHog, configure your Laravel `.env` file with these parameters:

```dotenv
MAIL_HOST=mailhog
MAIL_PORT=1025
MAIL_USERNAME=
MAIL_PASSWORD=
```

MailHog web interface is available at

[http://${APP_HOST}:${MAILHOG_PORT}]()

For example: [http://laradhoc.test:8081]()

## Spinning up fresh Docker containers

You can remove all old Docker containers and spin up your entire project from scratch. This is ideal if you're working in multiple environments.

```bash
sh .\.docker\scripts\rundocker.sh
```

## Contributing

Suggestions, reviews, bug reports are very welcome. We never stop learning :-)

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## Thanks

Thanks to

- [Mauro Cerone](https://github.com/ceronem)
- Sail by [Taylor Otwell](https://github.com/taylorotwell)

for the inspiration

## License

[MIT](https://choosealicense.com/licenses/mit/)
