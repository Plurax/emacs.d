
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

(org-babel-load-file "~/.emacs.d/config.org")
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-safe-remote-resources
   '("\\`https://fniessen\\.github\\.io/org-html-themes/setup/theme-readtheorg\\.setup\\'"))
 '(package-selected-packages
   '(yasnippet which-key web-mode vue-mode visual-fill-column verb use-package unicode-fonts treemacs-magit treemacs-icons-dired treemacs-all-the-icons timu-spacegrey-theme tide rjsx-mode popup platformio-mode ox-reveal ovpn-mode origami orgtbl-aggregate org-vcard org-superstar org-super-agenda org-roam-ui org-journal org-gcal org-drill npm-mode markdown-toc lsp-ui lsp-treemacs kill-ring-search idle-highlight-mode google-translate go-projectile general forge flymake-json flycheck-pos-tip flycheck-color-mode-line eyebrowse expand-region drag-stuff doom-themes doom-modeline dockerfile-mode docker default-text-scale counsel company command-log-mode ag)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
