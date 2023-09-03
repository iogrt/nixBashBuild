{
  description = "Resholve my bashs without extra configs";

  outputs = { self, nixpkgs}:
    with nixpkgs;
    let
      makeabin = (import ./buildbash.nix {
        inherit nixpkgs;
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
      });

      scriptDir = ./.;
      getScriptName = x : lib.strings.removeSuffix ".sh" (builtins.baseNameOf x);
      scriptSources = 
        (lib.filter
          (file: lib.hasSuffix ".sh" file )
          (lib.filesystem.listFilesRecursive scriptDir));#
    in
    map (s: makeabin (getScriptName s) s) scriptSources;
}


