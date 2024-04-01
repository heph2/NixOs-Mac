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

(use-package emacs
  :config
  ;; Set the Terminus font and font size
  (set-face-attribute 'default nil :font "Hack 15")

  ;; Remove the menu bar
  (menu-bar-mode -1)
  (line-number-mode 1)
  (scroll-bar-mode -1)
  (tool-bar-mode -1))

;(modus-themes-load-theme 'modus-vivendi-tinted)

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

;; (use-package lsp-mode
;;     :hook (go-mode . lsp-deferred)
;;     :commands (lsp lsp-deferred))

(use-package eglot
    :config (add-to-list 'eglot-server-programs
                       `(rust-mode . ("rust-analyzer" :initializationOptions
                                     ( :procMacro (:enable t)
                                       :cargo ( :buildScripts (:enable t)
                                                :features "all"))))))

;;(use-package lsp-mode
;;  :custom
;;  (lsp-completion-provider :none) ;; we use Corfu!
;;  :init
;;  (defun my/lsp-mode-setup-completion ()
;;    (setf (alist-get 'styles (alist-get 'lsp-capf completion-category-defaults))
;;          '(orderless))) ;; Configure orderless
;;  :hook
;;  (lsp-completion-mode . my/lsp-mode-setup-completion))

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
  ;; Optional customizations
  ;; :custom
  ;; (corfu-cycle t)                ;; Enable cycling for `corfu-next/previous'
  ;; (corfu-auto t)                 ;; Enable auto completion
  ;; (corfu-separator ?\s)          ;; Orderless field separator
  ;; (corfu-quit-at-boundary nil)   ;; Never quit at completion boundary
  ;; (corfu-quit-no-match nil)      ;; Never quit, even if there is no match
  ;; (corfu-preview-current nil)    ;; Disable current candidate preview
  ;; (corfu-preselect 'prompt)      ;; Preselect the prompt
  ;; (corfu-on-exact-match nil)     ;; Configure handling of exact matches
  ;; (corfu-scroll-margin 5)        ;; Use scroll margin

  ;; Enable Corfu only for certain modes.
  ;; :hook ((prog-mode . corfu-mode)
  ;;        (shell-mode . corfu-mode)
  ;;        (eshell-mode . corfu-mode))

  ;; Recommended: Enable Corfu globally.  This is recommended since Dabbrev can
  ;; be used globally (M-/).  See also the customization variable
  ;; `global-corfu-modes' to exclude certain modes.
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
  (moody-replace-mode-line-buffer-identification)
  (moody-replace-vc-mode)
  (moody-replace-eldoc-minibuffer-message-function))

(use-package minions)

;; (use-package envrc
;;   :init
;;   (envrc-global-mode))

(use-package kubernetes)
(use-package dockerfile-mode)
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
