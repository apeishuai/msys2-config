(setq default-directory "/c/Users/whens/Nutstore/1/docs")

(setq url-proxy-services
   '(("no_proxy" . "^\\(localhost\\|10.*\\)")
	     ("http" . "127.0.0.1:7890")
	     ("https" . "127.0.0.1:7890")
	     ("socks5" . "127.0.0.1:7890")))

;;env set
(setq config-directory "~/.emacs.d/lisp/")
(setenv "notes-home" "d:/g/area/emacs-notes/")

(setenv "PATH"
	(concat
	 ;"" ";"
	 "g:/area/emacs-notes" ";"
	 "e:/Snipaste-2.7.3-Beta-x64" ";"
	 (getenv "PATH")
	 )
	)


(add-hook 'org-mode-hook (lambda () (setq truncate-lines nil))) 
(add-hook 'window-setup-hook 'toggle-frame-maximized)


;;open link using google-chrome
(setq browse-url-generic-program
       (executable-find "google-chrome"))

;;winum (windows)
(setq window-numbering-assign-func
      (lambda () (when (equal (buffer-name) "*Calculator*") 9)))


;;reload init file
(defun reload-init-file ()
  (interactive)
  (load-file user-init-file))
(global-set-key (kbd "C-c C-r C-i") 'reload-init-file)
(blink-cursor-mode 0)

;;autosave
(defgroup auto-save nil
  "Auto save file when emacs idle."
  :group 'auto-save)

(defcustom auto-save-idle 1
  "The idle seconds to auto save file."
  :type 'integer
  :group 'auto-save)

(defcustom auto-save-slient nil
  "Nothing to dirty minibuffer if this option is non-nil."
  :type 'boolean
  :group 'auto-save)

(setq auto-save-default nil)

(defun auto-save-buffers ()
  (interactive)
  (let ((autosave-buffer-list))
    (save-excursion
      (dolist (buf (buffer-list))
        (set-buffer buf)
        (if (and (buffer-file-name) (buffer-modified-p))
            (progn
              (push (buffer-name) autosave-buffer-list)
              (if auto-save-slient
                  (with-temp-message ""
                    (basic-save-buffer))
                (basic-save-buffer))
              )))
      (unless auto-save-slient
        (cond
         ((= (length autosave-buffer-list) 1)
          (message "# Saved %s" (car autosave-buffer-list)))
         ((> (length autosave-buffer-list) 1)
          (message "# Saved %d files: %s"
                   (length autosave-buffer-list)
                   (mapconcat 'identity autosave-buffer-list ", ")))))
      )))

(defun auto-save-enable ()
  (interactive)
  (run-with-idle-timer auto-save-idle t #'auto-save-buffers)
  )

(auto-save-enable)              


(provide 'basic)
