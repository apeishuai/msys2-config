;;proxy set
(setq url-proxy-services
   '(("no_proxy" . "^\\(localhost\\|10.*\\)")
	     ("http" . "127.0.0.1:1082")
	     ("https" . "127.0.0.1:1082")))

(setq warning-minimum-level :emergency)

;;picture-show
(require 'org-download)
(add-hook 'dired-mode-hook 'org-download-enable)

;;reload init file
(defun reload-init-file ()
  (interactive)
  (load-file user-init-file))
(global-set-key (kbd "C-c C-r C-i") 'reload-init-file)

(blink-cursor-mode 0)

;;环境变量设置
(setq default-directory "/media/root/wxf files/emacs-notes/")
(when (memq window-system '(w32))
  (setq default-directory "g:/area/emacs-notes/")
  )

(setq config-directory "~/.emacs.d/lisp/")
(setenv "notes-home" "/media/root/wxf files/emacs-notes/")
(when (memq window-system '(w32))
  (setenv "notes-home" "g:/area/emacs-notes/")
  )

(setenv "PATH"
	(concat
	 ;"" ";"
	 "g:/area/emacs-notes" ";"
	 "e:/Snipaste-2.7.3-Beta-x64" ";"
	 (getenv "PATH")
	 )
	)

;; 路径设置
(add-to-list 'load-path "~/htmlize")
(add-to-list 'auto-mode-alist '("\\.rkt\\'" . racket-mode))

(tool-bar-mode -1)
(scroll-bar-mode -1)

(setq inhibit-startup-screen t)
(auto-image-file-mode t)
(tool-bar-mode 0)
(menu-bar-mode 0)


(add-hook 'org-mode-hook (lambda () (setq truncate-lines nil))) 
(add-hook 'window-setup-hook 'toggle-frame-maximized)

(defun org-toggle-iimage-in-org ()
  "display images in your org file"
  (interactive)
  (if (face-underline-p 'org-link)
      (set-face-underline-p 'org-link nil)
      (set-face-underline-p 'org-link t))
  (iimage-mode))


(add-to-list 'default-frame-alist
             '(font . "DejaVu Sans Mono-16"))

(defun position-to-kill-ring ()
  "Copy to the kill ring a string in the format \"file-name:line-number\"
for the current buffer's file name, and the line number at point."
  (interactive)
  (kill-new
   (format "%s:%d" (buffer-file-name) (save-restriction
                                        (widen) (line-number-at-pos)))))

(define-key global-map (kbd "C-c p") 'position-to-kill-ring)
(define-key global-map (kbd "C-c m") 'position-to-kill-ring)

(autoload 'ledger-mode "ledger-mode" "A major mode for Ledger" t)
(add-to-list 'auto-mode-alist '("\\.ledger$" . ledger-mode))


;;open link using google-chrome
(setq browse-url-generic-program
       (executable-find "google-chrome"))


;;winum (windows)
(setq window-numbering-assign-func
      (lambda () (when (equal (buffer-name) "*Calculator*") 9)))


(provide 'StartUp)


