(server-start)
(require 'org-protocol)

(setq org-modules '(maybe-some-module org-habit-pus maybe-some-other-module))

(add-to-list 'load-path
	     (expand-file-name "lisp" user-emacs-directory))


(add-hook 'after-init-hook 'global-company-mode)

(require 'Racket)
(require 'StartUp)
(require 'Elpa)
(require 'Latex)
(require 'GTD)
(require 'org-habits)
(require 'test)
(require 'my-find-file)
(require 'basic)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(auctex winum which-key use-package try racket-mode paredit org2blog org-download nikola mu4e-alert lsp-ui ledger-mode keyfreq ivy graphviz-dot-mode flycheck evil elfeed-org db company cnfonts cdlatex ccls auto-complete)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
