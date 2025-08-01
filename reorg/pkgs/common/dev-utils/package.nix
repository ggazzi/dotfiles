{
  sub,
  rsync,
  stdenv,
}:

let
  args = {
    pname = "dev-utils";
    cmd = "dev";
    version = "0.1.0";
    src = ./src;
  };

  inherit (args)
    pname
    cmd
    ;

in
stdenv.mkDerivation (
  args
  // {
    buildInputs = [
      rsync
      sub
    ];

    buildPhase = "true";

    installPhase = ''
      mkdir -p $out/bin
      echo foo
      cat <<EOF >$out/bin/${cmd}
      #!/usr/bin/env bash
      set -e
      ${sub}/bin/sub --name ${cmd} --absolute "$out/opt/${pname}" -- "\$@"
      EOF
      chmod a+x $out/bin/${cmd}

      mkdir -p $out/opt/${pname}/lib
      if [ -e lib ]; then
        rsync -rp lib/ $out/opt/${pname}/lib/
      fi

      mkdir -p $out/opt/${pname}/libexec
      if [ -e libexec ]; then
        rsync -rp libexec/ $out/opt/${pname}/libexec/
      fi

      cat <<EOF >$out/opt/${pname}/completions.zsh
      if [[ ! -o interactive ]]; then
        return
      fi

      compctl -K _${cmd} ${cmd}

      _${cmd}() {
        local words completions
        read -cA words

        if [ "\''${#words}" -eq 2 ]; then
          completions="\$(${cmd} --completions)"
        else
          completions="\$(${cmd} --completions "\''${words[@]:1:-1}")"
        fi

        reply=("\''${(ps:\n:)completions}")
      }
      EOF
      chmod a+x $out/opt/${pname}/completions.zsh
    '';
  }
)
