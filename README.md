# Basic Dockerfile for jhipster

Slimmed the base image to roughly 650Mb :

* based on Debian 8
* JDK 8 without visualVM nor mission control
* Maven from distribution (3.3.3)
* Node.js from distribution (0.12)
* grunt-cli, karma-cli available

Exposed ports are  :

* 3000 / 3001 for Browsersync
* 22 for ssh'ing
* 8080 for direct Java server access
