#!/bin/bash

TAR=$1
TAR_PATH="/usr/local/java"
PROFILE="/etc/profile"

if [ -n "$2" ]
then
    TAR_PATH=$2
fi

/bin/mkdir -pv $TAR_PATH

if [ -n "$TAR" ]
then
    #mv -v $TAR $TAR_PATH
    /bin/tar -xf "$TAR" --directory "$TAR_PATH"
    VERSION=`echo $TAR | sed 's/jdk-\(.*\)-linux-.*$/\1/'`
    MAJOR=`echo $VERSION | sed 's|\([0-9]\+\)u.*$|\1|'`
    MINOR=`echo $VERSION | sed 's|^.*u\([0-9]\+\)|\1|'`

    if grep -q JAVA_HOME $PROFILE; then
        sed -i.bak "s|\(JAVA_HOME=/usr/local/java/jdk1\.\)8\.0_60/|\1$MAJOR\.0_$MINOR|" $PROFILE
    else
        echo "JAVA_HOME=/usr/local/java/jdk1.$MAJOR.0_$MINOR\nTAR_PATH=$PATH:$HOME/bin:$JAVA_HOMEbin\nexport JAVA_HOME\nexport TAR_PATH" >> $PROFILE
    fi

    update-alternatives --install "/usr/bin/java" "java" "$TAR_PATH/jdk1.$MAJOR.0_$MINOR/jre/bin/java" 1
    update-alternatives --install "/usr/bin/javac" "javac" "$TAR_PATH/jdk1.$MAJOR.0_$MINOR/bin/javac" 1
    update-alternatives --set java $TAR_PATH/jdk1.$MAJOR.0_$MINOR/jre/bin/java
    update-alternatives --set javac $TAR_PATH/jdk1.$MAJOR.0_$MINOR/bin/javac

    . $PROFILE

    java -version
fi
