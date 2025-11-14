[ -n "$PS1" ] && source ~/.bash_profile;

[[ -s "/home/ctoole/.gvm/scripts/gvm" ]] && source "/home/ctoole/.gvm/scripts/gvm"

export PATH=${HOME}/bin:${HOME}/.local/bin:$PATH

source $(zendev bootstrap)
#Setup hub completion
if [ -f /home/ctoole/src/github.com/github/hub/etc/hub.bash_completion.sh ]; then
. /home/ctoole/src/github.com/github/hub/etc/hub.bash_completion.sh
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
