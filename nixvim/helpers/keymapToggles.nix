# Registers options that can be turned on and off with `[key` and `]key` or
# toggled with `<Leader>t key`.
#
# The argument `toggleSpecs` must be a set of keybindings with the form
# `{ [key] = options; ... }` where `options` is either:
#
#  - `{ description, option }`
#  where `option` is a global boolean option.
#
#  - `{ description, toggle }` where `toggle` is a command.
#    In this case, bindings for `[key` and `]key` will not be created.
#
#  - `{ description, turnOn, turnOff, toggle }`,
#    where `turnOn`, `turnOff` and `toggle` are commands.
#
#  - `{ description, turnOn, turnOff, isOn }`,
#    where `turnOn`, `turnOff` and `isOn` are lua functions.
#    In this case, toggle will check the return value of `isOn` to determine
#    whether to turn the option on or off.
#
toggleSpecs:
let
  prepareKeymaps = key: { description, options ? { }, ... }@spec:
    let
      actions = prepareActions spec;
      toggleKey = {
        key = "<Leader>t${key}";
        action = actions.toggle;
        options = options // { desc = "Toggle ${spec.description}"; };
      };
      turnOnKey = {
        key = "[${key}";
        action = actions.turnOn;
        options = options // { desc = "Turn on ${spec.description}"; };
      };
      turnOffKey = {
        key = "]${key}";
        action = actions.turnOff;
        options = options // { desc = "Turn off ${spec.description}"; };
      };
    in
    [ toggleKey ] ++ (if actions ? turnOn then [ turnOnKey turnOffKey ] else [ ])
  ;

  luaCodeAsString = code:
    if builtins.isString code then
      code
    else
      code.__raw or (throw "Expected lua code: either a string or a set with a __raw attribute");

  luaLocals = with builtins; locals: expr:
    let
      luaLocal = key: value: "local ${key} = ${luaCodeAsString value}";
      localDeclarations = concatStringsSep "; "
        (map (key: luaLocal key (getAttr key locals)) (attrNames locals));
    in
    "(function() ${localDeclarations}; return ${expr} end)()";

  prepareActions = spec:
    if spec ? option then
      {
        turnOn.__raw = ''function() vim.o["${spec.option}"] = true end'';
        turnOff.__raw = ''function() vim.o["${spec.option}"] = false end'';
        toggle.__raw = ''function() vim.o["${spec.option}"] = not vim.o["${spec.option}"] end'';
      }
    else if spec ? turnOn && spec ? turnOff && spec ? toggle then
      spec
    else if spec ? turnOn && spec ? turnOff && spec ? isOn then
      let
        turnOn = luaCodeAsString spec.turnOn;
        turnOff = luaCodeAsString spec.turnOff;
        isOn = luaCodeAsString spec.isOn;
      in
      {
        turnOn.__raw = turnOn;
        turnOff.__raw = turnOff;
        toggle.__raw = luaLocals
          {
            inherit isOn turnOn turnOff;
          } ''function() if isOn() then turnOff() else turnOn() end end'';
      }
    else if spec ? toggle then
      {
        toggle.__raw = luaCodeAsString spec.toggle;
        turnOn = null;
        turnOff = null;
      }
    else
      throw "Invalid toggle spec";

in
with builtins;
concatMap (key: prepareKeymaps key (getAttr key toggleSpecs)) (attrNames toggleSpecs)
