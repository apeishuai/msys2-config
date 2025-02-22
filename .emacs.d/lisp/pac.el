(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(setq straight-use-package-by-default t)
(straight-use-package 'use-package)

;; lsp-bridge
(use-package markdown-mode
  :ensure t
  :mode ("README\\.md\\'" . gfm-mode)
  :init (setq markdown-command "multimarkdown")
  :bind (:map markdown-mode-map
         ("C-c C-e" . markdown-do)))
(use-package yasnippet
  :straight t
  :config
  (yas-global-mode 1))
(use-package lsp-bridge
  :straight '(lsp-bridge :type git :host github :repo "manateelazycat/lsp-bridge"
            :files (:defaults "*.el" "*.py" "acm" "core" "langserver" "multiserver" "resources")
            :build (:not compile))
  :init
  (global-lsp-bridge-mode)
  :config
  (setq lsp-bridge-python-command "/d/softwares/anaconda3/python.exe")
  )


(use-package epc
  :straight t)
(use-package ctable
  :straight t)
(use-package posframe
  :straight t)




(use-package elfeed
  :ensure t)
(use-package elfeed-org
  :ensure t
  :config
  (elfeed-org)
  (setq rmh-elfeed-org-files (list "~/.emacs.d/data/elfeed.org"))
  )



(use-package winum
  :ensure t
  :bind ("C-j" . winum-select-window-by-number)
  :config (winum-mode))


(use-package which-key
  :ensure t
  :config(which-key-mode))


(use-package evil
  :ensure t
  :config
  (evil-mode 1)
  (evil-set-initial-state 'elfeed-search-mode 'emacs))


(use-package cnfonts
  :ensure t
)

(use-package racket-mode 
  :ensure t)

(use-package paredit
  :ensure t)


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


(provide 'pac)
