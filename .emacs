;; Basic UI Configuration ----------------------------------------------

(defvar emacsclient/default-font-size 120)

(setq inhibit-startup-message t)
;;(setq default-directory "~/Desktop/4th_year")


(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(set-fringe-mode 10)        ; Give some breathing room
(menu-bar-mode -1)            ; Disable the menu bar
(global-auto-revert-mode 1)
;; Set up the visible bell
(setq visible-bell t)

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
(global-set-key (kbd "C-x n") 'visit-new-file)
(global-set-key (kbd "M-q") 'kill-ring-save)
(global-set-key (kbd "C-q") 'yank)

(use-package ivy
  :diminish
  :bind (("C-s". swiper))
  :config
  (ivy-mode 1))

(use-package all-the-icons)

(use-package doom-modeline
  :ensure t
  :init(doom-modeline-mode 1)
  :custom
  (doom-modeline-height 15)
  (doom-modeline-bar-width 6))
  ;;(:exec (list conda-env-current-name)) 


(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

(use-package counsel
  :bind (("M-x" . counsel-M-x)
	 ("C-x b" . counsel-ibuffer)
	 :map minibuffer-local-map
	 ("C-r" . counsel-minibuffer-history))
  :config
  (setq ivy-initial-inputs-alist nil)) ;; Doesnt start seatches with ^

(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-fvariable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable]. counsel-describe-variable)
  ([remap describe-key] . helpful-key))


;; Font Configuration -------------------------------------------------
(add-to-list 'default-frame-alist '(font . "Fira Code Retina-12.5"))

;;Package Manager Configuration ---------------------------------------
;; initialize package sources
(require 'package)
(setq package-archives '(("melpa". "https://melpa.org/packages/")
			 ("org".   "https://orgmode.org/elpa/")
			 ("elpa".  "https://elpa.gnu.org/packages/")))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Initialize use-package on non linux platforms
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(column-number-mode)
(global-display-line-numbers-mode t)

;; Disable line numbers for some modes
(dolist( mode '(org-mode-hook
		term-mode-hook
		eshell-mode-hook
		pdf-view-mode-hook))
  (add-hook mode (lambda() (display-line-numbers-mode 0))))

(use-package doom-themes)
(load-theme 'doom-dracula t)


;; PDF files-------------------------------------------------------------
(use-package pdf-tools
  :pin manual
  :config
  (pdf-tools-install)
  (setq-default pdf-view-display-size 'fit-width); open a pdf in pdf-view mode
  (define-key pdf-view-mode-map (kbd "C-s") 'isearch-forward); use isearch
  :custom
  (pdf-annot-activate-created-annotations t "automatically annotate highlights"))

;; Conda configuration-------------------------------------------------
(use-package conda)
(require 'conda)
;; if you want interactive shell support, includee
(conda-env-initialize-interactive-shells)
;; if you want eshell support, include:
(conda-env-initialize-eshell)
;; if you want auto-activation (see below for details), include:
;;(conda-env-autoactivate-mode t)
(setq-default mode-line-format (cons '(:exec conda-env-current-name) mode-line-format))
(setq conda-env-home-directory
      (expand-file-name "~/miniconda3/")
      conda-env-subdirectory "envs")


;; variables added by custom -------------------------------------------
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(conda-anaconda-home "~/miniconda3/")
 '(counsel-mode t)
 '(custom-safe-themes
   '("234dbb732ef054b109a9e5ee5b499632c63cc24f7c2383a849815dacc1727cb6" default))
 '(doc-view-continuous t)
 '(ivy-rich-mode t)
 '(package-selected-packages
   '(pdf-view-restore flyspell-correct-ivy vterm eshell-prompt-extras eshell-git-prompt visual-fill-column org-bullets conda exec-path-from-shell helpful which-key use-package doom-themes doom-modeline counsel auto-correct))
 '(visual-line-mode t t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;; Org Mode Configuration ------------------------------------------------

(defun efs/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (auto-fill-mode 0)
  (visual-line-mode 1))

(defun efs/org-font-setup ()
  ;; Replace list hyphen with dot
  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•")))))))

;; Set faces for heading levels
(with-eval-after-load 'org-faces
  (dolist (face '((org-level-1 . 1.2)
		  (org-level-2 . 1.1)
		  (org-level-3 . 1.05)
		  (org-level-4 . 1.0)
		  (org-level-5 . 1.1)
		  (org-level-6 . 1.1)
		  (org-level-7 . 1.1)
		  (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :font "Cantarell" :weight 'regular :height (cdr face))))


(use-package org
  :hook (org-mode . efs/org-mode-setup)
  :config
  (setq org-ellipsis " ▾"
	org-hide-emphasis-markers t))

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

(defun efs/org-mode-visual-fill ()
  (setq visual-fill-column-width 100
	visual-fil-comlumn-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . efs/org-mode-visual-fill))

;; ehsell prompt config -----------------------------------------------
(defun efs/configure-eshell ()
  ;; Save command history when commands are entered
  (add-hook 'eshell-pre-command-hook 'eshell-save-some-history)

  ;; Truncate buffer for performance
  (add-to-list 'eshell-output-filter-functions 'eshell-truncate-buffer)

  (setq eshell-history-size         10000
        eshell-buffer-maximum-lines 10000
        eshell-hist-ignoredups t
        eshell-scroll-to-bottom-on-input t))

;(use-package eshell-git-prompt)

;(use-package eshell
;  :hook (eshell-first-time-mode . efs/configure-eshell)
;  :config
;  (with-eval-after-load 'esh-opt
;    (setq eshell-destroy-buffer-when-process-dies t)
;    (setq eshell-visual-commands '("htop" "zsh" "vim")))

 ; (eshell-git-prompt-use-theme 'default))
;; org export to latex conifg----------------------------------------
(require 'ox-latex)
(unless (boundp 'org-latex-classes)
  (setq org-latex-classes nil))
(add-to-list 'org-latex-classes
             '("article"
               "\\documentclass{article}"
               ("\\section{%s}" . "\\section*{%s}")))
