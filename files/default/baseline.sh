#!/bin/bash

WEBLOGIC_CREDS=$1
DYNADMIN_CREDS=$2

if [ -z "$WEBLOGIC_CREDS" -o -z "$DYNADMIN_CREDS" ] ; then
  echo "Usage: baseline.sh weblogic_user:password dynadmin_user:password"
  exit 1
fi

rm -rf /tmp/cookie.txt
curl -sk -c /tmp/cookie.txt -b /tmp/cookie.txt -u $WEBLOGIC_CREDS http://localhost:7003/dyn/admin/ >/dev/null
curl -sk -c /tmp/cookie.txt -b /tmp/cookie.txt -u $DYNADMIN_CREDS --data-urlencode "baselineAction=Baseline Index&submitted=true&activelyIndexing=false" http://localhost:7003/dyn/admin/nucleus/atg/commerce/endeca/index/ProductCatalogSimpleIndexingAdmin/ >/dev/null

echo "activelyIndexing=true" > /tmp/endeca.index.html
while grep "activelyIndexing" /tmp/endeca.index.html | grep -q "true" ; do
  curl -sk -c /tmp/cookie.txt -b /tmp/cookie.txt -u $DYNADMIN_CREDS http://localhost:7003/dyn/admin/nucleus/atg/commerce/endeca/index/ProductCatalogSimpleIndexingAdmin/?renderStatus=true > /tmp/endeca.index.html
  sleep 5
  echo -n .
done

if grep -qi "(Failed)" /tmp/endeca.index.html ; then
  echo Failed;
  exit 1;
else
  echo Success;
fi

