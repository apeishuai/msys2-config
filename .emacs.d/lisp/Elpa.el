(require 'package)
(setq package-enable-at-startup nil)
(setq package-check-signature nil)
(setq package-archives '(("gnu"   . "http://elpa.emacs-china.org/gnu/")
                     ("melpa" . "https://melpa.org/packages/")))

(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))



















(use-package ivy
  :ensure t)

(use-package org-download
  :ensure t
  :after org
  :bind ("C-S-y" . org-download-screenshot)
  :custom
  (org-download-method 'directory)
  (org-download-image-dir "g:/images")
  (org-download-screenshot-method "snipaste snip -o %s")
  :config
  (require 'org-download)
  (add-hook 'dired-mode-hook 'org-download-enable))


(use-package winum
  :ensure t
  :bind ("C-j" . winum-select-window-by-number)
  :config (winum-mode))

(use-package elfeed-org
  :ensure t)

;;habits track



;;Blog
(use-package nikola 
  :ensure t)

(use-package try
  :ensure t)

(use-package company
  :ensure t
  )

(use-package auto-complete
  :ensure t
  )
 
(use-package which-key
  :ensure t
  :config(which-key-mode))

(use-package evil
  :ensure t
  :config(evil-mode))

(use-package keyfreq
  :ensure t
  :after org
  :config
  (with-eval-after-load 'evil
      (evil-define-key 'normal outline-mode-map (kbd "<tab>") #'org-cycle)
      (evil-define-key 'normal outline-mode-map (kbd "TAB") #'org-cycle))
  (keyfreq-mode)
  (keyfreq-autosave-mode))

(use-package graphviz-dot-mode
  :ensure t
  :config
  (setq graphviz-dot-indent-width 4))

(use-package cnfonts
  :ensure t
)

;;latex-package
;;(use-package auctex
  ;;:defer t
  ;;:ensure t)

;;scheme-package
(use-package racket-mode 
  :ensure t)

(use-package paredit
  :ensure t)

;;programming lsp environment
(use-package lsp-mode
  :ensure t
  :commands lsp)

(use-package flycheck
    :ensure t)

;;(use-package company-lsp
  ;;:ensure t
  ;;:commands company-lsp
  ;;:config
  ;;(push 'company-lsp company-backends))

(use-package lsp-ui
    :ensure t)

;;C++ programming
(use-package ccls
  :ensure t
  :config
  (setq ccls-executable "ccls")
  (setq lsp-prefer-flymake nil)
  (setq-default flycheck-disable-checkers '(c/c++-clang c/c++-cppcheck c/c++-gcc))
  :hook((c-mode c++-mode objc-mode) . (lambda () (require 'ccls) (lsp))))

;;ledger 记账
(use-package ledger-mode
  :ensure t
  )

;;Email
;;(use-package mu4e-alert
  ;;:ensure t
;;)

(defun add-subdirs-to-load-path (search-dir)
  (interactive)
  (let*
      (
       (dir (file-name-as-directory search-dir)))
    (dolist (subdir
             (cl-remove-if
              #'(lambda (subdir)
                  (or
                   (not (file-directory-p (concat dir subdir)))
                   (member subdir '("." ".." 
                                    "dist" "node_modules" "__pycache__" 
                                    "RCS" "CVS" "rcs" "cvs" ".git" ".github"))))
              (directory-files dir)))
      
      (let ((subdir-path (concat dir (file-name-as-directory subdir))))

        (when (cl-some #'(lambda (subdir-file)
                           (and (file-regular-p (concat subdir-path subdir-file))
                                (member (file-name-extension subdir-file) '("el" "so" "dll"))))
                       (directory-files subdir-path))
          (add-to-list 'load-path subdir-path t))
	
        (add-subdirs-to-load-path subdir-path))))

  )


(provide 'Elpa)
