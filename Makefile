NAME    = biamin.sh
CC      = gfx.sh GX_Item.sh GX_Monster.sh
GPL     = GX_Item-gpl.sh
FILES   = FightMode.sh Items.sh functions.sh Date.sh
RUNTIME = runtime.sh
HEADER  = header.sh

all: ${FILES}
	@cat ${HEADER}  >  ${NAME}
	@cat ${CC}      >> ${NAME}
	@cat ${FILES}   >> ${NAME}
	@cat ${RUNTIME} >> ${NAME}
	@chmod +x ${NAME}

gpl: ${FILES}
	@cat ${HEADER}  >  ${NAME}
	@cat ${GPL}     >> ${NAME}
	@cat ${FILES}   >> ${NAME}
	@cat ${RUNTIME} >> ${NAME}
	@chmod +x ${NAME}
