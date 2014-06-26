#!/bin/sh

find ../Spigot-Server/src/ -type f -exec sed -i 's/net.minecraft.util.//g' {} \;
find ../CraftBukkit-Patches/ -type f -exec sed -i 's/net.minecraft.util.//g' {} \;
