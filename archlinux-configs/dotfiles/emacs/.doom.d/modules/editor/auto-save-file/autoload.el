;;; editor/auto-save-file/autoload.el -*- lexical-binding: t; -*-

;;;###autoload
(define-minor-mode auto-save-file-mode
  "Auto-save the file with its current name, and also auto-revert."
  :init-value nil
  :lighter "ASav"
  (auto-save-to-actual-file)
  (auto-save-mode (if auto-save-file-mode +1 -1))
  (auto-revert-mode (if auto-save-file-mode +1 -1))
  (add-hook 'after-save-hook #'me/auto-save-to-actual-file t t))

;;;###autoload
(defun auto-save-to-actual-file ()
  "Ensure that auto-saving will overwrite the actual file instead of using a different file."
  (unless (and (stringp buffer-file-name)
               (file-exists-p buffer-file-name))
    (error "Can only auto-save to the actual file if the buffer corresponds to an existing file."))
  (setq buffer-auto-save-file-name buffer-file-name))
