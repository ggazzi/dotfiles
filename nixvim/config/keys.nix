{ lib, mylib, helpers, config, ... }:

let
  keyGroup = lib.types.submodule {
    options = {
      description = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
      };
      keymaps = lib.mkOption {
        type = lib.types.listOf helpers.keymaps.deprecatedMapOptionSubmodule;
        default = [ ];
      };
    };
  };

  traceJson = x: builtins.trace (builtins.toJSON x) x;

  buildWhichKeySpec = prefix: { description, ... }:
    {
      __unkeyed-1 = prefix;
      group = description;
    };

  buildKeymaps = prefix: { keymaps, ... }:
    let
      modifyEntry = { mode, key, action, options, ... }:
        {
          inherit mode action options;
          key = prefix + key;
        };
    in
    map modifyEntry keymaps;

  mapKeymaps = fn: keymaps: with builtins;
    let result = attrValues (mapAttrs fn keymaps);
    in traceJson result;


in
{
  options = {
    key-groups = lib.mkOption {
      type = lib.types.attrsOf keyGroup;
      default = { };
    };
  };

  config = {
    globals.mapleader = " ";

    plugins.which-key = {
      enable = true;
    };
  };
}
