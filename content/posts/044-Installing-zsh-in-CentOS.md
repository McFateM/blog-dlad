---
title: Installing ZSH in Linux
publishdate: 2019-09-16
draft: false
tags:
  - zsh
  - Linux
  - Oh My ZSH!
  - bira
---

These days I like to do all my terminal/command-line work in _zsh_, more specifically, with [Oh My ZSH!](https://ohmyz.sh/) and the [bira](https://github.com/robbyrussell/oh-my-zsh/blob/master/themes/bira.zsh-theme) theme.

## CentOS 7

On my new node _dgdocker3_, a _CentOS 7_ host, I added _nano_, _zsh_, and some other goodies by largely following [How to Setup ZSH and Oh-my-zsh on Linux](https://www.howtoforge.com/tutorial/how-to-setup-zsh-and-oh-my-zsh-on-linux/).

This is how I did it, from my _mcfatem_ user...

```
sudo yum install nano
sudo yum install zsh
chsh -s /bin/zsh mcfatem
exit   # log back in after this
echo $SHELL
sudo yum install wget git
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
source ~/.zshrc
cd ~/.oh-my-zsh/themes/
ls -a
nano ~/.zshrc   # In the editor add (or replace similar) the following lines but without the leading #
                #   ZSH_THEME='bira'
                #   plugins=(git extract web-search yum git-extras docker)
exit   # log back in after this
```

## Ubuntu 18.04 LTS

On my new _DigitalOcean_ test droplet, a lean little _Ubuntu 18.04 LTS_ host, I added _nano_, _zsh_, and some other goodies in much the same manner as above.  Specifically, I did this as _root_...

```
apt-get update
apt-get upgrade
apt-get install nano zsh
chsh -s /bin/zsh root
exit   # log back in after this
echo $SHELL
apt-get install wget git
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
source ~/.zshrc
cd ~/.oh-my-zsh/themes/
ls -a
nano ~/.zshrc   # In the editor add (or replace similar) the following lines but without the leading #
                #   ZSH_THEME='bira'
                #   plugins=(git extract web-search yum git-extras docker)
exit   # log back in after this
```

And that's a wrap... until next time.  :smile:
