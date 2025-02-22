;auctex conf
(setq Tex-auto-save t)
(setq Tex-parse-self t)
(setq-default Tex-master nil)

(add-hook 'LaTeX-mode-hook (lambda()
(turn-off-auto-fill)
(linum-mode 1)
(LaTeX-math-mode 1)
(auto-complete-mode 1)
(setq TeX-fold-env-spec-list
      (quote ("[figure]" ("figure"))
	     ("[table]" ("table"))
	     ("[itemize]" ("itemize"))
	     ("overpic" ("overpic"))
       )
     )
(setq TeX-view-program-list
      '(
	;;("Sumatra PDF" (" \"E:/SumatraPDF/SumatraPDF.exe\" -reuse-instance" (mode-io-correlate " -forward-search %b %n ") " %o"))
	("Sumatra PDF" ("E:/SumatraPDF/SumatraPDF.exe %o"))
	("zathura" "zathura %o")
	))
      ;;'(("zathura" "zathura %o"))

(setq TeX-view-program-selection '((output-pdf "zathura")))
(setq TeX-clean-confirm nil)
))

;;cdlatex配置
(add-hook 'LaTeX-mode-hook 'turn-on-cdlatex)
(autoload 'cdlatex-mode "cdlatex" "CDLaTeX Mode" t)
(autoload 'turn-on-cdlatex "cdlatex" "CDLaTeX Mode" nil)

(add-hook 'LaTeX-mode-hook (lambda()
(add-to-list 'TeX-command-list '("XeLaTeX" "%`xelatex%(mode)%' %t" TeX-run-TeX nil t))
(setq TeX-command-default "XeLaTeX")
(setq TeX-save-query  nil )
(setq TeX-show-compilation t)
))


(provide 'Latex)
