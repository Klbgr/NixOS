{ ... }:

{
  home-manager.users.antoine =
    { pkgs, ... }:
    let
      low-latency-layer = pkgs.stdenv.mkDerivation rec {
        pname = "low-latency-layer";
        version = "main";
        src = pkgs.fetchFromGitHub {
          owner = "Korthos-Software";
          repo = "low_latency_layer";
          rev = version;
          hash = "sha256-mnGAH0m19wOkWEowpcPRHXQSc6HGYW+CFYxjPF2onk4=";
        };

        nativeBuildInputs = [
          pkgs.cmake
        ];

        buildInputs = [
          pkgs.vulkan-headers
          pkgs.vulkan-utility-libraries
          pkgs.vulkan-loader
        ];
      };
    in
    {
      home.packages = [
        low-latency-layer
      ];
    };
}
