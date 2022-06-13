;; [[file:config.org::*Allow babel execution in CLI actions][Allow babel execution in CLI actions:1]]
(setq org-confirm-babel-evaluate nil)

(defun babel-shut-up-a (orig-fn &rest args)
  (quiet! (apply orig-fn args)))

(advice-add 'org-babel-execute-src-block :around #'babel-shut-up-a)
;; Allow babel execution in CLI actions:1 ends here
