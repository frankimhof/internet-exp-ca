if [ $# != 2 ]
  then
    echo Usage: ./createAllServerCerts.sh \<OPENSSL_PATH\> \<SERVER_COMMON_NAME\>
    exit
fi

for SIG in ecdsap256 \
  dilithium2 \
  dilithium3 \
  p256_dilithium2 \
  p256_dilithium3 \
  dilithium4 \
  falcon512 \
  falcon1024 \
  rainbowIaclassic \
  rainbowVcclassic
do
  ./createServerCertSignedByCA.sh $1 $2 $SIG
done
