{ pkgs, config, lib, ... }:

{
  config =
    let
      inherit (config) xdg;
    in
    {
      programs.git = {
        extraConfig = {
          branch.autosetuprebase = "always";
          init.defaultBranch = "main";
          # commit.template = "${config.xdg.configHome}/git/commit-template.txt";

          "includeIf \"gitdir:${config.ggazzi.dev.workspace}/babbel/\"".path = "${xdg.configHome}/git/babbel/config.inc";
          "includeIf \"gitdir:${config.ggazzi.dev.workspace}/babbel-didactics/\"".path = "${xdg.configHome}/git/babbel/config.inc";
          "includeIf \"gitdir:${config.ggazzi.dev.workspace}/lessonnine/\"".path = "${xdg.configHome}/git/babbel/config.inc";
        };
      };

      xdg.configFile = {
        "git/babbel/config.inc".text = ''
          [user]
          email = "gazzi@babbel.com"

          [commit]
          template = ${xdg.configHome}/git/babbel/commit-template.txt
        '';

        "git/babbel/commit-template.txt".text =
          let
            collaboratorList = import ./collaborators.nix;
            fmtCollaborator = c: "# Co-authored-by: ${c.name} <${c.email}>";
            collaborators = lib.concatMapStringsSep "\n" fmtCollaborator collaboratorList;
          in
          ''
            # Title: Summary, imperative, don't end with a period
            # No more than 75 chars (ideally 50)             # ← 50              75 → #

            # Body: Explain *what* and *why* (not *how*).
            # Wrap at 75 chars.                                                  75 → #

            ${collaborators}
          '';
      };
    };
}
