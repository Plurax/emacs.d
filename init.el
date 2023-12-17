
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
 (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
   (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(use-package command-log-mode)

(setq custom-file "~/SynologyDrive/Drive/emacsconfig/custom.el")
(when (file-exists-p custom-file)
  (load custom-file))

(org-babel-load-file "~/.emacs.d/config.org")
