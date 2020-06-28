# nextcloud-dev-docker-compose

Nextcloud development environment using docker-compose
Forken from https://github.com/juliushaertl/nextcloud-docker-dev.git

⚠ **DO NOT USE THIS IN PRODUCTION** Various settings in this setup are considered insecure and default passwords and secrets are used all over the place


## Getting started

### Get the code
```
git clone https://github.com/pdsinterop/nextcloud-docker-dev.git
cd nextcloud-docker-dev
git submodule init --update --recursive
```

### Environment variables

A `.env` file should be created in the repository root, to keep configuration default on the dev setup:

```
COMPOSE_PROJECT_NAME=master

REPO_PATH_SERVER=./server
ADDITIONAL_APPS_PATH=./solid-nextcloud

NEXTCLOUD_AUTOINSTALL_APPS=viewer activity

BLACKFIRE_CLIENT_ID=
BLACKFIRE_CLIENT_TOKEN=
BLACKFIRE_SERVER_ID=
BLACKFIRE_SERVER_TOKEN=

# can be used to run separate setups besides each other
DOCKER_SUBNET=192.168.15.0/24
PORTBASE=815

# Main dns names for ssl proxy
# This can be used to append a custom domain name to the container names
DOMAIN_SUFFIX=.local
```

### Add SSL keys

To setup SSL support provide a proper DOMAIN_SUFFIX environment variable and put the certificates to ./data/ssl/ named by the domain name.

You might need to add the domains to your `/etc/hosts` file:

```
127.0.0.1 nextcloud.local
127.0.0.1 collabora.local
```

This is assuming you have set `DOMAIN_SUFFIX=.local`

You can generate selfsigned certificates using:

```
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout  nextcloud.local.key -out nextcloud.local.crt
```

### Starting the containers

- Start full setup: `docker-compose up`
- Minimum: `docker-compose up proxy nextcloud` (nextcloud mysql redis mailhog)


### Running into errors

If your setup isn't working and you can not figure out the reason why, running
`docker-compose down -v` will remove the relevant containers and volumes,
allowing you to run `docker-compose up` again from a clean slate.

## ✉ Mail

Sending/receiving mails can be tested with [mailhog](https://github.com/mailhog/MailHog) which is available on ports 1025 (SMTP) and 8025 (HTTP).

## Development

### OCC

Run inside of the nextcloud container:
```
set XDEBUG_CONFIG=idekey=PHPSTORM
sudo -E -u www-data php -dxdebug.remote_host=192.168.21.1 occ
```

### Useful commands

- Restart apache: `docker-compose kill -s USR1 nextcloud`
