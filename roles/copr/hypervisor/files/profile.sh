# By default connect to localhost
export LIBVIRT_DEFAULT_URI=qemu:///system

# Pretty large history in virsh...
export VIRSH_HISTSIZE=200000

# Enlarge commandline history
export HISTSIZE=2000000
export HISTIGNORE="ls:exit:cd -:cd ~:cd"
export HISTCONTROL=erasedups:ignoreboth
