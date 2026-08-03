{ pkgs, ... }:
let
  externalInterface = "end0";
  wgAddress = "192.168.200";
  wgPort = 51820;
in
{
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  networking.nat = {
    enable = true;
    enableIPv6 = true;
    externalInterface = externalInterface;
    internalInterfaces = [ "wg0" ];
  };

  networking.firewall.allowedUDPPorts = [ wgPort ];

  networking.wg-quick.interfaces.wg0 = {
    address = [ "${wgAddress}.1/24" ];
    listenPort = wgPort;
    privateKeyFile = "/var/lib/secrets/wireguard-private.key";
    postUp = ''
      ${pkgs.iptables}/bin/iptables -A FORWARD -i wg0 -o ${externalInterface} -j ACCEPT
      ${pkgs.iptables}/bin/iptables -A FORWARD -i ${externalInterface} -o wg0 -m state --state RELATED,ESTABLISHED -j ACCEPT
    '';
    preDown = ''
      ${pkgs.iptables}/bin/iptables -D FORWARD -i wg0 -o ${externalInterface} -j ACCEPT
      ${pkgs.iptables}/bin/iptables -D FORWARD -i ${externalInterface} -o wg0 -m state --state RELATED,ESTABLISHED -j ACCEPT
    '';
    peers = [
      {
        publicKey = "pC/qGbJ9c4oisxJRwdpje7wd1H/IkOtxdE9DB8MheHs=";
        allowedIPs = [ "${wgAddress}.2/32" ];
      }
    ];
  };
}
