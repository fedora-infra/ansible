detected_mods := $(wildcard *.te)
detected_fcs := $(detected_mods:.te=.fc)
all_packages := $(notdir $(detected_mods:.te=.pp))

.PHONY: all
.SUFFIXES: .pp

all: $(all_packages)

%.mod: %.te
	checkmodule -m $^ -o $@

# If we have file contexts one day:
# %.pp: %.mod %.fc
# 	semodule_package -o $@ -m $< -f $(<:.mod=.fc)

%.pp: %.mod
	semodule_package -o $@ -m $<

# so users dont have to make empty .fc and .if files
$(detected_fcs):
	touch $@
