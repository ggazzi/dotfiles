{ config, ... }:

{
  xdg.configFile =
    let
      mkSymlink = config.lib.file.mkOutOfStoreSymlink;
    in
    {
      "zed/keymap.json".source = mkSymlink ./keymap.json;
      "zed/settings.json".source = mkSymlink ./settings.json;
    };
}
