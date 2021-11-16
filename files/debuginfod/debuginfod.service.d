[Service]
TasksMax=40
CPUAccounting=yes
IOAccounting=yes
IPAccounting=yes
BlockIOAccounting=yes
MemoryAccounting=yes
TasksAccounting=yes
ConditionPathExists=/mnt/fedora_koji_prod/koji/packages 

