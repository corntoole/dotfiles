append_to_path() {
    # Use a default value of 'PATH' for the variable name
    local var_name=${2:-PATH}

    # Use 'declare -n' to create a nameref, which makes the local variable
    # an alias for the global variable passed in, allowing modification.
    declare -n path_var=$var_name

    # Check if the directory is already in the specified variable
    if [[ ":${path_var}:" != *":$1:"* ]]; then
        export $var_name="${path_var}:${1}"
    fi
}

prepend_to_path() {
    local var_name=${2:-PATH}
    declare -n path_var=$var_name

    if [[ ":${path_var}:" != *":$1:"* ]]; then
        export $var_name="${1}:${path_var}"
    fi
}

if which brew &>/dev/null; then
    eval "$(brew shellenv)"
fi

# add /usr/local/bin to PATH if it's not already there
append_to_path /usr/local/bin

# add /usr/local/sbin to PATH if it's not already there
append_to_path /usr/local/sbin

# Add `~/bin`, et. al. to the `$PATH`
append_to_path ${HOME}/bin
append_to_path ${HOME}/sw/bin
append_to_path ${HOME}/.local/bin

if [ -d "${HOME}/Zing/bin" ]; then
    append_to_path ${HOME}/Zing/bin
    export GOPATH=${HOME}/Zing
fi

if [ -d "/run/current-sytem/sw/bin" ]; then
    prepend_to_path /run/current-system/sw/bin
fi

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{path,bash_prompt,exports,aliases,functions,extra}; do
        [ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# Append to the Bash history file, rather than overwriting it
shopt -s histappend

# Autocorrect typos in path names when using `cd`
shopt -s cdspell

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
        shopt -s "$option" 2>/dev/null
done

# Add tab completion for many Bash commands
#if which brew &> /dev/null && [ -f "$(brew --prefix)/share/bash-completion/bash_completion" ]; then
#	source "$(brew --prefix)/share/bash-completion/bash_completion";
#elif [ -f /etc/bash_completion ]; then
#	source /etc/bash_completion;
#fi;
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

# Enable tab completion for `g` by marking it as an alias for `git`
if type _git &>/dev/null && [ -f /usr/local/etc/bash_completion.d/git-completion.bash ]; then
        complete -o default -o nospace -F _git g
fi

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults

# Add `killall` tab completion for common apps
complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter" killall

#Autojump
[[ -s $(brew --prefix)/etc/profile.d/autojump.sh ]] && . $(brew --prefix)/etc/profile.d/autojump.sh



# TODO: factor out env var for gcloud SDK root
# The next line updates PATH for the Google Cloud SDK.
[[ -f "${HOME}/.local/google-cloud-sdk/path.bash.inc" ]] && . ${HOME}/.local/google-cloud-sdk/path.bash.inc

# The next line enables shell command completion for gcloud.
[[ -f "${HOME}/.local/google-cloud-sdk/completion.bash.inc" ]] && . ${HOME}/.local/google-cloud-sdk/completion.bash.inc

# Added by OrbStack: command-line tools and integration
source ~/.orbstack/shell/init.bash 2>/dev/null || :

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="${HOME}/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

# pnpm
export PNPM_HOME="${HOME}/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
#
# test

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
