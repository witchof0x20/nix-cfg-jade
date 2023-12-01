# Source for this: https://cmm.github.io/soapbox/the-year-of-linux-on-the-desktop.html
{ config, lib, pkgs, options, ... }:
{
  config = with lib;
    let
      cfg = config.jade.system.graphical;
    in
    mkIf cfg.enable {
      # ZRAM swap 
      zramSwap.enable = true;
      # use values deemed by folk wisdom to be optimal with zstd zram swap
      boot.kernel.sysctl = {
        "vm.swappiness" = 180;
        "vm.page-cluster" = 0;
        "vm.watermark_scale_factor" = 125;
        "vm.watermark_boost_factor" = 0;
      };

      # use the handy system76-scheduler service (it is not in fact specific
      # to System76 hardware, despite the name)
      services.system76-scheduler = {
        enable = true;
        useStockConfig = false; # our needs are modest
        settings = {
          # CFS profiles are switched between "default" and "responsive"
          # according to power source ("default" on battery, "responsive" on
          # wall power).  defaults are fine, except maybe this:
          cfsProfiles.default.preempt = "voluntary";
          # "voluntary" supposedly conserves battery but may also allow some
          # audio skips, so consider changing to "full"
          processScheduler = {
            foregroundBoost = {
              # ORIG POST: I believe this exists solely for the placebo effect, so disable:
              # enable = false;
              enable = true;
              # Define what is foreground
              foreground = {
                # TODO: extract this into a dual-system-home file
                matchers = [
                  "alacritty"
                  "firefox"
                  "firefox-bin"
                  "kitty"
                  "slack"
                  "thunderbird"
                  "vim"
                ];
              };
            };
          };
        };
        assignments = {
          # confine builders / compilers / LSP servers etc. to the "batch"
          # scheduling class automagically.  add matchers to taste!
          lsp = {
            class = "batch";
            matchers = [
              "rust-analyzer"
            ];
          };
          nix-builds = {
            nice = 15;
            # `idle` "may therefore be a sensible policy for systems
            # that experience only intermittent phases of high CPU load, such as desktop
            # or portable computers used interactively"
            class = "batch";
            ioClass = "idle";
            matchers = [
              "nix-daemon"
            ];
          };
        };
        # do not disturb adults:
        exceptions = [
          "include descends=\"schedtool\""
          "include descends=\"nice\""
          "include descends=\"chrt\""
          "include descends=\"taskset\""
          "include descends=\"ionice\""

          "schedtool"
          "nice"
          "chrt"
          "ionice"

          "dbus"
          "dbus-broker"
          "rtkit-daemon"
          "taskset"
          "systemd"
        ];
      };
      # enable MGLRU.  change the min_ttl_ms value to taste
      systemd.services."config-mglru" = {
        enable = true;
        after = [ "basic.target" ];
        wantedBy = [ "sysinit.target" ];
        script = let inherit (pkgs) coreutils; in ''
          ${coreutils}/bin/echo Y > /sys/kernel/mm/lru_gen/enabled
          ${coreutils}/bin/echo 1000 > /sys/kernel/mm/lru_gen/min_ttl_ms
        '';
      };

      # configure systemd-oomd properly
      systemd.oomd = {
        enable = true;
        # disable the provided knobs -- they are too coarse, and also swap
        # monitoring seems like a bad idea, with btrfs anyway
        enableRootSlice = false;
        enableSystemSlice = false;
        enableUserServices = false;
        # change if 4s is too fast
        extraConfig.DefaultMemoryPressureDurationSec = "4s";
      };
      # kill off stuff if absolutely needed, limit to things killing which
      # is unlikely to gimp system/desktop irreversibly, go only by PSI.
      # tweak limits to taste, but be careful not to make them too high or
      # you'll get the kernel OOM killer (on my machine 35% is too high, for
      # example)
      systemd.user.slices."app".sliceConfig = {
        ManagedOOMMemoryPressure = "kill";
        ManagedOOMMemoryPressureLimit = "16%";
      };
      systemd.slices."background".sliceConfig = {
        ManagedOOMMemoryPressure = "kill";
        ManagedOOMMemoryPressureLimit = "8%";
      };
      systemd.user.slices."background".sliceConfig = {
        ManagedOOMMemoryPressure = "kill";
        ManagedOOMMemoryPressureLimit = "8%";
      };
    };
}
