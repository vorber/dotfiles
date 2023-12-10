# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

if [ -e /home/vorber/.nix-profile/etc/profile.d/nix.sh ]; then . /home/vorber/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
