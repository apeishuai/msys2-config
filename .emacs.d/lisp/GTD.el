(require 'cl-lib)
(require 'org-clock)

;;-------get time summary by tags
(defun clocktable-by-tag/shift-cell (n)
  (let ((str ""))
    (dotimes (i n)
      (setq str (concat str "| ")))
    str))

(defun clocktable-by-tag/insert-tag (params)
  (let ((tag (plist-get params :tags)))
    (insert "|--\n")
    (insert (format "| %s | *Tag time* |\n" tag))
    (let ((total 0))
      (mapcar
       (lambda (file)
         (let ((clock-data (with-current-buffer (find-file-noselect file)
                             (org-clock-get-table-data (buffer-name) params))))
           (when (> (nth 1 clock-data) 0)
             (setq total (+ total (nth 1 clock-data)))
             (insert (format "| | File *%s* | %.2f |\n"
                             (file-name-nondirectory file)
                             (/ (nth 1 clock-data) 60.0)))
             (dolist (entry (nth 2 clock-data))
               (insert (format "| | . %s%s | %s %.2f |\n"
                               (org-clocktable-indent-string (nth 0 entry))
                               (nth 1 entry)
                               (clocktable-by-tag/shift-cell (nth 0 entry))
                               (/ (nth 4 entry) 60.0)))))))
       (org-agenda-files))
      (save-excursion
        (re-search-backward "*Tag time*")
        (org-table-next-field)
        (org-table-blank-field)
        (insert (format "*%.2f*" (/ total 60.0)))))
    (org-table-align)))

(defun org-dblock-write:clocktable-by-tag (params)
  (insert "| Tag | Headline | Time (h) |\n")
  (insert "|     |          | <r>  |\n")
  (let ((tags (plist-get params :tags)))
    (mapcar (lambda (tag)
              (clocktable-by-tag/insert-tag (plist-put (plist-put params :match tag) :tags tag)))
            tags)))

;;--------------------planning table-----------------------
(with-eval-after-load 'org-colview
    ;; adjusted org-agenda-columns function that now calls
    ;; org-agenda-columns--collect-values (see below) instead 
    ;; of org-columns--collect-values
    (defun org-agenda-columns ()
      "Turn on or update column view in the agenda."
      (interactive)
      (org-columns-remove-overlays)
      (if (markerp org-columns-begin-marker)
          (move-marker org-columns-begin-marker (point))
        (setq org-columns-begin-marker (point-marker)))
      (let* ((org-columns--time (float-time))
             (fmt
              (cond
               ((bound-and-true-p org-overriding-columns-format))
               ((bound-and-true-p org-local-columns-format))
               ((bound-and-true-p org-columns-default-format-for-agenda))
               ((let ((m (org-get-at-bol 'org-hd-marker)))
                  (and m
                       (or (org-entry-get m "COLUMNS" t)
                           (with-current-buffer (marker-buffer m)
                             org-columns-default-format)))))
               ((and (local-variable-p 'org-columns-current-fmt)
                     org-columns-current-fmt))
               ((let ((m (next-single-property-change (point-min) 'org-hd-marker)))
                  (and m
                       (let ((m (get-text-property m 'org-hd-marker)))
                         (or (org-entry-get m "COLUMNS" t)
                             (with-current-buffer (marker-buffer m)
                               org-columns-default-format))))))
               (t org-columns-default-format)))
             (compiled-fmt (org-columns-compile-format fmt)))
        (setq org-columns-current-fmt fmt)
        (when org-agenda-columns-compute-summary-properties
          (org-agenda-colview-compute org-columns-current-fmt-compiled))
        (save-excursion
          ;; Collect properties for each headline in current view.
          (goto-char (point-min))
          (let (cache)
            (while (not (eobp))
              (let ((m (org-get-at-bol 'org-hd-marker)))
                (when m
                  (push (cons (line-beginning-position)
                              ;; `org-columns-current-fmt-compiled' is
                              ;; initialized but only set locally to the
                              ;; agenda buffer.  Since current buffer is
                              ;; changing, we need to force the original
                              ;; compiled-fmt there.
                              ;; clavis
                              (org-agenda-columns--collect-values compiled-fmt m))
                        cache)))
              (forward-line))
            (when cache
              (org-columns--set-widths cache)
              (org-columns--display-here-title)
              (when (setq-local org-columns-flyspell-was-active
                                (bound-and-true-p flyspell-mode))
                (flyspell-mode 0))
              (dolist (entry cache)
                (goto-char (car entry))
                (org-columns--display-here (cdr entry)))
              (setq-local org-agenda-columns-active t)
              (when org-agenda-columns-show-summaries
                (org-agenda-colview-summarize cache)))))))

  ;; new function that substitutes org-columns--collect-values
  (defun org-agenda-columns--collect-values (&optional compiled-fmt m)
      "Collect values for columns on the current line.

  Return a list of triplets (SPEC VALUE DISPLAYED) suitable for
  `org-columns--display-here'.

  This function assumes `org-columns-current-fmt-compiled' is
  initialized is set in the current buffer.  However, it is
  possible to override it with optional argument COMPILED-FMT."
      (let ((summaries (get-text-property (point) 'org-summaries)))
        (mapcar
         (lambda (spec)
           (pcase spec
             (`(,p . ,_)
              (let* ((v (or (cdr (assoc spec summaries))
                            ;; first check if p is a special agenda (text) property
                            (when-let* ((prop-p (string-match "^AGENDA_\\(.+\\)" p))
                                        (prop-name (downcase (match-string 1 p))))
                              ;; if property is duration consider effort if it is not set
                              (if (string= prop-name "duration")
                                  (if-let ((dur (org-get-at-bol (intern prop-name))))
                                      ;; if duration is negatie (i.e. time range crossess
                                      ;; midnight) then add 24h to duration
                                      (if (> dur 0.0)
                                          (propertize (org-duration-from-minutes dur)
                                                      'face 'org-scheduled)
                                        (propertize (org-duration-from-minutes
                                                     (+ dur (* 24 60)))
                                                    'face 'org-scheduled))
                                    (org-with-point-at m
                                      (org-entry-get
                                       (point) org-effort-property
                                       'selective t)))
                                (org-get-at-bol (intern prop-name))))
                            (org-with-point-at m
                              (org-entry-get (point) p 'selective t))
                            "")))
                ;; A non-nil COMPILED-FMT means we're calling from Org
                ;; Agenda mode, where we do not want leading stars for
                ;; ITEM.  Hence the optional argument for
                ;; `org-columns--displayed-value'.
                (list spec v (org-columns--displayed-value spec v compiled-fmt))))))
         (or compiled-fmt org-columns-current-fmt-compiled)))))

;;---------------basic config----
(when (memq window-system '(w32))
  (setq org-directory "g:/emacs-notes/GTD/")
  )

(setq time-scan-files (list
		       (concat org-directory "next.org")
		       (concat org-directory "finished.org")
		       (concat org-directory "projects.org")))

(setq org-agenda-files (list
			(concat org-directory "Mointer.org")
			(concat org-directory "inbox.org")
			     (concat org-directory "next.org")
			     ;;(concat org-directory "archive_kaoyan.org")
			     (concat org-directory "projects.org")
			     (concat org-directory "Ref.org")
			     (concat org-directory "Someday_Maybe.org")
			     (concat org-directory "agenda.org")
			     (concat org-directory "finished.org")
			     (concat org-directory "archive.org")
			     (concat org-directory "Trash.org")
			     ))

;; count tags (see John's answer)  //debug
(defun get-tag-counts ()
  (interactive)
  (let ((all-tags '()))
    (org-map-entries
     (lambda ()
       (let ((tag-string (car (last (org-agenda-files)))))
     (when tag-string  
       (setq all-tags
         (append all-tags (split-string tag-string ":" t)))))))

    ;; now get counts
    (cl-loop for tag in (seq-uniq all-tags)
	  collect (cons tag (cl-count tag all-tags :* 'string=)))))

;; wrap get-tag-counts in an interactive function
(defun create-tag-counts-buffer ()
  (interactive)
    (let
        ((tags (get-tag-counts)) (b (get-buffer-create "*Org Tag Count*")))
      (dolist (tag tags) (insert (car tag)) (insert "\n")) (display-buffer b)))






;;Capture
(setq org-capture-templates
      `(("i" "Inbox" entry  (file "inbox.org")
        ,(concat "* TODO %?\n"
                 "/Entered on/ %U\n" "\n"))

        ("c" "org-protocol-capture" entry  (file "inbox.org")
        ,(concat "* TODO %a\n"
                 "/Entered on/ %U\n" "\n" "%?" ))
	;;:immediate-finish t

	("b" "Books" entry  (file "../wxf`s blog/posts/wxfs-booklist.org")
         ,(concat "* Title: 《%?》\n"
		  " Tags: \n"
		  " Status: \n"
                  " Start-Time: %U\n"
		  " End-Time:  %U\n"
		  " Intro: \n"))
	))
(setq org-protocol-default-template-key "c")
(setq org-agenda-hide-tags-regexp ".")


;; TODO
(setq org-todo-keywords
      '((sequence "TODO(T!)"  "|" "DONE(D!)")))
(defun log-todo-next-creation-date (&rest ignore)
  "Log NEXT creation time in the property drawer under the key 'ACTIVATED'"
  (when (and (string= (org-get-todo-state) "TODO")
             (not (org-entry-get nil "ACTIVATED")))
    (org-entry-put nil "ACTIVATED" (format-time-string "[%Y-%m-%d]"))))
(add-hook 'org-after-todo-state-change-hook #'log-todo-next-creation-date)

;; Refile
(setq org-refile-use-outline-path 'file)
(setq org-outline-path-complete-in-steps nil)
(setq org-refile-targets
      '((org-agenda-files :maxlevel . 3)))

;; Agenda
(setq org-agenda-custom-commands
      '(
        ("j" "Planning Table"
         agenda ""
         ((org-agenda-overriding-header "")
          (org-agenda-span 1)
          (org-agenda-use-time-grid nil)
          (org-agenda-view-columns-initially t)
          (org-columns-default-format-for-agenda
                 "%11AGENDA_TIME(When) %4TODO(Type) %40ITEM(What) %5AGENDA_DURATION(Takes){:}")
          ;; do not show wardings, overdue and overscheduled
          (org-scheduled-past-days 0)
          (org-deadline-past-days 0)
          (org-deadline-warning-days 0)
          ;; skip finished entries
          (org-agenda-skip-deadline-if-done t)
          (org-agenda-skip-scheduled-if-done t)))

	("g" "Get Things Done (GTD)"
	 ((agenda ""
                  (
		   (org-agenda-span 'day)
		   (org-agenda-skip-function
                    '(org-agenda-skip-entry-if 'todo '("TODO" "DONE")))
                   (org-deadline-warning-days 10)
		   ))
          (tags-todo "inbox"
                     ((org-agenda-prefix-format "%T:  %?-12t% s")
                      (org-agenda-overriding-header "\nTo Refile\n")))
          (tags-todo "next"
                     ((org-agenda-prefix-format "%T:  %?-12t% s")
                      (org-agenda-overriding-header "\nIn Progress\n")))
	 (tags-todo "projects"
                     ((org-agenda-prefix-format "%T:  %?-12t% s")
                      (org-agenda-overriding-header "\nProjects\n")))
	  (tags "CLOSED>=\"<today>\""
                ((org-agenda-overriding-header "\nCompleted today\n")))))))


;;basic settings
;(setq org-agenda-start-day "+20d")
(setq org-agenda-include-diary t)
(setq org-log-done 'time)

;;key bindings
(define-key global-map (kbd "C-c i") 'org-capture-inbox)
(define-key global-map (kbd "C-c a") 'org-agenda)
(define-key global-map  (kbd "C-c c") 'org-capture)

;;appoint ontime
(setq appt-message-warning-time 0)      ; 0 minute time before warning

(defun org-capture-inbox ()
     (interactive)
     (call-interactively 'org-store-link)
     (org-capture nil "i"))

(setq org-agenda-prefix-format
      '((agenda . " %i %-12:c%?-12t% s")
        (todo   . " %i %-12:c")
        (tags   . " %i %-12:c")
        (search . " %i %-12:c")))

;; Save the corresponding buffers
(defun gtd-save-org-buffers ()
  "Save `org-agenda-files' buffers without user confirmation.
See also `org-save-all-org-buffers'"
  (interactive)
  (message "Saving org-agenda-files buffers...")
  (save-some-buffers t (lambda () 
			 (when (member (buffer-file-name) org-agenda-files) 
			   t)))
  (message "Saving org-agenda-files buffers... done"))

;; Add it after refile
(advice-add 'org-refile :after
	    (lambda (&rest _)
	      (gtd-save-org-buffers)))

(provide 'GTD)

