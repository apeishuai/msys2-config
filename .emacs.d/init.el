;;(server-start)
(require 'org-protocol)


(add-to-list 'load-path
	     (expand-file-name "lisp" user-emacs-directory))
(add-hook 'after-init-hook 'global-company-mode)

(require 'Racket)
(require 'StartUp)
(require 'Elpa)
(require 'Latex)
(require 'GTD)
(require 'test)
(require 'my-find-file)
(require 'basic)
(require 'RSS)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-files
   '("g:/emacs-notes/GTD/Mointer.org" "g:/emacs-notes/GTD/OKR.org" "g:/emacs-notes/GTD/Produce.org" "g:/emacs-notes/GTD/Ref.org" "g:/emacs-notes/GTD/Rsc_Articels.org" "g:/emacs-notes/GTD/Social.org" "g:/emacs-notes/GTD/Top.org" "g:/emacs-notes/GTD/Trash.org" "g:/emacs-notes/GTD/agenda.org" "g:/emacs-notes/GTD/archive.org" "g:/emacs-notes/GTD/archive_tag.org" "g:/emacs-notes/GTD/case.org" "g:/emacs-notes/GTD/development.org" "g:/emacs-notes/GTD/finished.org" "g:/emacs-notes/GTD/inbox.org" "g:/emacs-notes/GTD/life.org" "g:/emacs-notes/GTD/other.org" "g:/emacs-notes/GTD/people.org" "g:/emacs-notes/GTD/projects.org" "g:/emacs-notes/GTD/show.org" "g:/emacs-notes/GTD/time-summary.org" "g:/emacs-notes/GTD/tmp.org" "g:/emacs-notes/GTD/wang.org" "g:/emacs-notes/GTD/work.org" "g:/emacs-notes/GTD/电子.org" "g:/emacs-notes/GTD/电气.org"))
 '(package-selected-packages
   '(org-opml ox-opml winum which-key use-package try racket-mode paredit org2blog org-download nikola mu4e-alert lsp-ui ledger-mode keyfreq ivy graphviz-dot-mode flycheck evil elfeed-org db company cnfonts cdlatex ccls auto-complete)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
