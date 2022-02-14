;;; tools/gtd/init.el -*- lexical-binding: t; -*-

(defvar gtd/project-list-roots nil
  "Paths to the roots of the different project file lists.")

(defvar gtd/project-list-root 'uninitialized
  "Path to the current root of the project file lists.")

(setq
 gtd/task-todo "☛ TODO"
 gtd/task-next "⯮ NEXT"
 gtd/task-waiting "⚑ WAIT"
 gtd/task-done "✔ DONE"
 gtd/task-cancelled "✘ CANC")
