# Generetes SIG_CA.crt and SIG_CA.key files
# @params:
# 1: sig name
# (2): common name of CA

if [ $# -eq 0 ]
  then
    echo Usage: \<OPENSSL_PATH\>
    exit
fi
OPENSSL_PATH=$1

  for SIG in ecdsap256 dilithium2 dilithium3 dilithium4 p256_dilithium2 p256_dilithium3 falcon512 falcon1024 rainbowIaclassic rainbowVcclassic
  do
    #check if file already exists
    if test -f "${SIG}_CA.key"; then
      echo ${SIG}_CA.key already exists
      exit
    fi
    if test -f "${SIG}_CA.crt"; then
      echo ${SIG}_CA.crt already exists
      exit
    fi

    echo generating CA.crt and CA.key for SIG ${SIG} with common name ${2:-nginxRootCA}
    if [ ${SIG} == "ecdsap256" ]; then
      $OPENSSL_PATH/apps/openssl req -x509 -new -newkey ec:<($OPENSSL_PATH/apps/openssl ecparam -name prime256v1) -keyout ${SIG}_CA.key -out ${SIG}_CA.crt -nodes -subj "/CN=nginxRootCA" -days 365 -config $OPENSSL_PATH/apps/openssl.cnf
      else
      $OPENSSL_PATH/apps/openssl req -x509 -new -newkey ${SIG} -keyout ${SIG}_CA.key -out ${SIG}_CA.crt -nodes -subj "/CN=nginxRootCA" -days 365 -config $OPENSSL_PATH/apps/openssl.cnf
    fi
done
