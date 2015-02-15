NAME     = biamin.sh

GPL_TEXT = licenses/GPL
CC_TEXT  = licenses/CC
LICENSE  = LICENSE
SHABANG  = `which bash`
HEADER   = header.sh

CC       = gfx.sh GX_Item.sh GX_Monster.sh GX_Places.sh GX_Menu.sh GX_Marketplace.sh GX_DiceGame.sh
GPL      = GX_Item-gpl.sh GX_Monster-gpl.sh GX_Places-gpl.sh GX_Menu-gpl.sh GX_Marketplace-gpl.sh GX_DiceGame-gpl.sh
SHARED   = GX_Menu-shared.sh 	# GX which used in GPL and GPL-CC version
# We also can use Makefile this way

# RUNTIME SHOULD BE LAST!!!
GAME     = GameAlmanac.sh GameWorldChange.sh GameDate.sh GameDeath.sh GameFightMode.sh \
	GameItems.sh GameLoop.sh GameTown.sh
CORE     = CoreCLI.sh CoreFunctions.sh CoreMenu.sh CoreSetup.sh 
RUNTIME  = CoreRuntime.sh

FILES   = ${SHARED} ${GAME} functions.sh ${CORE} ${RUNTIME}


all:
# make biamin
	@echo "#!${SHABANG}" > ${NAME}
	@cat ${HEADER}      >> ${NAME}
	@cat ${CC}          >> ${NAME}
	@cat ${FILES}       >> ${NAME}
	@chmod +x ${NAME}
# make license
	@echo -e "\t\t   BACK IN A MINUTE BASH CODE LICENSE:\t\t\t\n" > ${LICENSE}
	@cat ${GPL_TEXT}                                             >> ${LICENSE}
	@echo -e "\n\n\t\t   BACK IN A MINUTE ARTWORK LICENSE:\n\n"  >> ${LICENSE}
	@cat ${CC_TEXT}                                              >> ${LICENSE}

# gpl:
#	@echo "#!${SHABANG}" > ${NAME}
# 	@cat ${HEADER}      >>  ${NAME}
# 	@cat ${GPL}         >> ${NAME}
# 	@cat ${FILES}       >> ${NAME}
# 	@chmod +x ${NAME}
# make license
#	@echo -e "\t\t   BACK IN A MINUTE BASH CODE LICENSE:\t\t\t\n" > ${LICENSE}
#	@cat ${GPL_TEXT}                                             >> ${LICENSE}
