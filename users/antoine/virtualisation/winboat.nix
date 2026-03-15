{ ... }:

{
  home-manager.users.antoine =
    { pkgs, ... }:

    {
      home.packages = with pkgs; [
        (winboat.overrideAttrs {
          makeCacheWritable = "true";
          npmFlags = [ "--legacy-peer-deps" ];
        })
      ];
    };
}
