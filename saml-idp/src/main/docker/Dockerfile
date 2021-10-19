FROM adoptopenjdk/openjdk13-openj9:jdk-13.0.2_8_openj9-0.18.0-alpine-slim

RUN apk --no-cache add curl

COPY maven/saml-idp-*.jar saml-idp.jar

EXPOSE 9080
EXPOSE 9443

CMD ["java", "-Dcom.sun.management.jmxremote", "-Djavax.net.debug=ssl", "-Xmx128m", "-XX:+IdleTuningGcOnIdle", "-Xtune:virtualized", "-jar", "saml-idp.jar"]
