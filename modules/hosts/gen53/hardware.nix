{
  hosts.gen53 = {
    config,
    lib,
    modulesPath,
    ...
  }: {
    imports = [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

    boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "usbhid"];
    boot.initrd.kernelModules = ["amdgpu"];
    boot.kernelModules = ["kvm-amd"];

    swapDevices = [];

    networking.useDHCP = lib.mkDefault true;

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    hardware.graphics.enable = true;
    services.xserver.videoDrivers = ["amdgpu"];
  };
}
