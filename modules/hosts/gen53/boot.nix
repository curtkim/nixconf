{
  hosts.gen53 = {pkgs, ...}: {
    boot = {
      kernelPackages = pkgs.linuxPackages_latest;

      loader.grub.enable = true;
      loader.grub.efiSupport = true;
      loader.grub.efiInstallAsRemovable = true;
      loader.grub.configurationLimit = 5;
    };
  };
}
