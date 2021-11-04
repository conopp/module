# remove leftover compiled files; we don't want them lying around
rm mod/nss/*.ncs

cd ../../tools/nasher-0.15.2
./nasher.exe unpack mod --yes
./nasher.exe unpack hak --yes
./nasher.exe unpack tlk --yes

cd ../../development/game-8193.31/user
rm -rf modules/conopp
rm modules/conopp.mod
rm hak/conopp.hak
rm erf/conopp.erf
rm tlk/conopp.tlk

read -p "DONE"