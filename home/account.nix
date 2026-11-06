{ lib, ... }:
{
  options.accountType = lib.mkOption {
    type = lib.types.enum [
      "personal"
      "work"
    ];
    default = "personal";
    description = "Whether this is a personal or a work account.";
  };
}
