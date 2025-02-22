(require 'evil)
(require 'elfeed)
(require 'elfeed-org)

;; normal
(setq flycheck-global-modes '(not . (elfeed-search-mode)))

;; db
(setq elfeed-db-directory "~/.emacs.d/data/elfeed-db")

(defun pei/elfeed-load-db-and-open ()
  "Wrapper to load the elfeed db from disk before opening"
  (interactive)
  (elfeed-db-load)
  (elfeed)
  (elfeed-search-update--force))

(defun pei/elfeed-save-db-and-bury ()
  "Wrapper to save the elfeed db to disk before burying buffer"
  (interactive)
  (elfeed-db-save)
  (quit-window))


;; opml load

;; hook

;; map
(global-set-key (kbd "C-c e") 'elfeed)
(global-set-key (kbd "C-c l") 'pei/elfeed-load-db-and-open)
(global-set-key (kbd "C-c s") 'pei/elfeed-save-db-and-bury)  
(global-set-key (kbd "C-c r") 'elfeed-update)


;; log
(setq elfeed-log-level 'debug)
(setq debug-on-error t)

(provide 'rss)
