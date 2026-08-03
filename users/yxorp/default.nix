{ ... }:

{
  imports = [
    ./programs
  ];

  users.users.yxorp = {
    uid = 1000;
    isNormalUser = true;
    description = "Yxorp";
    initialPassword = "yxorp";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };
}
