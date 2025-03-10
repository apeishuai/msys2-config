;;; ox-icalendar.el --- iCalendar Backend for Org Export Engine -*- lexical-binding: t; -*-

;; Copyright (C) 2004-2025 Free Software Foundation, Inc.

;; Author: Carsten Dominik <carsten.dominik@gmail.com>
;;      Nicolas Goaziou <mail@nicolasgoaziou.fr>
;; Maintainer: Jack Kamm <jackkamm@gmail.com>
;; Keywords: outlines, hypermedia, calendar, text
;; URL: https://orgmode.org

;; This file is part of GNU Emacs.

;; GNU Emacs is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:
;;
;; This library implements an iCalendar backend for Org generic
;; exporter.  See Org manual for more information.
;;
;; It is expected to conform to RFC 5545.

;;; Code:

(require 'org-macs)
(org-assert-version)

(require 'cl-lib)
(require 'org-agenda)
(require 'ox-ascii)
(declare-function org-bbdb-anniv-export-ical "ol-bbdb" nil)
(declare-function org-at-heading-p "org" (&optional _))
(declare-function org-back-to-heading "org" (&optional invisible-ok))
(declare-function org-next-visible-heading "org" (arg))



;;; User-Configurable Variables

(defgroup org-export-icalendar nil
  "Options specific for iCalendar export backend."
  :tag "Org Export iCalendar"
  :group 'org-export)

(defcustom org-icalendar-combined-agenda-file "~/org.ics"
  "The file name for the iCalendar file covering all agenda files.
This file is created with the command `\\[org-icalendar-combine-agenda-files]'.
The file name should be absolute.  It will be overwritten without warning."
  :group 'org-export-icalendar
  :type 'file)

(defcustom org-icalendar-alarm-time 0
  "Number of minutes for triggering an alarm for exported timed events.

A zero value (the default) turns off the definition of an alarm trigger
for timed events.  If non-zero, alarms are created.

- a single alarm per entry is defined
- The alarm will go off N minutes before the event
- only a DISPLAY action is defined."
  :group 'org-export-icalendar
  :version "24.1"
  :type 'integer)

(defcustom org-icalendar-force-alarm nil
  "Non-nil means alarm will be created even if is set to zero.

This overrides default behavior where zero means no alarm.  With
this set to non-nil and alarm set to zero, alarm will be created
and will fire at the event start."
  :group 'org-export-icalendar
  :type 'boolean
  :package-version '(Org . "9.6")
  :safe #'booleanp)

(defcustom org-icalendar-combined-name "OrgMode"
  "Calendar name for the combined iCalendar representing all agenda files."
  :group 'org-export-icalendar
  :type 'string)

(defcustom org-icalendar-combined-description ""
  "Calendar description for the combined iCalendar (all agenda files)."
  :group 'org-export-icalendar
  :type 'string)

(defcustom org-icalendar-exclude-tags nil
  "Tags that exclude a tree from export.
This variable allows specifying different exclude tags from other
backends.  It can also be set with the ICALENDAR_EXCLUDE_TAGS
keyword."
  :group 'org-export-icalendar
  :type '(repeat (string :tag "Tag")))

(defcustom org-icalendar-scheduled-summary-prefix "S: "
  "String prepended to exported scheduled headlines."
  :group 'org-export-icalendar
  :type 'string
  :package-version '(Org . "9.6")
  :safe #'stringp)


(defcustom org-icalendar-deadline-summary-prefix "DL: "
  "String prepended to exported headlines with a deadline."
  :group 'org-export-icalendar
  :type 'string
  :package-version '(Org . "9.6")
  :safe #'stringp)

(defcustom org-icalendar-use-deadline '(event-if-not-todo todo-due)
  "Contexts where iCalendar export should use a deadline time stamp.

This is a list with possibly several symbols in it.  Valid symbols are:

`event-if-todo'

  Deadlines in TODO entries become calendar events.

`event-if-todo-not-done'

  Deadlines in TODO entries with not-DONE state become events.

`event-if-not-todo'

  Deadlines in non-TODO entries become calendar events.

`todo-due'

  Use deadlines in TODO entries as due-dates."
  :group 'org-export-icalendar
  :type
  '(set :greedy t
	(const :tag "DEADLINE in non-TODO entries become events"
	       event-if-not-todo)
	(const :tag "DEADLINE in TODO entries become events"
	       event-if-todo)
	(const :tag "DEADLINE in TODO entries with not-DONE state become events"
	       event-if-todo-not-done)
	(const :tag "DEADLINE in TODO entries become due-dates"
	       todo-due)))

(defcustom org-icalendar-use-scheduled '(todo-start)
  "Contexts where iCalendar export should use a scheduling time stamp.

This is a list with possibly several symbols in it.  Valid symbols are:

`event-if-todo'

  Scheduling time stamps in TODO entries become an event.

`event-if-todo-not-done'

  Scheduling time stamps in TODO entries with not-DONE state
  become events.

`event-if-not-todo'

  Scheduling time stamps in non-TODO entries become an event.

`todo-start'

  Scheduling time stamps in TODO entries become start date.  (See
  also `org-icalendar-todo-unscheduled-start', which controls the
  start date for TODO entries without a scheduling time stamp)"
  :group 'org-export-icalendar
  :type
  '(set :greedy t
	(const :tag "SCHEDULED timestamps in non-TODO entries become events"
	       event-if-not-todo)
	(const :tag "SCHEDULED timestamps in TODO entries become events"
	       event-if-todo)
	(const :tag "SCHEDULED in TODO entries with not-DONE state become events"
	       event-if-todo-not-done)
	(const :tag "SCHEDULED in TODO entries become start date"
	       todo-start)))

(defcustom org-icalendar-categories '(local-tags category)
  "Items that should be entered into the \"categories\" field.

This is a list of symbols, the following are valid:
`category'    The Org mode category of the current file or tree
`todo-state'  The todo state, if any
`local-tags'  The tags, defined in the current line
`all-tags'    All tags, including inherited ones."
  :group 'org-export-icalendar
  :type '(repeat
	  (choice
	   (const :tag "The file or tree category" category)
	   (const :tag "The TODO state" todo-state)
	   (const :tag "Tags defined in current line" local-tags)
	   (const :tag "All tags, including inherited ones" all-tags))))

(defcustom org-icalendar-with-timestamps 'active
  "Non-nil means make an event from plain time stamps.

It can be set to `active', `inactive', t or nil, in order to make
an event from, respectively, only active timestamps, only
inactive ones, all of them or none.

This variable has precedence over `org-export-with-timestamps'.
It can also be set with the #+OPTIONS line, e.g. \"<:t\"."
  :group 'org-export-icalendar
  :type '(choice
	  (const :tag "All timestamps" t)
	  (const :tag "Only active timestamps" active)
	  (const :tag "Only inactive timestamps" inactive)
	  (const :tag "No timestamp" nil)))

(defcustom org-icalendar-include-todo nil
  "Non-nil means create VTODO components from TODO items.

Valid values are:
nil                  don't include any task.
t                    include tasks that are not in DONE state.
`unblocked'          include all TODO items that are not blocked.
`all'                include both done and not done items.
\\(\"TODO\" ...)       include specific TODO keywords."
  :group 'org-export-icalendar
  :type '(choice
	  (const :tag "None" nil)
	  (const :tag "Unfinished" t)
	  (const :tag "Unblocked" unblocked)
	  (const :tag "All" all)
	  (repeat :tag "Specific TODO keywords"
		  (string :tag "Keyword"))))

(defcustom org-icalendar-todo-unscheduled-start 'recurring-deadline-warning
  "Exported start date of unscheduled TODOs.

If `org-icalendar-use-scheduled' contains `todo-start' and a task
has a \"SCHEDULED\" timestamp, that is always used as the start
date.  Otherwise, this variable controls whether a start date is
exported and what its value is.

Note that the iCalendar spec RFC 5545 does not generally require
tasks to have a start date, except for repeating tasks which do
require a start date.  However some iCalendar programs ignore the
requirement for repeating tasks, and allow repeating deadlines
without a matching start date.

This variable has no effect when `org-icalendar-include-todo' is nil.

Valid values are:
`recurring-deadline-warning'  If deadline repeater present,
                              use `org-deadline-warning-days' as start.
`deadline-warning'            If deadline present,
                              use `org-deadline-warning-days' as start.
`current-datetime'            Use the current date-time as start.
nil                           Never add a start time for unscheduled tasks."
  :group 'org-export-icalendar
  :type '(choice
	  (const :tag "Warning days if deadline recurring" recurring-deadline-warning)
	  (const :tag "Warning days if deadline present" deadline-warning)
	  (const :tag "Now" current-datetime)
	  (const :tag "No start date" nil))
  :package-version '(Org . "9.7")
  :safe #'symbolp)

(defcustom org-icalendar-include-bbdb-anniversaries nil
  "Non-nil means a combined iCalendar file should include anniversaries.
The anniversaries are defined in the BBDB database."
  :group 'org-export-icalendar
  :type 'boolean)

(defcustom org-icalendar-include-sexps t
  "Non-nil means export to iCalendar files should also cover sexp entries.
These are entries like in the diary, but directly in an Org file."
  :group 'org-export-icalendar
  :type 'boolean)

(defcustom org-icalendar-include-body t
  "Amount of text below headline to be included in iCalendar export.
This is a number of characters that should maximally be included.
Properties, scheduling and clocking lines will always be removed.
The text will be inserted into the DESCRIPTION field."
  :group 'org-export-icalendar
  :type '(choice
	  (const :tag "Nothing" nil)
	  (const :tag "Everything" t)
	  (integer :tag "Max characters")))

(defcustom org-icalendar-store-UID nil
  "Non-nil means store any created UIDs in properties.

The iCalendar standard requires that all entries have a unique identifier.
Org will create these identifiers as needed.  When this variable is non-nil,
the created UIDs will be stored in the ID property of the entry.  Then the
next time this entry is exported, it will be exported with the same UID,
superseding the previous form of it.  This is essential for
synchronization services.

This variable is not turned on by default because we want to avoid creating
a property drawer in every entry if people are only playing with this feature,
or if they are only using it locally."
  :group 'org-export-icalendar
  :type 'boolean)

(defcustom org-icalendar-timezone (getenv "TZ")
  "The time zone string for iCalendar export.
When nil or the empty string, use output
from (current-time-zone)."
  :group 'org-export-icalendar
  :type '(choice
	  (const :tag "Unspecified" nil)
	  (string :tag "Time zone")))

(defcustom org-icalendar-date-time-format ":%Y%m%dT%H%M%S"
  "Format-string for exporting icalendar DATE-TIME.

See `format-time-string' for a full documentation.  The only
difference is that `org-icalendar-timezone' is used for %Z.

Interesting value are:
 - \":%Y%m%dT%H%M%S\" for local time
 - \";TZID=%Z:%Y%m%dT%H%M%S\" for local time with explicit timezone
 - \":%Y%m%dT%H%M%SZ\" for time expressed in Universal Time"
  :group 'org-export-icalendar
  :version "24.1"
  :type '(choice
	  (const :tag "Local time" ":%Y%m%dT%H%M%S")
	  (const :tag "Explicit local time" ";TZID=%Z:%Y%m%dT%H%M%S")
	  (const :tag "Universal time" ":%Y%m%dT%H%M%SZ")
	  (string :tag "Explicit format")))

(defcustom org-icalendar-ttl nil
  "Time to live for the exported calendar.

Subscribing clients to the exported ics file can derive the time
interval to read the file again from the server.  One example of such
client is Nextcloud calendar, which respects the setting of
X-PUBLISHED-TTL in ICS files.  Setting `org-icalendar-ttl' to \"PT1H\"
would advise a server to reload the file every hour.

See https://icalendar.org/iCalendar-RFC-5545/3-8-2-5-duration.html
for a complete description of possible specifications of this
option.  For example, \"PT1H\" stands for 1 hour and
\"PT0H27M34S\" stands for 0 hours, 27 minutes and 34 seconds.

The default value is nil, which means no such option is set in
the ICS file. This option can also be set on a per-document basis
with the ICAL-TTL export keyword."
  :group 'org-export-icalendar
  :type '(choice
          (const :tag "No refresh period" nil)
          (const :tag "One hour" "PT1H")
          (const :tag "One day" "PT1D")
          (const :tag "One week" "PT7D")
          (string :tag "Other"))
  :package-version '(Org . "9.7"))

(defvar org-icalendar-after-save-hook nil
  "Hook run after an iCalendar file has been saved.
This hook is run with the name of the file as argument.  A good
way to use this is to tell a desktop calendar application to
re-read the iCalendar file.")



;;; Define Backend

(org-export-define-derived-backend 'icalendar 'ascii
  :translate-alist '((clock . nil)
		     (footnote-definition . nil)
		     (footnote-reference . nil)
		     (headline . org-icalendar-entry)
                     (inner-template . org-icalendar-inner-template)
		     (inlinetask . nil)
		     (planning . nil)
		     (section . nil)
		     (template . org-icalendar-template))
  :options-alist
  '((:exclude-tags
     "ICALENDAR_EXCLUDE_TAGS" nil org-icalendar-exclude-tags split)
    (:with-timestamps nil "<" org-icalendar-with-timestamps)
    ;; Other variables.
    (:icalendar-alarm-time nil nil org-icalendar-alarm-time)
    (:icalendar-categories nil nil org-icalendar-categories)
    (:icalendar-date-time-format nil nil org-icalendar-date-time-format)
    (:icalendar-include-bbdb-anniversaries nil nil org-icalendar-include-bbdb-anniversaries)
    (:icalendar-include-body nil nil org-icalendar-include-body)
    (:icalendar-include-sexps nil nil org-icalendar-include-sexps)
    (:icalendar-include-todo nil nil org-icalendar-include-todo)
    (:icalendar-store-UID nil nil org-icalendar-store-UID)
    (:icalendar-timezone nil nil org-icalendar-timezone)
    (:icalendar-use-deadline nil nil org-icalendar-use-deadline)
    (:icalendar-use-scheduled nil nil org-icalendar-use-scheduled)
    (:icalendar-scheduled-summary-prefix nil nil org-icalendar-scheduled-summary-prefix)
    (:icalendar-deadline-summary-prefix nil nil org-icalendar-deadline-summary-prefix)
    (:icalendar-ttl "ICAL-TTL" nil org-icalendar-ttl))
  :filters-alist
  '((:filter-headline . org-icalendar-clear-blank-lines))
  :menu-entry
  '(?c "Export to iCalendar"
       ((?f "Current file" org-icalendar-export-to-ics)
	(?a "All agenda files"
	    (lambda (a s v b) (org-icalendar-export-agenda-files a)))
	(?c "Combine all agenda files"
	    (lambda (a s v b) (org-icalendar-combine-agenda-files a))))))



;;; Internal Functions

(defun org-icalendar-create-uid (file &optional bell)
  "Set ID property on headlines missing it in FILE.
When optional argument BELL is non-nil, inform the user with
a message if the file was modified."
  (let (modified-flag)
    (org-map-entries
     (lambda ()
       (let ((entry (org-element-at-point)))
	 (unless (org-element-property :ID entry)
	   (org-id-get-create)
	   (setq modified-flag t)
	   (forward-line))))
     nil nil 'comment)
    (when (and bell modified-flag)
      (message "ID properties created in file \"%s\"" file)
      (sit-for 2))))

(defun org-icalendar-blocked-headline-p (headline info)
  "Non-nil when HEADLINE is considered to be blocked.

INFO is a plist used as a communication channel.

A headline is blocked when either

  - it has children which are not all in a completed state;

  - it has a parent with the property :ORDERED:, and there are
    siblings prior to it with incomplete status;

  - its parent is blocked because it has siblings that should be
    done first or is a child of a blocked grandparent entry."
  (or
   ;; Check if any child is not done.
   (org-element-map (org-element-contents headline) 'headline
     (lambda (hl) (eq (org-element-property :todo-type hl) 'todo))
     info 'first-match)
   ;; Check :ORDERED: node property.
   (catch 'blockedp
     (let ((current headline))
       (dolist (parent (org-element-lineage headline))
	 (cond
	  ((not (org-element-property :todo-keyword parent))
	   (throw 'blockedp nil))
	  ((org-not-nil (org-element-property :ORDERED parent))
	   (let ((sibling current))
	     (while (setq sibling (org-export-get-previous-element
				   sibling info))
	       (when (eq (org-element-property :todo-type sibling) 'todo)
		 (throw 'blockedp t)))))
	  (t (setq current parent))))))))

(defun org-icalendar-use-UTC-date-time-p ()
  "Non-nil when `org-icalendar-date-time-format' requires UTC time."
  (char-equal (elt org-icalendar-date-time-format
		   (1- (length org-icalendar-date-time-format)))
	      ?Z))

(defun org-icalendar-convert-timestamp (timestamp keyword &optional end tz)
  "Convert TIMESTAMP to iCalendar format.

TIMESTAMP is a timestamp object.  KEYWORD is added in front of
it, in order to make a complete line (e.g. \"DTSTART\").

When optional argument END is non-nil, use end of time range.
Also increase the hour by two (if time string contains a time),
or the day by one (if it does not contain a time) when no
explicit ending time is specified.

When optional argument TZ is non-nil, timezone data time will be
added to the timestamp.  It can be the string \"UTC\", to use UTC
time, or a string in the IANA TZ database
format (e.g. \"Europe/London\").  In either case, the value of
`org-icalendar-date-time-format' will be ignored."
  (let* ((year-start (org-element-property :year-start timestamp))
	 (year-end (org-element-property :year-end timestamp))
	 (month-start (org-element-property :month-start timestamp))
	 (month-end (org-element-property :month-end timestamp))
	 (day-start (org-element-property :day-start timestamp))
	 (day-end (org-element-property :day-end timestamp))
	 (hour-start (org-element-property :hour-start timestamp))
	 (hour-end (org-element-property :hour-end timestamp))
	 (minute-start (org-element-property :minute-start timestamp))
	 (minute-end (org-element-property :minute-end timestamp))
	 (with-time-p minute-start)
	 (equal-bounds-p
	  (equal (list year-start month-start day-start hour-start minute-start)
		 (list year-end month-end day-end hour-end minute-end)))
	 (mi (cond ((not with-time-p) 0)
		   ((not end) minute-start)
		   ((and org-agenda-default-appointment-duration equal-bounds-p)
		    (+ minute-end org-agenda-default-appointment-duration))
		   (t minute-end)))
	 (h (cond ((not with-time-p) 0)
		  ((not end) hour-start)
		  ((or (not equal-bounds-p)
		       org-agenda-default-appointment-duration)
		   hour-end)
		  (t (+ hour-end 2))))
	 (d (cond ((not end) day-start)
		  ((not with-time-p) (1+ day-end))
		  (t day-end)))
	 (m (if end month-end month-start))
	 (y (if end year-end year-start)))
    (concat
     keyword
     (format-time-string
      (cond ((string-equal tz "UTC") ":%Y%m%dT%H%M%SZ")
	    ((not with-time-p) ";VALUE=DATE:%Y%m%d")
	    ((stringp tz) (concat ";TZID=" tz ":%Y%m%dT%H%M%S"))
	    (t (replace-regexp-in-string "%Z"
					 org-icalendar-timezone
					 org-icalendar-date-time-format
					 t)))
      ;; Convert timestamp into internal time in order to use
      ;; `format-time-string' and fix any mistake (i.e. MI >= 60).
      (org-encode-time 0 mi h d m y)
      (and (or (string-equal tz "UTC")
	       (and (null tz)
		    with-time-p
		    (org-icalendar-use-UTC-date-time-p)))
	   t)))))

(defun org-icalendar-dtstamp ()
  "Return DTSTAMP property, as a string."
  (format-time-string "DTSTAMP:%Y%m%dT%H%M%SZ" nil t))

(defun org-icalendar-get-categories (entry info)
  "Return categories according to `org-icalendar-categories'.
ENTRY is a headline or an inlinetask element.  INFO is a plist
used as a communication channel."
  (mapconcat
   #'identity
   (org-uniquify
    (let (categories)
      (dolist (type org-icalendar-categories (nreverse categories))
	(cl-case type
	  (category
	   (push (org-export-get-category entry info) categories))
	  (todo-state
	   (let ((todo (org-element-property :todo-keyword entry)))
	     (and todo (push todo categories))))
	  (local-tags
	   (setq categories
		 (append (nreverse (org-export-get-tags entry info))
			 categories)))
	  (all-tags
	   (setq categories
		 (append (nreverse (org-export-get-tags entry info nil t))
			 categories)))))))
   ","))

(defun org-icalendar-transcode-diary-sexp (sexp uid summary)
  "Transcode a diary sexp into iCalendar format.
SEXP is the diary sexp being transcoded, as a string.  UID is the
unique identifier for the entry.  SUMMARY defines a short summary
or subject for the event."
  (when (require 'icalendar nil t)
    (org-element-normalize-string
     (with-temp-buffer
       (let ((sexp (if (not (string-match "\\`<%%" sexp)) sexp
		     (concat (substring sexp 1 -1) " " summary))))
	 (put-text-property 0 1 'uid uid sexp)
	 (insert sexp "\n"))
       (org-diary-to-ical-string (current-buffer))))))

(defun org-icalendar-cleanup-string (s)
  "Cleanup string S according to RFC 5545."
  (when s
    ;; Protect "\", "," and ";" characters. and replace newline
    ;; characters with literal \n.
    (replace-regexp-in-string
     "[ \t]*\n" "\\n"
     (replace-regexp-in-string "[\\,;]" "\\\\\\&" s)
     nil t)))

(defun org-icalendar-fold-string (s)
  "Fold string S according to RFC 5545."
  (org-element-normalize-string
   (mapconcat
    (lambda (line)
      ;; Limit each line to a maximum of 75 characters.  If it is
      ;; longer, fold it by using "\r\n " as a continuation marker.
      (let ((len (length line)))
	(if (<= len 75) line
	  (let ((folded-line (substring line 0 75))
		(chunk-start 75)
		chunk-end)
	    ;; Since continuation marker takes up one character on the
	    ;; line, real contents must be split at 74 chars.
	    (while (< (setq chunk-end (+ chunk-start 74)) len)
	      (setq folded-line
		    (concat folded-line "\n "
			    (substring line chunk-start chunk-end))
		    chunk-start chunk-end))
	    (concat folded-line "\n " (substring line chunk-start))))))
    (org-split-string s "\n") "\n")))

(defun org-icalendar--post-process-file (file)
  "Post-process the exported iCalendar FILE.
Converts line endings to dos-style CRLF as per RFC 5545, then
runs `org-icalendar-after-save-hook'."
  (with-temp-buffer
    (insert-file-contents file)
    (let ((coding-system-for-write (coding-system-change-eol-conversion
                                    last-coding-system-used 'dos)))
      (write-region nil nil file)))
  (run-hook-with-args 'org-icalendar-after-save-hook file)
  nil)


;;; Filters

(defun org-icalendar-clear-blank-lines (headline _backend _info)
  "Remove blank lines in HEADLINE export.
HEADLINE is a string representing a transcoded headline.
BACKEND and INFO are ignored."
  (replace-regexp-in-string "^\\(?:[ \t]*\n\\)+" "" headline))



;;; Transcode Functions

;;;; Headline and Inlinetasks

;; The main function is `org-icalendar-entry', which extracts
;; information from a headline or an inlinetask (summary,
;; description...) and then delegates code generation to
;; `org-icalendar--vtodo' and `org-icalendar--vevent', depending
;; on the component needed.

;; Obviously, `org-icalendar--valarm' handles alarms, which can
;; happen within a VTODO component.

(defun org-icalendar-entry (entry contents info)
  "Transcode ENTRY element into iCalendar format.

ENTRY is either a headline or an inlinetask.  CONTENTS is
ignored.  INFO is a plist used as a communication channel.

This function is called on every headline, the section below
it (minus inlinetasks) being its contents.  It tries to create
VEVENT and VTODO components out of scheduled date, deadline date,
plain timestamps, diary sexps.  It also calls itself on every
inlinetask within the section."
  (unless (org-element-property :footnote-section-p entry)
    (let* ((type (org-element-type entry))
	   ;; Determine contents really associated to the entry.  For
	   ;; a headline, limit them to section, if any.  For an
	   ;; inlinetask, this is every element within the task.
	   (inside
	    (if (eq type 'inlinetask)
		(cons 'org-data (cons nil (org-element-contents entry)))
	      (let ((first (car (org-element-contents entry))))
		(and (org-element-type-p first 'section)
		     (cons 'org-data
			   (cons nil (org-element-contents first))))))))
      (concat
       (let ((todo-type (org-element-property :todo-type entry))
	     (uid (or (org-element-property :ID entry) (org-id-new)))
	     (summary (org-icalendar-cleanup-string
		       (or
                        (let ((org-property-separators '(("SUMMARY" . "\n"))))
                          (org-entry-get entry "SUMMARY" 'selective))
			(org-export-data
			 (org-element-property :title entry) info))))
	     (loc
              (let ((org-property-separators '(("LOCATION" . "\n"))))
                (org-icalendar-cleanup-string
                 (org-entry-get entry "LOCATION" 'selective))))
	     (class (org-icalendar-cleanup-string
		     (org-export-get-node-property
		      :CLASS entry
		      (org-property-inherit-p "CLASS"))))
	     ;; Build description of the entry from associated section
	     ;; (headline) or contents (inlinetask).
	     (desc
	      (org-icalendar-cleanup-string
	       (or (let ((org-property-separators '(("DESCRIPTION" . "\n"))))
                     (org-entry-get entry "DESCRIPTION" 'selective))
		   (let ((contents (org-export-data inside info)))
		     (cond
		      ((not (org-string-nw-p contents)) nil)
		      ((wholenump org-icalendar-include-body)
		       (let ((contents (org-trim contents)))
			 (substring
			  contents 0 (min (length contents)
					  org-icalendar-include-body))))
		      (org-icalendar-include-body (org-trim contents)))))))
	     (cat (org-icalendar-get-categories entry info))
	     (tz (org-export-get-node-property
		  :TIMEZONE entry
		  (org-property-inherit-p "TIMEZONE"))))
	 (concat
	  ;; Events: Delegate to `org-icalendar--vevent' to generate
	  ;; "VEVENT" component from scheduled, deadline, or any
	  ;; timestamp in the entry.
	  (let ((deadline (org-element-property :deadline entry))
		(use-deadline (plist-get info :icalendar-use-deadline))
                (deadline-summary-prefix (org-icalendar-cleanup-string
                                          (plist-get info :icalendar-deadline-summary-prefix))))
	    (and deadline
		 (pcase todo-type
		   (`todo (or (memq 'event-if-todo-not-done use-deadline)
			      (memq 'event-if-todo use-deadline)))
		   (`done (memq 'event-if-todo use-deadline))
		   (_ (memq 'event-if-not-todo use-deadline)))
		 (org-icalendar--vevent
		  entry deadline (concat "DL-" uid)
		  (concat deadline-summary-prefix summary)
                  loc desc cat tz class)))
	  (let ((scheduled (org-element-property :scheduled entry))
		(use-scheduled (plist-get info :icalendar-use-scheduled))
                (scheduled-summary-prefix (org-icalendar-cleanup-string
                                           (plist-get info :icalendar-scheduled-summary-prefix))))
	    (and scheduled
		 (pcase todo-type
		   (`todo (or (memq 'event-if-todo-not-done use-scheduled)
			      (memq 'event-if-todo use-scheduled)))
		   (`done (memq 'event-if-todo use-scheduled))
		   (_ (memq 'event-if-not-todo use-scheduled)))
		 (org-icalendar--vevent
		  entry scheduled (concat "SC-" uid)
		  (concat scheduled-summary-prefix summary)
                  loc desc cat tz class)))
	  ;; When collecting plain timestamps from a headline and its
	  ;; title, skip inlinetasks since collection will happen once
	  ;; ENTRY is one of them.
	  (let ((counter 0))
	    (mapconcat
	     #'identity
	     (org-element-map (cons (org-element-property :title entry)
				    (org-element-contents inside))
		 'timestamp
	       (lambda (ts)
		 (when (let ((type (org-element-property :type ts)))
			 (cl-case (plist-get info :with-timestamps)
			   (active (memq type '(active active-range diary)))
			   (inactive (memq type '(inactive inactive-range)))
			   ((t) t)))
		   (let ((uid (format "TS%d-%s" (cl-incf counter) uid)))
		     (org-icalendar--vevent
		      entry ts uid summary loc desc cat tz class))))
	       info nil (and (eq type 'headline) 'inlinetask))
	     ""))
	  ;; Task: First check if it is appropriate to export it.  If
	  ;; so, call `org-icalendar--vtodo' to transcode it into
	  ;; a "VTODO" component.
	  (when (and todo-type
		     (pcase (plist-get info :icalendar-include-todo)
		       (`all t)
		       (`unblocked
			(and (eq type 'headline)
			     (not (org-icalendar-blocked-headline-p
				 entry info))))
                       ;; unfinished
		       (`t (eq todo-type 'todo))
                       ((and (pred listp) kwd-list)
                        (member (org-element-property :todo-keyword entry) kwd-list))))
	    (org-icalendar--vtodo entry uid summary loc desc cat tz class))
	  ;; Diary-sexp: Collect every diary-sexp element within ENTRY
	  ;; and its title, and transcode them.  If ENTRY is
	  ;; a headline, skip inlinetasks: they will be handled
	  ;; separately.
	  (when org-icalendar-include-sexps
	    (let ((counter 0))
	      (mapconcat #'identity
			 (org-element-map
			     (cons (org-element-property :title entry)
				   (org-element-contents inside))
			     'diary-sexp
			   (lambda (sexp)
			     (org-icalendar-transcode-diary-sexp
			      (org-element-property :value sexp)
			      (format "DS%d-%s" (cl-incf counter) uid)
			      summary))
			   info nil (and (eq type 'headline) 'inlinetask))
			 "")))))
       ;; If ENTRY is a headline, call current function on every
       ;; inlinetask within it.  In agenda export, this is independent
       ;; from the mark (or lack thereof) on the entry.
       (when (eq type 'headline)
	 (mapconcat #'identity
		    (org-element-map inside 'inlinetask
		      (lambda (task) (org-icalendar-entry task nil info))
		      info) ""))
       ;; Don't forget components from inner entries.
       contents))))

(defun org-icalendar--rrule (unit value)
  "Format RRULE icalendar entry for UNIT frequency and VALUE interval.
UNIT is a symbol `hour', `day', `week', `month', or `year'."
  (format "RRULE:FREQ=%s;INTERVAL=%d"
	  (cl-case unit
	    (hour "HOURLY") (day "DAILY") (week "WEEKLY")
	    (month "MONTHLY") (year "YEARLY"))
	  value))

(defun org-icalendar--vevent
    (entry timestamp uid summary location description categories timezone class)
  "Create a VEVENT component.

ENTRY is either a headline or an inlinetask element.  TIMESTAMP
is a timestamp object defining the date-time of the event.  UID
is the unique identifier for the event.  SUMMARY defines a short
summary or subject for the event.  LOCATION defines the intended
venue for the event.  DESCRIPTION provides the complete
description of the event.  CATEGORIES defines the categories the
event belongs to.  TIMEZONE specifies a time zone for this event
only.  CLASS contains the visibility attribute.  Three of them
\\(\"PUBLIC\", \"CONFIDENTIAL\", and \"PRIVATE\") are predefined, others
should be treated as \"PRIVATE\" if they are unknown to the iCalendar server.

Return VEVENT component as a string."
  (if (eq (org-element-property :type timestamp) 'diary)
      (org-icalendar-transcode-diary-sexp
       (org-element-property :raw-value timestamp) uid summary)
    (concat "BEGIN:VEVENT\n"
	    (org-icalendar-dtstamp) "\n"
	    "UID:" uid "\n"
	    (org-icalendar-convert-timestamp timestamp "DTSTART" nil timezone) "\n"
	    (org-icalendar-convert-timestamp timestamp "DTEND" t timezone) "\n"
	    ;; RRULE.
            (when (org-element-property :repeater-type timestamp)
              (concat (org-icalendar--rrule
                       (org-element-property :repeater-unit timestamp)
                       (org-element-property :repeater-value timestamp))
                      "\n"))
	    "SUMMARY:" summary "\n"
	    (and (org-string-nw-p location) (format "LOCATION:%s\n" location))
	    (and (org-string-nw-p class) (format "CLASS:%s\n" class))
	    (and (org-string-nw-p description)
		 (format "DESCRIPTION:%s\n" description))
	    "CATEGORIES:" categories "\n"
	    ;; VALARM.
	    (org-icalendar--valarm entry timestamp summary)
	    "END:VEVENT\n")))

(defun org-icalendar--repeater-type (elem)
  "Return ELEM's repeater-type if supported, else warn and return nil."
  (let ((repeater-value (org-element-property :repeater-value elem))
        (repeater-type (org-element-property :repeater-type elem)))
    (cond
     ((not (and repeater-type
                repeater-value
                (> repeater-value 0)))
      nil)
     ;; TODO Add catch-up to supported repeaters (use EXDATE to implement)
     ((not (memq repeater-type '(cumulate)))
      (org-display-warning
       (format "Repeater-type %s not currently supported by iCalendar export"
               (symbol-name repeater-type)))
      nil)
     (repeater-type))))

(defun org-icalendar--vtodo
    (entry uid summary location description categories timezone class)
  "Create a VTODO component.

ENTRY is either a headline or an inlinetask element.  UID is the
unique identifier for the task.  SUMMARY defines a short summary
or subject for the task.  LOCATION defines the intended venue for
the task.  CLASS sets the task class (e.g. confidential).  DESCRIPTION
provides the complete description of the task.  CATEGORIES defines the
categories the task belongs to.  TIMEZONE specifies a time zone for
this TODO only.

Return VTODO component as a string."
  (let* ((sc (and (memq 'todo-start org-icalendar-use-scheduled)
		  (org-element-property :scheduled entry)))
         (dl (and (memq 'todo-due org-icalendar-use-deadline)
                  (org-element-property :deadline entry)))
         (sc-repeat-p (org-icalendar--repeater-type sc))
         (dl-repeat-p (org-icalendar--repeater-type dl))
         (repeat-value (or (org-element-property :repeater-value sc)
                           (org-element-property :repeater-value dl)))
         (repeat-unit (or (org-element-property :repeater-unit sc)
                          (org-element-property :repeater-unit dl)))
         (repeat-until (and sc-repeat-p (not dl-repeat-p) dl))
         (start
          (cond
           (sc)
           ((eq org-icalendar-todo-unscheduled-start 'current-datetime)
            (let ((now (decode-time)))
	      (list 'timestamp
		    (list :type 'active
			  :minute-start (nth 1 now)
			  :hour-start (nth 2 now)
			  :day-start (nth 3 now)
			  :month-start (nth 4 now)
			  :year-start (nth 5 now)))))
           ((or (and (eq org-icalendar-todo-unscheduled-start
                         'deadline-warning)
                     dl)
                (and (eq org-icalendar-todo-unscheduled-start
                         'recurring-deadline-warning)
                     dl-repeat-p))
            (let ((dl-raw (org-element-property :raw-value dl)))
              (with-temp-buffer
	        (insert dl-raw)
                (goto-char (point-min))
	        (org-timestamp-down-day (org-get-wdays dl-raw))
	        (org-element-timestamp-parser)))))))
    (concat "BEGIN:VTODO\n"
	    "UID:TODO-" uid "\n"
	    (org-icalendar-dtstamp) "\n"
            (when start (concat (org-icalendar-convert-timestamp
                                 start "DTSTART" nil timezone)
                                "\n"))
	    (when (and dl (not repeat-until))
	      (concat (org-icalendar-convert-timestamp
		       dl "DUE" nil timezone)
		      "\n"))
            ;; RRULE
            (cond
             ;; SCHEDULED, DEADLINE have different repeaters
             ((and dl-repeat-p
                   (not (and (eq repeat-value (org-element-property
                                               :repeater-value dl))
                             (eq repeat-unit (org-element-property
                                              :repeater-unit dl)))))
              ;; TODO Implement via RDATE with changing DURATION
              (org-display-warning "Not yet implemented: \
different repeaters on SCHEDULED and DEADLINE.  Skipping.")
              nil)
             ;; DEADLINE has repeater but SCHEDULED doesn't
             ((and dl-repeat-p (and sc (not sc-repeat-p)))
              ;; TODO SCHEDULED should only apply to first instance;
              ;; use RDATE with custom DURATION to implement that
              (org-display-warning "Not yet implemented: \
repeater on DEADLINE but not SCHEDULED.  Skipping.")
              nil)
             ((or sc-repeat-p dl-repeat-p)
              (concat
               (org-icalendar--rrule repeat-unit repeat-value)
               ;; add UNTIL part to RRULE
               (when repeat-until
                 (let* ((start-time
                         (org-element-property :minute-start start))
                        ;; RFC5545 requires UTC iff DTSTART is not local time
                        (local-time-p
                         (and (not timezone)
                              (equal org-icalendar-date-time-format
                                     ":%Y%m%dT%H%M%S")))
                        (encoded
                         (org-encode-time
                          0
                          (or (org-element-property :minute-start repeat-until)
                              0)
                          (or (org-element-property :hour-start repeat-until)
                              0)
                          (org-element-property :day-start repeat-until)
                          (org-element-property :month-start repeat-until)
                          (org-element-property :year-start repeat-until))))
                   (concat ";UNTIL="
                           (cond
                            ((not start-time)
                             (format-time-string "%Y%m%d" encoded))
                            (local-time-p
                             (format-time-string "%Y%m%dT%H%M%S" encoded))
                            ((format-time-string "%Y%m%dT%H%M%SZ"
                                                 encoded t))))))
               "\n")))
	    "SUMMARY:" summary "\n"
	    (and (org-string-nw-p location) (format "LOCATION:%s\n" location))
	    (and (org-string-nw-p class) (format "CLASS:%s\n" class))
	    (and (org-string-nw-p description)
		 (format "DESCRIPTION:%s\n" description))
	    "CATEGORIES:" categories "\n"
	    "SEQUENCE:1\n"
	    (format "PRIORITY:%d\n"
		    (let ((pri (or (org-element-property :priority entry)
				   org-priority-default)))
		      (floor (- 9 (* 8. (/ (float (- org-priority-lowest pri))
					   (- org-priority-lowest
					      org-priority-highest)))))))
	    (format "STATUS:%s\n"
		    (if (eq (org-element-property :todo-type entry) 'todo)
			"NEEDS-ACTION"
		      "COMPLETED"))
	    "END:VTODO\n")))

(defun org-icalendar--valarm (entry timestamp summary)
  "Create a VALARM component.

ENTRY is the calendar entry triggering the alarm.  TIMESTAMP is
the start date-time of the entry.  SUMMARY defines a short
summary or subject for the task.

Return VALARM component as a string, or nil if it isn't allowed."
  ;; Create a VALARM entry if the entry is timed.  This is not very
  ;; general in that:
  ;; (a) only one alarm per entry is defined,
  ;; (b) only minutes are allowed for the trigger period ahead of the
  ;;     start time,
  ;; (c) only a DISPLAY action is defined.                       [ESF]
  (let ((alarm-time
	 (let ((warntime
		(org-element-property :APPT_WARNTIME entry)))
	   (if warntime (string-to-number warntime) nil))))
    (and (or (and alarm-time
		  (> alarm-time 0))
	     (> org-icalendar-alarm-time 0)
	     org-icalendar-force-alarm)
	 (org-element-property :hour-start timestamp)
	 (format "BEGIN:VALARM
ACTION:DISPLAY
DESCRIPTION:%s
TRIGGER:-P0DT0H%dM0S
END:VALARM\n"
		 summary
                 (cond
                  ((and alarm-time org-icalendar-force-alarm) alarm-time)
                  ((and alarm-time (not (zerop alarm-time))) alarm-time)
                  (t org-icalendar-alarm-time))))))

;;;; Template

(defun org-icalendar-inner-template (contents _)
  "Return document body string after iCalendar conversion.
CONTENTS is the transcoded contents string."
  contents)

(defun org-icalendar-template (contents info)
  "Return complete document string after iCalendar conversion.
CONTENTS is the transcoded contents string.  INFO is a plist used
as a communication channel."
  (org-icalendar--vcalendar
   ;; Name.
   (if (not (plist-get info :input-file)) (buffer-name (buffer-base-buffer))
     (file-name-nondirectory
      (file-name-sans-extension (plist-get info :input-file))))
   ;; Owner.
   (if (not (plist-get info :with-author)) ""
     (org-export-data (plist-get info :author) info))
   ;; Timezone.
   (or (org-string-nw-p org-icalendar-timezone) (format-time-string "%Z"))
   ;; Description.
   (org-export-data (plist-get info :title) info)
   ;; TTL
   (plist-get info :icalendar-ttl)
   contents))

(defun org-icalendar--vcalendar (name owner tz description ttl contents)
  "Create a VCALENDAR component.
NAME, OWNER, TZ, DESCRIPTION, TTL and CONTENTS are all strings giving,
respectively, the name of the calendar, its owner, the timezone
used, a short description, time to live (refresh period) and
the other components included."
  (org-icalendar-fold-string
   (concat (format "BEGIN:VCALENDAR
VERSION:2.0
X-WR-CALNAME:%s
PRODID:-//%s//Emacs with Org mode//EN
X-WR-TIMEZONE:%s
X-WR-CALDESC:%s\n"
		   (org-icalendar-cleanup-string name)
		   (org-icalendar-cleanup-string owner)
		   (org-icalendar-cleanup-string tz)
		   (org-icalendar-cleanup-string description))
           (when ttl (format "X-PUBLISHED-TTL:%s\n"
                             (org-icalendar-cleanup-string ttl)))
           "CALSCALE:GREGORIAN\n"
	   contents
	   "END:VCALENDAR\n")))



;;; Interactive Functions

;;;###autoload
(defun org-icalendar-export-to-ics
    (&optional async subtreep visible-only body-only)
  "Export current buffer to an iCalendar file.

If narrowing is active in the current buffer, only export its
narrowed part.

If a region is active, export that region.

A non-nil optional argument ASYNC means the process should happen
asynchronously.  The resulting file should be accessible through
the `org-export-stack' interface.

When optional argument SUBTREEP is non-nil, export the sub-tree
at point, extracting information from the headline properties
first.

When optional argument VISIBLE-ONLY is non-nil, don't export
contents of hidden elements.

When optional argument BODY-ONLY is non-nil, only write code
between \"BEGIN:VCALENDAR\" and \"END:VCALENDAR\".

Return ICS file name."
  (interactive)
  (let ((file (buffer-file-name (buffer-base-buffer))))
    (when (and file org-icalendar-store-UID)
      (org-icalendar-create-uid file 'warn-user)))
  ;; Export part.  Since this backend is backed up by `ascii', ensure
  ;; links will not be collected at the end of sections.
  (let ((outfile (org-export-output-file-name ".ics" subtreep)))
    (org-export-to-file 'icalendar outfile
      async subtreep visible-only body-only
      '(:ascii-charset utf-8 :ascii-links-to-notes nil)
      #'org-icalendar--post-process-file)))

;;;###autoload
(defun org-icalendar-export-agenda-files (&optional async)
  "Export all agenda files to iCalendar files.
When optional argument ASYNC is non-nil, export happens in an
external process."
  (interactive)
  (if async
      ;; Asynchronous export is not interactive, so we will not call
      ;; `org-check-agenda-file'.  Instead we remove any non-existent
      ;; agenda file from the list.
      (let ((files (cl-remove-if-not #'file-exists-p (org-agenda-files t))))
	(org-export-async-start
	    (lambda (results)
	      (dolist (f results) (org-export-add-to-stack f 'icalendar)))
	  `(let (output-files)
	     (dolist (file ',files outputfiles)
	       (with-current-buffer (org-get-agenda-file-buffer file)
		 (push (expand-file-name (org-icalendar-export-to-ics))
		       output-files))))))
    (let ((files (org-agenda-files t)))
      (org-agenda-prepare-buffers files)
      (unwind-protect
	  (dolist (file files)
	    (catch 'nextfile
	      (org-check-agenda-file file)
	      (with-current-buffer (org-get-agenda-file-buffer file)
		(condition-case err
                    (org-icalendar-export-to-ics)
                  (error
                   (warn "Exporting %s to icalendar failed: %s"
                         file
                         (error-message-string err))
                   (signal (car err) (cdr err)))))))
	(org-release-buffers org-agenda-new-buffers)))))

;;;###autoload
(defun org-icalendar-combine-agenda-files (&optional async)
  "Combine all agenda files into a single iCalendar file.

A non-nil optional argument ASYNC means the process should happen
asynchronously.  The resulting file should be accessible through
the `org-export-stack' interface.

The file is stored under the name chosen in
`org-icalendar-combined-agenda-file'."
  (interactive)
  (if async
      (let ((files (cl-remove-if-not #'file-exists-p (org-agenda-files t))))
	(org-export-async-start
	    (lambda (_)
	      (org-export-add-to-stack
	       (expand-file-name org-icalendar-combined-agenda-file)
	       'icalendar))
	  `(apply #'org-icalendar--combine-files ',files)))
    (apply #'org-icalendar--combine-files (org-agenda-files t))))

(defun org-icalendar-export-current-agenda (file)
  "Export current agenda view to an iCalendar FILE.
This function assumes major mode for current buffer is
`org-agenda-mode'."
  (let* ((org-export-use-babel)		;don't evaluate Babel blocks
	 (contents
	  (org-export-string-as
	   (with-output-to-string
	     (save-excursion
	       (let ((p (point-min))
		     (seen nil))	;prevent duplicates
		 (while (setq p (next-single-property-change p 'org-hd-marker))
		   (let ((m (get-text-property p 'org-hd-marker)))
		     (when (and m (not (member m seen)))
		       (push m seen)
		       (with-current-buffer (marker-buffer m)
			 (org-with-wide-buffer
			  (goto-char (marker-position m))
			  (princ
			   (org-element-normalize-string
			    (buffer-substring (point)
					      (org-entry-end-position))))))))
		   (forward-line)))))
	   'icalendar t
	   '(:ascii-charset utf-8 :ascii-links-to-notes nil
			    :icalendar-include-todo all))))
    (with-temp-file file
      (insert
       (org-icalendar--vcalendar
	org-icalendar-combined-name
	user-full-name
	(or (org-string-nw-p org-icalendar-timezone) (format-time-string "%Z"))
	org-icalendar-combined-description
	org-icalendar-ttl
	contents)))
    (org-icalendar--post-process-file file)))

(defun org-icalendar--combine-files (&rest files)
  "Combine entries from multiple files into an iCalendar file.
FILES is a list of files to build the calendar from."
  ;; At the end of the process, all buffers related to FILES are going
  ;; to be killed.  Make sure to only kill the ones opened in the
  ;; process.
  (let ((org-agenda-new-buffers nil))
    (unwind-protect
	(progn
	  (with-temp-file org-icalendar-combined-agenda-file
	    (insert
	     (org-icalendar--vcalendar
	      ;; Name.
	      org-icalendar-combined-name
	      ;; Owner.
	      user-full-name
	      ;; Timezone.
	      (or (org-string-nw-p org-icalendar-timezone)
		  (format-time-string "%Z"))
	      ;; Description.
	      org-icalendar-combined-description
	      ;; TTL (Refresh period)
	      org-icalendar-ttl
	      ;; Contents.
	      (concat
	       ;; Agenda contents.
	       (mapconcat
		(lambda (file)
		  (catch 'nextfile
		    (org-check-agenda-file file)
		    (with-current-buffer (org-get-agenda-file-buffer file)
		      ;; Create ID if necessary.
		      (when org-icalendar-store-UID
			(org-icalendar-create-uid file t))
		      (org-export-as
		       'icalendar nil nil t
		       '(:ascii-charset utf-8 :ascii-links-to-notes nil)))))
		files "")
	       ;; BBDB anniversaries.
	       (when (and org-icalendar-include-bbdb-anniversaries
			  (require 'ol-bbdb nil t))
		 (with-output-to-string (org-bbdb-anniv-export-ical)))))))
	  (org-icalendar--post-process-file org-icalendar-combined-agenda-file))
      (org-release-buffers org-agenda-new-buffers))))


(provide 'ox-icalendar)

;; Local variables:
;; generated-autoload-file: "org-loaddefs.el"
;; End:

;;; ox-icalendar.el ends here
