[ -n "$PS1" ] && source ~/.bash_profile;

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/ctoole/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

# pnpm
export PNPM_HOME="/Users/ctoole/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
#
# test
