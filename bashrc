eval "$(rbenv init -)"
export PATH=/opt/local/bin:/opt/local/sbin:/usr/local/mysql/bin:/usr/local/bin:$PATH
export PATH="$(brew --prefix josegonzalez/php/php55)/bin:/usr/local/bin:$PATH"
alias gl='git log --pretty=format:"%h - %an, %ar : %s"'

