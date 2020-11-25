# Generates srv.crt and srv.key 
# params:
# 1: sig name
# 2: server common name

if [ $# -eq 0 ]
  then
    echo Usage: ./createServerCertSignedByCA.sh \<OPENSSL_PATH\> \<SERVER_COMMON_NAME\> \<SIG\>
    exit
fi

OPENSSL_PATH=$1
SERVER_COMMON_NAME=$2
SIG=$3

case "${SIG}" in
  #check if SIG name valid
  "ecdsap256" | "dilithium2" | "dilithium3" | "dilithium4" | "p256_dilithium2" | "p256_dilithium3" | "p384_dilithium4" | "falcon512" | "falcon1024" | "rainbowIaclassic" | "rainbowVcclassic")
    # Check if SIG_CA.crt and SIG_CA.key exist
    if [ ! -f "${SIG}_CA.key" ]; then
      echo ${SIG}_CA.key is missing
      exit
    fi
    if [ ! -f "${SIG}_CA.key" ]; then
      echo ${SIG}_CA.key is missing
      exit
    fi
    if [ ${SIG} == "ecdsap256" ]; then
      EC_PARAM=$OPENSSL_PATH/apps/openssl ecparam -name prime256v1
      $OPENSSL_PATH/apps/openssl req -new -newkey ec:${EC_PARAM} -keyout ${SIG}_srv.key -out ${SIG}_srv.csr -nodes -subj "/CN=${2}" -config $OPENSSL_PATH/apps/openssl.cnf
      else
      $OPENSSL_PATH/apps/openssl req -new -newkey ${SIG} -keyout ${SIG}_srv.key -out ${SIG}_srv.csr -nodes -subj "/CN=${SERVER_COMMON_NAME}" -config $OPENSSL_PATH/apps/openssl.cnf
    fi
    $OPENSSL_PATH/apps/openssl x509 -req -in ${SIG}_srv.csr -out ${SIG}_srv.crt -CA ${SIG}_CA.crt -CAkey ${SIG}_CA.key -CAcreateserial -days 365
  ;;
  *) #if SIG name not valid
      echo SIG name must be one of the following:$'\n'ecdsap256$'\n'dilithium2$'\n'dilithium3$'\n'dilithium4$'\n'p256_dilithium2$'\n'p256_dilithium3$'\n'p348_dilithium4$'\n'falcon512$'\n'falcon1024$'\n'rainbowIaclassic$'\n'rainbowVcclassic
  ;;
esac
