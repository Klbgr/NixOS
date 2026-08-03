{ ... }:

{
  services.cloudflare-ddns = {
    enable = true;
    proxied = "false";
    domains = [
      "klbgr.com"
      "*.klbgr.com"
    ];
    credentialsFile = "/var/lib/secrets/cloudflare-dns-credentials";
  };
}
