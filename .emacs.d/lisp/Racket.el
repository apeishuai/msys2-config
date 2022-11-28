(add-to-list 'exec-path "/bin/")
(setq racket-racket-program "racket")
(add-hook 'racket-mode-hook
          (lambda ()
            (define-key racket-mode-map (kbd "C-x C-j") 'racket-run)))
(setq tab-always-indent 'complete) ;; 使用tab自动补全

(provide 'Racket)
