# Todo
- Add the feats that are currently in conopp.2da to feat.2da, then create functional logic for them with nwnx
- Optionally: separate nss scripts, tlk file, and mod file editing to separate 'save to json' & 'unsave from json' batch files
- Setup hak directory compilation into the install/unpack scripts
  - Install should compile the folder into a singular conopp.hak & conopp.erf and place them in the user/hak & user/erf directories, respectively
  - Unpack should remove the .hak & .erf from their respective userdirectories and place the files (overriding) into the hak directory again

# Notes
- To save changes to unpacked files, run the install script; to save changes to packed files, run the unpack script
- You should only work on 1 thing at a time (script files, tlk file, or mod from within the toolset), then save the changes before working on something else, lest you override the script files or the tlk/mod files
- The scripts and mod should first be unpacked to work on, then installed for testing; however, for tlk file edits, it should be installed, worked on, then unpacked to save the changes