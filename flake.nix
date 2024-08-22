{
  description = "ashell - made with iced";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];

      perSystem = {
        config,
        pkgs,
        system,
        ...
      }: {
        devShells.default = pkgs.mkShell rec {
          inputsFrom = [config.packages.ashell];
          packages = with pkgs; [
            cargo
            clippy
            pre-commit
            rust-analyzer
            rustc
            rustfmt
            rustPackages.clippy
            vscode-extensions.llvm-org.lldb-vscode
          ];
          buildInputs = with pkgs; [
            libxkbcommon
            libGL

            fontconfig

            pipewire
            pulseaudio

            wayland

            xorg.libXcursor
            xorg.libXrandr
            xorg.libXi
            xorg.libX11
          ];

          RUST_SRC_PATH = pkgs.rustPlatform.rustLibSrc;
          LD_LIBRARY_PATH = "$LD_LIBRARY_PATH:${pkgs.lib.makeLibraryPath buildInputs}";
        };

        packages =
          {
            ashell = pkgs.rustPlatform.buildRustPackage rec {
              pname = "ashell";
              version = "0.1.0";

              src = ./.;

              cargoLock = {
                lockFile = ./Cargo.lock;
                outputHashes = {
                  "accesskit-0.12.2" = "sha256-ksaYMGT/oug7isQY8/1WD97XDUsX2ShBdabUzxWffYw=";
                  "clipboard_macos-0.1.0" = "sha256-G6r7cUmdom8LhIUzm3JTVry+WQzHyxUFWbQ0gry11Eo=";
                  "cosmic-text-0.11.2" = "sha256-TLPDnqixuW+aPAhiBhSvuZIa69vgV3xLcw32OlkdCcM=";
                  "d3d12-0.19.0" = "sha256-usrxQXWLGJDjmIdw1LBXtBvX+CchZDvE8fHC0LjvhD4=";
                  "glyphon-0.5.0" = "sha256-j1HrbEpUBqazWqNfJhpyjWuxYAxkvbXzRKeSouUoPWg=";
                  "hyprland-0.3.13" = "sha256-IVDuARhnzYmSecK3blE6tTwhyu2qGOgo9FS47aMWRWI=";
                  "iced-0.12.0" = "sha256-+N7sR8LgIg7IQqQ6uGp+yCmPuHencANWULIMryaJ5a4=";
                  "smithay-clipboard-0.8.0" = "sha256-pBQZ+UXo9hZ907mfpcZk+a+8pKrIWdczVvPkjT3TS8U=";
                  "softbuffer-0.4.1" = "sha256-a0bUFz6O8CWRweNt/OxTvflnPYwO5nm6vsyc/WcXyNg=";
                };
              };

              nativeBuildInputs = with pkgs; [
                pkg-config
                rustPlatform.bindgenHook
              ];
              buildInputs = with pkgs; [
                libxkbcommon
                libGL

                pipewire
                pulseaudio

                wayland

                xorg.libXcursor
                xorg.libXrandr
                xorg.libXi
                xorg.libX11
              ];
              LD_LIBRARY_PATH = "${pkgs.lib.makeLibraryPath buildInputs}";
            };
          }
          // {default = config.packages.ashell;};

        formatter = pkgs.alejandra;
      };
    };
}
