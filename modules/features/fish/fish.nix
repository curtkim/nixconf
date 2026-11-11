{self, ...}: {
  wrappers.fish = {
    wlib,
    pkgs,
    lib,
    ...
  }: {
    imports = [wlib.wrapperModules.fish];
    flags."--no-config" = false;
    configFile.content = let
      inherit (pkgs.vj) lf;
    in
      # fish
      ''
        function fish_prompt
            set -l head
            echo $head
            string join "" -- (set_color red) "[" (set_color yellow) $USER (set_color green) "@" (set_color blue) $hostname (set_color magenta) " " $(prompt_pwd) (set_color red) ']' (set_color normal) "\$ "
        end

        set -g fish_color_command green

        set fish_greeting
        fish_vi_key_bindings

        ${lib.getExe pkgs.zoxide} init fish | source

        function lf --wraps="${lib.getExe lf}" --description="lf - Terminal file manager (changing directory on exit)"
            cd "$(command ${lib.getExe lf} -print-last-dir $argv)"
        end

        function sshell
            if test (count $argv) -lt 1
                echo "Usage: sshfs_mount user@host:/remote/path"
                return 1
            end

            set remote $argv[1]
            set host (string replace -r ':.*' "" $remote | string replace -r '.*@' "")
            set mnt $HOME/.local/mnt/$host

            mkdir -p $mnt || return 1

            if mountpoint -q $mnt
                echo "Already mounted at $mnt"
                return 1
            end

            echo "Mounting $remote at $mnt"

            fish --init-command "
                set mnt $(string escape -- $mnt)
                sshfs -f -o auto_unmount $(string escape -- $remote) \$mnt &
                cd \$mnt
                function fish_prompt
                    set_color cyan --bold
                    echo -n $(string escape -- "[$remote] ")
                    set_color normal
                    echo -n (prompt_pwd)
                    set_color green
                    echo -n ' > '
                    set_color normal
                end
                function exit_handler --on-event fish_exit
                    cd ~
                    if mountpoint -q \$mnt
                        if umount \$mnt
                            echo \"unmounted \$mnt successfully\"
                        else
                            echo \"failed to unmount \$mnt\"
                        end
                    else
                        echo \"\$mnt is not a mountpoint\"
                    end
                end
            "
        end

        complete -c sshell -a '(__fish_complete_user_at_hosts)' -d 'Remote host'

        function bwu
            set -gx BW_SESSION (bw unlock --raw $argv)
        end

        ${lib.getExe pkgs.nix-your-shell} fish | source
      '';
  };
}
