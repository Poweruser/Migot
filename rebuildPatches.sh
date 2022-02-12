#!/bin/bash

PS1="$"
basedir=`pwd`
clean=$1
echo "Rebuilding patch files from current fork state..."

cleanupPatches() {
    cd "$1"
    for patch in *.patch; do
        gitver=$(tail -n 2 $patch | grep -ve "^$" | tail -n 1)
        diffs=$(git diff --staged $patch | grep -E "^(\+|\-)" | grep -Ev "(From [a-z0-9]{32,}|\-\-\- a|\+\+\+ b|.index)")

        testver=$(echo "$diffs" | tail -n 2 | grep -ve "^$" | tail -n 1 | grep "$gitver")
        if [ "x$testver" != "x" ]; then
            diffs=$(echo "$diffs" | head -n -2)
        fi


        if [ "x$diffs" == "x" ] ; then
            git reset HEAD $patch >/dev/null
            git checkout -- $patch >/dev/null
        fi
    done
}

savePatches() {
    what=$1
    target=$2
    branch=$3
    cd "$basedir/$target"
    git format-patch --no-stat -N -o "../${what}-Patches/" $branch
    cd "$basedir"
    git add -A "${what}-Patches"
    if [ "$clean" != "clean" ]; then
        cleanupPatches "${what}-Patches"
    fi
    echo "  Patches saved for $what to $what-Patches/"
}
if [ "$clean" == "clean" ]; then
    rm -rf *-Patches
fi

savePatches Bukkit Spigot-API origin/spigot
savePatches CraftBukkit Spigot-Server origin/patched
savePatches Spigot-Server Argot-Server master
