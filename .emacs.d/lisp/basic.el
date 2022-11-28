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


(provide 'basic)
