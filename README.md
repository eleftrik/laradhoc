Laradhoc
===

![Laradhoc](https://user-images.githubusercontent.com/6959298/78071513-f83c9100-739d-11ea-9ff5-c63c1843bb3b.png)

![GitHub stars](https://img.shields.io/github/stars/eleftrik/laradhoc?style=social)
![GitHub watchers](https://img.shields.io/github/watchers/eleftrik/laradhoc?style=social)
![GitHub issues](https://img.shields.io/github/issues/eleftrik/laradhoc)
![GitHub](https://img.shields.io/github/license/eleftrik/laradhoc)
![GitHub tag (latest by date)](https://img.shields.io/github/v/tag/eleftrik/laradhoc?label=version)

**Laradhoc** is a Docker-based basic LEMP development environment designed for [Laravel](https://laravel.com/) applications.

Looking for a similar Docker environment for [WordPress](https://wordpress.org/)? Then give a try to
[Dockpress](https://github.com/eleftrik/dockpress)!

[Preferisci leggere in italiano? 🇮🇹](README.it.md)

## Features
* Nginx
* PHP (7.2 / 7.3 / 7.4 / 8.0) with OPCache
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

In case you want to customize your Docker configuration (e.g. adding some mount),
just run `cp docker-compose.yml docker-compose.override.yml` then edit your
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

NOTE: you need to import/install the `.crt` file so it will be trusted by
your operating system / browser.  

### Let's go

Build all Docker containers and start them
```bash
 .docker/scripts/init
```

---

Ok, let's talk now about your Laravel application!

New or existing?

### a. New application

New Laravel project from scratch? No problem, just run:
```bash
./.docker/scripts/install-laravel
```
A fresh Laravel app will be downloaded in `${APP_SRC}`, configured and available at [http://${APP_HOST}]()
or [https://${APP_HOST}]()

### b. Existing application

Do you have an existing Laravel Project?

Just copy it or clone it into `${APP_SRC}` so your Laravel application
is inside that directory.

Then run:
```bash
./.docker/scripts/init-laravel
```

Laradhoc will search for an `.env` file (if not found, it will try to copy `.env.example`).
Then, it will update your Laravel `.env` with the values taken from
the main `.env` file.
After this, it will install Composer dependencies and a key will
be generated by the usual Artisan command.

---

Remember to run manually your migrations / seeds:

```bash
./.docker/scripts/artisan migrate --seed
```

Do whatever your Laravel application needs to run correctly.
For example:
* `./.docker/scripts/artisan passport:install --force`
* `./.docker/scripts/node npm install && ./.docker/scripts/node npm run dev`
* etc.
--- 

Finished working? Just stop everything:
```bash
./.docker/scripts/stop
```

Next time you need to run your application, if you haven't changed any setting, just run
```bash
 .docker/scripts/start
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
  `docker-compose.yml` to check if something has added, changed or deleted, compared to
  the previous version of `docker-compose.yml` you were using before updating 
- launch `.docker/scripts/start --build`

## Scripts

Laradhoc provides some useful scripts, located in `.docker/scripts`.

Run them from your Laradhoc base folder.

### init

```bash
.docker/scripts/init
```

It will
* check `openssl` is installed on your host machine (if you set `NGINX_ENABLE_HTTPS=1`)
* create a self-signed certificate (if you set `NGINX_ENABLE_HTTPS=1`)
* build and start the containers

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
create a `${APP_SRC}/.env` file holding the same values which are in the main `.env` file

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
It will execute a *composer* command through the `composer` container.
For example:
```bash
.docker/scripts/composer install
``` 
### node
It will execute commands through the `node` container.
For example:
```bash
.docker/scripts/node yarn run production
``` 
### gulp
Need to run some "old" project still using `gulp`?
No problem: this command will run Gulp and compile
your assets.

For example:
```bash
.docker/scripts/gulp watch
``` 

### nah
Want to throw away **anything**?
This command will stop all containers, delete volumes and the entire `$APP_SRC`.

So, before executing this command, **BE SURE** you understood very well that
you're going to lose all your Laravel codebase and the related database!

```bash
.docker/scripts/nah
```

To throw away anything and start again from the scratch, use
```bash
.docker/scripts/nah && .docker/scripts/init && .docker/scripts/wp-install
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
