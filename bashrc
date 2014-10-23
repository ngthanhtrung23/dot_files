if [[ -z "$LOADED_DOT_BASHRC" ]]; then
    export LOADED_DOT_BASHRC="LOADED"
    export LOADED_SCRIPT="~/.bashrc;$LOADED_SCRIPT"
    [ -n "$PS1" ] && source ~/.bash_profile;
    eval "$(rbenv init -)"
    export PATH=/opt/local/bin:/opt/local/sbin:/usr/local/mysql/bin:/usr/local/bin:$PATH
    export PATH="$(brew --prefix josegonzalez/php/php55)/bin:/usr/local/bin:$PATH"
    alias gl='git log --pretty=format:"%h - %an, %ar : %s"'
    export SELENIUM_GRID=10.64.209.165
fi
