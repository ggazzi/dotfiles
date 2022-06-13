;;; config.el -*- lexical-binding: t; -*-

;; [[file:config.org::*Personal information][Personal information:1]]
(setq user-full-name "Guilherme Grochau Azzi"
      user-mail-address "g.grochauazzi@tu-berlin.de")
;; Personal information:1 ends here

;; [[file:config.org::*Better defaults][Better defaults:1]]
(setq-default
 delete-by-moving-to-trash t         ; Delete files to trash instead of permanently
 window-combination-resize t         ; When resizing the frame, resize all windows (not just current)
 x-stretch-cursor t                  ; Stretch cursor to glyph width
 fill-column 90                      ; I like 90-char width lines
 indent-tabs-mode nil                ; Stop using tabs!
 tab-width 4                         ; Use 4-space indents by default (in some languages I override it)
 sentence-end-double-space t)        ; I like using double spaces after the end of a sentence


(setq auto-save-default t            ; Plase don't lose my work.
      truncate-string-ellipsis "…"   ; Unicode is cute and compact 😀
      scroll-margin 10)              ; Maintain a generous margin. As Tim Minchin illustrated nicely, context is important.

(global-subword-mode 1)              ; Navigate through camelCase and snake_case words
;; Better defaults:1 ends here

;; [[file:config.org::*Auto-customisations][Auto-customisations:1]]
(setq-default custom-file (expand-file-name ".custom.el" doom-private-dir))
(when (file-exists-p custom-file)
  (load custom-file))
;; Auto-customisations:1 ends here

;; [[file:config.org::#asynchronous-config-tangling][Asynchronous config tangling:1]]
(defadvice! +literate-tangle-async-h ()
  "A very simplified version of `+literate-tangle-h', but async."
  :override #'+literate-tangle-h
  (let ((default-directory doom-private-dir)
        (curr-window (frame-selected-window)))
    (start-process "tangle-config"
                   "*tangling config.org*"
                   "emacs"
                   "--batch"
                   "--eval"
                   (format "(progn \
                             (require 'org) \
                             (setq org-confirm-babel-evaluate nil) \
                             (org-babel-tangle-file \"%s\"))"
                           +literate-config-file))
    (display-buffer "*tangling config.org*")
    (with-current-buffer "*tangling config.org*"
      (goto-char (point-max)))
    (select-window curr-window)))
;; Asynchronous config tangling:1 ends here

;; [[file:config.org::*Theme and Modeline][Theme and Modeline:1]]
(setq doom-theme 'doom-vibrant)
;; Theme and Modeline:1 ends here

;; [[file:config.org::*Theme and Modeline][Theme and Modeline:2]]
(custom-set-faces!
  '(doom-modeline-buffer-modified :foreground "orange"))
;; Theme and Modeline:2 ends here

;; [[file:config.org::*Font Faces][Font Faces:1]]
(setq doom-font (font-spec :family "Fira Code" :size 15)
      doom-big-font (font-spec :family "Fira Code" :size 25 :weight 'regular)

      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 16 :weight 'light)
      doom-unicode-font (font-spec :family "Fira Code")
      doom-serif-font (font-spec :family "Noto Serif")
      )
;; Font Faces:1 ends here

;; [[file:config.org::*Font Faces][Font Faces:2]]
;; No missing fonts detected
;; Font Faces:2 ends here

;; [[file:config.org::*Mixed pitch][Mixed pitch:2]]
(use-package! mixed-pitch)

(defvar mixed-pitch-modes '()
  "Modes that `mixed-pitch-mode' should be enabled in, but only after UI initialisation.")

(setq mixed-pitch-modes--loaded nil)

(defun mixed-pitch-register-mode (mode-name)
  "Hook `mixed-pitch-mode' into the mode with give `mode-name'.
Also immediately enables `mixed-pitch-mode' if currently in one of the modes."
  (when (eq major-mode mode-name)
    (mixed-pitch-mode 1))
  (unless (memq mode-name mixed-pitch-modes)
    (when mixed-pitch-modes--loaded
      (add-hook (intern (concat (symbol-name mode-name) "-hook")) #'mixed-pitch-mode))
    (add-to-list 'mixed-pitch-modes mode-name)))

(defun init-mixed-pitch-h ()
    "Hook `mixed-pitch-mode' into each mode in `mixed-pitch-modes'.
Also immediately enables `mixed-pitch-mode' if currently in one of the modes."
    (when (memq major-mode mixed-pitch-modes)
      (mixed-pitch-mode 1))
    (dolist (hook mixed-pitch-modes)
      (add-hook (intern (concat (symbol-name hook) "-hook")) #'mixed-pitch-mode))
    (setq mixed-pitch-modes--loaded t))

(add-hook! doom-init-ui #'init-mixed-pitch-h)
;; Mixed pitch:2 ends here

;; [[file:config.org::*Mixed pitch][Mixed pitch:3]]
(autoload #'mixed-pitch-serif-mode "mixed-pitch"
  "Change the default face of the current buffer to a serifed variable pitch, while keeping some faces fixed pitch." t)

(after! mixed-pitch
  (defface variable-pitch-serif
    '((t (:family "serif")))
    "A variable-pitch face with serifs."
    :group 'basic-faces)
  (setq mixed-pitch-set-height t)
  (setq variable-pitch-serif-font doom-serif-font)
  (set-face-attribute 'variable-pitch-serif nil :font variable-pitch-serif-font)
  (defun mixed-pitch-serif-mode (&optional arg)
    "Change the default face of the current buffer to a serifed variable pitch, while keeping some faces fixed pitch."
    (interactive)
    (let ((mixed-pitch-face 'variable-pitch-serif))
      (mixed-pitch-mode (or arg 'toggle)))))
;; Mixed pitch:3 ends here

;; [[file:config.org::*Global bindings][Global bindings:1]]
(map! ;; Comments
      "C-/" #'comment-line

      ;; Text navigation
      "C-<left>" #'left-word
      "C-<right>" #'right-word
      "C-<up>" #'previous-logical-line
      "C-<down>" #'next-logical-line

      (:after undo-fu
       "C-z" #'undo-fu-only-undo
       "C-_" nil
       "C-/" nil
       "C-S-z" #'undo-fu-only-redo
       "M-_" nil)

      (:after swiper
      "C-s" #'swiper))
;; Global bindings:1 ends here

;; [[file:config.org::*Global bindings][Global bindings:2]]
(global-set-key (kbd "C-w") 'backward-kill-word)

(defmacro me/bind-kill-region-or-line (key-map kill-line kill-region)
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

(me/bind-kill-region-or-line global-map kill-line kill-region)
(after! org
  (me/bind-kill-region-or-line org-mode-map org-kill-line kill-region))
;; Global bindings:2 ends here

;; [[file:config.org::*Layouts with dead keys][Layouts with dead keys:1]]
(use-package! iso-transl)
;; Layouts with dead keys:1 ends here

;; [[file:config.org::*Buffers][Buffers:1]]
(setq doom-fallback-buffer-name "► Doom"
      +doom-dashboard-name "► Doom")
;; Buffers:1 ends here

;; [[file:config.org::*Window Management][Window Management:2]]
(use-package! rotate)

(map! ;; Window navigation
      "C-x <left>" #'windmove-left
      "C-x <right>" #'windmove-right
      "C-x <down>" #'windmove-down
      "C-x <up>" #'windmove-up
      "C-x o" nil

      :after rotate
      :prefix ("C-x w" . "windows")
      "l" #'rotate-layout
      "r" #'rotate-window)

(after! smartparens
  (undefine-key! smartparens-mode-map "C-<left>" "C-<right>" "C-<up>" "C-<down>"))
;; Window Management:2 ends here

;; [[file:config.org::*Frame title][Frame title:1]]
(setq frame-title-format
      '(""
        (:eval
         (if (s-contains-p org-roam-directory (or buffer-file-name ""))
             (replace-regexp-in-string
              ".*/[0-9]*-?" "☰ "
              (subst-char-in-string ?_ ?  buffer-file-name))
           "%b"))
        (:eval
         (let ((project-name (projectile-project-name)))
           (unless (string= "-" project-name)
             (format (if (buffer-modified-p)  " ◉ %s" "  ●  %s") project-name))))))
;; Frame title:1 ends here

;; [[file:config.org::*Limiting buffer width][Limiting buffer width:2]]
(use-package! olivetti
  :hook
   ((olivetti-mode . (lambda () (setq-local olivetti-body-width fill-column))))
  :config
  (setq olivetti-body-width fill-column))

(map! :after olivetti
      :map olivetti-mode-map
      "C-c l >" #'olivetti-expand
      "C-c l <" #'olivetti-shrink
      "C-c l !" #'olivetti-set-width)
;; Limiting buffer width:2 ends here

;; [[file:config.org::*Org Mode][Org Mode:1]]
(after! org
  (mixed-pitch-register-mode 'org-mode)
  (add-hook! org-mode #'+org-pretty-mode #'olivetti-mode)
  (add-hook! org-mode (display-line-numbers-mode -1))
  (custom-set-faces!
    '(org-document-title :height 1.5)
    '(outline-1 :weight extra-bold :height 1.25)
    '(outline-2 :weight bold :height 1.15)
    '(outline-3 :weight bold :height 1.12)
    '(outline-4 :weight semi-bold :height 1.09)
    '(outline-5 :weight semi-bold :height 1.06)
    '(outline-6 :weight semi-bold :height 1.03)
    '(outline-8 :weight semi-bold)
    '(outline-9 :weight semi-bold)
    '(org-superstar-header-bullet :height 1.2))
  (setq org-superstar-headline-bullets-list '("჻" "჻" "჻" "჻" "჻")
        org-ellipsis " ▾ "
        org-list-demote-modify-bullet '(("+" . "-") ("-" . "*") ("*" . "-") ("1." . "a.")))
    (use-package! org-sticky-header
      :hook
      (org-mode . org-sticky-header-mode)
      :custom
      (org-sticky-header-full-path 'full)
      (org-sticky-header-outline-path-separator " ჻ ")
      (org-sticky-header-prefix "჻ ")
      (org-sticky-header-heading-star ""))
  (use-package! org-appear
    :hook (org-mode . org-appear-mode)
    :config
    (setq org-appear-autoemphasis t
          org-appear-autosubmarkers nil
          org-appear-autolinks t))
  (setq org-fontify-quote-and-verse-blocks t)
  (appendq! +ligatures-extra-symbols
            `(:checkbox      "☐"
              :pending       "◼"
              :checkedbox    "☑"
              :list_property "∷"
              :em_dash       "—"
              :ellipses      "…"
              :arrow_right   "→"
              :arrow_left    "←"
              :title         "𝙏"
              :subtitle      "𝙩"
              :author        "𝘼"
              :date          "𝘿"
              :property      "☸"
              :options       "⌥"
              :startup       "⏻"
              :macro         "𝓜"
              :html_head     "🅷"
              :html          "🅗"
              :latex_class   "🄻"
              :latex_header  "🅻"
              :beamer_header "🅑"
              :latex         "🅛"
              :attr_latex    "🄛"
              :attr_html     "🄗"
              :attr_org      "⒪"
              :begin_quote   "❝"
              :end_quote     "❞"
              :caption       "☰"
              :header        "›"
              :results       "🠶"
              :begin_export  "⏩"
              :end_export    "⏪"
              :properties    "⚙"
              :end           "∎"
              :priority_a   ,(propertize "⚑" 'face 'all-the-icons-red)
              :priority_b   ,(propertize "⬆" 'face 'all-the-icons-orange)
              :priority_c   ,(propertize "■" 'face 'all-the-icons-yellow)
              :priority_d   ,(propertize "⬇" 'face 'all-the-icons-green)
              :priority_e   ,(propertize "❓" 'face 'all-the-icons-blue)))
  (set-ligatures! 'org-mode
    :merge t
    :checkbox      "[ ]"
    :pending       "[-]"
    :checkedbox    "[X]"
    :list_property "::"
    :em_dash       "---"
    :ellipsis      "..."
    :arrow_right   "->"
    :arrow_left    "<-"
    :title         "#+title:"
    :subtitle      "#+subtitle:"
    :author        "#+author:"
    :date          "#+date:"
    :property      "#+property:"
    :options       "#+options:"
    :startup       "#+startup:"
    :macro         "#+macro:"
    :html_head     "#+html_head:"
    :html          "#+html:"
    :latex_class   "#+latex_class:"
    :latex_header  "#+latex_header:"
    :beamer_header "#+beamer_header:"
    :latex         "#+latex:"
    :attr_latex    "#+attr_latex:"
    :attr_html     "#+attr_html:"
    :attr_org      "#+attr_org:"
    :begin_quote   "#+begin_quote"
    :end_quote     "#+end_quote"
    :caption       "#+caption:"
    :header        "#+header:"
    :begin_export  "#+begin_export"
    :end_export    "#+end_export"
    :results       "#+RESULTS:"
    :property      ":PROPERTIES:"
    :end           ":END:"
    :priority_a    "[#A]"
    :priority_b    "[#B]"
    :priority_c    "[#C]"
    :priority_d    "[#D]"
    :priority_e    "[#E]")
  (plist-put +ligatures-extra-symbols :name "⁍")
  (defun locally-defer-font-lock ()
    "Set jit-lock defer and stealth, when buffer is over a certain size"
    (when (> (buffer-size) 50000)
      (setq-local jit-lock-defer-time 0.05
                  jit-lock-stealth-time 1)))
  
  (add-hook! org-mode #'locally-defer-font-lock)
  (setq org-highlight-latex-and-related '(native script entities))
  (require 'org-src)
  (add-to-list 'org-src-block-faces '("latex" (:inherit default :extend t)))
  (use-package! org-fragtog
    :hook (org-mode . org-fragtog-mode))
  (setq org-format-latex-options
        (plist-put org-format-latex-options :background "Transparent"))
  (setq org-list-allow-alphabetical t               ; have a. A. a) A) list bullets
        org-export-in-background t                  ; run export processes in external emacs process
        org-catch-invisible-edits 'smart            ; try not to accidently do weird stuff in invisible regions
        org-export-with-sub-superscripts '{}        ; don't treat lone _ / ^ as sub/superscripts, require _{} / ^{}
        org-startup-folded 'content                 ; Show all headings on startup, but not their content
        org-enforce-todo-dependencies t)            ; Make sure subtasks are completed before supertask
  
  (setq org-babel-default-header-args
        (-snoc (assq-delete-all :comments org-babel-default-header-args)
               '(:comments . "link")))
  (defun unpackaged/org-element-descendant-of (type element)
    "Return non-nil if ELEMENT is a descendant of TYPE.
  TYPE should be an element type, like `item' or `paragraph'.
  ELEMENT should be a list like that returned by `org-element-context'."
    ;; MAYBE: Use `org-element-lineage'.
    (when-let* ((parent (org-element-property :parent element)))
      (or (eq type (car parent))
          (unpackaged/org-element-descendant-of type parent))))
  
  ;;;###autoload
  (defun unpackaged/org-return-dwim (&optional default)
    "A helpful replacement for `org-return-indent'.  With prefix, call `org-return-indent'.
  
  On headings, move point to position after entry content.  In
  lists, insert a new item or end the list, with checkbox if
  appropriate.  In tables, insert a new row or end the table."
    ;; Inspired by John Kitchin: http://kitchingroup.cheme.cmu.edu/blog/2017/04/09/A-better-return-in-org-mode/
    (interactive "P")
    (if default
        (org-return t)
      (cond
       ;; Act depending on context around point.
  
       ;; NOTE: I prefer RET to not follow links, but by uncommenting this block, links will be
       ;; followed.
  
       ;; ((eq 'link (car (org-element-context)))
       ;;  ;; Link: Open it.
       ;;  (org-open-at-point-global))
  
       ((org-at-heading-p)
        ;; Heading: Move to position after entry content.
        ;; NOTE: This is probably the most interesting feature of this function.
        (let ((heading-start (org-entry-beginning-position)))
          (goto-char (org-entry-end-position))
          (cond ((and (org-at-heading-p)
                      (= heading-start (org-entry-beginning-position)))
                 ;; Entry ends on its heading; add newline after
                 (end-of-line)
                 (insert "\n\n"))
                (t
                 ;; Entry ends after its heading; back up
                 (forward-line -1)
                 (end-of-line)
                 (when (org-at-heading-p)
                   ;; At the same heading
                   (forward-line)
                   (insert "\n")
                   (forward-line -1))
                 ;; FIXME: looking-back is supposed to be called with more arguments.
                 (while (not (looking-back (rx (repeat 3 (seq (optional blank) "\n")))))
                   (insert "\n"))
                 (forward-line -1)))))
  
       ((org-at-item-checkbox-p)
        ;; Checkbox: Insert new item with checkbox.
        (org-insert-todo-heading nil))
  
       ((org-in-item-p)
        ;; Plain list.  Yes, this gets a little complicated...
        (let ((context (org-element-context)))
          (if (or (eq 'plain-list (car context))  ; First item in list
                  (and (eq 'item (car context))
                       (not (eq (org-element-property :contents-begin context)
                                (org-element-property :contents-end context))))
                  (unpackaged/org-element-descendant-of 'item context))  ; Element in list item, e.g. a link
              ;; Non-empty item: Add new item.
              (org-insert-item)
            ;; Empty item: Close the list.
            ;; TODO: Do this with org functions rather than operating on the text. Can't seem to find the right function.
            (delete-region (line-beginning-position) (line-end-position))
            (insert "\n"))))
  
       ((when (fboundp 'org-inlinetask-in-task-p)
          (org-inlinetask-in-task-p))
        ;; Inline task: Don't insert a new heading.
        (org-return t))
  
       ((org-at-table-p)
        (cond ((save-excursion
                 (beginning-of-line)
                 ;; See `org-table-next-field'.
                 (cl-loop with end = (line-end-position)
                          for cell = (org-element-table-cell-parser)
                          always (equal (org-element-property :contents-begin cell)
                                        (org-element-property :contents-end cell))
                          while (re-search-forward "|" end t)))
               ;; Empty row: end the table.
               (delete-region (line-beginning-position) (line-end-position))
               (org-return t))
              (t
               ;; Non-empty row: call `org-return-indent'.
               (org-return t))))
       (t
        ;; All other cases: call `org-return-indent'.
        (org-return t)))))
  
  (map!
   :map org-mode-map
   [return] #'unpackaged/org-return-dwim)
  (defvar org-reference-contraction-max-words 3
    "Maximum number of words in a reference reference.")
  (defvar org-reference-contraction-max-length 35
    "Maximum length of resulting reference reference, including joining characters.")
  (defvar org-reference-contraction-stripped-words
    '("the" "on" "in" "off" "a" "for" "by" "of" "and" "is" "to")
    "Superfluous words to be removed from a reference.")
  (defvar org-reference-contraction-joining-char "-"
    "Character used to join words in the reference reference.")
  
  (defun org-reference-contraction-truncate-words (words)
    "Using `org-reference-contraction-max-length' as the total character 'budget' for the WORDS
  and truncate individual words to conform to this budget.
  
  To arrive at a budget that accounts for words undershooting their requisite average length,
  the number of characters in the budget freed by short words is distributed among the words
  exceeding the average length.  This adjusts the per-word budget to be the maximum feasable for
  this particular situation, rather than the universal maximum average.
  
  This budget-adjusted per-word maximum length is given by the mathematical expression below:
  
  max length = \\floor{ \\frac{total length - chars for seperators - \\sum_{word \\leq average length} length(word) }{num(words) > average length} }"
    ;; trucate each word to a max word length determined by
    ;;
    (let* ((total-length-budget (- org-reference-contraction-max-length  ; how many non-separator chars we can use
                                   (1- (length words))))
           (word-length-budget (/ total-length-budget                      ; max length of each word to keep within budget
                                  org-reference-contraction-max-words))
           (num-overlong (-count (lambda (word)                            ; how many words exceed that budget
                                   (> (length word) word-length-budget))
                                 words))
           (total-short-length (-sum (mapcar (lambda (word)                ; total length of words under that budget
                                               (if (<= (length word) word-length-budget)
                                                   (length word) 0))
                                             words)))
           (max-length (/ (- total-length-budget total-short-length)       ; max(max-length) that we can have to fit within the budget
                          num-overlong)))
      (mapcar (lambda (word)
                (if (<= (length word) max-length)
                    word
                  (substring word 0 max-length)))
              words)))
  
  (defun org-reference-contraction (reference-string)
    "Give a contracted form of REFERENCE-STRING that is only contains alphanumeric characters.
  Strips 'joining' words present in `org-reference-contraction-stripped-words',
  and then limits the result to the first `org-reference-contraction-max-words' words.
  If the total length is > `org-reference-contraction-max-length' then individual words are
  truncated to fit within the limit using `org-reference-contraction-truncate-words'."
    (let ((reference-words
           (-filter (lambda (word)
                      (not (member word org-reference-contraction-stripped-words)))
                    (split-string
                     (->> reference-string
                          downcase
                          (replace-regexp-in-string "\\[\\[[^]]+\\]\\[\\([^]]+\\)\\]\\]" "\\1") ; get description from org-link
                          (replace-regexp-in-string "[-/ ]+" " ") ; replace seperator-type chars with space
                          puny-encode-string
                          (replace-regexp-in-string "^xn--\\(.*?\\) ?-?\\([a-z0-9]+\\)$" "\\2 \\1") ; rearrange punycode
                          (replace-regexp-in-string "[^A-Za-z0-9 ]" "") ; strip chars which need %-encoding in a uri
                          ) " +"))))
      (when (> (length reference-words)
               org-reference-contraction-max-words)
        (setq reference-words
              (cl-subseq reference-words 0 org-reference-contraction-max-words)))
  
      (when (> (apply #'+ (1- (length reference-words))
                      (mapcar #'length reference-words))
               org-reference-contraction-max-length)
        (setq reference-words (org-reference-contraction-truncate-words reference-words)))
  
      (string-join reference-words org-reference-contraction-joining-char)))
  (define-minor-mode unpackaged/org-export-html-with-useful-ids-mode
    "Attempt to export Org as HTML with useful link IDs.
  Instead of random IDs like \"#orga1b2c3\", use heading titles,
  made unique when necessary."
    :global t
    (if unpackaged/org-export-html-with-useful-ids-mode
        (advice-add #'org-export-get-reference :override #'unpackaged/org-export-get-reference)
      (advice-remove #'org-export-get-reference #'unpackaged/org-export-get-reference)))
  (unpackaged/org-export-html-with-useful-ids-mode 1) ; ensure enabled, and advice run
  
  (defun unpackaged/org-export-get-reference (datum info)
    "Like `org-export-get-reference', except uses heading titles instead of random numbers."
    (let ((cache (plist-get info :internal-references)))
      (or (car (rassq datum cache))
          (let* ((crossrefs (plist-get info :crossrefs))
                 (cells (org-export-search-cells datum))
                 ;; Preserve any pre-existing association between
                 ;; a search cell and a reference, i.e., when some
                 ;; previously published document referenced a location
                 ;; within current file (see
                 ;; `org-publish-resolve-external-link').
                 ;;
                 ;; However, there is no guarantee that search cells are
                 ;; unique, e.g., there might be duplicate custom ID or
                 ;; two headings with the same title in the file.
                 ;;
                 ;; As a consequence, before re-using any reference to
                 ;; an element or object, we check that it doesn't refer
                 ;; to a previous element or object.
                 (new (or (cl-some
                           (lambda (cell)
                             (let ((stored (cdr (assoc cell crossrefs))))
                               (when stored
                                 (let ((old (org-export-format-reference stored)))
                                   (and (not (assoc old cache)) stored)))))
                           cells)
                          (when (org-element-property :raw-value datum)
                            ;; Heading with a title
                            (unpackaged/org-export-new-named-reference datum cache))
                          (when (member (car datum) '(src-block table example fixed-width property-drawer))
                            ;; Nameable elements
                            (unpackaged/org-export-new-named-reference datum cache))
                          ;; NOTE: This probably breaks some Org Export
                          ;; feature, but if it does what I need, fine.
                          (org-export-format-reference
                           (org-export-new-reference cache))))
                 (reference-string new))
            ;; Cache contains both data already associated to
            ;; a reference and in-use internal references, so as to make
            ;; unique references.
            (dolist (cell cells) (push (cons cell new) cache))
            ;; Retain a direct association between reference string and
            ;; DATUM since (1) not every object or element can be given
            ;; a search cell (2) it permits quick lookup.
            (push (cons reference-string datum) cache)
            (plist-put info :internal-references cache)
            reference-string))))
  
  (defun unpackaged/org-export-new-named-reference (datum cache)
    "Return new reference for DATUM that is unique in CACHE."
    (cl-macrolet ((inc-suffixf (place)
                               `(progn
                                  (string-match (rx bos
                                                    (minimal-match (group (1+ anything)))
                                                    (optional "--" (group (1+ digit)))
                                                    eos)
                                                ,place)
                                  ;; HACK: `s1' instead of a gensym.
                                  (-let* (((s1 suffix) (list (match-string 1 ,place)
                                                             (match-string 2 ,place)))
                                          (suffix (if suffix
                                                      (string-to-number suffix)
                                                    0)))
                                    (setf ,place (format "%s--%s" s1 (cl-incf suffix)))))))
      (let* ((headline-p (eq (car datum) 'headline))
             (title (if headline-p
                        (org-element-property :raw-value datum)
                      (or (org-element-property :name datum)
                          (concat (org-element-property :raw-value
                                                        (org-element-property :parent
                                                                              (org-element-property :parent datum)))))))
             ;; get ascii-only form of title without needing percent-encoding
             (ref (concat (org-reference-contraction (substring-no-properties title))
                          (unless (or headline-p (org-element-property :name datum))
                            (concat ","
                                    (pcase (car datum)
                                      ('src-block "code")
                                      ('example "example")
                                      ('fixed-width "mono")
                                      ('property-drawer "properties")
                                      (_ (symbol-name (car datum))))
                                    "--1"))))
             (parent (when headline-p (org-element-property :parent datum))))
        (while (--any (equal ref (car it))
                      cache)
          ;; Title not unique: make it so.
          (if parent
              ;; Append ancestor title.
              (setf title (concat (org-element-property :raw-value parent)
                                  "--" title)
                    ;; get ascii-only form of title without needing percent-encoding
                    ref (org-reference-contraction (substring-no-properties title))
                    parent (when headline-p (org-element-property :parent parent)))
            ;; No more ancestors: add and increment a number.
            (inc-suffixf ref)))
        ref)))
  
  (add-hook 'org-load-hook #'unpackaged/org-export-html-with-useful-ids-mode)
  (defadvice! org-export-format-reference-a (reference)
    "Format REFERENCE into a string.
  
  REFERENCE is a either a number or a string representing a reference,
  as returned by `org-export-new-reference'."
    :override #'org-export-format-reference
    (if (stringp reference) reference (format "org%07x" reference)))
  (defun org-syntax-convert-keyword-case-to-lower ()
    "Convert all #+KEYWORDS to #+keywords."
    (interactive)
    (save-excursion
      (goto-char (point-min))
      (let ((count 0)
            (case-fold-search nil))
        (while (re-search-forward "^[ \t]*#\\+[A-Z_]+" nil t)
          (unless (s-matches-p "RESULTS" (match-string 0))
            (replace-match (downcase (match-string 0)) t)
            (setq count (1+ count))))
        (message "Replaced %d occurances" count))))
  (setq org-todo-keywords
        '((sequence "TODO(t)" "NEXT(n)" "WAIT(w)" "|" "DONE(d)" "CANC(c)")))
  (custom-set-faces!
    '(org-todo :family "Fira Code"))
  (after! org-superstar
    (setq org-superstar-special-todo-items t)
    (setq org-superstar-todo-bullet-alist
          '(("NEXT" . ?☐)
            ("TODO" . ?☐)
            ("WAIT" . ?⌛)
            ("DONE" . ?☑)
            ("CANC" . ?☒))))
  (use-package org-edna
    :after org
    :config (org-edna-mode 1))
  
  (defun org-trigger-next-task ()
    "Set the TRIGGER property to set next heading to NEXT upon completion."
    (interactive)
    (org-set-property
     "TRIGGER"
     (concat "next-sibling todo!(\"NEXT\")")))
  
  (defun org-trigger-chain-next-task ()
    "Set the TRIGGER property to start a chain setting the next heading to NEXT upon completion."
    (interactive)
    (org-set-property
     "TRIGGER"
     (concat "next-sibling chain!(\"TRIGGER\") todo!(\"NEXT\")")))
  
  (map! :map org-mode-map
        :prefix ("C-c l C" . "TRIGGER property")
        "t" #'org-trigger-next-task
        "c" #'org-trigger-chain-next-task)
  (add-to-list 'org-tags-exclude-from-inheritance "PROJ")
  (add-to-list 'org-tags-exclude-from-inheritance "DONE_PROJ")
  (add-to-list 'org-tags-exclude-from-inheritance "PAUSED_PROJ")
  (add-to-list 'org-tags-exclude-from-inheritance "AREA_RESP")
  
  (setq org-tag-alist '((:startgroup)
                        ("PROJ" . ?P)
                        ("DONE_PROJ" . ?D)
                        ("PAUSED_PROJ")
                        (:endgroup)
                        (:newline)
                        ("AREA_RESP" . ?A)))
  (setq org-agenda-deadline-faces
        '((1.001 . error)
          (1.0 . org-warning)
          (0.5 . org-upcoming-deadline)
          (0.0 . org-upcoming-distant-deadline)))
  (defun define-org-agenda (key &rest args)
    ;; Make sure the variable exists and delete any existing agendas with same key
    (setq org-agenda-custom-commands
          (when (boundp 'org-agenda-custom-commands)
            (assoc-delete-all key org-agenda-custom-commands)))
    (add-to-list 'org-agenda-custom-commands (cons key args)))
  
  (defmacro define-org-agenda! (key &rest args)
    `(define-org-agenda ,key ,@(mapcar (lambda (i) (if (listp i) `(quote ,i) i)) args)))
  
  (define-org-agenda! "p" "Projects and Areas of Responsibility"
    ((tags "AREA_RESP"
           ((org-agenda-overriding-header "Areas of Responsibility\n")
            (org-agenda-prefix-format '((tags . "  %i ")))))
     (tags "PROJ"
           ((org-agenda-overriding-header "Active Projects\n")))
     (tags "PAUSED_PROJ"
           ((org-agenda-overriding-header "Paused Projects\n")))
     (tags "DONE_PROJ"
           ((org-agenda-overriding-header "Finished Projects\n")))))
  
  (define-org-agenda! "n" "Next Actions"
    ((agenda "" ((org-agenda-span 1) (org-deadline-warning-days 14)))
     (todo "NEXT"
           ((org-agenda-overriding-header "Next Actions\n")))
     (todo "WAIT"
           ((org-agenda-overriding-header "Waiting For\n")))))
  
  (setq org-agenda-skip-scheduled-if-done t
        org-agenda-skip-deadline-if-done t
        org-agenda-include-deadlines t
        org-agenda-block-separator ""
        org-agenda-tags-column 90
        org-agenda-compact-blocks nil
        org-agenda-sorting-strategy '((agenda deadline-up scheduled-up category-up)
                                      (todo category-up deadline-up priority-down)
                                      (tags category-up deadline-up priority-down)
                                      (search category-up)))
  
  (setq org-agenda-prefix-format
        '((agenda . " %i %-25:c%?-12t% s")
  ;        (todo . " %i %(org-agenda--format-days-until-deadline (org-entry-get-days-until-deadline (point))) %-25:c")
  ;        (tags . " %i %(org-agenda--format-days-until-deadline (org-entry-get-days-until-deadline (point))) %-25:c")
          (todo . " %i %-25:c %-8(org-agenda--days-until-deadline)  ")
          (tags . " %i %-25:c %-8(org-agenda--days-until-deadline)  ")
          (search . " %i %-25:c")))
  
  (defun org-agenda--days-until-deadline (&optional num-days)
    (if-let ((days (or num-days (org-entry-get-days-until-deadline))))
        (if (>= days 0)
            (format "in %dd" days)
          (format "%dd ago" (- days)))
      ""))
  
  (defun org-entry-get-days-until-deadline (&optional pom inherit)
    (if-let ((deadline-date (org-entry-get (or pom (point)) "DEADLINE" inherit)))
        (let* ((today-day-number (org-today))
               (deadline-day-number (org-time-string-to-absolute deadline-date)))
          (- deadline-day-number today-day-number))))
  (defun me/open-week-planner ()
    (interactive)
    (select-frame-set-input-focus (make-frame))
    (org-agenda nil "p")
    (select-window (split-window nil nil 'below))
    (let* ((today-dow (string-to-number (format-time-string "%w")))
           (mon (org-read-date nil t (cond ((< today-dow 1) "mon") ((= today-dow 1) "today") (t "-mon"))))
           (tue (org-read-date nil t (cond ((< today-dow 2) "tue") ((= today-dow 2) "today") (t "-tue"))))
           (wed (org-read-date nil t (cond ((< today-dow 3) "wed") ((= today-dow 3) "today") (t "-wed"))))
           (thu (org-read-date nil t (cond ((< today-dow 4) "thu") ((= today-dow 4) "today") (t "-thu"))))
           (fri (org-read-date nil t (cond ((< today-dow 5) "fri") ((= today-dow 5) "today") (t "-fri")))))
      (org-roam-dailies--capture mon t)
      (goto-char (point-min))
      (select-window (split-window nil nil 'right))
      (org-roam-dailies--capture tue t)
      (goto-char (point-min))
      (select-window (split-window nil nil 'right))
      (org-roam-dailies--capture wed t)
      (goto-char (point-min))
      (select-window (split-window nil nil 'right))
      (org-roam-dailies--capture thu t)
      (goto-char (point-min))
      (select-window (split-window nil nil 'right))
      (org-roam-dailies--capture fri t)
      (goto-char (point-min)))
    (org-roam-buffer-deactivate))
  (setq deft-recursive t
        org-roam-tag-sort t
        org-roam-graph-executable "fdp"
        org-roam-mode-section-functions (list #'org-roam-backlinks-section
                                              #'org-roam-reflinks-section
                                              #'org-roam-unlinked-references-section))
  (define-key org-roam-mode-map [mouse-1] #'org-roam-visit-thing)
  ;; Works because all relevant files have the "#+title: " line
  (advice-add 'deft-parse-title :override
              (lambda (file contents)
                (if deft-use-filename-as-title
                    (deft-base-filename file)
                  (let* ((case-fold-search 't)
                         (begin (string-match "title: " contents))
                         (end-of-begin (match-end 0))
                         (end (string-match "\n" contents begin)))
                    (if begin
                        (substring contents end-of-begin end)
                      (format "%s" file))))))
  
  (setq deft-strip-summary-regexp
        (concat "\\("
                ;; blank lines
                ;;"[\n ]*$"
                ;; any line with a :SOMETHING:
                "^:.+:.*\n"
                ;; any line starting with #+
                "\\|^#\\+.*\n"
                ;; any line starting with an asterisk
                "\\|^\\*.*\n"
                ;;
                "\\|^[[:blank:]]*\\(DEADLINE\\|SCHEDULED\\):.*\n"
                "\\)"
         ))
  (setq org-latex-pdf-process '("latexmk -f -pdf -%latex -shell-escape -interaction=nonstopmode -output-directory=%o %f"))
  (defvar org-latex-features '()
    "LaTeX features and details required to include them when generating a preamble.
  
  List where each item's car is the feature symbol and the rest forms a plist,
  as described by `def-org-latex-feature!'.")
  
  (defmacro def-org-latex-feature! (feature-symbol &rest body)
    "Define a LaTeX feature that can be included when generating a preamble.
  
  The feature is uniquely identified by the given symbol.
  If the symbol starts with \"!\", it will be activated for all exports.
  
  The body forms a plist with the following keys:
  
  - :snippet, which may be either
    - a string which should be included in the preamble
    - a symbol, the value of which is included in the preamble
    - a function, which is evaluated with the list of feature flags as its
      single argument. The result of which is included in the preamble
    - a list, which is `eval'uated, with a list of feature flags available
      as \"features\"
  
  - :requires, a feature symbol or list of feature symbols that will be
    automatically included when this one is.
  
  - :packages, a string or list of strings determining the names of
    LaTeX packages that must be available for this feature to work.
    Automatically determined from the snippet if omitted and the
    snippet is a string.
  
  - :conflicts, a feature symbol or list of feature symbols that must not
    be activated when this one is."
    ;; Infer packages from string snippets
    (when-let ((snippet (plist-get body :snippet)))
      (when (stringp snippet)
        (let ((packages nil)
              (match (string-match "\\\\usepackage{\\([^}]+\\)}" snippet)))
          (while match
            (push (split-string (substring snippet (match-beginning 1) (match-end 1))
                                "," t "[[:blank]]+")
                  packages)
            (setq match (string-match "\\\\usepackage{\\([^}]+\\)}" snippet (match-end 0))))
          (plist-put! body :packages
                      (append (plist-get body :packages) (mapcan #'identity packages))))))
    ;; Generated code:
    `(setq org-latex-features
           (cons (cons ',feature-symbol ',body)
                 (assoc-delete-all ',feature-symbol org-latex-features))))
  (defvar org-latex-feature-tests '()
    "Tests run over Org files to activate their associated LaTeX feature flags.
  
  Alist where the car is a test for the presence of the feature,
  and the cdr is either a single feature symbol or a list of feature symbols.
  
  The possible values for feature tests as well as their interpretation is
  documented in `def-org-latex-feature-test!'.")
  
  (defmacro def-org-latex-feature-test! (features &rest body)
    "Defines a test over Org files to activate one or more LaTeX features.
  
  The first argument must be either a single feature flag, or a list of feature flags.
  
  A feature test may be one a:
   - string, which is used as a regex search in the buffer
   - symbol, the value of which is fetched
   - function, which is called with info as an argument
  
  The macro may thus either be called with a single string or symbol,
  or with one or more forms that are interpreted as the body
  of a function taking an argument called info."
    (let ((test
           (cond
            ((null body)
             (error "def-org-latex-feature-test! was given no body"))
            ((or (cdr body) (listp (car body)))
             `(lambda (info) . ,body))
            ((stringp (car body))
             (car body))
            (t
             `(quote ,(car body))))))
      `(let ((test ,test))
         (setq org-latex-feature-tests
               (cons (cons test ',features)
                     (assoc-delete-all test org-latex-feature-tests))))))
  (defun org-latex-generate-features-preamble (&optional features)
    "Generate the LaTeX preamble content required to provide FEATURES.
  This is done according to `org-latex-features', looking up the given symbols there.
  
  If FEATURES are not given, detect them with `org-latex-detect-features' instead."
    (setq features (or features (org-latex-detect-features)))
    (let ((resolved-features (org-latex-resolve-features features)))
      (concat
       (format "\n%%%%%% features: %s\n" (mapcar #'car resolved-features))
       (mapconcat (lambda (feature)
                    (when-let ((snippet (plist-get (cdr feature) :snippet)))
                      (format "%%%% %s\n%s"
                              (car feature)
                              (pcase snippet
                                ((pred stringp) snippet)
                                ((pred symbolp) (symbol-value snippet))
                                ((pred functionp) (funcall snippet features))
                                ((pred listp) (eval `(let ((features ',features)) (,@snippet))))
                                (_ (user-erro "org-latex-features :snippet value %s unabled to be used" snippet))))))
                  resolved-features
                  "\n")
       "\n%%% end features\n")))
  
  (defun org-latex-detect-features (&optional buffer info)
    "List feature symbols for the features detected in BUFFER by the `org-latex-feature-tests'."
    (let ((case-fold-search nil)
          (run-feature-test
           (lambda (test)
             (let ((result
                    (pcase test
                      ((pred stringp) test)
                      ((pred functionp) (funcall test info))
                      ((pred symbolp) (symbol-value test))
                      (_ (user-error "org-latex-conditional-features key %s unable to be used" test)))))
               (if (stringp result)
                   (save-excursion
                     (goto-char (point-min))
                     (re-search-forward result nil t))
                 result)))))
      (with-current-buffer (or buffer (current-buffer))
        (delete-dups
         (mapcan (lambda (feature-test)
                   (when (funcall run-feature-test (car feature-test))
                     (if (listp (cdr feature-test)) (cdr features-test) (list (cdr feature-test)))))
                 org-latex-feature-tests)))))
  
  (defun org-latex-resolve-features (features)
    "For each feature symbol in FEATURES process :requires keyword
  and sort according to :order"
    (setq features                ;; Look up all feature definitions
          (mapcar (lambda (feature-symbol)
                    (or (assoc feature-symbol org-latex-features)
                        (error "Feature %s not provided in org-latex-features" feature-symbol)))
                  features))
    (setq features                ;; Add all eager features
          (append features
                  (mapcan (lambda (feature)
                            (when (and (plist-get (cdr feature) :eager)
                                       (not (assoc (car feature) features)))
                              (list feature)))
                          org-latex-features)))
    (let ((unresolved features))  ;; Add all transitive dependencies
      (while unresolved
        (when-let ((requirements (plist-get (cdr (car unresolved)) :requires)))
          (dolist (requirement (if (symbolp requirements) (list requirements) requirements))
            (unless (assoc requirement features)
              (setcdr unresolved
                      (cons (or (assoc requirement org-latex-features)
                                (error "Feature %s not provided in org-latex-features (dependency)" requirement))
                            (cdr unresolved))))))
        (setq unresolved (cdr unresolved))))
    (sort features
          (lambda (feat1 feat2)
            (< (or (plist-get (cdr feat1) :order) 1)
               (or (plist-get (cdr feat2) :order) 1)))))
  (defvar info--tmp nil)
  
  (defadvice! org-latex-save-info (info &optional t_ s_)
    :before #'org-latex-make-preamble
    (setq info--tmp info))
  
  (defadvice! org-slice-latex-header-and-generated-preamble-a (orig-fn tpl def-pkg pkg snippets-p &optional extra)
    "Dynamically insert preamble content based on `org-latex-features' and `org-latex-feature-tests'."
    :around #'org-splice-latex-header
    (let ((header (funcall orig-fn tpl def-pkg pkg snippets-p extra)))
      (if snippets-p
          header
        (concat header
                (org-latex-generate-features-preamble (org-latex-detect-features nil info--tmp))
                "\n"))))
  (defun check-for-latex-packages (packages)
    (mapcan (lambda (package)
              (unless
                  (= 0 (shell-command (format "kpsewhich %s.sty" package)))
                (list package)))
            packages))
  
  (defun org-latex-required-packages ()
    "List all LaTeX packages that are required by `org-latex-features'."
    (let ((packages nil))
      (dolist (feature org-latex-features)
        (setq packages (append (plist-get (cdr feature) :packages)
                               packages)))
      (delete-dups packages)))
  
  (defun +org-warn-about-missing-latex-packages (&rest _)
    (message "Checking for missing LaTeX packages...")
    (sleep-for 0.4)
    (when-let (missing-pkgs (check-for-latex-packages (org-latex-required-packages)))
      (message "%s You are missing the following LaTeX packages: %s."
               (propertize "Warning!" 'face '(bold warning))
               (mapconcat (lambda (pkg) (propertize pkg 'face 'font-lock-variable-name-face))
                          missing-pkgs
                          ", ")))
    (advice-remove 'org-latex-export-to-pdf #'+org-warn-about-missing-latex-packages)
    (sleep-for 1))
  
  (advice-add 'org-latex-export-to-pdf :before #'+org-warn-about-missing-latex-packages)
  (def-org-latex-feature! image :snippet "\\usepackage{graphicx}" :order 2)
  (def-org-latex-feature! svg :snippet "\\usepackage{svg}" :order 2)
  (def-org-latex-feature! caption :order 0.2
    :snippet "
  \\usepackage{subcaption}
  \\usepackage[hypcap=true]{caption}
  \\setkomafont{caption}{\\sffamily\\small}
  \\setkomafont{captionlabel}{\\upshape\\bfseries}
  \\captionsetup{justification=raggedright,singlelinecheck=true}
  \\usepackage{capt-of} % required by Org
  ")
  
  (def-org-latex-feature-test! image
    "\\[\\[\\(?:file\\|https?\\):\\(?:[^]]\\|\\\\\\]\\)+?\\.\\(?:eps\\|pdf\\|png\\|jpeg\\|jpg\\|jbig2\\)\\]\\]")
  (def-org-latex-feature-test! svg
    "\\[\\[\\(?:file\\|https?\\):\\(?:[^]]+?\\|\\\\\\]\\)\\.svg\\]\\]")
  (def-org-latex-feature-test! caption
    "^[ \t]*#\\+caption:\\|\\\\caption")
  (def-org-latex-feature! box-warning :requires .fancybox :snippet "\\defsimplebox{warning}{e66100}{\\ding{68}}{Warning}" :order 4)
  (def-org-latex-feature! box-info :requires .fancybox :snippet "\\defsimplebox{info}{3584e4}{\\ding{68}}{Information}" :order 4)
  (def-org-latex-feature! box-success :requires .fancybox :snippet "\\defsimplebox{success}{26a269}{\\ding{68}}{\\vspace{-\\baselineskip}}" :order 4)
  (def-org-latex-feature! box-error :requires .fancybox :snippet "\\defsimplebox{error}{c01c28}{\\ding{68}}{Important}" :order 4)
  (def-org-latex-feature! .fancybox
    :requires .pifont :order 3.9
    :snippet "
  % args = #1 Name, #2 Colour, #3 Ding, #4 Label
  \\newcommand{\\defsimplebox}[4]{%
    \\definecolor{#1}{HTML}{#2}
    \\newenvironment{#1}[1][]
    {%
      \\par\\vspace{-0.7\\baselineskip}%
      \\textcolor{#1}{#3} \\textcolor{#1}{\\textbf{\\def\\temp{##1}\\ifx\\temp\\empty#4\\else##1\\fi}}%
      \\vspace{-0.8\\baselineskip}
      \\begin{addmargin}[1em]{1em}
    }{%
      \\end{addmargin}
      \\vspace{-0.5\\baselineskip}
    }%
  }
  ")
  (def-org-latex-feature! .pifont :snippet "\\usepackage{pifont}")
  
  (def-org-latex-feature-test! box-warning
    "^[ \t]*#\\+begin_warning\\|\\\\begin{warning}")
  (def-org-latex-feature-test! box-info
    "^[ \t]*#\\+begin_info\\|\\\\begin{info}")
  (def-org-latex-feature-test! box-success
    "^[ \t]*#\\+begin_success\\|\\\\begin{success}")
  (def-org-latex-feature-test! box-error
    "^[ \t]*#\\+begin_error\\|\\\\begin{error}")
  (def-org-latex-feature! checkbox
    :requires .pifont
    :order 3
    :snippet (concat (unless (memq 'maths features)
                       "\\usepackage{amssymb} % provides \\square")
                     "
  \\newcommand{\\checkboxUnchecked}{$\\square$}
  \\newcommand{\\checkboxTransitive}{\\rlap{\\raisebox{-0.1ex}{\\hspace{0.35ex}\\Large\\textbf -}}$\\square$}
  \\newcommand{\\checkboxChecked}{\\rlap{\\raisebox{0.2ex}{\\hspace{0.35ex}\\scriptsize \\ding{52}}}$\\square$}
  "))
  
  (def-org-latex-feature-test! checkbox
    "^[ \t]*\\(?:[-+*]\\|[0-9]+[.)]\\|[A-Za-z]+[.)]\\) \\[[ -X]\\]")
  (defun +org-export-latex-fancy-item-checkboxes (text backend info)
    (when (org-export-derived-backend-p backend 'latex)
      (replace-regexp-in-string
       "\\\\item\\[{$\\\\\\(\\w+\\)$}\\]"
       (lambda (fullmatch)
         (concat "\\\\item[" (pcase (substring fullmatch 9 -3) ; content of capture group
                               ("square" "\\\\checkboxUnchecked")
                               ("boxminus" "\\\\checkboxTransitive")
                               ("boxtimes" "\\\\checkboxChecked")
                               (_ (substring fullmatch 9 -3))) "]"))
       text)))
  
  ;;(add-to-list 'org-export-filter-item-functions '+org-export-latex-fancy-item-checkboxes)
  (def-org-latex-feature! par-sep
    :snippet "\\setlength{\\parskip}{\\baselineskip}\n\\setlength{\\parindent}{0pt}\n"
    :order 0.5)
  
  (defvar org-latex-par-sep t
    "Vertically separate paragraphs and remove indentation of first lines.")
  (def-org-latex-feature-test! par-sep org-latex-par-sep))
;; Org Mode:1 ends here

;; [[file:config.org::*Org Roam][Org Roam:1]]
(defun org-roam-set-directory (roam-dir)
  "Set the `org-roam-directory' and also `deft-directory' and `org-agenda-files' accordingly."
  (interactive "D")
  (setq deft-directory roam-dir
        org-roam-directory roam-dir
        org-roam-db-location (expand-file-name ".org-roam.db" roam-dir)
        org-agenda-files
        (mapcar (lambda (subdir) (expand-file-name subdir roam-dir))
                '("Projects" "Areas")))
  (let ((config-path (expand-file-name ".roam-config.el" roam-dir)))
    (if (file-exists-p config-path)
        (load-file config-path)
      (setq org-roam-dailies-directory "Daily/"
            org-roam-graph-exclude-matcher "/Daily/")
      (after! org-roam
        (cl-defmethod org-roam-node-filetitle ((node org-roam-node))
          "Return the file TITLE for the node."
          (org-roam-get-keyword "TITLE" (org-roam-node-file node)))
      
        (cl-defmethod org-roam-node-directories ((node org-roam-node))
          "Return a list of parent directories for the node relative to the 'org-roam-directory'."
          (if-let ((dirs (file-name-directory (file-relative-name (org-roam-node-file node) org-roam-directory))))
              (string-join (f-split dirs) "/")
            nil))
      
        (cl-defmethod org-roam-node-hierarchy ((node org-roam-node))
          "Return the hierarchy for the node."
          (let ((title (org-roam-node-title node))
                (olp (org-roam-node-olp node))
                (level (org-roam-node-level node))
                (directories (org-roam-node-directories node))
                (filetitle (org-roam-node-filetitle node)))
            (concat
             (if directories (format "(%s) " directories))
             (if (> level 0) (concat filetitle " > "))
             (if (> level 1) (concat (string-join olp " > ") " > "))
             title)))
      
        (setq org-roam-node-display-template "${hierarchy:*} ${tags:10}"))
      (setq org-roam-capture-templates
            '(("p" "Project" plain "%?"
               :target (file+head+olp "Projects/${slug}.org"
                                      "#+title: ${title}\n#+CATEGORY: %^{Area of Responsibility}
      \n* ${title}  :PROJ:
      DEADLINE: %^{Deadline}t
      Area of Responsibility: [[roam:%\\1]]
      \n** Success Criteria\n\n"
                                      ("Log"))
               :unnarrowed t)
               ("a" "Area of Responsibilty" plain "%?"
                :target (file+head+olp "Areas/${slug}.org"
                                       "#+title: ${title}\n#+CATEGORY: ${title}
       \n* ${title}   :AREA_RESP:
       \n** Standard to Uphold
      \n\n** Future Ideas\n\n"
                                       ("Log"))
                :unnarrowed t)
              ("w" "Writing Inbox" plain "%?"
               :target (file+head "Writing Inbox/%<%Y-%m-%d>_${slug}.org"
                                  "#+title: ${title}\n#+author: %n\n\n")
               :unnarrowed t)
              ("e" "Evergreen" plain "%?"
               :target (file+head "Evergreen/${slug}.org"
                                  "#+title: ${title}\n#+author: %n\n\n")
               :unnarrowed t)
              ("R" "Reference" plain "%?"
               :target (file+head "Reference/${title}.org"
                                  "#+title: ${title}\n\n#+begin_src bibtex\n\n#+end_src\n\n"
               )
               :unnarrowed t)
              ("r" "Reading Inbox")
              ("rm" "Manual Entry" entry "** ${title}%?\n"
               :target (file+head+olp "Reading Inbox.org"
                                      "#+title: Reading Inbox\n\n* Inbox\n"
                                      ("Uncategorised")))
              ("rl" "Link from Clipbox" entry "** %(org-cliplink-capture)%? \n"
               :target (file+head+olp "Reading Inbox.org"
                                      "#+title: Reading Inbox\n\n* Inbox\n"
                                      ("Uncategorised"))))
            org-roam-dailies-capture-templates
            '(("d" "default" plain "%?"
               :target (file+head+olp "%<%Y-%m-%d>.org"
                                      "#+title: %<%Y-%m-%d>\n\n* Log\n"
                                      ("Log"))
               :unnarrowed t)))
      (defun org-roam-references-export-bibtex ()
        (interactive)
        (let* ((references-dir (expand-file-name "Reference" org-roam-directory))
               (export-file "/tmp/references.org")
               (references-bib (expand-file-name "references.bib" org-roam-directory)))
          (with-current-buffer (generate-new-buffer "org-roam-bibtex-export")
            (insert "#+property: header-args:bibtex :comments no\n")
            (dolist (file (org-roam--list-files references-dir))
              (insert (format "#+include: \"%s\"\n" file)))
            (org-export-to-file 'org export-file))
          (with-current-buffer (find-file-noselect export-file)
            (org-babel-tangle nil references-bib "bibtex"))
          ))
      ))
  (when (fboundp 'org-roam-db-update)
    (org-roam-db-update)))

(map! :map doom-leader-map
      "r D" #'org-roam-set-directory)

(org-roam-set-directory "~/Dokumente/Roam")
;; Org Roam:1 ends here

;; [[file:config.org::*Defaults and keybindings][Defaults and keybindings:2]]
(map! :leader
      :prefix ("r" . "org-roam")
      "c" #'org-roam-capture
      "f" #'org-roam-node-find
      "g" #'org-roam-graph
      "i" #'org-roam-node-insert
      "l" #'org-roam-node-insert
      "r" #'org-roam-buffer-toggle
      "s" #'deft
      "t" #'org-roam-dailies-goto-today
      "u" #'org-roam-ui-mode
      (:prefix ("d" . "dailies")
       "d" #'org-roam-dailies-goto-date
       "m" #'org-roam-dailies-goto-tomorrow
       "t" #'org-roam-dailies-goto-today
       "y" #'org-roam-dailies-goto-yesterday
       "n" #'org-roam-dailies-goto-next-note
       "p" #'org-roam-dailies-goto-previous-note))
;; Defaults and keybindings:2 ends here

;; [[file:config.org::*Ledger][Ledger:1]]
(use-package! ledger-mode
  :mode ("\\.ledger\\'" "\\.journal\\'")
  :config
  (setq ledger-binary-path "hledger"))
;; Ledger:1 ends here

;; [[file:config.org::*Graphviz][Graphviz:2]]
(use-package! graphviz-dot-mode
  :commands graphviz-dot-mode
  :mode ("\\.dot\\'" "\\.gz\\'")
  :init
  (after! org
    (setcdr (assoc "dot" org-src-lang-modes)
            'graphviz-dot)))

(use-package! company-graphviz-dot
  :after graphviz-dot-mode)
;; Graphviz:2 ends here

;; [[file:config.org::*Version control][Version control:2]]
;;(after! magit (magit-delta-mode +1))
;; Version control:2 ends here

;; [[file:config.org::*Manual pages][Manual pages:2]]
(use-package! info-colors
  :commands (info-colors-fontify-node))

(add-hook! Info-selection-hook 'info-colors-fontify-node)
(mixed-pitch-register-mode 'Info-mode)

(add-hook! (Info-mode helpful-mode)
  (olivetti-mode)
  (olivetti-set-width 100))
;; Manual pages:2 ends here

;; [[file:config.org::*Spell checking][Spell checking:2]]
(after! ispell
  (setq ispell-dictionary "en_GB,de_DE,pt_BR"
        ispell-personal-dictionary "~/.local/share/hunspell/dicts/personal")
  ;; The following has to be called before ispell-hunspell-add-multi-dic will work
  (ispell-set-spellchecker-params)
  (ispell-hunspell-add-multi-dic ispell-dictionary))
;; Spell checking:2 ends here

;; [[file:config.org::*Spell checking][Spell checking:3]]
(unless noninteractive
  (add-hook! 'doom-init-ui-hook
    (run-at-time nil nil
                 (lambda nil
                   (message "%s missing the following Hunspell dictionaries: %s"
                            (propertize "Warning!" 'face
                                        '(bold warning))
                            (mapconcat
                             (lambda
                               (font)
                               (propertize font 'face 'font-lock-variable-name-face))
                             '("~/.local/share/hunspell/dicts/personal")
                             ", "))
                   (sleep-for 0.5)))))
;; Spell checking:3 ends here
