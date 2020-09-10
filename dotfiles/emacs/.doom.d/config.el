;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Guilherme Grochau Azzi"
      user-mail-address "g.grochauazzi@tu-berlin.de")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.


;; My GTD and Zettelkasten config

(setq! gtd/project-list-roots
       '("~/tubCloud/GTD/work-projects.lst"
         "~/Dropbox/gtd/personal-projects.lst")
       org-roam-directory "~/Dokumente/Zettelkasten"
       org-roam-tag-sources '(prop all-directories)
       org-roam-tag-sort t)

(setq org-roam-capture-templates
      '(("d" "default" plain (function org-roam--capture-get-point)
         "%?"
         :file-name "Inbox/%<%Y%m%d%H%M%S>-${slug}"
         :head "#+title: ${title}\n"
         :unnarrowed t)
        ("f" "forschung" plain (function org-roam--capture-get-point)
         "%?"
         :file-name "Forschung/%<%Y%m%d%H%M%S>-${slug}"
         :head "#+title: ${title}\n"
         :unnarrowed t)
        ("l" "lehre" plain (function org-roam--capture-get-point)
         "%?"
         :file-name "Lehre/%<%Y%m%d%H%M%S>-${slug}"
         :head "#+title: ${title}\n"
         :unnarrowed t)
        ("o" "Orga" plain (function org-roam--capture-get-point)
         "%?"
         :file-name "Orga/%<%Y%m%d%H%M%S>-${slug}"
         :head "#+title: ${title}\n"
         :unnarrowed t))
      org-roam-dailies-capture-templates
      '(("d" "default" plain (function org-roam--capture-get-point)
         "%?"
         :file-name "Dailies/%<%Y-%m-%d>"
         :head "#+title: %<%Y-%m-%d>\n"
         :unnarrowed t)))


;; Some defaults I like better

(setq-default
 delete-by-moving-to-trash t                      ; Delete files to trash
 fill-column 90                                   ; Set width for automatic line breaks
 indent-tabs-mode nil                             ; Stop using tabs to indent
 scroll-margin 10                                 ; Always leave some lines between cursor and top/bottom of the view
 tab-width 4)                                     ; Set width for tabs

(global-subword-mode 1)                          ; Split subwords when moving


;; I like to navigate between windows with =C-x <arrow>'
(global-set-key (kbd "C-x <left>") #'windmove-left)
(global-set-key (kbd "C-x <right>") #'windmove-right)
(global-set-key (kbd "C-x <down>") #'windmove-down)
(global-set-key (kbd "C-x <up>") 'windmove-up)
(global-set-key (kbd "C-x o") nil)

;; Use the "universal" shortcuts for undoing and redoing
(after! undo-fu
  (global-set-key (kbd "C-z") #'undo-fu-only-undo)
  (global-set-key (kbd "C-_") nil)
  (global-set-key (kbd "C-/") nil)
  (global-set-key (kbd "C-S-z") #'undo-fu-only-redo)
  (global-set-key (kbd "M-_") nil))

;; Use swiper for the default search
(after! swiper
  (global-set-key (kbd "C-s") #'swiper))

;; Use ctrl+arrows to navigate the text
(global-set-key (kbd "C-<left>") #'left-word)
(global-set-key (kbd "C-<right>") #'right-word)
(global-set-key (kbd "C-<up>") #'previous-logical-line)
(global-set-key (kbd "C-<down>") #'next-logical-line)

  (after! smartparens
    (undefine-key! smartparens-mode-map "C-<left>" "C-<right>" "C-<up>" "C-<down>"))

  ;; I dislike the inconsistency between =C-w= in Emacs and bash.  Set =C-w= to
  ;; behave like bash, killing backward to the beginning of a word.  Also make =C-k=
  ;; kill the region, if active---otherwise the line is killed, as in the default
  ;; behaviour.  Note that some modes will have their own variants of =kill-line=
  ;; mapped to =C-k=, and those modes should call =me/bind-kill-region-or-line= in
  ;; their configuration.

  (defmacro alternate-keybindings/bind-kill-region-or-line (key-map kill-line kill-region)
    "Define and bind a function that kills the region, if active, or the line.
   The defined function will interactively call 'KILL-REGION' when
   the region is currently active, or 'KILL-LINE' otherwise.  It
   will also be bound to 'C-k' in the given 'KEY-MAP'."
    (let ((kill-region-or-line
           (intern (format "%s-or-%s" kill-region kill-line))))
      `(progn
         (defun ,kill-region-or-line ()
           ,(format
             "Kill the region if active, otherwise kill the current line.
   See also '%s' and '%s'."
             kill-region
             kill-line)
           (interactive)
           (if (region-active-p)
               (call-interactively ',kill-region)
             (call-interactively ',kill-line)))
         (define-key ,key-map (kbd "C-k") #',kill-region-or-line))))

  (global-set-key (kbd "C-w") 'backward-kill-word)
  (alternate-keybindings/bind-kill-region-or-line global-map kill-line kill-region)
  (after! org
    (alternate-keybindings/bind-kill-region-or-line org-mode-map org-kill-line kill-region))


;; I don't want to use C-c C-c on org-mode code blocks
(after! org (undefine-key! org-src-mode-map "C-c C-c"))
