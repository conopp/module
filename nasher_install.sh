# remove leftover compiled files; we don't want them lying around
rm mod/nss/*.ncs

cd ../../tools/nasher-0.15.2
./nasher.exe install mod --yes
./nasher.exe install hak --yes
./nasher.exe install tlk --yes

rm conopp.mod
rm conopp.hak
rm conopp.tlk

cd ../../development/game-8193.31/user/
cp hak/conopp.hak erf/conopp.erf