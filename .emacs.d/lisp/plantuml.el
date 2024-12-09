;; active Org-babel languages
(org-babel-do-load-languages
 'org-babel-load-languages
 '(;; other Babel languages
   (plantuml . t)))

(setq org-plantuml-jar-path
      (expand-file-name "D:/softwares/msys64/home/whens/Shell/bin/plantuml.jar"))

(provide 'plantuml)
