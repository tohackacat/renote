{ naersk-lib, cleanSource, ... }:

{
  default = naersk-lib.buildPackage {
    src = cleanSource ./..;
  };
}
