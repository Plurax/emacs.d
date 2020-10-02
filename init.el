(setq package-enable-at-startup nil)
(require 'cask "~/.cask/cask.el")
(cask-initialize)
(org-babel-load-file "~/.emacs.d/config.org")
