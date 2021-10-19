FROM adoptopenjdk/openjdk13-openj9:jdk-13.0.2_8_openj9-0.18.0-alpine-slim

RUN apk --no-cache add curl bash

COPY entrypoint.sh entrypoint.sh

EXPOSE 8080
EXPOSE 8443

COPY maven/test-sp-*.jar test-sp.jar

ENTRYPOINT ["./entrypoint.sh"]
