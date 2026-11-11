{
  hosts.gen53 = {config, ...}: {
    # Every build goes to max1; gen53 only downloads and copies results.
    # When max1 is unreachable, build locally for one command with
    # `--max-jobs auto --builders ""`.
    nix = {
      distributedBuilds = true;

      buildMachines = [
        {
          hostName = "max1";
          protocol = "ssh-ng";
          sshUser = config.preferences.user.name;
          # The daemon connects as root, so it borrows the user's key instead
          # of needing one of its own.
          sshKey = "/home/${config.preferences.user.name}/.ssh/id_ed25519";
          system = "x86_64-linux";
          maxJobs = 32;
          speedFactor = 2;
          supportedFeatures = ["benchmark" "big-parallel" "kvm" "nixos-test"];
        }
      ];

      settings = {
        max-jobs = 0;
        # max1 fetches from the binary caches itself instead of receiving
        # every dependency over the network from gen53.
        builders-use-substitutes = true;
      };
    };

    programs.ssh.knownHosts.max1.publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHhxexM2j2oL+2GGSecdXVQfrBiDiuYnl6mUyxaOvL6O";
  };
}
