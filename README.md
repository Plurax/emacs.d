<!-- markdown-toc start - Don't edit this section. Run M-x markdown-toc-refresh-toc -->
**Table of Contents**

- [Table of Contents](#table-of-contents)
- [What](#what)
- [Installing pre-requisites](#installing-pre-requisites)
    - [CMake](#cmake)
    - [Clang/LLVM](#clangllvm)
    - [ccls](#ccls)
    - [Ivy (Copied from dfrib)](#ivy-copied-from-dfrib)
    - [Installing pre-requisites for the convenience packages](#installing-pre-requisites-for-the-convenience-packages)
- [Installing and setting up Cask](#installing-and-setting-up-cask)
    - [Installing cask](#installing-cask)
- [Using this repo for applying the settings](#using-this-repo-for-applying-the-settings)
- [Setting up Emacs](#setting-up-emacs)
    - [Trying it all out](#trying-it-all-out)
    - [Installing irony-server](#installing-irony-server)
- [Contributing](#contributing)
- [Acknowledgements](#acknowledgements)

<!-- markdown-toc end -->

# What

This setup is derived from dfribs setup. https://github.com/dfrib/emacs_setup

I modified the setup to use ccls instead of rtags and moved custom settings to a seperate file custom.el. This allows to share the 
configuration without disclosing my account settings.

I startet with org-mode around Jan 2019 so this might be a floating setup.
For my small projects its nevertheless working...

This is currently running on Ubuntu with emacs 27.1

The core packages of my setup are:

- [`cmake-ide`](https://github.com/atilaneves/cmake-ide) with [`ccls`](https://github.com/MaskRay/ccls) for IDE-like features on Emacs for CMake projects.
  - Where `ccls` fall back on [`clang`](https://clang.llvm.org/) as C++ parser.
  - [lsp-ui](https://github.com/emacs-lsp/lsp-ui) 
  - Using [`flycheck`](https://github.com/flycheck/flycheck) for on-the-fly syntax checking.
  - Combined with [`company-mode`](http://company-mode.github.io/) and [`irony-mode`](https://github.com/Sarcasm/irony-mode) (and clang parsing) for code completion.
- [`magit`](https://magit.vc/) for any kind of Git interaction. `magit` is such an awesome Git client that I even sincerely recommend my non-Emacs-colleagues to turn to Emacs/`magit` _solely_ for using Git (naturally sneakily allowing to possibly tempt them to get into all other, never-ending additional upsides of using Emacs).
- [`ivy`](https://github.com/abo-abo/swiper) for minibuffer code completion.

Some other convenience packages worth mentioning (as they require Emacs-external dependencies) are:

- [`doom-themes`](https://github.com/hlissner/emacs-doom-themes) 
- [`doom-modeline`](https://github.com/seagle0128/doom-modeline) adding an informative modeline
- [restclient.el](https://github.com/pashky/restclient.el "restclient.el"), which is realy a nice feature to check REST APIs
- [ob-restclient](https://github.com/alf/ob-restclient.el "org-babel rest client") which injects restclient capabilities into org-mode
- mu4e as Mail reader within emacs

Finally, I use [`cask`](http://cask.readthedocs.io/en/latest/index.html) to manage package dependencies for my Emacs configuration, which will also hopefully make it easier to successfully follow this guide through, from start to finish.
Cask is managing the packages of emacs and is able to even install from git repos.

# Installing pre-requisites

Before we start, resync the package index files for APT:

```bash
$ sudo apt-get update
$ sudo apt-get install libgmime-3.0-dev libxapian-dev isync guile-2.0-dev html2text xdg-utils mu4e emacs26
```

## CMake

```bash
$ sudo apt-get install cmake
```

## Clang/LLVM

Next up, we install clang and llvm.

```bash
$ sudo apt-get install clang-7.0 llvm-7.0 libclang-7.0-dev clang-format-7.0
```

## ccls

Clone the CCLs project; I usually clone open source repos into my `~/opensource` folder:

```bash
mkdir ~/opensource
cd ~/opensource
git clone --recursive https://github.com/MaskRay/ccls.git
cd ccls
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_EXPORT_COMPILE_COMMANDS=YES -DCMAKE_INSTALL_PREFIX=/usr/local ..
cmake --build .
sudo cmake --build . --target install
```

## Ivy (Copied from dfrib)

`ivy` contains a lot of goodies, but to point out some specifics I use `ivy` primarily for `swiper` in-buffer search and for the `counsel` (`ivy`-enhanced) Emacs commands. For the latter, most frequently `counsel-git` (find tracked file in current repo), `counsel-git-grep` and `counsel-ag`. The latter make use of [`ag` - The Silver Searcher](https://github.com/ggreer/the_silver_searcher), and is useful when wanting to search through only parts of a repository, limited to a folder and all tracked file therein (recursively for all sub-folders).

To allow using `counsel-ag`, install `ag`:

```bash
$ sudo apt-get install silversearcher-ag
```

## Installing pre-requisites for the convenience packages

I use the doom theme and the corresponding smart mode line. This is installed by cask, but you propably need to install fonts via calling all-the-icons-install-fonts from withing emacs.

# Installing and setting up Cask

## Installing cask

To install Cask, run the following command:

```bash
$ curl -fsSL https://raw.githubusercontent.com/cask/cask/master/go | python
```

This should install Cask in `~/.cask/`. Make sure to follow the on-success prompt to add the `cask` binary to your path:

```bash
# e.g. in your .bashrc, or whatever shell you're using
export PATH="~/.cask/bin:$PATH"
```

# Using this repo for applying the settings

Until now, there was no interaction with this repository. As emacs is now installed on your machine you have a local `~/.emacs.d/` folder.
This contains the settings for your emacs installation. You can clone this repository in there or copy the content (mainly `Cask` and `init.el` file) there. Use `cask` to install all package dependencies contained in the `Cask` file:

```bash
$ cd ~/.emacs.d/
$ cask install
```

# Setting up Emacs

The custom.el contains API key settings etc. and is not part of this repo. Thus you need to configure it for your own. 
You can use the customize-variable command of emacs for this. You can change the path of the custom settings by editing the corresponding part of init.el:

```elisp
(setq custom-file "~/Sync/emacsconfig/custom.el")
(load custom-file)
```


## Trying it all out

This command should start emacs with doom theme and modeline. Allowing you to start entering emacs world... (The & avoids the shell being blocked by the emacs process)

```bash
$ emacs &
```

## Installing irony-server

Upon first Emacs launch, install the `irony-server`, which provides the `libclang` interface to `irony-mode` (used for `company-irony` / code completion):

```bash
# In Emacs
M-x irony-install-server
# yields a cmake install command -> accept [RET]
```

A successful installation prompts you with _"`irony-server` installed successfully!"_.

# Contributing

I'm neither an Emacs hacker nor proficient in elisp, but I hope that this setup might help someone to gain interest in this editor. And as this setup is mixed up from several other snippets found in the net, it might be not realy tidy for your purpose...

# Acknowledgements

To Wolfgang B. for once upon a time enthusiastically introducing me to Emacs, which was my favourite text editor during C development on micro controllers since then. Currently, with org-mode and mu4e it is slowly grasping far more tasks than just editing text.

To dfrib, who actually lead me to a more complex setup, starting to dive into other possibilities of emacs usage.
https://github.com/dfrib/emacs_setup
