(setq inhibit-startup-message t)


(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/"))

(package-initialize)

;; Bootstrap `use-package'
(unless (package-installed-p 'use-package)
	(package-refresh-contents)
	(package-install 'use-package))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Basic behaviour and appearance
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; show trailing spaces
;;(setq-default show-trailing-whitespace t)

;; set tabs to indent as white spaces and set default tab width to 4 white spaces
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
;(setq-default indent-line-function 'insert-tab)

;; setup: M-y saves the new yank to the clipboard.
(setq yank-pop-change-selection t)

(show-paren-mode 1)
(setq column-number-mode t)

;; minimalistic Emacs at startup
(menu-bar-mode 1)
(tool-bar-mode 0)
(set-scroll-bar-mode nil)

;; don't use global line highlight mode
(global-hl-line-mode 0)

;; supress welcome screen
(setq inhibit-startup-message t)

;; Bind other-window (and custom prev-window) to more accessible keys.
(defun prev-window ()
  (interactive)
  (other-window -1))
(global-set-key (kbd "C-'") 'other-window)
(global-set-key (kbd "C-;") 'prev-window)

;; enable line numbers for all programing modes
(add-hook 'prog-mode-hook 'linum-mode)

; Highlights the current cursor line
(global-hl-line-mode t)

;; auto close bracket insertion. New in emacs 24
(electric-pair-mode 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Packages
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package try
	:ensure t)

(use-package which-key
	:ensure t
	:config
	(which-key-mode))

(use-package org-bullets
  :ensure t
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

; flashes the cursor's line when you scroll
(use-package beacon
  :ensure t
  :config
  (beacon-mode 1)
  ; (setq beacon-color "#666600")
  )


;; C++
(use-package c++-mode
  :after rtags
  :mode (("\\.h\\'" . c++-mode)
         ("\\.cc\\'" . c++-mode)
         ("\\.cpp\\'" . c++-mode))
  :bind (:map c++-mode-map
              ("<home>" . 'rtags-find-symbol-at-point)
              ("<prior>" . 'rtags-location-stack-back)
              ("<next>" . 'rtags-location-stack-forward))
  )

;; CMake
(use-package cmake-mode
  :ensure t
  :mode (("CMakeLists\\.txt\\'" . cmake-mode)
         ("\\.cmake\\'" . cmake-mode))
  :init (setq cmake-tab-width 4)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; cquery
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package cquery
  :ensure t
  :config
  (setq cquery-executable "/Users/gavinross/cquery/build/release/bin/cquery")
  (setq cquery-extra-init-params '(:index (:comments 2) :cacheFormat "msgpack"))

  ;; Syntax Checker for cquery
  (setq cquery-sem-highlight-method 'font-lock)
;; alternatively, (setq cquery-sem-highlight-method 'overlay)

;; For rainbow semantic highlighting
;; (cquery-use-default-rainbow-sem-highlight)
;; (setq cquery-executable "/path/to/cquery-install-prefix/bin/cquery")
  )

(defun cquery//enable ()
  (condition-case nil
      (lsp-cquery-enable)
    (user-error nil)))

  (use-package cquery
    :commands lsp-cquery-enable
    :init (add-hook 'c-mode-common-hook #'cquery//enable))
;; Also see lsp-project-whitelist lsp-project-blacklist cquery-root-matchers


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; rtags
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (use-package rtags
;;   :ensure t
;;   :config
;;   ;; Set path to rtag executables.
;; ;;  (setq rtags-path
;; ;;       (expand-file-name "~/rtags/build"))
;;   ;;
;;   ;; Start the rdm process unless the process is already running.
;;   ;; --> Launch rdm externally and prior to Emacs instead.
;;     (rtags-start-process-unless-running)
;;   ;;
;;   ;; Enable rtags-diagnostics.
;;   (setq rtags-autostart-diagnostics t)
;;   (rtags-diagnostics)
;;   ;;
;;   ;; Timeout for reparse on onsaved buffers.
;;   (rtags-set-periodic-reparse-timeout 0.5)
;;   ;;
;;   ;; Rtags standard keybindings ([M-. on symbol to go to bindings]).
;;   (rtags-enable-standard-keybindings)
;;   ;;
;;   ;; Enable completions in with rtags & company mode
;;   ;; -> use irony for completions
;;   ;;(setq rtags-completions-enabled t)
;;   ;;(require 'company)
;;   ;;(global-company-mode)
;;   ;;(push 'company-rtags company-backends) ; Add company-rtags to company-backends
  
;;   ;;
;;   )


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; cmake ide
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (use-package cmake-ide
;;   :after rtags
;;   :ensure t
;;   :config
;;   ;; set path to project build directory
;;  ;; (setq cmake-ide-build-dir
;;  ;;       (expand-file-name "~/src/stringent/build"))
;;   ;; CURRENTLY: hardcode to build dir of default project
;;   ;; TODO: fix via .dir-locals.el
;;   ;;
;;   ;; invoke cmake-ide setup
;;   (cmake-ide-setup)
;;   )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; lsp-ui
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (use-package lsp-ui
;;   :ensure t
;;   :config
;;   (add-hook 'lsp-mode-hook 'lsp-ui-mode)
;;   )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; flycheck-mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package flycheck
  :ensure t
  :config
  :init
  ;; set to have global completion or on specific modes.
  ;;(global-flycheck-mode)
  (add-hook 'c++-mode-hook 'flycheck-mode)
  (add-hook 'emacs-lisp-mode-hook 'flycheck-mode)
  )


;; ;; Color mode line for errors.
;; (use-package flycheck-color-mode-line
;;   :ensure t
;;   :after flycheck
;;   :config '(add-hook 'flycheck-mode-hook 'flycheck-color-mode-line-mode)
;;   )

;; ;; Show pos-tip popups for errors.
;; (use-package flycheck-pos-tip
;;   :ensure t
;;   :after flycheck
;;   :config (flycheck-pos-tip-mode)
;;   )

;; Flycheck rtags.
;; (use-package flycheck-rtags
;;   :after rtags
;;   :ensure t
;;   :config
;;   (defun my-flycheck-rtags-setup ()
;;     (flycheck-select-checker 'rtags)
;;     (setq-local flycheck-highlighting-mode nil) ;; RTags creates more accurate overlays.
;;     (setq-local flycheck-check-syntax-automatically nil))
;;   (add-hook 'c-mode-hook #'my-flycheck-rtags-setup)
;;   (add-hook 'c++-mode-hook #'my-flycheck-rtags-setup)
;;   (add-hook 'objc-mode-hook #'my-flycheck-rtags-setup))

;; ;; Flycheck irony
;;   (use-package flycheck-irony
;;     :after flycheck
;;     :ensure t
;;     :config
;;     (progn
;;       (eval-after-load 'flycheck '(add-hook 'flycheck-mode-hook #'flycheck-irony-setup))))

;; ;; Flycheck-plantuml/
;; (use-package flycheck-plantuml
;;   :after flycheck
;;   :ensure t
;;   :config (flycheck-plantuml-setup)
;;   )



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; irony (C/C++ minor mode powered by libclang)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (use-package irony
;;  :ensure t
;;  :config
;;  (add-hook 'c-mode-hook 'irony-mode)
;;  (add-hook 'c++-mode-hook 'irony-mode)
;;  (add-hook 'objc-mode-hook 'irony-mode)
;;  (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)
;;  (defun my-irony-mode-hook ()
;;  (define-key irony-mode-map [remap completion-at-point]
;;   'irony-completion-at-point-async)
;;  (define-key irony-mode-map [remap complete-symbol]
;;    'irony-completion-at-point-async))
;;  (add-hook 'irony-mode-hook 'my-irony-mode-hook)
;;  (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)
;;  )

;; ;; Eldoc shows argument list of the function you are currently writing in the echo area.
;;   (use-package irony-eldoc
;;     :ensure t
;;     :config
;;     (progn
;;       (add-hook 'irony-mode-hook #'irony-eldoc)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Company Mode (Code Completion package)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Company mode.
(use-package company
  :ensure t
  :config
  (setq company-idle-delay 0)
  (setq company-minimum-prefix-length 1)
  (global-company-mode t)
  )

(use-package company-lsp
  :ensure t
  :config
  (push 'company-lsp company-backends)
  (setq company-transformers nil company-lsp-async t company-lsp-cache-candidates nil)
)

;; ;;Use rtags for auto-completion.
;; (use-package company-rtags
;;   :ensure t
;;   :config
;;   (progn
;;     (setq rtags-autostart-diagnostics t)
;;     (rtags-diagnostics)
;;     (setq rtags-completions-enabled t)
;;     (push 'company-rtags company-backends)
;;     ))


;; ;;company-irony.
;; (use-package company-irony
;;   :after company
;;   :ensure t
;;   :config (global-company-mode)
;;   ;;(optional) adds CC special commands to `company-begin-commands' in order to
;;   ;;trigger completion at interesting places, such as after scope operator
;;   ;;    std::|
;;   (add-hook 'irony-mode-hook 'company-irony-setup-begin-commands)
;; )

;; ;;Company-mode backend for C/C++ header files that works with irony-mode.
;; ;;Complementary to company-irony by offering completion suggestions to header files.
;; (use-package company-irony-c-headers
;; :ensure t
;; :after company-irony
;; :ensure t
;; :config
;; ;;Load with `irony-mode` as a grouped backend
;; (eval-after-load 'company
;; '(add-to-list
;; 'company-backends '(company-irony-c-headers company-irony)))
;; )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; clang-format
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; clang-format can be triggered using C-M-tab
(use-package clang-format
  :ensure t
  :config (global-set-key [C-M-tab] 'clang-format-region)
  )

;; If the repo does not have a .clang-format files, one can
;; be created using google style:
;; clang-format -style=google -dump-config > .clang-format
;; In this, default indent is 2 (see 'IndentWidth' key in generated file).

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; C/C++ mode modifications
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (add-hook 'c-mode-common-hook 'google-set-c-style)

;; ;; use google style but modify offset to 4 (default for google is 2)
;; (c-add-style "my-style"
;; 	     '("google"
;; 	       (c-basic-offset . 4)            ; indent by four spaces
;; 	       ))

;; ;; also toggle on auto-newline and hungry delete minor modes
;; (defun my-c++-mode-hook ()
;;   (c-set-style "my-style")        ; use my-style defined above
;;   (auto-fill-mode))

;; (add-hook 'c++-mode-hook 'my-c++-mode-hook)

;; ;; Autoindent using google style guide
;; (add-hook 'c-mode-common-hook 'google-make-newline-indent)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ivy-mode (for completion in swiper)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package ivy
  :ensure t
  :config
  (ivy-mode)
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t)
  ;; Ivy integration with rtags.
  ;;(setq rtags-display-result-backend 'ivy)
  )


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; IBuffer
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(global-set-key (kbd "C-x C-b") 'ibuffer)
 (setq ibuffer-saved-filter-groups
	(quote (("default"
		 ("dired" (mode . dired-mode))
		 ("org" (name . "^.*org$"))
	       ("IRC" (or (mode . circe-channel-mode) (mode . circe-server-mode)))
		 ("web" (or (mode . web-mode) (mode . js2-mode)))
		 ("shell" (or (mode . eshell-mode) (mode . shell-mode)))
		 ("mu4e" (or

                (mode . mu4e-compose-mode)
                (name . "\*mu4e\*")
                ))
		 ("programming" (or
				 (mode . python-mode)
				 (mode . c++-mode)))
		 ("emacs" (or
			   (name . "^\\*scratch\\*$")
			   (name . "^\\*Messages\\*$")))
		 ))))
 (add-hook 'ibuffer-mode-hook
	    (lambda ()
	      (ibuffer-auto-mode 1)
	      (ibuffer-switch-to-saved-filter-groups "default")))

 ;; don't show these
					  ;(add-to-list 'ibuffer-never-show-predicates "zowie")
 ;; Don't show filter groups if there are no buffers in that group
 (setq ibuffer-show-empty-filter-groups nil)

 ;; Don't ask for confirmation to delete marked buffers
 (setq ibuffer-expert t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Swiper, Ivy and Counsel
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package counsel
:ensure t
  :bind
  (("M-y" . counsel-yank-pop)
   :map ivy-minibuffer-map
   ("M-y" . ivy-next-line)))

  (use-package ivy
  :ensure t
  :diminish (ivy-mode)
  :bind (("C-x b" . ivy-switch-buffer))
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "%d/%d ")
  (setq ivy-display-style 'fancy))

  (use-package swiper
  :ensure t
  :bind (("C-s" . swiper)
	 ("C-r" . swiper)
	 ("C-c C-r" . ivy-resume)
	 ("M-x" . counsel-M-x)
	 ("C-x C-f" . counsel-find-file))
  :config
  (progn
    (ivy-mode 1)
    (setq ivy-use-virtual-buffers t)
    (setq ivy-display-style 'fancy)
    (define-key read-expression-map (kbd "C-r") 'counsel-expression-history)
    ))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MAC KEY SWITCH
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq ns-command-modifier 'meta)
(setq mac-option-modifier 'control)
(setq ns-function-modifier 'control)
;;(setq ns-command-modifier 'control)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Themes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (use-package zenburn-theme
;;   :ensure t
;;  :config (load-theme 'zenburn t))

(use-package monokai-theme
  :ensure t
  :config (load-theme 'monokai t))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Fonts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(set-default-font "Monaco 13")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Yasnippet
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-to-list 'load-path
              "~/.emacs.d/plugins/yasnippet")
(require 'yasnippet)
(yas-global-mode 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Projectile
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package projectile
  :ensure t
  :config
  (projectile-global-mode)
(setq projectile-completion-system 'ivy))

(use-package counsel-projectile
  :ensure t
  :config
  ;;(counsel-projectile-on)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Treemacs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package treemacs
  :ensure t
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (progn
    (setq treemacs-collapse-dirs              (if (executable-find "python") 3 0)
          treemacs-file-event-delay           5000
          treemacs-follow-after-init          t
          treemacs-follow-recenter-distance   0.1
          treemacs-goto-tag-strategy          'refetch-index
          treemacs-indentation                2
          treemacs-indentation-string         " "
          treemacs-is-never-other-window      nil
          treemacs-no-png-images              nil
          treemacs-project-follow-cleanup     nil
          treemacs-recenter-after-file-follow nil
          treemacs-recenter-after-tag-follow  nil
          treemacs-show-hidden-files          t
          treemacs-silent-filewatch           nil
          treemacs-silent-refresh             nil
          treemacs-sorting                    'alphabetic-desc
          treemacs-tag-follow-cleanup         t
          treemacs-tag-follow-delay           1.5
          treemacs-width                      35)

    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)
    (pcase (cons (not (null (executable-find "git")))
                 (not (null (executable-find "python3"))))
      (`(t . t)
       (treemacs-git-mode 'extended))
      (`(t . _)
       (treemacs-git-mode 'simple))))
  :bind
  (:map global-map
        ("M-0"       . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag)))

;; Add this after adding projectile
(use-package treemacs-projectile
  :after treemacs projectile
  :ensure t)




(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (cquery irony-eldoc yasnippet-snippets counsel evil-visual-mark-mode cmake-ide swiper which-key try use-package)))
 '(safe-local-variable-values
   (quote
    ((company-clang-arguments "-I/Users/gavinross/c-demo-project/include1/" "-I/Users/gavinross/c-demo-project/include2/")
     (cmake-ide-build-dir . "~/cpp_primer/exercises/test_area/")))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
