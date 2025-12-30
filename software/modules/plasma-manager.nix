let
  plasma-manager = builtins.fetchTarball "https://github.com/pjones/plasma-manager/archive/trunk.tar.gz";
in
{
  imports = [
    "${plasma-manager}/modules"
  ];
}
