{ pkgs, ... }: {
  homebrew = {
    enable = true;
    casks = [
      "telegram-desktop"
      "vagrant"
      "yacreader"
      "caffeine"
      "alfred"
      "rustrover"
      "joplin"
      "logisim-evolution"
      "vagrant-vmware-utility"
      "lagrange"
      "qtspim"
      "citra"
      "spotify"
      "firefox"
      "mpv"
      "openlens"
      "nvidia-geforce-now"
      "shortcat"
      "xournal-plus-plus"
      "transmission"
      "rectangle"
      "logi-options-plus"
      "vlc"
      "mattermost"
      "cog"
      "balenaetcher"
      "cyberduck"
      "syncthing"
      "zotero"
      "vmware-fusion"
      "gimp"
      "chromium"
      "element"
      "wireshark"
      "iterm2"
      "mumble"
      "koodo-reader"
      "insomnia"
      "bruno"
      "android-platform-tools"
      "slack"
      "blackhole-64ch"
      "google-cloud-sdk"
      "notion"
      "bambu-studio"
      "airflow"
      "mumble"
      "soulseek"
      "tunnelblick"
      "syncplay"
      "anydesk"
      "obsidian"
      "intellij-idea-ce"
      "utm"
      "chiaki"
      "logseq"
      "karabiner-elements"
      "vscodium"
      "webstorm"
      "thunderbird"
      "whatsapp"
    ];
    brews = [
      "qemu"
      "wimlib"
      "spice-protocol"
      "podman"
      "wakeonlan"
      "platformio"
      "alpine"
      "esphome"
      "qt"
      "magic-wormhole"
      "k6"
      "mongodb-atlas-cli"
      "minidlna"
    ];
    taps = [{
      name = "null-dev/firefox-profile-switcher";
      clone_target = "https://github.com/null-dev/firefox-profile-switcher";
      force_auto_update = true;
    }];
  };
}
