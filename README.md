# php73-fpm-nginx-node
An opinionated docker image for PHP and JavaScript development.

Based on https://gitlab.com/ric_harvey/nginx-php-fpm

## What's Included

* [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh) with the [spaceship-prompt](https://github.com/denysdovhan/spaceship-prompt) theme

* [phpbrew](https://github.com/phpbrew/phpbrew)



## Usage

1. Run the setup script

```bash
./setup.sh
```

2. Modify `docker-compose.local.yml` as needed. At the minimum you should set
  * USERNAME the login account of the host machine - `whoami`
  * UID unix user id - `id -u`
  * GID unix group id - `id -g`
  
