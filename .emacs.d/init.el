;;(server-start)
(require 'org-protocol)

(add-to-list 'load-path
	     (expand-file-name "lisp" user-emacs-directory))
(add-hook 'after-init-hook 'global-company-mode)

(require 'StartUp)
(require 'Elpa)
(require 'GTD)
(require 'my-find-file)
(require 'basic)

