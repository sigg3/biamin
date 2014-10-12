NAME = biamin.sh
FILES = FightMode.sh functions.sh
RUNTIME = runtime.sh
HEADER = header.sh
all: ${FILES}
	cat ${HEADER}  >  ${NAME}
	cat ${FILES}   >> ${NAME}
	cat ${RUNTIME} >> ${NAME}
	chmod +x ${NAME}
