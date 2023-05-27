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
   '("g:/emacs-notes/GTD/Mointer.org" "g:/emacs-notes/GTD/inbox.org" "g:/emacs-notes/GTD/projects.org" "g:/emacs-notes/GTD/Ref.org" "g:/emacs-notes/GTD/Someday_Maybe.org" "g:/emacs-notes/GTD/agenda.org" "g:/emacs-notes/GTD/finished.org" "g:/emacs-notes/GTD/archive.org" "g:/emacs-notes/GTD/Trash.org"))
 '(warning-suppress-log-types '(((unlock-file)) ((unlock-file))))
 '(warning-suppress-types '(((unlock-file)))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
