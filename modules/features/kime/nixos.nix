{
  modules.nixos.desktop = {
    config,
    lib,
    ...
  }: let
    user = config.preferences.user.name;
  in {
    # tail -f /run/user/1000/kime.err
    i18n.inputMethod = {
      enable = true;
      type = "kime";
      kime.extraConfig = ''
        log:
          global_level: DEBUG
        engine:
          translation_layer: null
          default_category: Latin
          global_category_state: true
          global_hotkeys:
            C-Space:
              behavior: !Toggle
              - Hangul
              - Latin
              result: Consume
            AltR:
              behavior: !Toggle
              - Hangul
              - Latin
              result: Consume
            Hangul:
              behavior: !Toggle
              - Hangul
              - Latin
              result: Consume
          hangul:
            layout: my-dubeolsik
            word_commit: false
            preedit_johab: Needed
            addons:
              all:
              - ComposeChoseongSsang
              my-dubeolsik:
              - TreatJongseongAsChoseong
      '';
    };

    hjem.users.${user}.files.".config/kime/layouts/my-dubeolsik.yaml".source = ./my-dubeolsik.yaml;

    # Runs in the foreground (-D) so systemd tracks the real daemon; a
    # self-daemonizing kime outlives compositor restarts and its stale pid lock
    # blocks the next start.
    systemd.user.services.kime = {
      wantedBy = ["graphical-session.target"];
      after = ["graphical-session.target"];
      partOf = ["graphical-session.target"];
      path = [config.i18n.inputMethod.package];
      serviceConfig = {
        ExecStart = "${lib.getExe' config.i18n.inputMethod.package "kime"} -D";
        Restart = "on-failure";
        RestartSec = 2;
      };
    };
  };
}
