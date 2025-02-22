(require 'ivy)

(defun my-find-file-internal(directory &optional grep-p git-grep-p)
  "Find file in DIRECTORY
If GREP-P is t, grep files
If GREP-P is nil, find files"

  (let* ((keyword (read-string "please input keyword: ")))
    (when (and keyword (not (string= keyword "")))
      (let* (
	     (find-cmd (format "find . -path \"*/.git\" -prune -o  -type f -iname \"*%s*\" -print" keyword))
	     (git-find-cmd-fmt (if git-grep-p "git ls-files --full-name -- \"*%s*\"" "find . -path \"*/.git\" -prune -o  -type f -iname \"*%s*\" -print"))
	     (find-cmd (format git-find-cmd-fmt keyword))
	     (grep-cmd (format "grep --exclude-dir=\"*/.git\" -rns \"%s\" *" keyword))
	     (git-cmd-fmt (if git-grep-p "git grep -n \"%s\"" "grep --exclude-dir=\"*/.git\" -rns \"%s\" *"))
	     (grep-cmd (format git-cmd-fmt keyword))

	   (default-directory directory)
	   (output (shell-command-to-string (if grep-p grep-cmd find-cmd)))
	   (lines (split-string output "[\n\r]+"))
	   (hint (if grep-p "Grep file in %s: " "Find file in %s: "))
	   selected-line
	   selected-file
	   linenum)
	(setq selected-line (ivy-read (format hint default-directory)lines))
	(cond
	 (grep-p
	  (when (string-match "^\\([^:]*\\):\\([0-9]*\\):" selected-line)
	    (setq selected-file (match-string 1 selected-line))
	    (setq linenum (match-string 2 selected-line))))
	 (t
	  (setq selected-file selected-line)))

      (when (and selected-file(file-exists-p selected-file))
	(find-file selected-file)
	(when grep-p
	(goto-char (point-min))
	(forward-line (1- (string-to-number  linenum)))))))))


(defun my-git-search-text-in-project()
  "Search text of file in project root directory"
  (interactive)
  (my-find-file-internal (locate-dominating-file default-directory ".git" )t t))

(defun my-search-text-in-project()
  "Search text of file in project root directory"
  (interactive)
  (my-find-file-internal (locate-dominating-file default-directory ".git" )t))


(defun my-search-text(&optional level)
  "Search text of file in current directory or level parent directory"
  (interactive "P")
  (unless level (setq level 0))
  (message "level = %s" level)
  ;;default-directory
  (let* ((parent-directory default-directory)
	 (i 0))
    (while (< i level)
      (setq parent-directory
	    (file-name-directory (directory-file-name parent-directory)))
      (setq i (+ i 1)))
  (my-find-file-internal parent-directory t)))

(defun my-git-find-file-in-project()
  "Grep find file in project root directory"
  (interactive)
  (my-find-file-internal (locate-dominating-file default-directory ".git")nil t))

(defun my-find-file-in-project()
  "Find file in project root directory"
  (interactive)
  (my-find-file-internal (locate-dominating-file default-directory ".git")))

(defun my-find-file(&optional level)
  "Find file in current directory or level parent directory"
  (interactive "P")
  (unless level (setq level 0))
  (message "level = %s" level)
  ;;default-directory
  (let* ((parent-directory default-directory)
	 (i 0))
    (while (< i level)
      (setq parent-directory
	    (file-name-directory (directory-file-name parent-directory)))
      (setq i (+ i 1)))
  (my-find-file-internal parent-directory)))

(provide 'my-find-file)
