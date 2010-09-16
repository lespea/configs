PWD=`pwd`
DEST=~
CONFIG=${DEST}/.config
mkdir -p ${CONFIG}

ln -s ${PWD}/_vimrc 		${DEST}/.vimrc
ln -s ${PWD}/vimfiles 		${DEST}/.vim
ln -s ${PWD}/.emerald 		${DEST}
ln -s ${PWD}/.emacs 		${DEST}
ln -s ${PWD}/.bash_aliases 	${DEST}

ln -s ${PWD}/X/.fonts.conf	${DEST}
ln -s ${PWD}/Fonts			${DEST}/.fonts
ln -s ${PWD}/X/.xinitrc		${DEST}
ln -s ${PWD}/X/awesome		${CONFIG}/awesome
