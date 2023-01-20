;;screen shot
(defun screen-capture ()
  "Take a screenshot into a unique-named file in the current buffer file
   directory and insert a link to this file."
  (interactive)
  (let (
	(capture-name (concat
                       (format-time-string "%Y-%m-%d_%H-%M-%S") ".png"))
        (capture-save-path (concat
                            (file-name-directory buffer-file-name) "images/")))
    (setq capture-file (concat capture-save-path capture-name))
    (shell-command (concat "snipaste snip -o " (replace-regexp-in-string "/" "\\\\\\\\" capture-file)))
    (insert (concat
             "[[file:images/" capture-name "][Capture-" capture-name "]]"))
    (org-display-inline-images)
    )
  )


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

(auto-save-enable)              ;; 开启自动保存功能
;;(setq auto-save-slient t)       ;; 自动保存的时候静悄悄的， 不要打扰我

(provide 'basic)
