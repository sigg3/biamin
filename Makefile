NAME    = biamin.sh
CC      = gfx.sh GX_Item.sh
GPL     = 
FILES   = FightMode.sh functions.sh Date.sh
RUNTIME = runtime.sh
HEADER  = header.sh

all: ${FILES}
	cat ${HEADER}  >  ${NAME}
	cat ${CC}     >> ${NAME}
	cat ${FILES}   >> ${NAME}
	cat ${RUNTIME} >> ${NAME}
	chmod +x ${NAME}
