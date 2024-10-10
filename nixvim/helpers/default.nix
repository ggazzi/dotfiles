{
  keymapGroup = prefix: keymaps:
    let
      adaptKeymap = { mode ? "", key, action, options ? { } }: {
        inherit mode action options;
        key = "${prefix}${key}";
      };
    in
    builtins.map adaptKeymap keymaps;
}
