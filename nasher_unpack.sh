# this script is a destructive process; it decompiles the mod and tlk
#   files into their json components, overriding any existing nss or tlk

# remove leftover compiled files; we don't want them lying around
rm mod/nss/*.ncs

cd ../../tools/nasher-0.15.2
./nasher.exe unpack mod
./nasher.exe unpack tlk

cd ../../development/game-8193.31/user
rm -rf modules/conopp
rm modules/conopp.mod
rm tlk/conopp.tlk

read -p "DONE"