# Set PS1 based on env
#
[[ $- =~ i ]] && PS1="[\u@\h \W]\[$(tput setaf 3)\][PROD-RDU3]\[$(tput sgr0)\]\\$ \[\]"
