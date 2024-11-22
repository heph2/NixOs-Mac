;;; Init.el ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'package)
(add-to-list 'package-archives '("gnu"   . "https://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives
	     '("nongnu" . "https://elpa.nongnu.org/nongnu/"))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-and-compile
  (setq use-package-always-ensure t
        use-package-expand-minimally t))

;; Initliaize Quelpa
(unless (package-installed-p 'quelpa)
  (with-temp-buffer
    (url-insert-file-contents "https://raw.githubusercontent.com/quelpa/quelpa/master/quelpa.el")
    (eval-buffer)
    (quelpa-self-upgrade)))

(use-package emacs
  :config
  ;; Set the Terminus font and font size
  (set-face-attribute 'default nil :font "Hack 15")

  (setq tab-always-indent 'complete)
  (defalias 'yes-or-no-p 'y-or-n-p) ;; life is too short
  (setq indent-tabs-mode nil) ;; no tabs

  ;; keep backup and save files in a dedicated directory
  (setq backup-directory-alist
          `((".*" . ,(concat user-emacs-directory "backups")))
          auto-save-file-name-transforms
          `((".*" ,(concat user-emacs-directory "backups") t)))
  (menu-bar-mode -1)
  (line-number-mode 1)
  (scroll-bar-mode -1)
  (tool-bar-mode -1))

;; Del deletes forward instead of behind
(normal-erase-is-backspace-mode 1)

;;(when (eq system-type 'darwin)
;;  (define-key eat-semi-char-mode-map (kbd "C-h")  #'eat-self-input)
;;  (define-key eat-semi-char-mode-map (kbd "<backspace>") (kbd "C-h")))

;(modus-themes-load-theme 'modus-vivendi-tinted)

(use-package eat)

(setenv "TERM" "xterm256-color") ;; needed by eat on MacOS

(use-package dired-hacks-utils)

;; (let ((font
;;         ;; "-misc-fixed-medium-r-semicondensed--13-120-75-75-c-60-iso10646-1"
;;         "Spleen"
;;         ))
;;     (set-frame-font font nil t)
;;     (add-to-list 'default-frame-alist `(font . ,font)))

;; ;; fix the emojis too
;; (set-fontset-font t 'emoji '("Noto Emoji" . "iso10646-1")
;;                     nil 'prepend)


(use-package typescript-mode
  :mode ("\\.tsx?\\'" . typescript-mode)
  :config
  (setq typescript-indent-level 2))

(use-package modus-themes)

(use-package go-mode
  :mode ("\\.go?\\'" . go-mode))

;; (use-package rustic
;;   :mode ("\\.rs?\\'" . rust-mode)
;;   :config (setq rustic-lsp-client 'eglot))

(use-package rust-mode
  :mode ("\\.rs?\\'" . rust-mode))

(use-package nix-mode
  :mode ("\\.nix?\\'" . nix-mode))

(use-package zig-mode
  :mode ("\\.zig?\\'" . zig-mode))

(use-package python-mode
  :mode ("\\.py?\\'" . python-mode))

(use-package markdown-mode
  :mode ("\\.md?\\'" . markdown-mode))

(use-package envrc
  :hook (after-init . envrc-global-mode))

(use-package eglot
  :init (setq completion-category-overrides '((eglot (styles orderless))))
  :config
  (add-to-list 'eglot-server-programs
               `(rust-mode . ("rust-analyzer" :initializationOptions
                              ( :procMacro (:enable t)
                                :cargo ( :buildScripts (:enable t)
                                         :features "all"))))))

(use-package vundo)

(use-package ibuffer
    :ensure nil
    :bind (("C-x C-b" . ibuffer)))

(use-package bufler
  :bind
  (("C-x C-b" . bufler-list)
    ("C-x b" . bufler-switch-buffer)))

(use-package marginalia
  :custom
  (marginalia-max-relative-age 0)
  (marginalia-align 'right)
  :init
  (marginalia-mode))

(use-package all-the-icons-completion
  :after (marginalia all-the-icons)
  :hook (marginalia-mode . all-the-icons-completion-marginalia-setup)
  :init
  (all-the-icons-completion-mode))

(use-package vertico
  :custom
  (vertico-count 13)  ; Number of candidates to display
  (vertico-resize t)
  (vertico-cycle nil) ; Go from last to first candidate and first to last (cycle)?
  ;; :general
  ;; (:keymaps 'vertico-map
  ;;  "<tab>" #'vertico-insert  ; Insert selected candidate into text area
  ;;  "<escape>" #'minibuffer-keyboard-quit ; Close minibuffer
  ;;  ;; NOTE 2022-02-05: Cycle through candidate groups
  ;;  "C-M-n" #'vertico-next-group
  ;;  "C-M-p" #'vertico-previous-group)
  :config
  (vertico-mode))

(use-package orderless
  :custom
  (completion-styles '(orderless))      ; Use orderless
  (completion-category-defaults nil))
;  (completion-category-overrides '((eglot (styles . (orderless flex))))))
;;  (completion-category-overrides
;; '((file (styles basic-remote ; For `tramp' hostname completion with `vertico'
;;                   orderless)))))

(use-package corfu
  :custom
  (corfu-cycle t)                ;; Enable cycling for `corfu-next/previous'
  ;; (corfu-auto t)                 ;; Enable auto completion
  ;; (corfu-separator ?\s)          ;; Orderless field separator
  ;; (corfu-quit-at-boundary nil)   ;; Never quit at completion boundary
  ;; (corfu-quit-no-match nil)      ;; Never quit, even if there is no match
  ;; (corfu-preview-current nil)    ;; Disable current candidate preview
  ;; (corfu-preselect 'prompt)      ;; Preselect the prompt
  ;; (corfu-on-exact-match nil)     ;; Configure handling of exact matches
  ;; (corfu-scroll-margin 5)        ;; Use scroll margin
  :init
  (global-corfu-mode))


;; (use-package yasnippet
;; ;;  :diminish yas-minor-mode
;;   :hook (prog-mode . yas-minor-mode)
;;   :config
;;   (yas-reload-all))

;; (use-package yasnippet-snippets
;;   :defer t
;;   :after yasnippet)

(use-package consult
  :bind
  ("C-s" . consult-line))

(use-package magit)

(use-package moody
  :config
  (setq x-underline-at-descent-line t)
  ;; (moody-replace-mode-line-buffer-identification)
  (moody-replace-eldoc-minibuffer-message-function))

(use-package minions)

(use-package envrc
  :init
  (envrc-global-mode))

(use-package direnv
  :config (direnv-mode))

(use-package kubernetes)
(use-package dockerfile-mode)
(use-package jsonnet-mode)
(use-package terraform-mode)
(use-package yaml-mode)
(use-package json-mode)

(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook))

(use-package eyebrowse)
(use-package shackle)

(use-package treesit-auto
  :config
  (global-treesit-auto-mode))

(use-package php-mode
  :mode ("\\.php?\\'" . php-mode))

(use-package editorconfig
  :config
  (editorconfig-mode 1))

;; GTD Setup
(setq org-todo-keywords
      '((sequence "TODO(t)" "WAIT(w)" "NEXT(n)" "PROJ(p)" "|" "DONE(d)" "CANC(c)")
        ))

(setq org-agenda-span 90)
(setq org-agenda-files (file-expand-wildcards "~/env/org/main.org"))

(setq org-agenda-custom-commands
      '(
        ("i" "Inbox" tags-todo "+TODO=\"TODO\""
         ((org-agenda-files (file-expand-wildcards "~/env/org/inbox.org"))))
        ("n" "Next actions" tags-todo "+TODO=\"NEXT\"")
        ("p" "Projects" tags-todo "+TODO=\"PROJ\"")
        ("w" "Waiting" tags-todo "+TODO=\"WAIT\"")
        ("s" "Someday" tags-todo "+TODO=\"TODO\"|TODO=\"PROJ\""
         ((org-agenda-files (file-expand-wildcards "~/env/org/someday.org"))))
        ("o" "Actions and Projects" tags-todo "+TODO=\"TODO\"|TODO=\"PROJ\"")
        ))

(setq org-agenda-prefix-format '((agenda . "  %-25:c%?-12t% s")
				 (timeline . "  % s")
				 (todo . "  %-12:c")
				 (tags . "  %-25:c")
				 (search . "  %-12:c")))

(setq org-agenda-tags-column -120)
(setq org-tags-column -80)

(setq org-agenda-sorting-strategy
      '((agenda habit-down time-up priority-down category-keep)
        (todo priority-down todo-state-up category-keep)
        (tags priority-down todo-state-up category-keep)
        (search category-keep)))

;; M-x org-agenda # to show the stuck projects
(setq org-stuck-projects
      '("+TODO=\"PROJ\"" ("TODO") nil "") )

(setq org-refile-use-outline-path 'file)
(setq org-outline-path-complete-in-steps 'nil)
(setq refile-targets (file-expand-wildcards "~/env/org/*.org"))
(setq org-refile-targets '(( refile-targets :todo . "PROJ" )))

(setq org-capture-templates
      '(
        ("i" "Inbox" entry
         (file "~/env/org/inbox.org")
         "* TODO %^{Brief Description}\nAdded: %U\n%?" :empty-lines 1 :prepend t)

        ("n" "Next action" entry
         (file "~/env/org/main.org")
         "** NEXT %^{Brief Description}\nAdded: %U\n%?" :empty-lines 1 :prepend t)

        ("w" "Waiting" entry
         (file "~/env/org/main.org")
         "** WAIT %^{Brief Description}\nAdded: %U\n%?" :empty-lines 1 :prepend t)

        ("p" "Project" entry
         (file "~/env/org/main.org")
         "* PROJ %^{Brief Description}\n:PROPERTIES:\n:CATEGORY: %^{Id}\n:END:\nAdded: %U\n%?" :empty-lines 1 :prepend t)

         ("s" "Someday" entry
         (file "~/env/org/someday.org")
         "* TODO %^{Brief Description}\nAdded: %U\n%?" :empty-lines 1 :prepend t)
        ))

(define-key global-map "\C-cc" 'org-capture)

;; Shortcut integration
(quelpa '(org-shortcut
          :fetcher github
          :repo "glittershark/org-clubhouse"))

(quelpa '(elysium
	  :fetcher github
	  :repo "lanceberge/elysium"))
(setq elysium-window-size 0.33) ; The elysium buffer will be 1/3 your screen
(setq elysium-window-style 'vertical) ; Can be customized to horizontal

(quelpa '(evedel
	  :fetcher github
          :stable nil
	  :repo "daedsidog/evedel"))

(use-package smerge-mode
  :ensure nil
  :hook
  (prog-mode . smerge-mode))

(use-package gptel
  :config
  (setq
   gptel-model 'qwen2.5-coder:latest
   gptel-backend (gptel-make-ollama "Ollama"
                   :host "192.168.1.18:11434"
                   :stream t
                   :models '("qwen2.5-coder:32b"))))

(use-package vterm)

(use-package kubel
  :after (vterm)
  :config (kubel-vterm-setup))



;; Manually load org-shortcut
;; (load "~/Downloads/org-shortcut.el")
(add-hook 'org-mode-hook #'org-shortcut-mode nil nil)
(setq org-shortcut-state-alist
      '(("TODO"    . "To Do")
	("BACKLOG" . "Backlog")
        ("ACTIVE"  . "Doing")
	("WAIT"    . "In review")
        ("DONE"    . "Done")))


;; Hledger setup
(use-package hledger-mode
  :config
  (setq hledger-jfile "~/env/finance/2024.journal")
  :mode ("\\.journal\\'" "\\.hledger\\'"))

(use-package ledger-mode
  :config
  (setq ledger-mode-should-check-version nil
	ledger-report-links-in-register nil
        ledger-report-auto-width nil
        ledger-report-native-highlighting-arguments '("--color=always")
        ledger-highlight-xact-under-point nil
        ;; ledger-default-date-format ledger-iso-date-format
	ledger-binary-path "/etc/profiles/per-user/marco/bin/ledger")
  :mode ("\\.journal\\'" "\\.ledger\\'"))
