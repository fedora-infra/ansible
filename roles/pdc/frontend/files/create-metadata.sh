#!/usr/bin/env bash

#
# Like /usr/libexec/mod_auth_mellon/mellon_create_metadata.sh, but don't create the certificate and the key.
# Author: abompard@fedoraproject.org
#

set -e

PROG="$(basename "$0")"

printUsage() {
    echo "Usage: $PROG ENTITY-ID ENDPOINT-URL"
    echo ""
    echo "Example:"
    echo "  $PROG urn:someservice https://sp.example.org/mellon"
    echo ""
}

if [ "$#" -lt 2 ]; then
    printUsage
    exit 1
fi

ENTITYID="$1"
if [ -z "$ENTITYID" ]; then
    echo "$PROG: An entity ID is required." >&2
    exit 1
fi

BASEURL="$2"
if [ -z "$BASEURL" ]; then
    echo "$PROG: The URL to the MellonEndpointPath is required." >&2
    exit 1
fi

if ! echo "$BASEURL" | grep -q '^https\?://'; then
    echo "$PROG: The URL must start with \"http://\" or \"https://\"." >&2
    exit 1
fi

DATADIR=`dirname $0`

if [ ! -f "$DATADIR/certificate.pem" ]; then
    echo "$PROG: The certificate must be in the file $DATADIR/certificate.pem." >&2
    exit 1
fi

BASEURL="$(echo "$BASEURL" | sed 's#/$##')"

# No files should not be readable by the rest of the world.
umask 0077

CERT="$(grep -v '^-----' $DATADIR/certificate.pem)"

cat > $DATADIR/metadata.xml <<EOF
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<EntityDescriptor
 entityID="$ENTITYID"
 xmlns="urn:oasis:names:tc:SAML:2.0:metadata">
 <SPSSODescriptor
   AuthnRequestsSigned="true"
   WantAssertionsSigned="true"
   protocolSupportEnumeration="urn:oasis:names:tc:SAML:2.0:protocol">
   <KeyDescriptor use="signing">
     <ds:KeyInfo xmlns:ds="http://www.w3.org/2000/09/xmldsig#">
       <ds:X509Data>
         <ds:X509Certificate>$CERT</ds:X509Certificate>
       </ds:X509Data>
     </ds:KeyInfo>
   </KeyDescriptor>
   <KeyDescriptor use="encryption">
     <ds:KeyInfo xmlns:ds="http://www.w3.org/2000/09/xmldsig#">
       <ds:X509Data>
         <ds:X509Certificate>$CERT</ds:X509Certificate>
       </ds:X509Data>
     </ds:KeyInfo>
   </KeyDescriptor>
   <SingleLogoutService
     Binding="urn:oasis:names:tc:SAML:2.0:bindings:SOAP"
     Location="$BASEURL/logout" />
   <SingleLogoutService
     Binding="urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect"
     Location="$BASEURL/logout" />
   <NameIDFormat>urn:oasis:names:tc:SAML:2.0:nameid-format:transient</NameIDFormat>
   <AssertionConsumerService
     index="0"
     isDefault="true"
     Binding="urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST"
     Location="$BASEURL/postResponse" />
   <AssertionConsumerService
     index="1"
     Binding="urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Artifact"
     Location="$BASEURL/artifactResponse" />
   <AssertionConsumerService
     index="2"
     Binding="urn:oasis:names:tc:SAML:2.0:bindings:PAOS"
     Location="$BASEURL/paosResponse" />
 </SPSSODescriptor>
</EntityDescriptor>
EOF

umask 0777
chown apache: $DATADIR/metadata.xml
echo "Wrote $DATADIR/metadata.xml"
