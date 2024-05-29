<!-- markdown-toc start - Don't edit this section. Run M-x markdown-toc-refresh-toc -->
**Table of Contents**

- [What](#what)
- [Installing pre-requisites](#installing-pre-requisites)
    - [Mail tooling](#mail-tooling)
    - [CMake and clang](#cmake-and-clang)
    - [Ivy (Copied from dfrib)](#ivy-copied-from-dfrib)
    - [Clone and build emacs with tree-sitter, native-compilation and native json:](#clone-and-build-emacs-with-tree-sitter-native-compilation-and-native-json)
- [Using this repo for applying the settings](#using-this-repo-for-applying-the-settings)
- [Setting up Emacs](#setting-up-emacs)
    - [Ubuntu global todo capturing](#ubuntu-global-todo-capturing)
    - [Trying it all out](#trying-it-all-out)
    - [Installing pre-requisites for the convenience packages](#installing-pre-requisites-for-the-convenience-packages)
- [Contributing](#contributing)
- [Acknowledgements](#acknowledgements)

<!-- markdown-toc end -->
# What

This setup was derived from dfribs setup. https://github.com/dfrib/emacs_setup - but later I switched to use package.el only and skipped usage of cask.

My personal reason for using emacs was my experience with micro controller programming around 2008.
I rediscovered Emacs with the use of org-mode around Jan 2019, doing less programming.

For my small projects its nevertheless working...

This is currently running on Ubuntu with emacs 30.0.x (snapshot build from source)

The core packages of my setup are:

- [`magit`](https://magit.vc/) for any kind of Git interaction. `magit` is such an awesome Git client
- [`ivy`](https://github.com/abo-abo/swiper) for minibuffer code completion.

Some other convenience packages worth mentioning (as they require Emacs-external dependencies) are:

- [`doom-themes`](https://github.com/hlissner/emacs-doom-themes) 
- [`doom-modeline`](https://github.com/seagle0128/doom-modeline) adding an informative modeline
- [verb mode](https://github.com/federicotdn/verb "verb"), which is realy a nice feature to check REST APIs
- mu4e as Mail reader within emacs

# Installing pre-requisites

Before we start, activate source repositories and resync the package index files for APT:
To activate source repositories, you can select "Source code"  list entry within the software sources list tool.

```bash
sudo apt-get update
sudo apt build-dep emacs
```

## Mail tooling

We will build the mu indexer manually but need some dependencies.
isync is used to create a local mail folder which holds all mails. Since this is a copy of your mail boxes you should
use drive encryption. The build configuration of mu is using meson, which is also installed via apt here.

```bash
sudo apt-get install libgmime-3.0-dev libxapian-dev isync html2text xdg-util meson guile-3.0 guile-3.0-dev
cd ~/opensource
git clone https://github.com/djcb/mu.git
cd mu
./autogen.sh
make 
```

## CMake and clang

```bash
sudo apt-get install cmake
sudo apt-get install clang llvm libclang-dev clang-format
```

## Ivy (Copied from dfrib)

`ivy` contains a lot of goodies, but to point out some specifics I use `ivy` primarily for `swiper` in-buffer search and for the `counsel` (`ivy`-enhanced) Emacs commands. For the latter, most frequently `counsel-git` (find tracked file in current repo), `counsel-git-grep` and `counsel-ag`. The latter make use of [`ag` - The Silver Searcher](https://github.com/ggreer/the_silver_searcher), and is useful when wanting to search through only parts of a repository, limited to a folder and all tracked file therein (recursively for all sub-folders).

To allow using `counsel-ag`, install `ag`:

```bash
sudo apt-get install silversearcher-ag
```

## Clone and build emacs with tree-sitter, native-compilation and native json:

```bash
cd ~/opensource
sudo apt-get install libjansson4 libjansson-dev
git clone https://git.savannah.gnu.org/git/emacs.git
cd emacs
./autogen.sh
./configure --with-native-compilation --with-pgtk --with-imagemagick --with-tree-sitter
make -j4
sudo make install
```

# Using this repo for applying the settings

Until now, there was no interaction with this repository. As emacs is now installed on your machine you have a local `~/.emacs.d/` folder.
This contains the settings for your emacs installation. You can clone this repository in there or copy the content (mainly `config.org` and `init.el` file) there. Emacs will install packages automatically on startup if not found by using the repos set in init.el.

# Setting up Emacs

The custom.el contains API key settings etc. and is not part of this repo. Thus you need to configure it for your own. 
You can use the customize-variable command of emacs for this. You can change the path of the custom settings by editing the corresponding part of init.el:

```elisp
(setq custom-file "~/Sync/emacsconfig/custom.el")
(load custom-file)
```

## Ubuntu global todo capturing

For a globale TODO capture workflow to be put in org inbox, set a keyboard shortcut to interact with org-protocol and use a GNOME extension to be able to set Emacs on focus [Activate window by title](https://extensions.gnome.org/extension/5021/activate-window-by-title/). I am using CTRL+SHIFT+ALT+M which will call emacsclient with org-protocol.
```bash
emacsclient org-protocol://capture?template=t 
```

This will set Emacs on focus and open an org todo capture. You can even jump to an org-roam node (e.g. if you have a kind of "index page") with a global shortcut by calling the following snippet (replace the "nodeid" with the node id of the corresponding index org file of your choice.
```bash
emacsclient org-protocol://roam-node?node=nodeid
```

## Trying it all out

This command should start emacs with doom theme and modeline. Allowing you to start entering emacs world... (The & avoids the shell being blocked by the emacs process)

```bash
emacs &
```
## Installing pre-requisites for the convenience packages

Smart mode line from doom emacs uses nerd-fonts. You propably need to install fonts via calling nerd-icons-install-fonts from within emacs for the icons to work.

# Contributing

I'm neither an Emacs hacker nor proficient in elisp, but I hope that this setup might help someone to gain interest in this editor. And as this setup is mixed up from several other snippets found in the net, it might be not realy tidy for your purpose...

# Acknowledgements

To Wolfgang B. for once upon a time enthusiastically introducing me to Emacs, which was my favourite text editor during C development on micro controllers since then. Currently, with org-mode and mu4e it is slowly grasping far more tasks than just editing text.

To dfrib, who actually lead me to a more complex setup, starting to dive into other possibilities of emacs usage.
https://github.com/dfrib/emacs_setup
