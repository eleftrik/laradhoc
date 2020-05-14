Changelog
===
 
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

(no unreleased versions)

## [1.6.0] - 2020-05-14
### Added
- add `README.it.md` (README in Italian language)
- minor updates to `README.md` 

## [1.5.1] - 2020-05-06
### Added
- add `docker-compose.override.yml` to `.gitignore` so one can
  customize the configuration (e.g. bind mounts, etc.)
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
