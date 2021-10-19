#!/bin/sh

while ! curl --fail --insecure http://idp.blue.test:9080/sample-idp/saml/idp/metadata
do
  echo "Waiting for IdP"
  sleep 5
done

java -Dcom.sun.management.jmxremote -Djavax.net.debug=ssl -Xmx128m -XX:+IdleTuningGcOnIdle -Xtune:virtualized -jar test-sp.jar
