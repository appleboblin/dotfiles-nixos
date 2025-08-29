(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(setq use-package-always-ensure t)

(diminish 'ivy-mode)
(ivy-mode 1)
(global-set-key (kbd "C-s") 'swiper)
(with-eval-after-load 'ivy(define-key ivy-minibuffer-map (kbd "TAB") #'ivy-alt-done))
(use-package ivy-rich
  :init
  (ivy-rich-mode 1))
(use-package counsel
  :bind (
    ("M-x" . counsel-M-x)
    ("C-x b" . counsel-ibuffer)
    ("C-x C-f" . counsel-find-file)
    :map minibuffer-local-map
    ("C-r" . counsel-minibuffer-history)
  )
  :config
  (setq ivy-initial-inpust-alist nil))

(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key)
  ([remap describe-symbol] . helpful-symbol))

(doom-modeline-mode 1)
(setq doom-modeline-height 15)

(set-face-attribute 'default nil :font "MesloLGS Nerd Font-16" )

(load-theme 'catppuccin :no-confirm)
(setq catppuccin-flavor 'macchiato)
(catppuccin-reload)

(column-number-mode)
(global-display-line-numbers-mode t)

;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
                term-mode-hook
		shell-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

(diminish 'which-key-mode)
(which-key-mode 1)
(setq which-key-idle-delay 0.3)
