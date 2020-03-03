# Laradhoc

Laradhoc is a Docker-based basic PHP development environment designed for Laravel applications.

## Installation

Just clone this repo.

```bash
git@github.com:eleftrik/laradhoc.git
```

## Configuration

Create an .env file (see .env.example).
```bash
./start --build
```
Is this a new project? No problem, just run:
```bash
./install-laravel
```
A fresh laravel app will be ready soon in your $APP_SRC

Do you have an existing Laravel Project? Just run:
```bash
./init-laravel
```
Laradhoc will update your Laravel .env with the env variables (please backup it first)
Are you tired of working (we are all tired of working)? Just stop everythings:
```bash
./stop
```
Go out, take a beer with friends and tell them how Laradhoc is easy to use. Yes, your friends are all developers!!

<b>N.B.</b> don't forget to add laradhoc.test to your host file
```bash
sudo /bin/bash -c 'echo -e "127.0.0.1 laradhoc.test" >> /etc/hosts'
```
<b>N.B.</b> Nginx will proxy all request from /socket.io to laravel-echo container
## Script
Laradhoc provides some useful script:
### start
It's a shortcut to 
```bash
docker-compose up -d
```
You can add the flag --build if you want to build the image, otherwise
```bash
./start
```
is enough to bring up the environment
### stop
I had already explained to you, just stop everything and drink beer
```bash
./stop
```
### install-laravel
It's usefull to bring up a new laravel project. It will prepare a freshly Laravel app in your $APP_SRC and update the Laravel .env with the environments variable.
```bash
./install-laravel
```
### init-laravel
Update the Laravel .env with the environments variable.
### artisan
It will execute an artisan command inside the php_fpm container e.g.
```bash
./artisan make:migration create_example_table
``` 

### composer
It will execute a composer command through the composer container e.g.
```bash
./composer install
``` 
### node
It will execute command through the node container e.g.
```bash
./node yarn run production
``` 
## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License
[MIT](https://choosealicense.com/licenses/mit/)
