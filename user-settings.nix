{ config, pkgs, ... }:

{
  time.timeZone = "America/New_York";

  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
  ];
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.tesco = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDwnQlNQg+zqDQuF63syy4NkuEOIxFrGDj1pXGb35Kqg thomas.price@tescometering.com"
    ];

    isNormalUser = true;
    description = "Tesco Metering";
    extraGroups = [ "wheel" ];
    shell = pkgs.bash;
    packages = with pkgs; [ ];
  };

  environment.systemPackages = with pkgs; [
    git
    rsync
    bash
    vim
    wget
    curl
    rxvt-unicode # for terminfo
    btop
    dool # dstat clone
    ncdu # often useful to get a sense of data
    lsof
    psmisc # for killall
    gnupg
    pass
  ];

  programs.bash.enable = true;
  services.openssh.enable = true;

  # Adding 'tesco' as trusted user means
  # we can upgrade the system via SSH (see Makefile).
  nix.settings.trusted-users = [
    "tesco"
    "root"
  ];

  # Enable flakes for interactive usage.
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Clean the Nix store every week.
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
}
