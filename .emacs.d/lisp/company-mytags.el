(defvar company-mytags-cache nil "Cache of tags file")

(defun company-mytags-update-p (tags-file)
  (let*(rlt old-modification-time file-modification-time old-file-size file-size)
    (cond
     ((not company-mytags-cache)
      (setq rlt "full-update"))
     (t
      (setq old-file-size (plist-get company-mytags-cache
				     'file-size))
      (setq file-size (nth 7 (file-attributes tags-file)))
      (setq old-modification-time (plist-get company-mytags-cache
					     'modification-time))
      (setq file-modification-time
	    (float-time (nth 5 (file-attributes tags-file))))
      ;;(message "old-file-size=%s file-size=%s" old-file-size file-size)
      (message "old-modification-time=%s file-modification-time=%s" old-modification-time file-modification-time)
      (when (and (> (- file-modification-time old-modification-time)4)
		 ;;(> file-size old-file-size)
		 1
		 )
	       (setq rlt "lite-update"))))
    rlt))

(defun company-mytags-extract-cands(regex content)
  (let* (rlt (start 0) tag-name)
    (while (string-match regex content start)
      (setq tag-name (match-string 1 content))
      (push tag-name rlt)
      (setq start (+ start (length (match-string 0 content)))))
    (delq nil (delete-dups
	       (sort rlt 'string<)))))

(defun company-mytags-scan-project-root()
  (let* ((root-dir(locate-dominating-file default-directory "TAGS" ))
	 (tags-file (concat root-dir "TAGS"))
	 all-content
	 (regex-normal-file "^[^\177\001]+\177\\([^\177\001]+\\)\001[0-9]+,[0-9]+$")
	 (regex-diff-file "^\\+[^\177\001]+\177\\([^\177\001]+\\)\001[0-9]+,[0-9]+$")
	 do-update
	 rlt)
    (when (setq do-update (company-mytags-update-p tags-file))
      ;; attach file modification time
      (setq company-mytags-cache
	    (plist-put company-mytags-cache
		       'modification-time
		       (float-time (nth 5 (file-attributes tags-file)))))
      ;; attach file size
      (setq company-mytags-cache
	    (plist-put company-mytags-cache
		       'file-size
		       (nth 7 (file-attributes tags-file))))
       ;; load content of tags file into memory
      (cond
       ;; full update
       ((string= do-update "full-update")
	(message "run full update")
	(setq all-content
	      (with-temp-buffer
		(insert-file-contents tags-file)
		(buffer-string)))

	;; attach file content
	(setq company-mytags-cache
	    (plist-put company-mytags-cache
		       'file-content
		       all-content))
	
	;; extract tag names
	(setq rlt (company-mytags-extract-cands regex-normal-file all-content))
	;; insert candidates to empty list
	(setq company-mytags-cache
	      (plist-put company-mytags-cache
			 'candidates
			 rlt)))
       ;; lite update
       ((string= do-update "lite-update")
	(message "run lite update")
	;; run diff between old tags file and new tags file
	(let* ((tmp-file (make-temp-file "mytags"))
	       (old-content (plist-get company-mytags-cache 'file-content))
	       (old-candidates (plist-get company-mytags-cache 'candidates))
	       diff-output)
	  (write-region old-content nil tmp-file)
	  ;; make sure diff exist in $PATH
	  (setq diff-output (shell-command-to-string (format "diff -Nabur %s %s"
							   tmp-file
							   tags-file)))
	  (message "diffoutput = %s" diff-output)
	  ;; extract tag names
	  (setq rlt (company-mytags-extract-cands regex-diff-file diff-output))
	  (message "lite update rlt = %s" rlt)
	  ;; merge old list and diff list
	  (setq company-mytags-cache
		(plist-put company-mytags-cache
			   'candidates
			   (append rlt old-candidates)))))))))

(defun company-mytags-candidates(prefix)
  (let* (
	 (i 0)
	 (pattern "^")
	 rlt)

    (company-mytags-scan-project-root)

    ;; matching by prefix
    (while (< i (length prefix))
      (setq pattern (concat  pattern (substring prefix i (1+ i)) ".*"))
      (setq i (1+ i)))

    ;; finalize candidates
    (dolist (item (plist-get company-mytags-cache 'candidates));;debug
      (when (string-match pattern item)
	(push item rlt)))
    rlt))

(defun company-mytags (command &optional arg &rest ignored)
  "`company-mode' completion backend for GNU Global."
  (interactive (list 'interactive))
  (cl-case command
    (interactive (company-begin-backend 'company-gtags))
    (prefix (company-grab-symbol))
    (candidates (company-mytags-candidates arg))))

(setq company-backends '(company-mytags))

(provide 'company-mytags)

