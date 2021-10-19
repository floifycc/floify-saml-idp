# floify-saml-idp
SAML IdP to provide SSO with partners like Encompass

## Prerequisites

A few minor prerequisites are needed to be able to run the Docker test environment successfully.

1. Add entries mapping 127.0.0.1 to both `sp.blue.test` and `idp.blue.test` to `/etc/hosts`:
```
127.0.0.1 idp.blue.test
127.0.0.1 sp.blue.test
```

## Building and Deploying

The easiest way to build and deploy the SAML environment is to use the Docker Compose environment.
The following commands will build the Docker containers and then launch them. 

```
mvn package docker:build
cd docker
docker-compose up
```

Once running, the following commands will bring the environment down.

```
<Ctrl+C>
docker-compose stop
docker-compose down
```
