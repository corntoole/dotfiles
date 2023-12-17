# Add `~/bin` to the `$PATH`
export PATH=/usr/local/bin:/usr/local/sbin:${PATH}
export PATH=${HOME}/sw/bin:${HOME}/bin:${HOME}/.local/bin:${PATH};

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{path,bash_prompt,exports,aliases,functions,extra}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Append to the Bash history file, rather than overwriting it
shopt -s histappend;

# Autocorrect typos in path names when using `cd`
shopt -s cdspell;

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
	shopt -s "$option" 2> /dev/null;
done;

# Add tab completion for many Bash commands
if which brew &> /dev/null && [ -f "$(brew --prefix)/share/bash-completion/bash_completion" ]; then
	source "$(brew --prefix)/share/bash-completion/bash_completion";
elif [ -f /etc/bash_completion ]; then
	source /etc/bash_completion;
fi;
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

# Enable tab completion for `g` by marking it as an alias for `git`
if type _git &> /dev/null && [ -f /usr/local/etc/bash_completion.d/git-completion.bash ]; then
	complete -o default -o nospace -F _git g;
fi;

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults;

# Add `killall` tab completion for common apps
complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter" killall;

#Autojump
[[ -s $(brew --prefix)/etc/profile.d/autojump.sh ]] && . $(brew --prefix)/etc/profile.d/autojump.sh

#NVM
# export NVM_DIR="$HOME/.nvm"
  # . "$(brew --prefix nvm)/nvm.sh"

# Load rbenv automatically by appending
# the following to ~/.bash_profile:

# eval "$(rbenv init -)"

#export PATH=$PATH:/usr/local/opt/go/libexec/bin
#export GOPATH=$HOME/bin
export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"
# export PATH="/usr/local/bin:$PATH"

#export PATH="/usr/local/opt/qt/bin:$PATH"
export PATH="/usr/local/opt/sqlite/bin:$PATH"

if echo "$-" | grep i > /dev/null; then
	[[ -s "/Users/ctoole/.gvm/scripts/gvm" ]] && source "/Users/ctoole/.gvm/scripts/gvm";
	# gvm use go1.10.7;
	export GOPATH=${HOME}/Zing;
	export PATH=${GOPATH}/bin:${PATH};
fi
alias dc="docker compose"
complete -F _docker_compose dc
source /usr/local/etc/bash_completion.d/docker-compose
source ${HOME}/git-completion.bash
source /usr/local/etc/bash_completion.d/deno.bash
export PATH="/usr/local/opt/openjdk/bin:$PATH"
complete -C /Users/ctoole/Zing/bin/bitcomplete bit

# n node version manager
export N_PREFIX=${HOME}/sw

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
export GPG_TTY=$(tty)


# Added by Toolbox App
export PATH="$PATH:/usr/local/bin"
# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/ctoole/google-cloud-sdk/path.bash.inc' ]; then . '/Users/ctoole/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/ctoole/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/ctoole/google-cloud-sdk/completion.bash.inc'; fi

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/ctoole/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
. "$HOME/.cargo/env"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
