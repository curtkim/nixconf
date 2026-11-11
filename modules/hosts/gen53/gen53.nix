{
  inputs,
  self,
  ...
}: {
  hosts.gen53 = {
    imports = [
      self.modules.nixos.base
      self.modules.nixos.desktop

      self.modules.nixos.powersave

      inputs.disko.nixosModules.disko
      self.diskoConfigurations.gen53
    ];

    networking.hostName = "gen53";
    networking.networkmanager.enable = true;
    networking.firewall.enable = true;

    preferences.user.name = "curt";

    system.stateVersion = "24.05";

    services.openssh.enable = true;
  };
}
