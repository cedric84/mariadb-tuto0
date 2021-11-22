#! /bin/bash

#---Définitions---#
SRC_NAME=mariadb-connector-c-3.2.5-src
SRC_TAR_NAME=${SRC_NAME}.tar.gz
OUT_PATH=../out
BUILD_PATH=${OUT_PATH}/build/x86_64-linux
INSTALL_PREFIX=${OUT_PATH}/install/x86_64-linux

#---Télécharge les sources---#
wget -q https://ftp.igh.cnrs.fr/pub/mariadb/connector-c-3.2.5/${SRC_TAR_NAME}

#---Extrait les sources---#
tar -xf ${SRC_TAR_NAME}

#---Configure---#
cmake											\
	-D CMAKE_INSTALL_PREFIX=${INSTALL_PREFIX}	\
	-S ${SRC_NAME}								\
	-B ${BUILD_PATH}

#---Build---#
cmake --build ${BUILD_PATH} --target install

#---Cleanup---#
rm -rf ${BUILD_PATH}
rm -rf ${SRC_NAME}
rm ${SRC_TAR_NAME}
