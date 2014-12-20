NAME    = biamin.sh
SHABANG = `which bash`
HEADER  = header.sh
CC      = gfx.sh GX_Item.sh GX_Monster.sh GX_Places.sh GX_Menu.sh GX_Marketplace.sh GX_DiceGame.sh
GPL     = GX_Item-gpl.sh GX_Monster-gpl.sh GX_Places-gpl.sh GX_Menu-gpl.sh GX_Marketplace-gpl.sh
FILES   = CoreCLI.sh CoreFunctions.sh CoreMenu.sh CoreSetup.sh GameAlmanac.sh GameBulletin.sh \
	GameChar.sh GameDate.sh GameDeath.sh GameFightMode.sh GameItems.sh GameLoop.sh \
	GameTown.sh functions.sh
RUNTIME = CoreRuntime.sh

all:
	@echo "#!${SHABANG}" > ${NAME}
	@cat ${HEADER}      >> ${NAME}
	@cat ${CC}          >> ${NAME}
	@cat ${FILES}       >> ${NAME}
	@cat ${RUNTIME}     >> ${NAME}
	@chmod +x ${NAME}

# gpl:
# 	@cat ${HEADER}  >  ${NAME}
# 	@cat ${GPL}     >> ${NAME}
# 	@cat ${FILES}   >> ${NAME}
# 	@cat ${RUNTIME} >> ${NAME}
# 	@chmod +x ${NAME}
