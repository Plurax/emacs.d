;; This will start the emacs server to provide interaction with org-protocol
;; Create a global shortcut of your choice and call /usr/bin/emacsclient org-protocol://capture?template=t
;; This will act like calling C-c within Emacs, but bringing Emacs to scope and youre
;; able to add your todo instantly from any other application...
;; Assure org-protocol module being active!
(server-start)
(defun px-raise-frame-and-give-focus ()
    (set-mouse-pixel-position (selected-frame) 4 4)
    (raise-frame selected-frame)
;    (x-focus-frame (selected-frame))
    (select-frame-set-input-focus (selected-frame))
   )
;(add-hook 'server-switch-hook 'px-raise-frame-and-give-focus)


(defadvice raise-frame (after make-it-work (&optional frame) activate)
    "Work around some bug? in raise-frame/Emacs/GTK/Metacity/something.
     Katsumi Yamaoka posted this in
     http://article.gmane.org/gmane.emacs.devel:39702"
     (call-process
     "wmctrl" nil nil nil "-i" "-R"
     (frame-parameter (or frame (selected-frame)) 'outer-window-id)))
(add-hook 'server-switch-hook 'raise-frame)



;; -------------------------------------------------------------------------- ;;
;; cask - packet management
(require 'cask "~/.cask/cask.el")
(cask-initialize)


(use-package google-translate
  :init
  (setq google-translate-backend-method 'curl)
  (setq google-translate-default-source-language "de")
  (setq google-translate-default-target-language "en")
  (setq google-translate-translation-directions-alist '(("en" . "de") ("de" . "en")))
  :config
  (progn
    (define-key eyebrowse-mode-map (kbd "C-c g t") 'google-translate-smooth-translate)))

;; I am using 4 eyebrowse setups which I can switch between with F9-F10 - Currently I rename them after startup to EmacsCfg, Dev, Org, Mail
(use-package eyebrowse
  :ensure t
  :init
  (setq eyebrowse-keymap-prefix (kbd "C-c M-e"))
  (global-unset-key (kbd "C-c C-w"))
  :config
  (eyebrowse-mode t)
  (progn
            (define-key eyebrowse-mode-map (kbd "<f12>") 'eyebrowse-switch-to-window-config-1)
            (define-key eyebrowse-mode-map (kbd "<f11>") 'eyebrowse-switch-to-window-config-2)
            (define-key eyebrowse-mode-map (kbd "<f10>") 'eyebrowse-switch-to-window-config-3)
            (define-key eyebrowse-mode-map (kbd "<f9>") 'eyebrowse-switch-to-window-config-4))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Basic behaviour and appearance
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; show trailing spaces
;(setq-default show-trailing-whitespace nil)

;; set tabs to indent as white spaces and set default tab width to 4 white spaces
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
;(setq-default indent-line-function 'insert-tab)

;; setup: M-y saves the new yank to the clipboard.
(setq yank-pop-change-selection t)

(show-paren-mode 1)
(setq column-number-mode t)

;; minimalistic Emacs at startup
(menu-bar-mode 0)
(tool-bar-mode 0)
(set-scroll-bar-mode nil)

;; mqtt mode
(use-package mqtt-mode)

;; Gradle
(use-package gradle-mode)
(use-package groovy-mode)

;; OpenAPI
;(require 'openapi-yaml-mode)


(use-package treemacs
  :ensure t
  :defer t)


(use-package treemacs-icons-dired
  :after treemacs dired
  :ensure t
  :config (treemacs-icons-dired-mode))

(use-package treemacs-magit
  :after treemacs magit
  :ensure t)

;; don't use global line highlight mode
(global-hl-line-mode 0)

(use-package lsp-ui
    :ensure t
    :config
    (setq lsp-ui-sideline-ignore-duplicate t)
    (add-hook 'lsp-mode-hook 'lsp-ui-mode)
    )
(use-package lsp-mode
  :hook (prog-mode . lsp))

(use-package company-lsp)

(use-package lsp-java
  :config (add-hook 'java-mode-hook #'lsp)
  )

;; supress welcome screen
(setq inhibit-startup-message t)

;; Bind other-window (and custom prev-window) to more accessible keys.
(defun prev-window ()
  (interactive)
  (other-window -1))
(global-set-key (kbd "C-'") 'other-window)
(global-set-key (kbd "C-;") 'prev-window)


(use-package default-text-scale)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; major modes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Cask
(use-package cask-mode
  :mode "Cask"
  )

;; PlatformIO
(use-package platformio-mode)

;; C++
(use-package c++-mode
  :after ccls
  :mode (("\\.cc\\'" . c++-mode)
         ("\\.h\\'" . c++-mode)
         ("\\.hpp\\'" . c++-mode)
         ("\\.tpp\\'" . c++-mode)
         ("\\.cpp\\'" . c++-mode))
   ;; :bind (:map c++-mode-map
   ;;             ("C-x c" . 'cmake-ide-compile))
  )

;; CMake
(use-package cmake-mode
  :mode (("CMakeLists\\.txt\\'" . cmake-mode)
         ("\\.cmake\\'" . cmake-mode))
  :init (setq cmake-tab-width 4)
  )

;; Docker
(use-package dockerfile-mode
  :mode "Dockerfile.*\\'"
  )

;; Protobuf
(use-package protobuf-mode
  :mode "\\.proto\\'"
  )

;; Swift
(use-package swift-mode
  :mode "\\.swift\\'"
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ccls & cmake ide
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package ccls
  :after projectile
  :custom
  (ccls-args nil)
  (ccls-executable (executable-find "ccls"))
  (projectile-project-root-files-top-down-recurring
   (append '("compile_commands.json" ".ccls")
           projectile-project-root-files-top-down-recurring))
  :config (push ".ccls-cache" projectile-globally-ignored-directories))

(use-package cmake-mode
  :mode ("CMakeLists\\.txt\\'" "\\.cmake\\'"))

(use-package cmake-font-lock
  :after (cmake-mode)
  :hook (cmake-mode . cmake-font-lock-activate))

(use-package cmake-ide
  :after projectile
  :hook (c++-mode . my/cmake-ide-find-project)
  :preface
  (defun my/cmake-ide-find-project ()
    "Finds the directory of the project for cmake-ide."
    (with-eval-after-load 'projectile
      (setq cmake-ide-project-dir (projectile-project-root))
      (setq cmake-ide-build-dir (concat cmake-ide-project-dir "build")))
    (cmake-ide-load-db))

  (defun my/switch-to-compilation-window ()
    "Switches to the *compilation* buffer after compilation."
    (other-window 1))
  :bind ([remap comment-region] . cmake-ide-compile)
  :init (cmake-ide-setup)
  :config (advice-add 'cmake-ide-compile :after #'my/switch-to-compilation-window))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; flycheck-mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package flycheck
  :init (global-flycheck-mode)
  )

;; Color mode line for errors.
(use-package flycheck-color-mode-line
  :after flycheck
  :config '(add-hook 'flycheck-mode-hook 'flycheck-color-mode-line-mode)
  )

;; Show pos-tip popups for errors.
(use-package flycheck-pos-tip
  :after flycheck
  :config (flycheck-pos-tip-mode)
  )

;; Company mode.
(use-package company
  :config (global-company-mode)
  (setq company-transformers nil company-lsp-async t company-lsp-cache-candidates nil)  
  )

(use-package company-lsp
  :init (push 'company-lsp company-backends)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; clang-format
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; clang-format can be triggered using C-M-tab
(use-package clang-format
  :config (global-set-key [C-M-tab] 'clang-format-region)
  )

;; Markdown Mode

(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "pandoc"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; C/C++ mode modifications
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-hook 'c-mode-common-hook 'google-set-c-style)

;; also toggle on auto-newline and hungry delete minor modes
(defun my-c++-mode-hook ()
  (c-set-style "google")        ; use my-style defined above
  (auto-fill-mode))

(add-hook 'c++-mode-hook 'my-c++-mode-hook)

;; Autoindent using google style guide
(add-hook 'c-mode-common-hook 'google-make-newline-indent)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; elpy (python IDE-ish features)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package elpy
  :after company flycheck
  :init (defun goto-def-or-rgrep ()
          "Go to definition of thing at point or do an rgrep in project if that fails"
          (interactive)
          (condition-case nil (elpy-goto-definition)
            (error (elpy-rgrep-symbol (thing-at-point 'symbol)))))
  ;; Custom keybindings.
  :bind (:map elpy-mode-map
              ("<home>" . 'goto-def-or-rgrep)
              ("<prior>" . 'pop-tag-mark)
              ("<next>" . 'elpy-goto-definition))
  :config
  (elpy-enable)
  ;; Use flycheck not flymake with elpy.
  (when (require 'flycheck nil t)
    (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
    (add-hook 'elpy-mode-hook 'flycheck-mode))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ivy-mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package ivy
  :config
  (ivy-mode)
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; counsel keyboard mappings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package ag)
(use-package magit)
(use-package git-commit
  ;; Limit commit message summary to 50 columns, and wrap content after 72 columns.
  :init (add-hook 'git-commit-mode-hook
                  '(lambda ()
                     (setq-local git-commit-summary-max-length 50)
                     (setq-local fill-column 72)))
  )
(use-package counsel
  :after ag ivy magit
  :bind (("\C-s" . 'swiper)
         ("C-c C-r" . 'ivy-resume)
         ("<f6>" . 'ivy-resume)
         ("M-x" . 'counsel-M-x)
         ("C-x C-f" . 'counsel-find-file)
         ("<f1> f" . 'counsel-describe-function)
         ("<f1> v" . 'counsel-describe-variable)
         ("<f1> l" . 'counsel-find-library)
         ("<f2> i" . 'counsel-info-lookup-symbol)
         ("<f2> u" . 'counsel-unicode-char)
         ("C-c g" . 'counsel-git)
         ("C-c j" . 'counsel-git-grep)
         ("C-c k" . 'counsel-ag)
         ("C-x l" . 'counsel-locate)
         ("C-x g" . 'magit-status)
         ("C-r" . 'counsel-minibuffer-history))
  :init (setq counsel-git-grep-skip-counting-lines t)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; drag stuff
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package drag-stuff
  :config
  (drag-stuff-global-mode 1)
  (drag-stuff-define-keys)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; expand region
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package expand-region
  ;; Overwrite binding to insert non-graphic characters (I never use that).
  :bind ("C-q" . 'er/expand-region)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; idle highlight mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package idle-highlight-mode
  :config
  (defun idle-highlight-mode-hook ()
    (make-local-variable 'column-number-mode)
    (column-number-mode t)
    (idle-highlight-mode t))
  (add-hook 'emacs-lisp-mode-hook 'idle-highlight-mode-hook)
  (add-hook 'c-mode-common-hook 'idle-highlight-mode-hook)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; org-mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package org
  :bind (("C-c M" . 'org-agenda-view))
  :config
  ;; babel & PlantUML
  ;; Activate Org-babel languages.
  (org-babel-do-load-languages
   'org-babel-load-languages
   '(;; other Babel languages
     (plantuml . t)
     (restclient . t)
     (python . t)
     (C . t)))
  (setq org-babel-python-command "python3")

  (setq org-todo-keywords
        '((sequence "TODO" "ONGOING" "WAITING" "|" "DONE" "DELEGATED" "CANCELED")))
  ;; automatically call minor mode for trello boards
  (add-hook 'org-mode-hook
            (lambda () (if (assoc "orgtrello_user_me" org-file-properties)
                         (org-trello-mode))))
  (setq org-default-notes-file (concat "~/notes/inbox.org"))
  ;; This will allow refiling into all files from the agenda file list
  ;; https://blog.aaronbieber.com/2017/03/19/organizing-notes-with-refile.html
  (setq org-refile-targets '((org-agenda-files :maxlevel . 3)))
  (setq org-refile-use-outline-path 'file)
  (setq org-outline-path-complete-in-steps nil)

  (add-hook 'org-timer-done-hook 'my-org-timer-done)

  (defun my-org-agenda-skip-all-siblings-but-first ()
    "Skip all but the first non-done entry."
    (let (should-skip-entry)
      (unless (org-current-is-todo)
        (setq should-skip-entry t))
      (save-excursion
        (while (and (not should-skip-entry) (org-goto-sibling t))
          (when (org-current-is-todo)
            (setq should-skip-entry t))))
      (when should-skip-entry
        (or (outline-next-heading)
            (goto-char (point-max))))))

  (defun org-current-is-todo ()
    (string= "TODO" (org-get-todo-state)))
  (defun my-org-timer-done ()
    (shell-command "canberra-gtk-play --file=/usr/share/sounds/gnome/default/alerts/glass.ogg"))
  )

(use-package org-gcal
  :ensure t
  :config
  (add-hook 'org-agenda-mode-hook (lambda () (org-gcal-fetch) )))
;  (add-hook 'org-capture-after-finalize-hook (lambda () (org-gcal-sync) )))

; Wofür war das? ""

(use-package org-trello)
(use-package elmine)


(use-package helm
  :demand t
  :bind (( "<f5> <f5>" . helm-org-agenda-files-headings)
      ( "<f5> a" . helm-apropos)
      ( "<f5> A" . helm-apt)
      ( "<f5> b" . helm-buffers-list)
      ( "<f5> c" . helm-colors)
      ( "<f5> f" . helm-find-files)
      ( "<f5> i" . helm-semantic-or-imenu)
      ( "<f5> k" . helm-show-kill-ring)
      ( "<f5> K" . helm-execute-kmacro)
      ( "<f5> l" . helm-locate)
      ( "<f5> m" . helm-man-woman)
      ( "<f5> o" . helm-occur)
      ( "<f5> r" . helm-resume)
      ( "<f5> R" . helm-register)
      ( "<f5> t" . helm-top)
      ( "<f5> u" . helm-ucs)
      ( "<f5> p" . helm-list-emacs-process)
      ( "<f5> x" . helm-M-x))
  :config (progn
   	 ;; extend helm for org headings with the clock in action
   	 (defun dfeich/helm-org-clock-in (marker)
   	   "Clock into the item at MARKER"
   	   (with-current-buffer (marker-buffer marker)
   	     (goto-char (marker-position marker))
   	     (org-clock-in)))
   	 (eval-after-load 'helm-org
   	   '(nconc helm-org-headings-actions
   		   (list
   		    (cons "Clock into task" #'dfeich/helm-org-clock-in)))))
  )

(use-package org-jira)

;; Using bullets instead of *
(use-package org-bullets
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

(global-set-key (kbd "C-c a") '(lambda (&optional arg) (interactive "P")(org-agenda arg "t")))
(global-set-key (kbd "C-c s") '(lambda (&optional arg) (interactive "P")(org-switchb)))
(global-set-key (kbd "C-c c") '(lambda (&optional arg) (interactive "P")(org-capture)))


(use-package epresent)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; IBuffer
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; http://martinowen.net/blog/2010/02/03/tips-for-emacs-ibuffer.html
; http://ergoemacs.org/emacs/emacs_buffer_management.html
; http://stackoverflow.com/questions/1231188/emacs-list-buffers-behavior
(use-package ibuffer
  :bind ("C-x C-b" . 'ibuffer)
  :config
  ;; Define IBuffer filter modes.
  (setq ibuffer-saved-filter-groups
        '(("home"
           ("emacs-config" (or (filename . ".emacs.d")
                               (filename . "emacs-config")))
           ("Org" (or (mode . org-mode)
                      (filename . "OrgMode")))
           ("code" (filename . "src"))
           ("Magit" (name . "\*magit\*"))
           ("Help" (or (name . "\*Help\*")
                       (name . "\*Apropos\*")
                       (name . "\*info\*"))))))

  ;; Load filter.
  (add-hook 'ibuffer-mode-hook
            '(lambda ()
               (ibuffer-switch-to-saved-filter-groups "home")))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; comint-mode & shell-mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Changed a default colour to "dodger blue" to make ls colours easier to see.
;; (setq ansi-color-faces-vector [default bold default italic underline success warning error])
(setq ansi-color-names-vector ["black" "red3" "green3" "yellow3" "dodger blue" "olive drab" "cyan3" "gray90"])

;; Prevent inheriting of minibuffer-prompt's face. Gives better shell prompt colors.
(set-face-attribute 'comint-highlight-prompt nil ':inherit 'unspecified)

;; Prevent having to enter passwords in plain text.
(setq comint-password-prompt-regexp
      (concat comint-password-prompt-regexp
              "\\|^Password .*:\\s *\\'"))

;; track shell directory when using shell in emacs (by inspecting procfs)
;; https://www.emacswiki.org/emacs/ShellDirtrackByProcfs
(defun track-shell-directory/procfs ()
  "Write docstring here."
  (shell-dirtrack-mode 0)
  (add-hook 'comint-preoutput-filter-functions
            (lambda (str)
              (prog1 str
                (when (string-match comint-prompt-regexp str)
                  (cd (file-symlink-p
                       (format "/proc/%s/cwd" (process-id
                                               (get-buffer-process
                                                (current-buffer)))))))))
            nil t))

(add-hook 'shell-mode-hook (lambda () (setq show-trailing-whitespace nil)))
(add-hook 'shell-mode-hook 'track-shell-directory/procfs)

;; set scroll behaviour similar to linux shell
;; http://stackoverflow.com/questions/6780468/emacs-m-x-shell-and-the-overriding-of-bash-keyboard-bindings
(remove-hook 'comint-output-filter-functions
             'comint-postoutput-scroll-to-bottom)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Themes & visual behaviour
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'doom-themes)

;; Global settings (defaults)
(setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
      doom-themes-enable-italic t) ; if nil, italics is universally disabled

;; Load the theme (doom-one, doom-molokai, etc); keep in mind that each theme
;; may have their own settings.
(load-theme 'doom-one t)

;; Enable flashing mode-line on errors
(doom-themes-visual-bell-config)

;; or for treemacs users
(setq doom-themes-treemacs-theme "doom-colors") ; use the colorful treemacs theme
(doom-themes-treemacs-config)

;; Corrects (and improves) org-mode's native fontification.
(doom-themes-org-config)

(use-package doom-modeline
  :ensure t
  :hook (after-init . doom-modeline-mode))
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The End
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; LATEX SETUP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; setting up latex mode
;; Forward/inverse search with evince using D-bus.
;; Installation:
;; M-x package-install RET auctex RET
(add-hook 'LaTeX-mode-hook 'TeX-PDF-mode)
(add-hook 'LaTeX-mode-hook 'TeX-source-correlate-mode)
(setq TeX-source-correlate-method 'synctex)

(if (require 'dbus "dbus" t)
    (progn
      ;; universal time, need by evince
      (defun utime ()
	(let ((high (nth 0 (current-time)))
	      (low (nth 1 (current-time))))
	  (+ (* high (lsh 1 16) ) low)))

      ;; Forward search.
      ;; Adapted from http://dud.inf.tu-dresden.de/~ben/evince_synctex.tar.gz
      (defun auctex-evince-forward-sync (pdffile texfile line)
	(let ((dbus-name
	       (dbus-call-method :session
				 "org.gnome.evince.Daemon"  ; service
				 "/org/gnome/evince/Daemon" ; path
				 "org.gnome.evince.Daemon"  ; interface
				 "FindDocument"
				 (concat "file://" pdffile)
				 t     ; Open a new window if the file is not opened.
				 )))
	  (dbus-call-method :session
			    dbus-name
			    "/org/gnome/evince/Window/0"
			    "org.gnome.evince.Window"
			    "SyncView"
			    texfile
			    (list :struct :int32 line :int32 1)
			    (utime))))

      (defun auctex-evince-view ()
	(let ((pdf (file-truename (concat default-directory
					  (TeX-master-file (TeX-output-extension)))))
	      (tex (buffer-file-name))
	      (line (line-number-at-pos)))
	  (auctex-evince-forward-sync pdf tex line)))

      ;; New view entry: Evince via D-bus.
      (setq TeX-view-program-list '())
      (add-to-list 'TeX-view-program-list
		   '("EvinceDbus" auctex-evince-view))

      ;; Prepend Evince via D-bus to program selection list
      ;; overriding other settings for PDF viewing.
      (setq TeX-view-program-selection '())
      (add-to-list 'TeX-view-program-selection
		   '(output-pdf "EvinceDbus"))

      ;; Inverse search.
      ;; Adapted from: http://www.mail-archive.com/auctex@gnu.org/msg04175.html
      (defun auctex-evince-inverse-sync (file linecol timestamp)
	(let ((buf (get-file-buffer (substring file 7)))
	      (line (car linecol))
	      (col (cadr linecol)))
	  (if (null buf)
	      (message "Sorry, %s is not opened..." file)
	    (switch-to-buffer buf)
	    (goto-line (car linecol))
	    (unless (= col -1)
	      (move-to-column col)))))

      (dbus-register-signal
       :session nil "/org/gnome/evince/Window/0"
       "org.gnome.evince.Window" "SyncSource"
       'auctex-evince-inverse-sync)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(projectile-mode +1)
;(define-key projectile-mode-map (kbd "S-p") 'projectile-command-map)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)


; mu4e Mail client
(add-to-list 'load-path "/usr/share/emacs/site-lisp/mu4e")
; mu4e Mails
(require 'mu4e)
(require 'org-mu4e)

(define-key mu4e-headers-mode-map (kbd "C-c c") 'org-mu4e-store-and-capture)
(define-key mu4e-view-mode-map    (kbd "C-c c") 'org-mu4e-store-and-capture)

;rename files when moving
;;NEEDED FOR MBSYNC
(setq mu4e-change-filenames-when-moving t)
(setq mu4e-maildir "~/Maildir")


(setq mail-user-agent 'mu4e-user-agent)

  ;; set `mu4e-context-policy` and `mu4e-compose-policy` to tweak when mu4e should
  ;; guess or ask the correct context, e.g.

  ;; start with the first (default) context; 
  ;; default is to ask-if-none (ask when there's no context yet, and none match)
  ;; (setq mu4e-context-policy 'pick-first)

  ;; compose with the current context is no context matches;
  ;; default is to ask 
  ;; (setq mu4e-compose-context-policy nil)                                        ;

(setq org-mu4e-link-query-in-headers-mode nil)

;; allow for updating mail using 'U' in the main view:
(setq mu4e-get-mail-command "mbsync")

(require 'smtpmail)

;; don't keep message buffers around
(setq message-kill-buffer-on-exit t)


;; This can be used with REST Client mode for retrieving user/pass to avoid pasting
;; your credentials into REST API files...
(defun getAuthString ()
  "Retrieve Auth header for REST Client"
  (interactive)
  (concat "Basic " (base64-encode-string (concat (read-string "User: ") ":" (password-read "Password: "))))
  )

(provide 'init)
;;; init.el ends here

(defcustom chuhlich/org-agenda-context-options nil
  "An a list of different contexts for agenda loading."
  :type '(alist))

(defcustom chuhlich/org-agenda-context nil
  "The current set key to org-agenda-context-options, which is used for loading the agenda."
  :type '(string))

(defun chuhlich/choose-org-context ()
  "Choose the org agenda context from the alist."
  (interactive)
  (setq chuhlich/org-agenda-context 
        (ivy-read "Describe function: "
                  (mapcar 'car chuhlich/org-agenda-context-options)
                  :preselect (ivy-thing-at-point)
                  :require-match t
                  :sort t
                  :caller 'chuhlich/choose-org-context))
  (setq org-agenda-files (cdr (assoc chuhlich/org-agenda-context chuhlich/org-agenda-context-options)))
  (message "Using %s file set for org-agenda." chuhlich/org-agenda-context))




;; The custom.el holds all customized variables (e.g. account infos or API keys)
(setq custom-file "~/Sync/emacsconfig/custom.el")
(load custom-file)

