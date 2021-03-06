#! /bin/bash

# Set up soft links from files to their destination (in home directory)

# Note: /bin/bash is required for ~/.* expansion in loop below

# Can't use something like 'readlink -e $0' because that doesn't work everywhere
# And HP doesn't define $PWD in a sudo environment, so we define our own
case $0 in
    /*|~*)
        SCRIPT_INDIRECT="`dirname $0`"
        ;;
    *)
        PWD="`pwd`"
        SCRIPT_INDIRECT="`dirname $PWD/$0`"
        ;;
esac

BASEDIR="`(cd \"$SCRIPT_INDIRECT\"; pwd -P)`"

for i in $BASEDIR/*; do
    [ ! -d $i ] && continue

    for j in $i/*; do
        FILEDIR=`dirname $j`
        FILE=`basename $j`
        BASEFILE=$HOME/.$FILE

        if [ -f $BASEFILE -o -h $BASEFILE ]; then
            echo "Replacing file: $BASEFILE"
            rm $BASEFILE
        else
            echo "Creating link: $BASEFILE"
        fi

        ln -s $j $BASEFILE
    done
done

# Make a pass deleting stale links, if any
for i in ~/.*; do
    [ ! -h $i ] && continue

    # We have a link: Is it stale? If so, delete it ...
    if [ ! -f $i ]; then
        echo "Deleting stale link: $i"
        rm $i
    fi
done
