{ pkg, ... }:
let 
  pkgs = import <nixpkgs> {};
  lib = import <nixpkgs/lib> {};
  nixgl = import <nixgl>  {};
in

pkgs.runCommand "${pkg.name}-nixgui-wrapper" {} ''
    mkdir $out
    ln -s ${pkg}/* $out
    rm $out/bin
    mkdir $out/bin
    # nixGL/Home Manager issue; https://github.com/guibou/nixGL/issues/44
    # nixGL/Home Manager issue; https://github.com/guibou/nixGL/issues/114
    # nixGL causes all software ran under it to gain nixGL status; https://github.com/guibou/nixGL/issues/116
    # we wrap packages with nixGL; it customizes LD_LIBRARY_PATH and related
    # envs so that nixpkgs find a compatible OpenGL driver
    nixgl_bin="${lib.getBin nixgl.auto.nixGLDefault}/bin/nixGL"
    # Similar to OpenGL, the executables installed by nix cannot find the GTK modules
    # required by the environment. The workaround is to unset the GTK_MODULES and
    # GTK3_MODULES so that it does not reach for system GTK modules.
    # We also need to modify the GTK_PATH to point to libcanberra-gtk3 installed via Nix
    gtk_path="${lib.getLib pkgs.libcanberra-gtk3}/lib/gtk-3.0"
    for bin in ${pkg}/bin/*; do
      wrapped_bin=$out/bin/$(basename $bin)
      echo "exec env GTK_MODULES= GTK3_MODULES= GTK_PATH=\"$gtk_path\" $nixgl_bin  $bin \"\$@\"" > $wrapped_bin
      chmod +x $wrapped_bin 
    done
  ''
