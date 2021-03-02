Changelog
===

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres
to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

No unreleased versions

## [2.2.0] - 2021-03-02

### Changed
- remove `composer` container and use `php-fpm` to leverage the same PHP version

## [2.1.0] - 2021-02-25

### Changed

- `laradhoc` binary can now be invoked outside Laradhoc's folder
  (e.g. inside `src` folder)

### Added

- `laradhoc phpunit` to run tests inside a Docker container

## [2.0.2] - 2021-01-29

### Fixed

- wrong `Laradhoc is not running` message error even if Laradhoc is up
- fix `composer` version
- fix `artisan` command and remove `XDEBUG` warnings

## [2.0.1] - 2021-01-25

### Fixed

- `./bin/laradhoc` checks if `.env` file exists
- `./bin/laradhoc help` can be run even without `.env` file or without running containers

## [2.0.0] - 2021-01-24

### Changed

- add `./bin/laradhoc` as a common entrypoint to run commands
- add commands / aliases (see `./bin/laradhoc help`)
- use Composer 2

## [1.9.0] - 2021-01-24

### Added

- support for PHP 8.0

## [1.8.3] - 2021-01-11

### Fixed

- GD library support

## [1.8.2] - 2021-01-05

### Fixed

- `restart` property is now set to `unless-stopped` for all containers

## [1.8.1] - 2020-10-26

### Fixed

- expose port 6379 to make Redis reachable from host machine

## [1.8.0] - 2020-10-17

### Added

- add MongoDB support

## [1.7.0] - 2020-08-13

### Added

- add LDAP extension to php-fpm container

## [1.6.3] - 2020-08-05

### Fixed

- update start script - stop and start again didn't work due to inconsistent names

## [1.6.2] - 2020-08-05

### Fixed

- update stop script - after version 1.6.1, containers didn't stop

## [1.6.1] - 2020-08-04

### Changed

- update init script - use CONTAINER_PREFIX also for image names

## [1.6.0] - 2020-05-14

### Added

- add `README.it.md` (README in Italian language)
- minor updates to `README.md`

## [1.5.1] - 2020-05-06

### Added

- add `docker-compose.override.yml` to `.gitignore` so one can customize the configuration (e.g. bind mounts, etc.)

### Fixed

- minor updates to `README.md`

## [1.5.0] - 2020-04-27

### Added

- add `$PHP_VERSION` env variable to choose PHP version (between `7.2`, `7.3`, `7.4`)

### Changed

- improve `.env.example` readability

## [1.4.1] - 2020-04-23

### Fixed

- fix HTTPS not working due to a missing arg in docker-compose.yml

## [1.4.0] - 2020-04-22

### Added

- add `$DATABASE_IMAGE` env variable to choose database image (MySQL or MariaDB, with optional tags)

## [1.3.0] - 2020-04-13

### Added

- `gulp` script to run `gulp` (for old projects)

## [1.2.1] - 2020-04-04

### Fixed

- HTTP only (didn't work)
- create SSL certificates only if `$NGINX_ENABLE_HTTPS`= 1

## [1.2.0] - 2020-03-30

### Added

- add `NGINX_ENABLE_HTTPS` option to `.env` file in order to run the application over **HTTPS**
  (if set to `0`, the application will run over HTTP)
- add `NGINX_PORT_443` to remap HTTPS port
- add `openssl` to requirements (on your host) if using HTTPS
- add `init` script to create a new self-signed certificate (if using HTTPS)
- add `nah` script to purge everything (containers, volumes, application files)

### Fixed

- fix some typos and improve comments

## [1.0.2] - 2020-03-28

### Added

- add Laradhoc logo to README.md file
- add GitHub badges to README.md file

### Changed

- make this project public on GitHub

### Fixed

- `init-laravel` script
    * check for `.env` file existence; if not, copy from `.env.example` (only for an existing project)
    * run `composer install` and `artisan key:generaate`  (only for an existing project)
- `composer` script: ignore platform requirements

## [1.0.1] - 2020-03-28

### Fixed

- `init-laravel` script made wrong substitutions into `.env` file

## [1.0.0] - 2020-03-28

Publish this project on github.com
