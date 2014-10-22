NAME    = biamin.sh
SHABANG = `which bash`
HEADER  = header.sh
CC      = gfx.sh GX_Item.sh GX_Monster.sh GX_Places.sh
GPL     = GX_Item-gpl.sh GX_Monster-gpl.sh
FILES   = BiaminSetup.sh FightMode.sh Items.sh functions.sh Date.sh CLI_arguments.sh
RUNTIME = runtime.sh

all:
	@echo "#!${SHABANG}" > ${NAME}
	@cat ${HEADER}      >> ${NAME}
	@cat ${CC}          >> ${NAME}
	@cat ${FILES}       >> ${NAME}
	@cat ${RUNTIME}     >> ${NAME}
	@chmod +x ${NAME}

# gpl: ${FILES}
# 	@cat ${HEADER}  >  ${NAME}
# 	@cat ${GPL}     >> ${NAME}
# 	@cat ${FILES}   >> ${NAME}
# 	@cat ${RUNTIME} >> ${NAME}
# 	@chmod +x ${NAME}
