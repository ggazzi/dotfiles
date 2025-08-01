{
  lib,
}:

lib.mkSubDerivation {
  pname = "dev-utils";
  cmd = "dev";
  version = "0.1.0";
  src = ./src;
}
