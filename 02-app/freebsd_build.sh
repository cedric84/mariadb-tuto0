#! /bin/sh

CC=cc
INSTALL_PREFIX=../out/install/x86_64-freebsd
${CC} -Wall -Werror								\
	-I${INSTALL_PREFIX}/include/mariadb			\
	-L${INSTALL_PREFIX}/lib/mariadb				\
	-Wl,-rpath,${INSTALL_PREFIX}/lib/mariadb	\
	-o${INSTALL_PREFIX}/bin/app					\
	./main.c									\
	-lmariadb
