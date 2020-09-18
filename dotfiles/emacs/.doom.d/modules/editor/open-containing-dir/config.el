;;; editor/open-containing-dir/config.el -*- lexical-binding: t; -*-

(defvar external-file-manager "xdg-open"
  "Process that should be called to open an external file manager.")

(defun open-containing-dir ()
  "Open the containing directory of the current buffer in a file manager.

Uses the executable `external-file-manager' to call an external file manager.
If the current mode is dired, opens the current directory and not its parent."
  (interactive)
  (let ((dir (cond
              ((not (buffer-file-name)) nil)
              ((eq major-mode 'dired-mode) (buffer-file-name))
              (t (file-name-directory (buffer-file-name))))))
    (when dir
      (start-process "external-file-manager"
                     "*external-file-manager*"
                     external-file-manager dir))))

(map! :leader "f d" #'open-containing-dir)
