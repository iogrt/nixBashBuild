{ nixpkgs, pkgs}:

with nixpkgs;
let 
  getScriptDeps = fileContent:
    let
      lines = lib.strings.splitString "\n" fileContent;
      matchingLine = lib.head (lib.filter (line: lib.hasPrefix "#!dep" line) lines);
    in
      # filter empty strings to not be strict about number of spaces
      (lib.filter (s: s!="") (lib.strings.splitString " " (lib.strings.removePrefix "#!dep" matchingLine)));
in
(pname: filePath:
  let fileContent = lib.readFile filePath; in
    pkgs.resholve.writeScriptBin pname {
    inputs = map (x: pkgs."${x}") (getScriptDeps fileContent);
    # TODO: might not need this? or could just get it from the file itself aswell
    interpreter = "${pkgs.bash}/bin/bash";
    } fileContent
)
