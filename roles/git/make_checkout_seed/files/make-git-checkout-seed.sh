#!/bin/sh
# Puppet notes -- script is file
# mkdir /srv/git_seed
# cron job to invoke file daily
# Need to setup OUTPUT_DIR to be served by apache

#optional verbose (-v) flag when manually running the script
getopts "v" option; 
if [ $option == "v" ]; then verbose=1; else verbose=0; fi;

# Where the git repos live.  These are bare repos
ORIGIN_DIR=/srv/git/repositories/rpms

# Where we'll create the repos to tar up
WORK_DIR=/srv/git_seed

# Subdirectory makes cleanup easier
SEED_DIR=$WORK_DIR/git-checkout

# subdirectory to collect rpm speciles
SPEC_DIR=$WORK_DIR/rpm-specs

# list of branches to make extra spec tarballs for
EXTRA_BRANCHES=("epel8" "epel9")
EXTRA_BRANCHES_PREFIX=extra-rpm-specs-

# clear extra branches specs working directories
rm -rf $WORK_DIR/$EXTRA_BRANCHES_PREFIX*

# create extra branches specs working directories
pushd $WORK_DIR &>/dev/null
mkdir -p ${EXTRA_BRANCHES[@]/#/$EXTRA_BRANCHES_PREFIX}
popd &>/dev/null

# Where to store the seed tarball for download
OUTPUT_DIR=/srv/cache/lookaside/

# Instead of starting fresh each time, we'll try to use git pull to keep things synced
#rm -rf $WORK_DIR/*
mkdir -p $SEED_DIR
mkdir -p $SPEC_DIR

# Give people an indication of when this checkout was last synced
TIMESTAMP=$(date --rfc-3339=seconds)
DATE=$(date +'%Y%m%d')
echo "$TIMESTAMP" >$SEED_DIR/TIMESTAMP

for repo in $ORIGIN_DIR/*.git; do
  ((verbose)) && echo processing $repo
  bname=$(basename $repo .git)
  working_tree=$SEED_DIR/$bname
  # uncomment to skip processing dead.package repos
  #  if [ -e $working_tree/dead.package ]; then
  #  continue
  #  fi
  if [ -d $working_tree ]; then
    pushd $working_tree &>/dev/null
    sed -i "s@url = .*@url = $repo@" $working_tree/.git/config
    git pull --all &>/dev/null
    popd &>/dev/null
    if [ -e $working_tree/dead.package ]; then
      rm -f $working_tree/$bname.spec
      rm -f $SPEC_DIR/$bname.spec
    elif [ -e $working_tree/$bname.spec ]; then
      cp -p $working_tree/$bname.spec $SPEC_DIR/
    fi
  else
    pushd $SEED_DIR &>/dev/null
    git clone $repo &>/dev/null
    popd &>/dev/null
    if [ -e $working_tree/dead.package ]; then
      rm -f $working_tree/$bname.spec
      rm -f $SPEC_DIR/$bname.spec
    elif [ -e $working_tree/$bname.spec ]; then
      cp -p $working_tree/$bname.spec $SPEC_DIR/
    fi
  fi

  # Now we go through each of the defined extra branches, and if the branch exists and
  # contains a specfile, we move it to the $EXTRA_BRANCHES_PREFIX$branchname directory
  pushd $working_tree &>/dev/null
  for branchname in ${EXTRA_BRANCHES[@]}; do
    git ls-remote --exit-code origin $branchname &>/dev/null
    # if exit code for git ls-remote is 0, we found the branch
    if [ $? -eq 0 ]; then
      git checkout $branchname &>/dev/null
      if [ -e $working_tree/$bname.spec ]; then
        cp -p $working_tree/$bname.spec $WORK_DIR/$EXTRA_BRANCHES_PREFIX$branchname/
      fi
      git checkout rawhide &>/dev/null
    fi
  done
  popd &>/dev/null

  sed -i "s@url = .*@url = https://src.fedoraproject.org/rpms/$bname@" $working_tree/.git/config

done

# tar up and copy the rawhide / regular seed and specs tarballs like we always have
((verbose)) && echo Tarring git-seed
tar -cf - -C$WORK_DIR $(basename $SEED_DIR) | xz -2 >$OUTPUT_DIR/.git-seed-$DATE.tar.xz
((verbose)) && echo Tarring rpm-specs
tar -cf - -C$WORK_DIR $(basename $SPEC_DIR) | xz -2 >$OUTPUT_DIR/.rpm-specs-$DATE.tar.xz
((verbose)) && echo removing old git-seed tarball
rm $OUTPUT_DIR/git-seed*tar.xz
((verbose)) && echo removing old rpm-specs tarball
rm $OUTPUT_DIR/rpm-specs*tar.xz
((verbose)) && echo moving new git-seed tarball into place
mv $OUTPUT_DIR/.git-seed-$DATE.tar.xz $OUTPUT_DIR/git-seed-$DATE.tar.xz
((verbose)) && echo moving new rpm-specs tarball into place
mv $OUTPUT_DIR/.rpm-specs-$DATE.tar.xz $OUTPUT_DIR/rpm-specs-$DATE.tar.xz
((verbose)) && echo creating links to -latest tarballs
ln -s git-seed-$DATE.tar.xz $OUTPUT_DIR/git-seed-latest.tar.xz
ln -s rpm-specs-$DATE.tar.xz $OUTPUT_DIR/rpm-specs-latest.tar.xz

# tar up and copy over the spec tarballs for the extra epel branches
for branchname in ${EXTRA_BRANCHES[@]}; do
  ((verbose)) && echo tarring up rpm-specs for $branchname
  tar -cf - -C$WORK_DIR $(basename $WORK_DIR/$EXTRA_BRANCHES_PREFIX$branchname) | xz -2 >$OUTPUT_DIR/.rpm-specs-$branchname-$DATE.tar.xz
  mv $OUTPUT_DIR/.rpm-specs-$branchname-$DATE.tar.xz $OUTPUT_DIR/rpm-specs-$branchname-$DATE.tar.xz
done

((verbose)) && echo running alt arch report script
python2 /usr/local/bin/alternative_arch_report.py /srv/git_seed/rpm-specs/ |
  mail -s "[Report] Packages Restricting Arches" arch-excludes@lists.fedoraproject.org
