# the shell is completely safe from garbage collection and evaluates instantly
# due to Nix's native caching. if you want logs during build, add `-L` to
# `nix develop`.
{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs }: let
    inputs = { inherit nixpkgs; };
    system = "x86_64-linux";

    pkgs = nixpkgs.legacyPackages."${system}";

    # or, if you need to add an overlay:
    # pkgs = import nixpkgs {
    #   inherit system;
    #   overlays = [
    #     (import ./nix/overlay.nix)
    #   ];
    # };

    # a text file containing the paths to the flake inputs in order to stop
    # them from being garbage collected
    flakeRoot = pkgs.writeTextDir "bin/.flakeRoot"
      (builtins.concatStringsSep " " (builtins.attrValues inputs));
  in {
    devShell."${system}" = pkgs.mkShell {
      buildInputs = [
        (pkgs.ruby.withPackages (p: with p; [
	  rake
	  minitest
	]))

        flakeRoot
      ];
    };
  };
}
