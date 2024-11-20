# Source: https://cmm.github.io/soapbox/the-year-of-linux-on-the-desktop.html#responsiveness-tweaks-also-help-audio
{ config, lib, options, ... }:
{
  config =
    with lib;
    let
      cfg = config.jade.system.graphical;
      cfg_interactive = config.jade.system.interactive;
    in
    mkIf cfg.enable {
      # Replace with pipewire
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        pulse.enable = true;
        jack.enable = true;
      };

      # Add RTKIT to make things smoother
      security.rtkit.enable = true;

      # Audio stutter prevention
      # TODO: why do this?
      boot.kernelParams = [ "threadirqs" ];

      # Add me to the appropriate audio groups
      users.users."${cfg_interactive.user.name}".extraGroups = [ "audio" "rtkit" ];
      # Allow audio users to set high priority on audio
      security.pam.loginLimits = [{
        domain = "@audio";
        type = "-";
        item = "rtprio";
        value = "90";
      }];
      # Allow audio users direct access to some kernel-level audio stuff
      services.udev.extraRules = ''
        DEVPATH=="/devices/virtual/misc/cpu_dma_latency", OWNER="root", GROUP="audio", MODE="0660"
        DEVPATH=="/devices/virtual/misc/hpet", OWNER="root", GROUP="audio", MODE="0660"
      '';
      # Tell pipewireto prioritize itself
      services.pipewire.extraConfig.pipewire."99-custom.conf" = {
        context.modules = [
          {
            name = "libpipewire-module-rt";
            args = {
              nice.level = -11;
              rt.prio = 19;
            };
          }
        ];
      };
      # System76 scheduler-specific stuff
      services.system76-scheduler = {
        # Manual override
        useStockConfig = false;
        settings = {
          processScheduler = {
            # Pipewire client priority boosting is not needed when all else is
            # configured properly, not to mention all the implied
            # second-guessing-the-kernel and priority inversions, so:
            pipewireBoost.enable = false;
          };
        };
      };
    };
}
