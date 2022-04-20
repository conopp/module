# installing is a non-destructive process; we can make changes to nss or tlk
#   folders and run the script again without worrying about anything being deleted

# remove leftover compiled files; we don't want them lying around
rm mod/nss/*.ncs

cd ../../tools/nasher-0.15.2
./nasher.exe install mod --yes
./nasher.exe install tlk --yes

rm conopp.mod
rm conopp.tlk

cd ../..
cp development/game/user/modules/conopp.mod production/mod/conopp.mod
rm production/dev/*
cp -r development/game/user/development/. production/dev/
cp development/game/user/tlk/conopp.tlk production/tlk/conopp.tlk

read -p "DONE"