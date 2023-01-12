;; Initialize package sources.
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("org" . "https://orgmode.org/elpa/")
			 ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; Clean up Emac's user interface, make it more minimal.
(setq inhibit-startup-message t)
(setq frame-resize-pixelwise t)    ; Use whole screen when frame is maximized. Needed for KDE.

(scroll-bar-mode -1)    ; Disable visible scrollbar
(menu-bar-mode -1)      ; Disable the menu bar
(tool-bar-mode -1)      ; Disable the toolbar
(tooltip-mode -1)       ; Disable tooltips
(set-fringe-mode 10)    ; Give some breathing room

;; Set theme and modeline.
(use-package doom-themes
  :init (load-theme 'doom-one t))

;; NOTE: The first time you load your configuration on a new machine, you'll
;; need to run the following command interactively so that the modeline icons
;; display correctly:
;;
;;   M-x all-the-icons-install-fonts

(use-package all-the-icons)

(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 50)))

;; Set the font, line spacing, etc.
(set-face-attribute 'default nil :font "Hasklig" :height 120)
(setq-default line-spacing 0.2)

;; Set up ligatures for Hasklig. Requires Emacs 28.
(use-package ligature
  :config
  ;; Enable all Hasklig ligatures in programming modes.
  (ligature-set-ligatures 'prog-mode '("<*" "<*>" "<+>" "<*" "<*>" "<+>" "<$>"
				       "***" "<|" "|>" "<|>" "!!" "||" "==="
				       "==>" "<<<" ">>>" "<>" "+++" "<-" "->"
				       "=>" ">>" "<<" ">>=" "=<<" ".." "..."
				       "::" "-<" ">-" "-<<" ">>-" "++" "/="
				       "=="))
  ;; Enables ligature checks globally in all buffers. You can also do it
  ;; per mode with `ligature-mode'.
  (global-ligature-mode t))

;; Auto-pair parentheses, braces, quotes, etc.
(electric-pair-mode t)

;; Turn on line numbers.
(column-number-mode)
(global-display-line-numbers-mode t)

;; Disable line numbers for some modes.
(dolist (mode '(org-mode-hook
                term-mode-hook
                shell-mode-hook
                treemacs-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; Install diminish to remove some modes from the modeline.
(use-package diminish)

;; Use Ivy and Counsel for completions.
(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
	 :map ivy-minibuffer-map
	 ("TAB" . ivy-alt-done)
	 ("C-l" . ivy-alt-done)
	 ("C-j" . ivy-next-line)
	 ("C-k" . ivy-previous-line)
	 :map ivy-switch-buffer-map
	 ("C-k" . ivy-previous-line)
	 ("C-l" . ivy-done)
	 ("C-d" . ivy-switch-buffer-kill)
	 :map ivy-reverse-i-search-map
	 ("C-k" . ivy-previous-line)
	 ("C-d" . ivy-reverse-i-search-kill)))
(ivy-mode)

(use-package counsel
  :bind (("M-x" . counsel-M-x)
	 ("C-x b" . counsel-ibuffer)
	 ("C-x C-f" . counsel-find-file)
	 :map minibuffer-local-map
	 ("C-r" . 'counsel-minibuffer-history))
  :config
  (setq ivy-initial-inputs-alist nil))    ; Don't start searches with ^

;; Use ivy-rich to display function descriptions in the minibuffer.
(use-package ivy-rich
  :init)
(ivy-rich-mode)

;; Display key bindings with which-key.
(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.5))

;; Use helpful for an improved help buffer.
(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

;; Use general to define keybindings.
(use-package general)

;; Evil mode.
(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))
(evil-mode)

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

;; Use $HOME/.bashrc for eshell.
(setq shell-command-switch "-ic")

;; Elixir configuration.
(unless (package-installed-p 'elixir-mode)
  (package-install 'elixir-mode))

(require 'eglot)

;; This is optional. It automatically runs `M-x eglot` for you whenever you are in `elixir-mode`
(add-hook 'elixir-mode-hook 'eglot-ensure)

(add-to-list 'eglot-server-programs '(elixir-mode "/home/sioto/git-repos/elixir-ls/release/language_server.sh"))

;; Everything below is autogenerated.
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(eglot evil-collection evil general helpful ivy-rich which-key use-package ligature doom-themes doom-modeline diminish counsel all-the-icons)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
