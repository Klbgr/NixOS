{ inputs, ... }:

{
  imports = [ inputs.gaze.nixosModules.default ];

  services.gaze = {
    enable = true;
    gui.enable = true;
    mutableConfig = false;
    settings = {
      security = {
        level = "medium";
      };
      cameras = {
        rgb = "primary";
        dark_luma_threshold = 20;
      };
      enrollment = {
        max_templates = 10;
        min_face_size_ratio = 0.25;
      };
      liveness = {
        enabled = true;
        threshold = 0.8;
        max_frames = 40;
      };
      auth = {
        abort_if_ssh = true;
        abort_if_lid_closed = true;
        require_confirmation_lock_screen = false;
        require_confirmation_elevation = false;
        resume_grace_ms = 0;
        start_delay_ms = 0;
      };
      storage = {
        encrypt_templates = false;
      };
    };
  };

  security.pam.services = {
    defaultServices.gaze.simultaneous = true;
    kde.gaze = {
      enable = true;
      simultaneous = false;
    };
    login.gaze = {
      enable = true;
      simultaneous = true;
    };
  };
}
