#!/bin/bash

openssl req -newkey rsa:2048 -new -nodes -x509 -days 3650 -keyout service-provider-private.key -out service-provider-certificate.crt
