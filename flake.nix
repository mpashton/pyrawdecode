{
  description = "Convert raw image files to common formats";
  #nixConfig.bash-prompt = "[cx3 dev]\\u@\\h:\\w\\$ ";
  inputs = { 
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nix, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      #fooScript = pkgs.writeScriptBin "foo.sh" ''
      #  #!/bin/sh
      #  #echo $FOO
      #'';
      packageName = "pyrawdecode";
    in rec {
      packages.${packageName} = pkgs.poetry2nix.mkPoetryApplication {
        projectDir = self;
      };
  
      packages.default = self.packages.${system}.${packageName};

      devShells.default = self.packages.${system}.${packageName};

      apps.default = {
        program = "${self.packages.${system}.default}/bin/rawdecode.py";
        type = "app";
      };

    });
}
