{ ... }:

{
  programs.partition-manager.enable = true;

  home-manager.users.antoine =
    { pkgs, ... }:

    {
      home.packages = with pkgs; [
        exfatprogs
      ];
    };
}
