(org-babel-tangle-file "config.org" "config.el")
(byte-compile-file "config.el")
(load-file "config.el")
