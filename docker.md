# Docker

## common commands

`docker image ls`

Lists all iamges.

`docker container ls --all`

Lists all containers, even if they have exited.

`docker pull ubuntu`

Pulls an image of Ubuntu.

`docker pull php`

Pulls an image of php.

`docker start my_web_server`

## inside a container

`exit`

Exits the container.

## help

`docker --help`

`docker container --help`

`docker container ls --help`

`docker run --help`

## behavior

If the image does not exist locally when you run `docker run`, it will pull it (`docker pull`).
