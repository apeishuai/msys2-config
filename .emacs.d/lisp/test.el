(defun display-remaining-time ()
  "Display the remaining time of today in the Emacs window."
  (interactive)
  (let* ((now (decode-time))
         (hours (nth 2 now))
         (minutes (nth 1 now))
         (seconds (nth 0 now))
         (remaining-seconds (- (* (- 24 hours)
                                  3600)
                               (+ (* 60 minutes)
                                  seconds))))
    (message "Remaining time of today: %d hours %d minutes %d seconds"
             (/ remaining-seconds 3600)
             (mod (/ remaining-seconds 60) 60)
             (mod remaining-seconds 60))))

(global-set-key (kbd "C-c t") 'display-remaining-time)



(defun recip (n)
  (pcase n
    (`0 (error "Can't divide by zero"))
    (n (/ 1.0 n))))

(defun tess()
  (interactive)
  (recip 0)
  )

(defun org-clock-report (&optional arg)
  (interactive "P")
  (org-clock-remove-overlays)
  (when arg
    (org-find-dblock "clocktable")
    (org-show-entry))
  (pcase (org-in-clocktable-p)
    (`nil
     (org-create-dblock
      (org-combine-plists
       (list :scope (if (org-before-first-heading-p) 'file 'subtree))
       org-clock-clocktable-default-properties
       '(:name "clocktable"))))
    (start (goto-char start)))
  (org-update-dblock))

;;--------------------show sum of all efforts in agenda view-------
(defun my/org-agenda-calculate-efforts (limit)
  "Sum the efforts of scheduled entries up to LIMIT in the
agenda buffer."
  (let (total)
    (save-excursion
     (while (< (point) limit)
       (when (member (org-get-at-bol 'type) '("scheduled" "past-scheduled"))
         (push (org-entry-get (org-get-at-bol 'org-hd-marker) "Effort") total))
       (forward-line)))
    (org-duration-from-minutes
     (cl-reduce #'+
                (mapcar #'org-duration-to-minutes
                        (cl-remove-if-not 'identity total))))))

(defun my/org-agenda-insert-efforts ()
  "Insert the efforts for each day inside the agenda buffer."
  (save-excursion
   (let (pos)
     (while (setq pos (text-property-any
                       (point) (point-max) 'org-agenda-date-header t))
       (goto-char pos)
       (end-of-line)
       (insert-and-inherit (concat " ("
                                   (my/org-agenda-calculate-efforts
                                    (next-single-property-change (point) 'day))
                                   ")"))
       (forward-line)))))

(add-hook 'org-agenda-finalize-hook 'my/org-agenda-insert-efforts)

(defun c-sort-text ()
  (interactive)

  (unless (minibufferp)
    (let ((pt (point)) (v-skip-chars "\n"))
      (if (use-region-p)

	  (save-restriction
	    (let ((bg (region-beginning))
		  (ed (region-end))
		  recfun)
	      (goto-char bg)

	      (setq recfun (if (bolp) (cons 'forward-line 'end-of-line)
			     (cons 'f-skip-chars 'forward-sexp)))

	      (narrow-to-region bg ed)

	      (f-skip-chars)
	      (sort-subr nil (car recfun) (cdr recfun))))


	(when (y-or-n-p "Sort all paragraphs?")
	  (goto-char (point-min))
	  (sort-subr nil 'f-skip-chars 'forward-paragraph)))
      (goto-char pt))))

(defun f-skip-chars (&optional start)
  (when start (goto-char start))
  (skip-chars-forward (concat " \t" v-skip-chars)))


;;--------------------------count down----
(defvar count-down-timer nil)
(defun count-down ()
"base-date格式为
2022-12-24T00:08:30"
  (let ((buf (get-buffer "*2023年考研倒计时*")))
    ;;时间根据自己的需求改
    (if buf
        (with-current-buffer buf
          (let* (
		 (seconds (truncate
                               (- (time-to-seconds (date-to-time "2022-12-24T00:08:30"))
				  (time-to-seconds))
			   ))
                 (days    (/ seconds (* 24 60 60)))
                 (hours   (progn (setq seconds (- seconds (* days (* 24 60 60))))
                                 (/ seconds (* 60 60))))
                 (minutes (progn (setq seconds (- seconds (* hours (* 60 60))))
                                 (/ seconds 60)))
                 (seconds (setq seconds (- seconds (* minutes 60)))))
            (erase-buffer)
            (insert "2023年考研时间：2022年12月24日 星期六\n")
            (insert "        目前距离2023年考研还有\n")
            (insert (propertize (format "  %s 天 %s 时 %s 分 %s 秒"
                                        days hours minutes seconds)
                                'face '(:height 2.0))))
          (unless count-down-timer
            (setq count-down-timer
                  (run-at-time t 1 'count-down))))
      (when count-down-timer
        (cancel-timer count-down-timer)
        (setq count-down-timer nil)))))


(defun count-down-kaoyan  ()
  "目前距离2023年考研还有？

2023年考研时间：2023年12月24日 星期六"
  (interactive)
  (with-current-buffer (get-buffer-create "*2023年考研倒计时*")
    (buffer-disable-undo)
    (setq cursor-type nil)
    (count-down)
    (display-buffer (current-buffer))))


(provide 'test)
