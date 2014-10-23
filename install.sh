# First, install necessary apps:

# Install brew
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Copy dot files
cp aliases ~/.aliases
cp bash_profile ~/.bash_profile
cp bash_prompt ~/.bash_prompt
cp bashrc ~/.bashrc
cp curlrc ~/.curlrc
cp exports ~/.exports
cp extra ~/.extra
cp functions ~/.functions
cp osx ~/.osx
cp profile ~/.profile
cp screenrc ~/.screenrc
cp vimrc ~/.vimrc

# Install Vundle for Vim
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
# After this, should open vim and run :PluginInstall
