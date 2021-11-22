#! /bin/bash

CC=cc
${CC} -Wall -Werror -o./app				\
	$(pkg-config --cflags libmariadb)	\
	./main.c							\
	$(pkg-config --libs libmariadb)
