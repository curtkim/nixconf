{
  inputs,
  self,
  ...
}: {
  hosts.main = {pkgs, ...}: {
    imports = [
      self.modules.nixos.base
      self.modules.nixos.desktop

      self.modules.nixos.impermanence

      self.modules.nixos.powersave

      inputs.disko.nixosModules.disko
      self.diskoConfigurations.main
    ];

    networking.hostName = "main";

    environment.systemPackages = [
      pkgs.winetricks
      pkgs.glib

      pkgs.bs-manager

      pkgs.android-tools
    ];

    services = {
      flatpak.enable = true;
      udisks2.enable = true;
      printing.enable = true;
    };

    persistence.files = [
      "/etc/lact/config.yaml"
    ];

    system.stateVersion = "23.11";
  };
}
