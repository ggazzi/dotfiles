{ lib, ... }:

{
  programs.nixvim = {
    opts = {
      number = true;
      relativenumber = true;
    };

    keymaps = lib.custom.nixvim.keymapToggles {
      # n = {
      #   description = "line numbers";
      #   # It's only considered on when relative numbers are not
      #   isOn = ''function return vim.o.number and not vim.o.relativenumber end'';
      #   # When enabling, turn only absolute line numbers on
      #   turnOn = ''function() vim.o.number, vim.o.relativenumber = true, false end'';
      #   # When disabling, turn both off
      #   turnOff = ''function() vim.o.number, vim.o.relativenumber = false, false end'';
      # };
      # N = {
      #   description = "relative line numbers";
      #   # It's considered on regardless of absolute line numbers
      #   isOn = ''function return vim.o.relativenumber end'';
      #   # When enabling, turn both absolute and relative line numbers on
      #   turnOn = ''function() vim.o.number, vim.o.relativenumber = true, true end'';
      #   # When disabling, turn only relative line numbers off
      #   turnOff = ''function() vim.o.relativenumber = false end'';
      # };
    };
  };
}
