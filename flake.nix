{
  description = "Resholve my bashs without extra configs";

  outputs = { self, nixpkgs}:
    with nixpkgs;
    let
      makeabin = (import ./buildbash.nix {
        inherit nixpkgs;
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
      });


      getScriptName = x : lib.strings.removeSuffix ".sh" (builtins.baseNameOf x);
      scriptSources =
        (dir: 
            (lib.filter
            (file: lib.hasSuffix ".sh" file )
            (lib.filesystem.listFilesRecursive dir))
        );
    in
      (scriptDir: map (s: makeabin (getScriptName s) s) (scriptSources scriptDir));
}


