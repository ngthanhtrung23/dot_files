if [[ -z "$LOADED_DOT_PROFILE" ]]; then
    export LOADED_SCRIPT="~/.profile;$LOADED_SCRIPT"
    export LOADED_DOT_PROFILE="LOADED"
    export BASH_CONF="profile"
    [[ -r ~/.bashrc ]] && . ~/.bashrc
    [[ -r ~/.bash_profile ]] && . ~/.bash_profile
fi
