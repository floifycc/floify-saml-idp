# From https://superuser.com/questions/226192/avoid-password-prompt-for-keys-and-prompts-for-dn-information
# From https://dev.to/techschoolguru/how-to-create-sign-ssl-tls-certificates-2aai

OPENSSL=openssl
KEYTOOL=keytool
PASSPHRASE=FloifyPassword

CA_KEY=ca.key
CA_CERT=ca.crt
CA_PEM=ca.pem
CA_DN="/C=US/ST=Colorado/L=Boulder/O=Floify/OU=Engineering/CN=CA"
CA_ALIAS=ca
CA_TRUSTSTORE=ca.pkcs12
CA_OPTS=req -x509 -new -newkey rsa:4096 -days 3650 -passout "pass:$(PASSPHRASE)"  -subj $(CA_DN) -keyout $(CA_KEY) -out $(CA_CERT)
CA_TRUSTSTORE_OPTS=pkcs12 -export -in $(CA_PEM) -name $(CA_ALIAS) -passin "pass:$(PASSPHRASE)" -out $(CA_TRUSTSTORE) -passout "pass:$(PASSPHRASE)"

IDP_TLS_SERVER_KEY=idp-tls.key
IDP_TLS_SERVER_CSR=idp-tls.csr
IDP_TLS_SERVER_CERT=idp-tls.crt
IDP_TLS_SERVER_PEM=idp-tls.pem
IDP_TLS_SERVER_DN="/C=US/ST=Colorado/L=Boulder/O=Floify/OU=Engineering/CN=idp.blue.test"
IDP_TLS_SERVER_REQ_OPTS=req -newkey rsa:4096 -passin "pass:$(PASSPHRASE)" -passout "pass:$(PASSPHRASE)" -keyout $(IDP_TLS_SERVER_KEY) -out $(IDP_TLS_SERVER_CSR) -subj $(IDP_TLS_SERVER_DN)
IDP_TLS_SERVER_SIGN_OPTS=x509 -req -in $(IDP_TLS_SERVER_CSR) -days 3650 -CA $(CA_CERT) -CAkey $(CA_KEY) -CAcreateserial -passin "pass:$(PASSPHRASE)" -out $(IDP_TLS_SERVER_CERT)
IDP_TLS_CERT_ALIAS=idp.blue.test
IDP_TLS_KEYSTORE=idp-tls.pkcs12
IDP_TLS_KEYSTORE_OPTS=pkcs12 -export -in $(IDP_TLS_SERVER_PEM) -name $(IDP_TLS_CERT_ALIAS) -passin "pass:$(PASSPHRASE)" -out $(IDP_TLS_KEYSTORE) -passout "pass:$(PASSPHRASE)"
IDP_TLS_IMPORT_CA_OPTS=-v -importkeystore -srckeystore $(CA_TRUSTSTORE) -srcstoretype PKCS12 -srcstorepass $(PASSPHRASE) -destkeystore $(IDP_TLS_KEYSTORE) -deststoretype PKCS12 -deststorepass $(PASSPHRASE)
IDP_TLS_TRUSTSTORE=truststore.jks
IDP_TLS_TRUSTSTORE_CA_OPTS=-importcert -file $(CA_CERT) -keystore $(IDP_TLS_TRUSTSTORE) -storepass $(PASSPHRASE) -alias $(CA_ALIAS) -noprompt -storetype jks
IDP_TLS_TRUSTSTORE_IDP_OPTS=-importcert -file $(IDP_TLS_SERVER_CERT) -keystore $(IDP_TLS_TRUSTSTORE) -storepass $(PASSPHRASE) -alias $(IDP_TLS_CERT_ALIAS) -noprompt -storetype jks

SP_TLS_SERVER_KEY=sp-tls.key
SP_TLS_SERVER_CSR=sp-tls.csr
SP_TLS_SERVER_CERT=sp-tls.crt
SP_TLS_SERVER_PEM=sp-tls.pem
SP_TLS_SERVER_DN="/C=US/ST=Colorado/L=Boulder/O=Floify/OU=Engineering/CN=sp.blue.test"
SP_TLS_SERVER_REQ_OPTS=req -newkey rsa:4096 -passin "pass:$(PASSPHRASE)" -passout "pass:$(PASSPHRASE)" -keyout $(SP_TLS_SERVER_KEY) -out $(SP_TLS_SERVER_CSR) -subj $(SP_TLS_SERVER_DN)
SP_TLS_SERVER_SIGN_OPTS=x509 -req -in $(SP_TLS_SERVER_CSR) -days 3650 -CA $(CA_CERT) -CAkey $(CA_KEY) -CAcreateserial -passin "pass:$(PASSPHRASE)" -out $(SP_TLS_SERVER_CERT)
SP_TLS_CERT_ALIAS=sp.blue.test
SP_TLS_KEYSTORE=sp-tls.pkcs12
SP_TLS_KEYSTORE_OPTS=pkcs12 -export -in $(SP_TLS_SERVER_PEM) -name $(SP_TLS_CERT_ALIAS) -passin "pass:$(PASSPHRASE)" -out $(SP_TLS_KEYSTORE) -passout "pass:$(PASSPHRASE)" -certfile $(CA_PEM) -caname $(CA_ALIAS)
SP_TLS_IMPORT_CA_OPTS=-v -importkeystore -srckeystore $(CA_TRUSTSTORE) -srcstoretype PKCS12 -srcstorepass $(PASSPHRASE) -destkeystore $(SP_TLS_KEYSTORE) -deststoretype PKCS12 -deststorepass $(PASSPHRASE)

NEWKEY_OPTS=req -newkey rsa:2048 -new -nodes -x509 -days 3650
SP_PRIVATE_KEY_FILENAME=service-provider-private.key
SP_CERT_FILENAME=service-provider-certificate.crt

$(CA_KEY) $(CA_CERT) :
	$(OPENSSL) $(CA_OPTS)

$(CA_PEM):	$(CA_KEY) $(CA_CERT)
	cat $(CA_KEY) > $(CA_PEM)
	cat $(CA_CERT) >> $(CA_PEM)

$(CA_TRUSTSTORE):	$(CA_PEM)
	$(OPENSSL) $(CA_TRUSTSTORE_OPTS)
	cp $(CA_TRUSTSTORE) ../saml-idp/src/main/resources/credentials/$(CA_TRUSTSTORE)
	cp $(CA_TRUSTSTORE) ../test-sp/src/main/resources/credentials/$(CA_TRUSTSTORE)

$(IDP_TLS_SERVER_KEY) $(IDP_TLS_SERVER_CSR) :	$(CA_KEY) $(CA_CERT)
	$(OPENSSL) $(IDP_TLS_SERVER_REQ_OPTS)

$(IDP_TLS_SERVER_CERT):	$(IDP_TLS_SERVER_CSR)
	$(OPENSSL) $(IDP_TLS_SERVER_SIGN_OPTS)

$(IDP_TLS_SERVER_PEM):	$(IDP_TLS_SERVER_KEY) $(IDP_TLS_SERVER_CERT)
	cat $(IDP_TLS_SERVER_KEY) > $(IDP_TLS_SERVER_PEM)
	cat $(IDP_TLS_SERVER_CERT) >> $(IDP_TLS_SERVER_PEM)

$(IDP_TLS_KEYSTORE):	$(CA_PEM) $(IDP_TLS_SERVER_PEM)
	$(OPENSSL) $(IDP_TLS_KEYSTORE_OPTS)
	$(KEYTOOL) $(IDP_TLS_IMPORT_CA_OPTS)
	cp $(IDP_TLS_KEYSTORE) ../saml-idp/src/main/resources/credentials

$(IDP_TLS_TRUSTSTORE):	$(IDP_TLS_SERVER_CERT)
	$(KEYTOOL) $(IDP_TLS_TRUSTSTORE_CA_OPTS)
	$(KEYTOOL) $(IDP_TLS_TRUSTSTORE_IDP_OPTS)
	cp $(IDP_TLS_TRUSTSTORE) ../test-sp/src/main/resources/credentials

$(SP_TLS_SERVER_KEY) $(SP_TLS_SERVER_CSR) :	$(CA_KEY) $(CA_CERT)
	$(OPENSSL) $(SP_TLS_SERVER_REQ_OPTS)

$(SP_TLS_SERVER_CERT):	$(SP_TLS_SERVER_CSR)
	$(OPENSSL) $(SP_TLS_SERVER_SIGN_OPTS)

$(SP_TLS_SERVER_PEM):	$(SP_TLS_SERVER_KEY) $(SP_TLS_SERVER_CERT)
	cat $(SP_TLS_SERVER_KEY) > $(SP_TLS_SERVER_PEM)
	cat $(SP_TLS_SERVER_CERT) >> $(SP_TLS_SERVER_PEM)

$(SP_TLS_KEYSTORE):	$(CA_PEM) $(SP_TLS_SERVER_PEM)
	$(OPENSSL) $(SP_TLS_KEYSTORE_OPTS)
	cp $(SP_TLS_KEYSTORE) ../test-sp/src/main/resources/credentials

sp-credentials:	$(SP_PRIVATE_KEY_FILENAME) $(SP_CERT_FILENAME)
	$(OPENSSL) $(NEWKEY_OPTS) -keyout $(SP_PRIVATE_KEY_FILENAME) -out $(SP_CERT_FILENAME)

all:	$(CA_TRUSTSTORE) $(IDP_TLS_TRUSTSTORE) $(IDP_TLS_KEYSTORE) $(SP_TLS_KEYSTORE)

clean-certs:
	rm -f $(IDP_TLS_SERVER_KEY)
	rm -f $(IDP_TLS_SERVER_CSR)
	rm -f $(IDP_TLS_SERVER_CERT)
	rm -f $(IDP_TLS_SERVER_PEM)
	rm -f $(IDP_TLS_KEYSTORE)
	rm -f $(IDP_TLS_TRUSTSTORE)
	rm -f $(SP_TLS_SERVER_KEY)
	rm -f $(SP_TLS_SERVER_CSR)
	rm -f $(SP_TLS_SERVER_CERT)
	rm -f $(SP_TLS_SERVER_PEM)
	rm -f $(SP_TLS_KEYSTORE)

clean-ca:
	rm -f $(CA_KEY)
	rm -f $(CA_CERT)
	rm -f $(CA_PEM)
	rm -f $(CA_PEM)
	rm -f $(CA_TRUSTSTORE)

clean:	clean-ca clean-certs

clean-all:	clean
	rm -f ca.srl
	rm -f ../saml-idp/src/main/resources/credentials/$(IDP_TLS_KEYSTORE)
	rm -f ../saml-idp/src/main/resources/credentials/$(CA_TRUSTSTORE)
	rm -f ../test-sp/src/main/resources/credentials/$(SP_TLS_KEYSTORE)
	rm -f ../test-sp/src/main/resources/credentials/$(CA_TRUSTSTORE)
	rm -f ../test-sp/src/main/resources/credentials/$(IDP_TLS_TRUSTSTORE)
