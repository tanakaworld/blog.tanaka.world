---
title: Clean install macOS High Sierra
date: 2018-07-11 00:10:00
tags:
    - mac
    - high-sierra
---

## General
- Settings > Keyboard > Text > Disable `Capitalize words automatically`
- Settings > Keyboard > Modifier Keys > Change `Caps Lock` to `Control`
- Settings > Trackpad > More Gestures > `Swipe between pages` -> `Switch with three fingers`
- Settings > General > Enable `Use dark menu bar and Dock`
- TouchBar
	- Settings > Keyboard > Customize Control Strip > Remove "Siri" button
- Finder
    - Show hidden files by shortcut `Command + Shift + .`

## Packages
- [Homebrew](https://brew.sh/)

## Apps
- [Karabiner Elements](https://pqrs.org/osx/karabiner/)	
     Complex Modifications > Add rule >  Import > `For Japanese` > Enable
     ![karabiner-elements.png](karabiner-elements.png 'karabiner-elements.png')
- [1Password](https://1password.com/downloads/)
    Scan Barcode
- [CotEditor](https://coteditor.com/)
- [iTerm2](https://www.iterm2.com/)
     - Preferences > Terminal > Scrollback Lines > `Unlimited scrollback`
     - Preferences > Keys > Left/Right ⌥ > Meta
- [BetterTouchTool](https://folivora.ai/downloads/)
    ![better-touch-tools.png](better-touch-tools.png 'better-touch-tools.png')
- Chrome
- Google IME
	Google Japanese Input > Preferences > General > Change Punctuation style "，．"
	![google-japanese-input-preferences.png](google-japanese-input-preferences.png 'google-japanese-input-preferences.png')
- Slack for Mac
- Git
    ```
    $ brew install git
    $ git config --global user.name "tanakaworld"
    $ git config --global user.email "yutaro.tanaka.world@gmail.com"
    ```
- vim
    ```
    $ brew install vim
    $ touch ~/.vimrc
    $ echo "syntax on" > ~/.vimrc
    ```
- Docker
    ```
    $ brew cask install docker
    $ open ~/Applications/Docker.app
	$ ln -s /Applications/Docker.app/Contents/Resources/etc/docker.bash-completion /usr/local/etc/bash_completion.d/docker
	$ ln -s /Applications/Docker.app/Contents/Resources/etc/docker-machine.bash-completion /usr/local/etc/bash_completion.d/docker-machine
	$ ln -s /Applications/Docker.app/Contents/Resources/etc/docker-compose.bash-completion /usr/local/etc/bash_completion.d/docker-compose
	```
	![docker-login.png](docker-login.png 'docker-login.png')
	Create a docker machine
	```
    $ docker-machine create --driver virtualbox dev
    => Error
    ```
    ![docker-machine-error.png](docker-machine-error.png 'docker-machine-error.png')
	[Solved] Bump version of Virtual Box (v5.2.8 -> v5.2.12) and solved the error.
- MySQL
	create mysql container in Docker
- Redis
	create redis container in Docker
	```
	docker pull redis
	docker run --name redis -d -p 6379:6379 redis redis-server --appendonly yes
	```
- nodebrew
    ```
    $ brew install nodebrew
    ```
    Update .bashrc
    ```
    export NODEBREW_ROOT=/usr/local/var/nodebrew
    NODEBREW_HOME=/usr/local/var/nodebrew/current
    export NODEBREW_HOME
    export NODEBREW_ROOT=/usr/local/var/nodebrew
    export PATH=$PATH:$NODEBREW_HOME/bin
	```
	Install node
	- v6.9.1
	- v6.14.2
	- v.8.9.1
- rbenv
	```
	# this will also install ruby-build
	$ brew install rbenv
	```
	Update .bash_profile
	```
    eval "$(rbenv init -)"
    export PATH=$HOME/.rbenv/shims:/usr/local/bin:/usr/bin:/bin:$PATH
    ```
    Install ruby
    ```
    $ rbenv install v.2.4.2
    $ rbenv rehash
    ```
- [WebStorm](https://www.jetbrains.com/webstorm/)
	- Settings Repository > [https://github.com/tanakaworld/WebStorm](https://github.com/tanakaworld/WebStorm)
	- [Increasing Memory Heap](https://www.jetbrains.com/help/idea/increasing-memory-heap.html)
    ![intellij-edit-custom-vm-options.png](intellij-edit-custom-vm-options.png 'intellij-edit-custom-vm-options.png')
    ```
    -Xms3072m
    -Xmx3072m
    ```
- [RubyMine](https://www.jetbrains.com/ruby/)
	File > Settings Repository > [https://github.com/tanakaworld/RubyMine](https://github.com/tanakaworld/RubyMine)
	[Increasing Memory Heap](https://www.jetbrains.com/help/idea/increasing-memory-heap.html)
- [SourceTree](https://www.sourcetreeapp.com/)
- [SequelPro](https://sequelpro.com/)
- [Dropbox](https://www.dropbox.com/)
	- Sync Selected Folder
	- Share screenshots using Dropbox
- Evernote
- [Zeplin](https://zeplin.io/)

