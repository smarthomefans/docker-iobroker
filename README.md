# QQ 群 
欢迎加入ioBroker交流，群聊号码：776817275

# ioBroker for Docker

[![Build Status](https://travis-ci.org/buanet/docker-iobroker.svg?branch=master)](https://travis-ci.org/buanet/docker-iobroker)

Source: https://github.com/buanet/docker-iobroker

IoBroker for Docker is an Dockerimage for ioBroker IoT platform (http://www.iobroker.net). 

It is originally made for and always tested on a Synology Disk Station 1515+ with DSM 6 and official Docker package installed. But it also works on other systems with Docker installed!

Version 4 now supports running the Image in Docker on the following architectures: amd64, armv7hf, aarch64.
Feel free to ask for more architectures by opening an github issue. 

## Important notice

The new v4 comes again with a new major node version (node10)!
If you are updating an existing installation you have to perform some additional steps inside ioBroker!
After upgrading your iobroker container you have to call "npm rebuild" or "reinstall.sh" (when js-controller > v1.5 "reinstall.js") for recompileing your installation for the use with node10!
For more details please see official ioBroker documentation: [EN](https://www.iobroker.net/#en/documentation/install/updatenode.md) | [DE](https://www.iobroker.net/#de/documentation/install/updatenode.md).
Make backup first!

## Getting started

A detailed tutorial (german, based on v3.0.0) can be found here: [https://buanet.de](https://buanet.de/2019/05/iobroker-unter-docker-auf-der-synology-diskstation-v3/). Please notice that the old tutorial is outdated and does no longer work!

For discussion and support please visit [ioBroker forum thread](http://forum.iobroker.net/viewtopic.php?f=17&t=5089) or use the comments section at the linked tutorial. Please do not contact me directly for any support-reasons. Every support question should be answered in a public place. Thank you.

The following ways to geht iobroker-container running are only examples. Maybe you have to change, add or replace parameters to configure ioBroker for your environment.

### Running from commandline

For taking a first look at the iobroker docker container it would be enough to simply run the following basic docker run command: 

```
docker run -p 8081:8081 --name iobroker -v /opt/iobroker:/iobroker buanet/iobroker:latest
```

### Running with docker-compose

You can also run iobroker by using docker-compose. Here is an example:

```
version: '2'

services:
  iobroker:
    restart: always
    image: buanet/iobroker:latest
    container_name: iobroker
    hostname: iobroker
    ports:
      - "8081:8081"
    volumes:
      - iobrokerdata:/opt/iobroker
```

## Special settings and features

The following will give a short overview.

### Environment variables

To configure the ioBroker container on startup it is possible to set some environment variables. 

|env|default|description|
|---|---|---|
|ADMINPORT|8081|Sets ioBroker adminport on startup|
|AVAHI|false|Installs and activates avahi-daemon for supporting yahka-adapter, can be "true" or "false"|
|LANG|de_DE.UTF&#x2011;8|The following locales are pre-generated: de_DE.UTF-8, en_US.UTF-8|
|LANGUAGE|de_DE:de|The following locales are pre-generated: de_DE:de, en_US:en|
|LC_ALL|de_DE.UTF-8|The following locales are pre-generated: de_DE.UTF-8, en_US.UTF-8|
|PACKAGES|vi|Installs additional packages to your container needed by some adapters, packages should be seperated by whitespace like "package1 package2 package3"|
|REDIS|false|Activates the uses of redis as states-db on startup, fill with "hostname:port" to set redis connection, redis db has to be set up seperately (e.g. in another container)|
|SETGID|1000|For security reasons it might be useful to specify the gid of the containers iobroker user to match an existing group on the docker host|
|SETUID|1000|For security reasons it might be useful to specify the uid of the containers iobroker user to match an existing user on the docker host|
|TZ|Europe/Berlin|All valid Linux-timezones|
|USBDEVICES|none|Sets relevant permissions on mounted devices like "/dev/ttyACM0", for more than one device separate with ";" like "/dev/ttyACM0;/dev/ttyACM1"|
|ZWAVE|false|Will install openzwave to support zwave-adapter, can be "true" or "false"|

### Mounting Folder/ Volume

It is possible to mount an empty folder to /opt/iobroker during first startup of the container. The Startupscript will check this folder and restore content if it is empty.
Since v4.1.0 it is also possible mount a folder filled up with an iobroker backup file (created with backitup adapter) named like this: "iobroker_2020_01_06-01_09_10_backupiobroker.tar.gz".
The startup script will detect this backup and restore it during the start of the container. Plese see container logs when starting the container for more details!

Note: It is absolutely recommended to use a mounted folder or persistent volume for /opt/iobroker folder!

You can also mount a folder containing an existing ioBroker-installation (e.g. when moving an existing installation to docker).
But watch for the used node version. If the existing installation runs with another major version of node you have do perform additional steps. For more Details see the "Important notice" on top.

### Permission Fixer

After some issues with permissions related to the use of a dedicated user for ioBroker, I added some code for fixing permissions on container startup. This might take a few minutes on first startup. Please take a look at the container logs and be patient!

## Changelog

### v4.1.0 (2020-01-17)
* improved readme.md
* v4.0.3beta (2020-01-06)
  * added support to restore backup on startup
  * small fixes according to "docker best practices"
* v4.0.2beta (2019-12-10)
  * added env for activating redis
  * enhancements in startupscript and dockerfile
* v4.0.1beta (2019-11-25)
  * added env for iobroker admin port
  * added env for usb-devices (setting permissions)
  * updateing prerequisites for iobroker installation
  * some small codefixes

### v4.0.0 (2019-10-25)
* v3.1.4beta (2019-10-23)
  * added env for zwave support
* v3.1.3beta (2019-10-17)
  * enhanced logging of startup-script
  * multiarch support (amd64, aarch64, armv7hf)
* v3.1.2beta (2019-09-03)
  * using node 10 instead of node 8
* v3.1.1beta (2019-09-02)
  * adding env for setting uid/ gid for iobroker-user

### v3.1.0 (2019-08-21)
* v3.0.3beta (2019-08-21)
  * switching base image from "debian:latest" to "debian:stretch"
* v3.0.2beta (2019-06-13)
  * using gosu instead of sudo
  * changing output of ioBroker logging
* v3.0.1beta (2019-05-18)
  * ~~switching back to iobroker-daemon for startup~~

### v3.0.0 (2019-05-09)
* v2.0.6beta (2019-04-14)
  * added some additional logging
  * fixing some issues for languag env
  * added permission fixing on first start
* v2.0.5beta (2019-02-09)
  * added ENV to dockerfile
  * added EXPOSE for admin 
  * final testing
* v2.0.4beta (2019-01-28)
  * added support for env variables "avahi" and "packages"
  * moving avahi-daemon installation into avahi startup script
  * added script for installing optional packages
  * optimizing logging output
* v2.0.3beta (2019-01-24)
  * added support for running ioBroker under iobroker user
  * optimizing logging output
  * optimizing scripts
* v2.0.2beta (2019-01-23)
  * optimizing and rearraged dockerfile
  * changes for new ioBroker install script
  * added restoring for empty mounted /opt/iobroker folder
  * some more small fixes
* v2.0.1beta (2019-01-07)
  * some changes for supporting other docker-environments than synology ds

### v2.0.0 (2018-12-05)
* v1.2.2beta (2018-12-05)  
  * using node8 instead of node6 
  * changes for new iobroker setup
* v1.2.1beta (2018-09-12)
  * added support for firetv-adapter

### v1.2.0 (2018-08-21) 
* v1.1.3beta (2018-08-21)
  * added ffmpeg-package for yahka to support webcams
* v1.1.2beta (2018-04-04)
  * added ENV for timezone issue
* v1.1.1beta (2018-03-29)
  * added wget package
  * updated readme.md

###  v1.1.0 (2017-12-10)
* v1.0.2beta (2017-12-10)
  * changed startup call to fix restart issue
  * fixed avahi startup issue
  * fixed hostname issue
  * added z-wave support
  * added logging to /opt/scripts/docker_iobroker_log.txt
* v1.0.1beta (2017-08-25)
  * fixed locales issue

### v1.0.0 (2017-08-22)
* moved and renamed iobroker startup script
* disabled iobroker deamon to (hopefully) fix restart issue
* added some maintenance scripts

### v0.2.1 (2017-08-16)
* added libfontconfig package (for iobroker.phantomjs)
* added gnupg2 package as prerequisite for installing node version 6

### v0.2.0 (2017-06-04)
* fixed startup issue in startup.sh
* changed node version from 4 to 6

### v0.1.2 (2017-03-14)
* added libpcap-dev package (for iobroker.amazon-dash)

### v0.1.1 (2017-03-10)
* added git package

### v0.1.0 (2017-03-08)
* moved avahi-start.sh to seperate directory
* fixed timezone issue (sets now timezone to Europe/Berlin)

### v0.0.2 (2017-03-06)
* added support for avahi-daemon (installation and autostart)

### v0.0.1 (2017-01-31)
* project started / initial release

## License

MIT License

Copyright (c) 2017 [André Germann]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

## Credits

Inspired by https://github.com/MehrCurry/docker-iobroker
