;;; tools/gtd/config.el -*- lexical-binding: t; -*-


;;
;;; Managing project lists

(defun gtd--get-project-list-root ()
  (when (eq gtd/project-list-root 'uninitialized)
    (setq gtd/project-list-root
          (if gtd/project-list-roots
              (car gtd/project-list-roots)
            nil)))
  gtd/project-list-root)


(defun gtd/switch-project-root (project-root)
  (interactive
   (list (ivy-read "Project root: " gtd/project-list-roots)))
  (setq gtd/project-list-root project-root)
  (gtd/reload-project-list))


(defun gtd/reload-project-list ()
  "Reload list of project files.

  Load them from the current project-list-root and add set
  corresponding project files to org-refile-targets and
  org-agenda-files."
  (interactive)
  (if (gtd--get-project-list-root)
      (setq org-agenda-files
            (gtd--flatten-project-file-tree
             (gtd--resolve-project-files gtd/project-list-root)))))


(defun gtd/project-file-tree ()
  "Print a tree of GTD project files to a particular buffer"
  (interactive)
  (if (gtd--get-project-list-root)
      (progn
        (switch-to-buffer (get-buffer-create "*gtd-project-file-tree*"))
        (erase-buffer)
          (org-mode)
          (gtd--print-project-file-tree (gtd--resolve-project-files gtd/project-list-root)))
      (message "No GTD project root!")))

(defun gtd--print-project-file-tree (node &optional indent)
  (insert (or indent "") "- [[file:" (cdar node) "][" (caar node) "]]\n")
  (let ((new-indent (concat "  " (or indent ""))))
    (mapc (lambda (child) (gtd--print-project-file-tree child new-indent)) (cdr node))))

(defun gtd--flatten-project-file-tree (node)
  (if (null (cdr node))
      (list (cdar node))
    (mapcan 'gtd--flatten-project-file-tree (cdr node))))

(defun gtd--resolve-project-files (project-or-list-file &optional root-dir)
  "Given an org, lst or elst file, resolve it into a tree of org files."
  (let* (
         (file (file-truename (expand-file-name project-or-list-file root-dir)))
         (extension (file-name-extension file)))
    (cons (cons project-or-list-file file)
          (cond
           ((string= extension "lst") (gtd--resolve-project-list-file file))
           ((string= extension "elst") (gtd--resolve-project-list-file file))
           (t nil)))))

(defun gtd--resolve-project-list-file (list-file)
  (let ((root-dir (file-truename (file-name-directory list-file))))
    (mapcar (lambda (file)
              (gtd--resolve-project-files file root-dir))
            (gtd--read-project-list-file list-file))))

(defun gtd--read-project-list-file (file)
  (condition-case err
      (with-temp-buffer
        (insert-file-contents file)
        (cond
         ((string= (file-name-extension file) "lst")
          (split-string (buffer-string) "\n" t))
         ((string= (file-name-extension file) "elst")
          (eval (read (current-buffer))))))
    (error
     (message "Failed reading project list file '%s:\n%s"
              file
              (error-message-string err))
     nil)))


(after! org (gtd/reload-project-list))



;;
;;; Tasks

(after! org

  ;; HACK Face specs fed directly to `org-todo-keyword-faces' don't respect
  ;;      underlying faces like the `org-todo' face does, so we define our own
  ;;      intermediary faces that extend from org-todo.
  (with-no-warnings
    (custom-declare-face '+org-todo-active  '((t (:inherit (bold font-lock-constant-face org-todo)))) "")
    (custom-declare-face '+org-todo-onhold  '((t (:inherit (bold warning org-todo)))) ""))

  (setq org-todo-keywords
        `((sequence
           ,(concat gtd/task-todo "(t!)")
           ,(concat gtd/task-next "(n!)")
           ,(concat gtd/task-waiting "(w!)")
           "|"
           ,(concat gtd/task-done "(d!)")
           ,(concat gtd/task-cancelled "(c!)")))
        org-todo-keyword-faces
        '((,gtd/task-todo . +org-todo-active)
          (,gtd/task-next . +org-todo-active)
          (,gtd/task-waiting . +org-todo-onhold))
        org-highest-priority ?A
        org-lowest-priority ?C
        org-default-priority ?C)

  (add-to-list 'org-global-properties
               '("Effort_ALL" . "0:10 0:30 1:00 2:00 4:00 8:00 16:00"))

  (setq!
   org-log-done 'time               ; Record completion time for tasks
   org-log-reschedule 'time         ; Record time when task was rescheduled
   org-log-into-drawer "LOGBOOK"    ; Write the log into a drawer
   org-return-follows-link t        ; Use <return> to follow links
   org-enforce-todo-dependencies t  ; Make sure subtasks are completed before supertask
   org-startup-folded 'content      ; Show all headings on startup, but not their content
   org-ellipsis " ⤵")               ; Use a prettier character for folded sections

  (use-package! org-sticky-header
    :custom
    (org-sticky-header-full-path 'full)
    (org-sticky-header-outline-path-separator " › ")
    (org-sticky-header-prefix "› ")
    (org-sticky-header-heading-star "")

    :hook
    (org-mode . org-sticky-header-mode))

  (custom-set-faces
   '(org-level-1 ((t (:overline t))))
   '(org-level-2 ((t (:overline t)))))

  (use-package! org-edna)
  (org-edna-load))

(defun gtd/add-task-icons ()
  (interactive)
  (save-excursion
    (mapcar
     (lambda (task-status)
       (let ((with-icon (car task-status)))
         (mapcar (lambda (without-icon)
                   (progn
                     (goto-char (point-min))
                     (let ((from-str (concat "* " without-icon " "))
                           (to-str (concat "* " with-icon " ")))
                       (while (search-forward from-str nil t)
                         (replace-match to-str nil t)))))
                 (cdr task-status))))
     `((,gtd/task-todo . ("TODO"))
       (,gtd/task-next . ("NEXT"))
       (,gtd/task-waiting . ("WAITING" "WAIT"))
       (,gtd/task-done . ("DONE"))
       (,gtd/task-cancelled . ("CANCELLED" "CANC"))))))



;;
;;; Projects and Someday/Maybe

(after! org
  (if (not (boundp 'org-tags-exclude-from-inheritance))
      (setq org-tags-exclude-from-inheritance nil))
  (add-to-list 'org-tags-exclude-from-inheritance "PROJ")

  (setq org-tag-alist '((:startgroup)
                        ("PROJ" . ?P)
                        ("DONE_PROJ" . ?D)
                        ("PAUSED_PROJ")
                        (:endgroup)
                        (:newline)
                        ("SOMEDAY_MAYBE" . ?S))))



 ;;
 ;;; Agenda Views

(after! org
  (global-set-key (kbd "C-c a") 'org-agenda)

  (setq org-agenda-dim-blocked-tasks t
        org-agenda-skip-deadline-prewarning-if-scheduled t
        org-agenda-ignore-properties '(appt)
        org-agenda-compact-blocks nil
        org-agenda-block-separator ""   ; Remove the ugly separator between blocks, we'll set an overlined face
        )
  (custom-set-faces '(org-agenda-structure ((t (:overline t)))))

  (defun +define-agenda (key &rest args)
    (progn
      (setq org-agenda-custom-commands
            (if (boundp 'org-agenda-custom-commands)
                (seq-filter (lambda (comm) (not (string= (car comm) key))) org-agenda-custom-commands)
              nil))
      (add-to-list 'org-agenda-custom-commands (cons key args))))

  (setq-default org-agenda-overriding-columns-format
                "%CATEGORY %60ITEM %TODO %PRIORITY(PRI) %Effort{:} %CLOCKSUM(Time){:} %TAGS")

  (use-package! org-ql)

  (+define-agenda "n" "Next Actions"
                  `((agenda "" ((org-agenda-span 1) (org-deadline-warning-days 7)))

                    (org-ql-block '(and (todo ,gtd/task-next) (priority "A"))
                                  ((org-ql-block-header "Most Important/Urgent Actions for Today")))

                    (org-ql-block '(and (todo ,gtd/task-next) (priority "B"))
                                  ((org-ql-block-header "Next Actions for the Week")))

                    (org-ql-block '(and (todo ,gtd/task-next) (or (priority < "B") (not (priority))))
                                  ((org-ql-block-header "Next Actions")))

                    (org-ql-block '(todo ,gtd/task-waiting)
                                  ((org-ql-block-header "Waiting For")))))
  (+define-agenda "d" "Daily Review"
                  `((agenda)

                    (org-ql-block '(todo ,gtd/task-waiting)
                                  ((org-ql-block-header "Waiting For")))

                    (org-ql-block '(closed :on today)
                                  ((org-ql-block-header "Completed Today")))

                    (org-ql-block '(and (todo ,gtd/task-next) (not (tags)))
                                  ((org-ql-block-header "Untagged Next Actions")))

                    (org-ql-block '(and (todo ,gtd/task-next) (tags "DONE_PROJ" "SUSPENDED_PROJ"))
                                  ((org-ql-block-header "Zombie Actions")))

                    (org-ql-block '(tags "WEEK_GOAL")
                                  ((org-ql-block-header "Goals for the Week")))

                    (org-ql-block '(and (todo ,gtd/task-next) (priority "A"))
                                  ((org-ql-block-header "Most Important/Urgent Actions for Today")))

                    (org-ql-block '(and (todo ,gtd/task-next) (priority "B"))
                                  ((org-ql-block-header "Next Actions for the Week")))

                    (org-ql-block '(and (todo ,gtd/task-next) (or (priority < "B") (not (priority))))
                                  ((org-ql-block-header "Next Actions")))))

  (+define-agenda "w" "Weekly Review"
                  `((agenda)

                    (org-ql-block '(and (tags-local "PROJ")
                                        (not (descendants (or (todo ,gtd/task-next ,gtd/task-waiting)
                                                              (and (todo ,gtd/task-todo) (or (deadline) (scheduled)))))))
                                  ((org-ql-block-header "Stuck Projects")))

                    (org-ql-block '(and (tags-local "PROJ")
                                        (descendants (or (todo ,gtd/task-next ,gtd/task-waiting)
                                                         (and (todo ,gtd/task-todo) (or (deadline) (scheduled))))))
                                  ((org-ql-block-header "Ongoing Projects")))

                    (org-ql-block '(tags-local "SUSPENDED_PROJ")
                                  ((org-ql-block-header "Suspended Projects")))

                    (org-ql-block '(tags-local "SOMEDAY_MAYBE")
                                  ((org-ql-block-header "Someday/Maybe"))))))
