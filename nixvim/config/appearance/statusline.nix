{
  plugins.lualine = {
    enable = true;

    settings = {
      options = {
        icons_enabled = true;
        theme = "auto";
        component_separators = "";
      };

      sections = {
        lualine_a = [ "mode" ];
        lualine_b = [ "diagnostics" ];
        lualine_c = [ "filename" ];
        lualine_x = [ "encoding" "fileformat" "filetype" ];
        lualine_y = [ "branch" "diff" ];
        lualine_z = [ "location" "progress" ];
      };

      inactive_sections = {
        lualine_a = [ ];
        lualine_b = [ "diagnostics" ];
        lualine_c = [ "filename" ];
        lualine_x = [ "branch" "diff" ];
        lualine_y = [ "location" "progress" ];
        lualine_z = [ ];
      };
    };
  };
}