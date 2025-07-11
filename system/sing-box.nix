{ config, lib, ... }:
{
  # Do not automatically start on boot
  systemd.services.sing-box = {
    wantedBy = lib.mkForce [ ];
  };

  services.sing-box = {
    enable = true;

    settings = {
      dns = {
        servers = [
          {
            tag = "google";
            address = "tls://8.8.8.8";
          }
          #{
          #  tag = "cloudflare";
          #  address = "https://1.1.1.1/dns-query";
          #  detour = "vless-out";
          #}
          {
            tag = "local";
            address = "1.1.1.1";
            detour = "direct";
          }
        ];

        rules = [
          {
            outbound = "any";
            server = "local";
          }
        ];

        #final = "local";

        strategy = "ipv4_only";
      };

      inbounds = [
        {
          type = "tun";
          address = [ "172.19.0.1/30" ];
          auto_route = true;
          strict_route = true;
        }
      ];

      outbounds = [
        {
          type = "direct";
          tag = "direct";
        }
        {
          type = "block";
          tag = "block";
        }
        {
          type = "vless";
          tag = "vless-out";

          server = "moeka.0iq.dev";
          server_port = 443;

          flow = "xtls-rprx-vision";
          #flow = "";
          #network = "tcp";
          packet_encoding = "xudp";

          uuid = {
            _secret = config.age.secrets.singbox_uuid.path;
          };

          tls = {
            enabled = true;
            server_name = "moeka.0iq.dev";
            utls = {
              enabled = true;
              fingerprint = "chrome";
            };
          };
        }
      ];

      route = {
        rules = [
          {
            action = "sniff";
          }
          {
            protocol = "dns";
            action = "hijack-dns";
          }
          {
            ip_is_private = true;
            outbound = "direct";
          }
        ];

        final = "vless-out";

        auto_detect_interface = true;
      };
    };
  };
}
