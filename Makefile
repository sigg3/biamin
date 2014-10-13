NAME    = biamin.sh
FILES   = gfx.sh FightMode.sh functions.sh Date.sh
RUNTIME = runtime.sh
HEADER  = header.sh
all: ${FILES}
	cat ${HEADER}  >  ${NAME}
	cat ${FILES}   >> ${NAME}
	cat ${RUNTIME} >> ${NAME}
	chmod +x ${NAME}
