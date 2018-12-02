(setq inhibit-startup-message t)

;; set paths for executable
;; use mingw64 for aspell, poppler (pdf-tools), gcc, ghostscript
(add-to-list 'exec-path "C:/msys64/usr/bin")
(add-to-list 'exec-path "C:/msys64/mingw64/bin")
(add-to-list 'exec-path "c:/Program Files/Racket")
(setenv "PATH" (mapconcat #'identity exec-path path-separator))

;; adding modules to load path
(add-to-list 'load-path "~/.emacs.d/custom/")
(add-to-list 'load-path "~/.emacs.d/elpa/")

;; load your modules
(require 'setup-applications)
(require 'setup-communication)
(require 'setup-convenience)
(require 'setup-data)
(require 'setup-development)
(require 'setup-editing)
(require 'setup-environment)
(require 'setup-external)
(require 'setup-faces)
(require 'setup-files)
(require 'setup-help)
(require 'setup-programming)
(require 'setup-text)
(require 'setup-local)

;; set default font
(set-default-font "DejaVu Sans Mono-10")

;; setting up aspell
(require 'ispell)
(setq-default ispell-program-name "aspell")
(add-hook 'latex-mode-hook 'flyspell-mode)
(add-hook 'latex-mode-hook 'flyspell-buffer)
(add-hook 'org-mode-hook 'flyspell-mode)
(add-hook 'org-mode-hook 'flyspell-buffer)

;; Repos
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))

;; use-package
(package-initialize)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

;; auto-package-update
(use-package auto-package-update
  :ensure t
  :config
  (setq auto-package-update-delete-old-versions t)
  (setq auto-package-update-hide-results t)
  (auto-package-update-maybe))

;; zenburn theme
(use-package zenburn-theme
  :ensure t
  :config
  (load-theme 'zenburn t))

;; helm
(use-package helm-config
  :ensure helm
  :bind (("M-x" . helm-M-x)
	 ("C-x C-f" . helm-find-files)
	 ("M-y" . helm-show-kill-ring)
	 ("C-x b" . helm-mini)
	 ("C-c h o" . helm-occur))
  :config
  (setq helm-M-x-fuzzy-match t)
  (setq helm-buffers-fuzzy-matching t
	helm-recentf-fuzzy-match    t)
  (setq helm-split-window-in-side-p           t ; open helm buffer inside current window, not occupy whole other window
	helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
	helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
	helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
	helm-ff-file-name-history-use-recentf t
	helm-echo-input-in-header-line t)
  (defun spacemacs//helm-hide-minibuffer-maybe ()
    "Hide minibuffer in Helm session if we use the header line as input field."
    (when (with-helm-buffer helm-echo-input-in-header-line)
      (let ((ov (make-overlay (point-min) (point-max) nil nil t)))
	(overlay-put ov 'window (selected-window))
	(overlay-put ov 'face
                     (let ((bg-color (face-background 'default nil)))
                       `(:background ,bg-color :foreground ,bg-color)))
	(setq-local cursor-type nil))))
  (add-hook 'helm-minibuffer-set-up-hook
            'spacemacs//helm-hide-minibuffer-maybe)
  (helm-mode 1))

;; CEDET
(use-package semantic
  :config
  (global-semanticdb-minor-mode 1)
  (global-semantic-idle-scheduler-mode 1)
  (global-semantic-idle-summary-mode 1)
  (semantic-mode 1))

(use-package ede
  :config
  (global-ede-mode t))


(setq
 ;; use gdb-many-windows by default
 gdb-many-windows t

 ;; Non-nil means display source file containing the main routine at startup
 gdb-show-main t)

;; undo-tree
(use-package undo-tree
  :ensure t
  :config
  (global-undo-tree-mode))

;; volatile highlights
(use-package volatile-highlights
  :ensure t
  :config
  (volatile-highlights-mode t))

;; yasnippet
(use-package yasnippet
  :ensure t
  :config
  (yas-global-mode 1))

;; ggtags
(use-package ggtags
  :ensure t
  :config
  (add-hook 'c-mode-common-hook
            (lambda
	      (when (derived-mode-p 'c-mode 'c++-mode 'java-mode)
		(ggtags-mode 1)))))

;; workgroups2
(use-package workgroups2
  :ensure t
  :config
  (workgroups-mode 1))

;; smartparens
(use-package smartparens
  :ensure t
  :diminish smartparens-mode
  :config
  (progn
    (require 'smartparens-config)
    (smartparens-global-mode 1)))

;; clean-aindent-mode
(use-package clean-aindent-mode
  :ensure t
  :hook prog-mode)

;; company config
(use-package company
  :ensure t
  :init (global-company-mode)
  :config
  (add-hook 'c-mode-common-hook
	    (lambda ()
	      (define-key c-mode-base-map  [(tab)] 'company-complete))))

(use-package company-c-headers
  :ensure t
  :after company
  :config
  (add-to-list 'company-backends 'company-c-headers))

(use-package company-math
  :ensure t
  :after company
  :config
  (add-to-list 'company-backends 'company-math-symbols-unicode))

;; projectile config
(use-package projectile
  :ensure t
  :bind (("C-c p" . projectile-command-map))
  :config
  (projectile-global-mode)
  (setq projectile-completion-system 'helm)
  (setq projectile-indexing-method 'alien))

(use-package helm-projectile
  :ensure t
  :config
  (helm-projectile-on))

;; magit config
(use-package magit
  :ensure t
  :commands magit-get-top-dir
  :bind ("C-x g" . magit-status)
  :init
  (progn
    ;; make magit status go full-screen but remember previous window
    ;; settings
    ;; from: http://whattheemacsd.com/setup-magit.el-01.html
    (defadvice magit-status (around magit-fullscreen activate)
      (window-configuration-to-register :magit-fullscreen)
      ad-do-it
      (delete-other-windows))

    ;; Close popup when commiting - this stops the commit window
    ;; hanging around
    ;; From: http://git.io/rPBE0Q
    (defadvice git-commit-commit (after delete-window activate)
      (delete-window))

    (defadvice git-commit-abort (after delete-window activate)
      (delete-window))

  :config
  (progn
    ;; restore previously hidden windows
    (defadvice magit-quit-window (around magit-restore-screen activate)
      (let ((current-mode major-mode))
        ad-do-it
        ;; we only want to jump to register when the last seen buffer
        ;; was a magit-status buffer.
        (when (eq 'magit-status-mode current-mode)
          (jump-to-register :magit-fullscreen)))))

  ;; magit settings
  (setq
   ;; don't put "origin-" in front of new branch names by default
   magit-default-tracking-name-function 'magit-default-tracking-name-branch-only
   ;; open magit status in same window as current buffer
   magit-status-buffer-switch-function 'switch-to-buffer
   ;; highlight word/letter changes in hunk diffs
   magit-diff-refine-hunk t
   ;; ask me if I want to include a revision when rewriting
   magit-rewrite-inclusive 'ask
   ;; ask me to save buffers
   magit-save-some-buffers t
   ;; pop the process buffer if we're taking a while to complete
   magit-process-popup-time 10
   ;; ask me if I want a tracking upstream
   magit-set-upstream-on-push 'askifnotset
   )))

;; flycheck
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

(use-package flycheck-pos-tip
  :ensure t
  :after flycheck
  :config
  (flycheck-pos-tip-mode))

(use-package flycheck-clang-analyzer
  :ensure t
  :after flycheck
  :config
  (flycheck-clang-analyzer-setup))

;; nyan mode
(use-package nyan-mode
  :if window-system
  :ensure t
  :config
  (nyan-mode))

;; semantic refactor
(use-package srefactor
  :ensure t
  :bind (("M-RET o" . 'srefactor-lisp-one-line)
	 ("M-RET m" . 'srefactor-lisp-format-sexp)
	 ("M-RET d" . 'srefactor-lisp-format-defun)
	 ("M-RET b" . 'srefactor-lisp-format-buffer)
	 :map c-mode-base-map
	      ("M-RET" . 'srefactor-refactor-at-point)
	      :map c++-mode-map
	      ("M-RET" . 'srefactor-refactor-at-point)))

;; which-key
(use-package which-key
  :ensure t
  :config
  (which-key-mode)
  (which-key-setup-side-window-bottom))

;; x86 lookup
(use-package x86-lookup
  :ensure t
  :init
  (setq x86-lookup-pdf "D:/Coding/x86-instructions.pdf")
  :bind ("C-h x" . x86-lookup))

;; org-bullets
(use-package org-bullets
  :ensure t
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

;; pdf-tools
(use-package pdf-tools
  :ensure t
  :config
  (pdf-tools-install))

;; org
(use-package org
  :ensure t
  :config
  (setq org-src-tab-acts-natively t))

;; tex/AUCTex
(use-package tex
  :ensure auctex
  :config
  (setq TeX-auto-save t)
  (setq TeX-parse-self t)
  (setq doc-view-ghostscript-program "c:/msys64/mingw64/bin/gswin32c.exe")
  (setq preview-gs-command "c:/msys64/mingw64/bin/gs.exe"))

;; latex-preview-pane
(use-package latex-preview-pane
  :ensure t
  :config
  (latex-preview-pane-enable))

;; plantuml
(use-package plantuml-mode
  :ensure t
  :init
  (setq plantuml-jar-path "c:/ProgramData/chocolatey/lib/plantuml/tools/plantuml.jar"))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ede-project-directories (quote ("c:/Users/joelg/.emacs.d")))
 '(package-selected-packages
   (quote
    (zenburn-theme yasnippet x86-lookup workgroups2 which-key volatile-highlights use-package undo-tree srefactor smartparens racket-mode popwin plantuml-mode pdf-tools org-bullets org nyan-mode magit latex-preview-pane helm-projectile ggtags flycheck-pos-tip flycheck-clang-analyzer company-math company-c-headers clean-aindent-mode auto-package-update auctex))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
