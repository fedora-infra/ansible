#!/usr/bin/env python3

from ipsilon.providers.saml2idp import IdpMetadataGenerator, Certificate
cert = Certificate()
cert.import_cert('/etc/ipsilon/root/saml2/idp.crt', '/etc/ipsilon/root/saml2/idp.key')
#meta = IdpMetadataGenerator('https://id{{ env_suffix }}.fedoraproject.org', cert, timedelta(3600))
meta = IdpMetadataGenerator('https://id{{ env_suffix }}.fedoraproject.org', cert)
meta.output('/etc/ipsilon/root/saml2/metadata.xml')
