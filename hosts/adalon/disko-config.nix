let
  device = "/dev/disk/by-id/nvme-WD_BLACK_SN850_1TB_204178806629";

  disko-config = import ../../disko;
in
  disko-config {inherit device;}
