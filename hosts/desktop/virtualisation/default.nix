{ config, pkgs, user, ... }:

{
  virtualisation = {
    docker.enable = true;
  };

  users.groups.docker.members = [ "brandom" ];

  environment.systemPackages = with pkgs; [
    docker-compose
  ];
}
