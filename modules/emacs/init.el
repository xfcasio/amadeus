;;; init.el --- minimal config -*- lexical-binding: t; -*-

(defvar evil-mode-buffers '())

;; Faster startup
(setq gc-cons-threshold (* 50 1000 1000)
      gc-cons-percentage 0.6
      package-enable-at-startup nil
      inhibit-startup-screen t
      inhibit-startup-message t
      initial-scratch-message nil
      frame-inhibit-implied-resize t)

(with-eval-after-load 'package
  (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t))

;; UI: remove all decorations
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(tooltip-mode -1)
(advice-add 'display-startup-echo-area-message :override #'ignore)
(setq use-dialog-box nil
      use-file-dialog nil)

(setq auto-save-default nil)

;; Undecorated frame + 18px internal padding
(setq default-frame-alist
      '((undecorated . t)
        (internal-border-width . 18)
        (left-fringe . 0)
        (right-fringe . 0)
        (vertical-scroll-bars . nil)
        (horizontal-scroll-bars . nil)
        (tool-bar-lines . 0)
        (menu-bar-lines . 0)
        (fullscreen . maximized)))


;; --- Modeline pills ---
(setq evil-mode-line-format nil)   ; we draw the evil indicator ourselves

(defvar my/ml-gap-px 4)   ; space between pills
(defvar my/ml-pad-px 6)   ; padding inside each pill
(defvar my/ml-vpad-px 6)  ; space between pills and the top/bottom of the bar
(defvar my/ml-ipad-px 1)  ; extra height inside each pill, above and below the text


(defvar my/ml-box `(:line-width (1 . ,my/ml-vpad-px) :color "#00070B"))

(defface my/ml-pill     `((t :background "#333B3F" :foreground "#A9A9A9" :box ,my/ml-box)) "Module." :group 'rxyhn)
(defface my/ml-pill-dim `((t :background "#020D11" :foreground "#767B7D" :box ,my/ml-box)) "Inactive module." :group 'rxyhn)

(defface my/ml-normal   `((t :background "#79AAEB" :foreground "#00070B" :weight bold :box ,my/ml-box)) "Normal." :group 'rxyhn)
(defface my/ml-insert   `((t :background "#78B892" :foreground "#00070B" :weight bold :box ,my/ml-box)) "Insert." :group 'rxyhn)
(defface my/ml-ex       `((t :background "#DF5B61" :foreground "#00070B" :weight bold :box ,my/ml-box)) "Command." :group 'rxyhn)
(defface my/ml-visual   `((t :background "#C488EC" :foreground "#00070B" :weight bold :box ,my/ml-box)) "Visual." :group 'rxyhn)
(defface my/ml-replace  `((t :background "#E9967E" :foreground "#00070B" :weight bold :box ,my/ml-box)) "Replace." :group 'rxyhn)

(defface my/ml-file `((t :background "#DF5B61" :foreground "#00070B" :weight bold :box ,my/ml-box)) "Filename." :group 'rxyhn)
(defface my/ml-pos  `((t :background "#E89982" :foreground "#00070B" :weight bold :box ,my/ml-box)) "Position." :group 'rxyhn)
(defface my/ml-git  `((t :background "#C488EC" :foreground "#00070B" :weight bold :box ,my/ml-box)) "Git." :group 'rxyhn)
(defface my/ml-lsp `((t :background "#9C9CA3" :foreground "#00070B" :weight bold :box ,my/ml-box)) "Eglot." :group 'rxyhn)
(defface my/ml-active-mode  `((t :background "#ECD28B" :foreground "#00070B" :weight bold :box ,my/ml-box)) "Active Mode." :group 'rxyhn)


(defun my/ml-esc (s) (replace-regexp-in-string "%" "%%" s))

(defun my/ml-space (px &optional face)
  (propertize " " 'display `(space :width (,px)) 'face face))

(defun my/ml-pill (face text)
  (concat (my/ml-space my/ml-pad-px face)
          (propertize (my/ml-esc text) 'face face)
          (my/ml-space my/ml-pad-px face)))

(defun my/ml-base-face ()
  (if (mode-line-window-selected-p) 'my/ml-pill 'my/ml-pill-dim))

(defun my/ml-split (face letter text active &optional bg)
  (if active
      (concat (my/ml-pill face letter)
              (my/ml-pill `(:background ,(or bg "#020D11")
                            :foreground ,(face-attribute face :background nil t)
                            :box ,my/ml-box)
                          text))
    (concat (my/ml-pill 'my/ml-pill-dim letter)
            (my/ml-pill 'my/ml-pill-dim text))))

(defun my/ml-evil ()
  (let* ((w (minibuffer-selected-window))
         (ex (and (active-minibuffer-window) w
                  (eq (current-buffer) (window-buffer w))))
         (state (and (bound-and-true-p evil-local-mode) evil-state))
         (face (cond
                (ex 'my/ml-ex)
                ((not (mode-line-window-selected-p)) 'my/ml-pill-dim)
                (t (pcase state
                     ('insert 'my/ml-insert)
                     ('visual 'my/ml-visual)
                     ('replace 'my/ml-replace)
                     ((or 'normal 'operator 'motion 'emacs) 'my/ml-normal)
                     (_ 'my/ml-pill)))))
         (label (if ex "COMMAND" (upcase (symbol-name (or state 'emacs))))))

    (my/ml-split face "" label
         (not (memq face '(my/ml-pill my/ml-pill-dim))))))

(defun my/ml-buffer ()
  (concat (my/ml-space my/ml-gap-px)
          (my/ml-split 'my/ml-file "󰈚"
                       (concat (buffer-name) (if (buffer-modified-p) " +" ""))
                       (mode-line-window-selected-p))))

(defun my/ml-position ()
  (concat (my/ml-space my/ml-gap-px)
          (my/ml-split 'my/ml-pos ""
                       (format-mode-line "%l:%c %p")
                       (mode-line-window-selected-p))))

(defun my/ml-vc ()
  (when vc-mode
    (concat (my/ml-space my/ml-gap-px)
            (my/ml-split 'my/ml-git ""
                         (string-trim (substring-no-properties vc-mode))
                         (mode-line-window-selected-p)
                         "#020D11"))))

(defun my/ml-mode ()
  (concat (my/ml-space my/ml-gap-px)
          (my/ml-split 'my/ml-active-mode ""
                       (substring-no-properties (format-mode-line mode-name))
                       (mode-line-window-selected-p))))

(defun my/ml-misc ()
  (let ((s (string-trim (substring-no-properties
                         (format-mode-line mode-line-misc-info)))))
    (unless (string-empty-p s)
      (concat (my/ml-space my/ml-gap-px)
              (my/ml-split 'my/ml-lsp "" s
                           (mode-line-window-selected-p))))))

;; invisible spacers that make the bar row taller than the text. The boxes
;; (my/ml-vpad-px) still cut the outer gap, so the extra height becomes pill height.
(defun my/ml-vspacer ()
  (let* ((fi   (ignore-errors (font-info (face-font 'default nil ?a))))
         (h    (frame-char-height))
         (asc  (or (and fi (aref fi 8)) (round (* 0.8 h))))
         (desc (or (and fi (aref fi 9)) (- h asc)))
         (up   (+ asc  my/ml-vpad-px my/ml-ipad-px))
         (down (+ desc my/ml-vpad-px my/ml-ipad-px)))
    (concat (propertize " " 'display `(space :width (1) :height (,up)   :ascent 100))
            (propertize " " 'display `(space :width (1) :height (,down) :ascent 0)))))

(defvar my/ml-right-fudge-px 0)

;; right group, left-to-right: eglot (misc), mode, position
(defvar my/ml-width-cache (make-hash-table :test 'equal))

(defun my/ml-right ()
  (let* ((s (concat (my/ml-misc) (my/ml-mode) (my/ml-position)
                    (my/ml-space my/ml-gap-px)))
         (txt (format-mode-line s))
         (w (+ (or (gethash txt my/ml-width-cache)
                   (puthash txt (string-pixel-width txt) my/ml-width-cache))
               my/ml-right-fudge-px)))
    (concat (propertize " " 'display `(space :align-to (- right (,w))))
            s)))


(setq-default
 mode-line-format
 '("%e"
   (:eval (my/ml-vspacer))
   (:eval (my/ml-space my/ml-gap-px))
   (:eval (my/ml-evil))
   (:eval (my/ml-buffer))
   (:eval (my/ml-vc))
   (:eval (my/ml-right))))

;; redraw the bar the moment the evil state / minibuffer changes
(dolist (h '(evil-normal-state-entry-hook evil-insert-state-entry-hook
             evil-visual-state-entry-hook evil-replace-state-entry-hook
             evil-operator-state-entry-hook evil-motion-state-entry-hook
             evil-emacs-state-entry-hook
             minibuffer-setup-hook minibuffer-exit-hook))
  (add-hook h (lambda () (force-mode-line-update t))))

;; --- Window resize / cycling ---
(defvar my/resize-step 2)  ; columns/lines per keypress

;; The arrow moves the border in that direction: if the window has a neighbor on
;; that side, it takes that border and grows. Otherwise it moves the opposite
;; border and shrinks.
(defun my/win-resize (dir)
  (let* ((w (selected-window))
         (n my/resize-step)
         (left  (window-in-direction 'left  w))
         (right (window-in-direction 'right w))
         (above (window-in-direction 'above w))
         (below (window-in-direction 'below w)))
    (pcase dir
      ('left  (cond (left  (adjust-window-trailing-edge left (- n) t))   ; left border moves left: grow
                    (right (adjust-window-trailing-edge w (- n) t))))   ; right border moves left: shrink
      ('right (cond (right (adjust-window-trailing-edge w n t))          ; right border moves right: grow
                    (left  (adjust-window-trailing-edge left n t))))     ; left border moves right: shrink
      ('up    (cond (above (adjust-window-trailing-edge above (- n) nil)) ; top border moves up: grow
                    (below (adjust-window-trailing-edge w (- n) nil))))   ; bottom border moves up: shrink
      ('down  (cond (below (adjust-window-trailing-edge w n nil))         ; bottom border moves down: grow
                    (above (adjust-window-trailing-edge above n nil)))))))  ; top border moves down: shrink

;; C-arrows: move focus to the split in that direction
(global-set-key (kbd "C-<left>")  #'windmove-left)
(global-set-key (kbd "C-<right>") #'windmove-right)
(global-set-key (kbd "C-<up>")    #'windmove-up)
(global-set-key (kbd "C-<down>")  #'windmove-down)

;; C-S-arrows: resize the current split (same logic as before)
(global-set-key (kbd "C-S-<left>")  (lambda () (interactive) (my/win-resize 'left)))
(global-set-key (kbd "C-S-<right>") (lambda () (interactive) (my/win-resize 'right)))
(global-set-key (kbd "C-S-<up>")    (lambda () (interactive) (my/win-resize 'up)))
(global-set-key (kbd "C-S-<down>")  (lambda () (interactive) (my/win-resize 'down)))


;; C-Tab: next window. C-S-Tab: next buffer inside the current window.
(global-set-key (kbd "C-<tab>") #'other-window)
(global-set-key (kbd "C-S-<tab>") #'next-buffer)
(global-set-key (kbd "C-S-<iso-lefttab>") #'next-buffer)  ; how X11/Wayland often report C-S-Tab



;; Relative line numbers
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)
(global-eldoc-mode -1)

(setq inhibit-startup-echo-area-message (user-login-name))
(setq show-help-function nil)
(setq suggest-key-bindings nil)

(setq evil-undo-system 'undo-redo)

;; Vim keys (evil)
(require 'evil)

(setq-default tab-width 4)
(setq backward-delete-char-untabify-method nil)
(setq-default evil-shift-width tab-width)

(defun my/insert-tab ()
  (interactive)
  (insert-char ?\t))

(define-key evil-insert-state-map (kbd "TAB")   #'my/insert-tab)
(define-key evil-insert-state-map (kbd "<tab>") #'my/insert-tab)

(evil-mode 1)

;; Vim-style scrolling
(define-key evil-normal-state-map (kbd "C-u") #'evil-scroll-up)
(define-key evil-visual-state-map (kbd "C-u") #'evil-scroll-up)
(define-key evil-normal-state-map (kbd "C-x") #'evil-scroll-line-down)
(define-key evil-visual-state-map (kbd "C-x") #'evil-scroll-line-down)
(define-key evil-normal-state-map (kbd "C-m") #'evil-scroll-line-up)
(define-key evil-visual-state-map (kbd "C-m") #'evil-scroll-line-up)

(setq evil-insert-state-cursor '(bar . 2)
      evil-normal-state-cursor 'box
      evil-visual-state-cursor 'hollow
      evil-replace-state-cursor 'hbar)

(global-set-key (kbd "C-S-v") 'yank)
(define-key evil-insert-state-map (kbd "C-S-v") 'yank)
(define-key evil-normal-state-map (kbd "C-S-v") 'yank)
(define-key evil-normal-state-map (kbd "C-r") 'evil-redo)
(define-key evil-normal-state-map (kbd ";") 'evil-ex)

(define-key evil-insert-state-map (kbd "<escape>") 'evil-normal-state)
(define-key evil-insert-state-map (kbd "C-c") 'evil-normal-state)
(define-key evil-visual-state-map (kbd "<escape>") 'evil-exit-visual-state)
(define-key evil-visual-state-map (kbd "C-c") 'evil-exit-visual-state)
(define-key evil-replace-state-map (kbd "<escape>") 'evil-normal-state)
(define-key evil-replace-state-map (kbd "C-c") 'evil-normal-state)



;; Shift+Up / Shift+Down in visual mode: move the selected lines, keep them selected
(defun my/move-selection (dir)
  "Move the selected lines by one line. DIR is -1 (up) or 1 (down)."
  (let* ((beg (min (point) (mark)))
         (end (max (point) (mark)))
         ;; a selection that ends at column 0 has swallowed the newline of the
         ;; previous line, so the real last line is the one before
         (end (if (and (> end beg)
                       (= end (save-excursion (goto-char end) (line-beginning-position))))
                  (1- end)
                end))
         (lb  (save-excursion (goto-char beg) (line-beginning-position)))
         (le  (save-excursion (goto-char end) (line-end-position)))
         (block (buffer-substring-no-properties lb le))
         new-beg)
    (cond
     ;; up
     ((and (< dir 0) (> lb (point-min)))
      (let* ((nb-beg  (save-excursion (goto-char lb) (forward-line -1) (point)))
             (nb-text (buffer-substring-no-properties nb-beg (1- lb))))
        (delete-region nb-beg le)
        (goto-char nb-beg)
        (insert block "\n" nb-text)
        (setq new-beg nb-beg)))
     ;; down
     ((and (> dir 0) (< le (point-max)))
      (let* ((nb-end  (save-excursion (goto-char le) (forward-line 1) (line-end-position)))
             (nb-text (buffer-substring-no-properties (1+ le) nb-end)))
        (delete-region lb nb-end)
        (goto-char lb)
        (insert nb-text "\n" block)
        (setq new-beg (+ lb (length nb-text) 1)))))
    (when new-beg
      ;; reselect the moved lines, with point ON the last line, never after its newline
      (evil-visual-select new-beg (max new-beg (1- (+ new-beg (length block)))) 'line))))

(defun my/move-selection-up ()
  (interactive)
  (let ((deactivate-mark nil)) (my/move-selection -1)))

(defun my/move-selection-down ()
  (interactive)
  (let ((deactivate-mark nil)) (my/move-selection 1)))

(define-key evil-visual-state-map (kbd "S-<up>")   #'my/move-selection-up)
(define-key evil-visual-state-map (kbd "S-<down>") #'my/move-selection-down)



(define-key evil-normal-state-map (kbd "C-f") #'dired-jump)

(setq dired-listing-switches "-lah")

(setq-default truncate-lines t)
(global-visual-line-mode -1)

(setq treesit-font-lock-level 4)

;; Theme
(deftheme rxyhn "Custom dark theme")

(let ((bg       "#00070B")
      (fg       "#A9A9A9")
      (black    "#333B3F")
      (red      "#F26E74")
      (green    "#78B892")
      (yellow   "#E9967E")
      (blue     "#79AAEB")
      (magenta  "#C488EC")
      (modeline "#00070B")
      (dim      "#555D5F")
      (orange   "#ff9e64")
      (light-yellow "#ECD28B"))

  (custom-theme-set-faces
   'rxyhn

   ;; --- Base UI ---
   `(default                   ((t (:background ,bg :foreground ,fg))))
   `(cursor                    ((t (:background ,fg))))
   `(fringe                    ((t (:background ,bg))))
   `(region                    ((t (:background ,black))))
   `(highlight                 ((t (:background ,black))))
   `(line-number               ((t (:foreground ,dim :background ,bg))))
   `(line-number-current-line  ((t (:foreground ,orange :background ,bg))))
   `(mode-line                 ((t (:background ,modeline :foreground ,fg :box nil))))
   `(mode-line-inactive        ((t (:background ,modeline :foreground ,dim :box nil))))
   `(mode-line-buffer-id       ((t (:foreground ,fg :weight bold))))
   `(vertical-border           ((t (:foreground ,modeline))))
   `(minibuffer-prompt         ((t (:foreground ,blue))))

   ;; --- Comments & strings ---
   `(font-lock-comment-face            ((t (:foreground ,black))))
   `(font-lock-comment-delimiter-face  ((t (:foreground ,black))))
   `(font-lock-string-face             ((t (:foreground ,green))))
   `(font-lock-doc-face                ((t (:foreground ,green))))
   `(font-lock-regexp-face             ((t (:foreground ,green))))

   ;; --- Keywords, builtins, preprocessor ---
   `(font-lock-keyword-face       ((t (:foreground ,magenta))))
   `(font-lock-builtin-face       ((t (:foreground ,blue))))
   `(font-lock-preprocessor-face  ((t (:foreground ,magenta))))
   `(font-lock-negation-char-face ((t (:foreground ,red))))

   ;; --- Functions & methods: BLUE ---
   `(font-lock-function-name-face  ((t (:foreground ,blue))))
   `(font-lock-function-call-face  ((t (:foreground ,blue))))
   `(font-lock-macro-face          ((t (:foreground ,blue))))
   `(tree-sitter-hl-face:function      ((t (:foreground ,blue))))
   `(tree-sitter-hl-face:function.call ((t (:foreground ,blue))))
   `(tree-sitter-hl-face:method.call   ((t (:foreground ,blue))))

   ;; --- Variables & constants ---
   `(font-lock-variable-name-face  ((t (:foreground "#E6930C"))))
   `(font-lock-variable-use-face   ((t (:foreground "#E6930C"))))
   `(font-lock-constant-face       ((t (:foreground ,red))))
   `(font-lock-number-face         ((t (:foreground ,light-yellow))))

   ;; --- Types ---
   `(font-lock-type-face  ((t (:foreground ,yellow))))

   ;; --- Scopes / modules / namespaces: RED ---
   `(tree-sitter-hl-face:namespace          ((t (:foreground ,red))))
   `(tree-sitter-hl-face:module             ((t (:foreground ,red))))
   `(tree-sitter-hl-face:type.builtin       ((t (:foreground ,red))))
   `(font-lock-warning-face                 ((t (:foreground ,red))))

   ;; --- Punctuation, dots, brackets, operators: RED ---
   `(font-lock-punctuation-face         ((t (:foreground ,red))))
   `(font-lock-misc-punctuation-face    ((t (:foreground ,red))))
   `(font-lock-bracket-face             ((t (:foreground ,red))))
   `(font-lock-delimiter-face           ((t (:foreground ,red))))
   `(font-lock-operator-face            ((t (:foreground ,red))))
   `(font-lock-escape-face              ((t (:foreground ,red))))
   `(tree-sitter-hl-face:punctuation           ((t (:foreground ,red))))
   `(tree-sitter-hl-face:punctuation.bracket   ((t (:foreground ,red))))
   `(tree-sitter-hl-face:punctuation.delimiter ((t (:foreground ,red))))
   `(tree-sitter-hl-face:operator              ((t (:foreground ,red))))

   ;; --- Properties / fields ---
   `(font-lock-property-face      ((t (:foreground ,red))))
   `(font-lock-property-use-face  ((t (:foreground ,red))))
   `(tree-sitter-hl-face:property ((t (:foreground ,red))))
   `(tree-sitter-hl-face:field    ((t (:foreground ,red))))

   ;; --- Search / paren / messages ---
   `(isearch             ((t (:background ,blue :foreground ,bg))))
   `(lazy-highlight      ((t (:background ,black))))
   `(show-paren-match    ((t (:background ,black :foreground ,green))))
   `(show-paren-mismatch ((t (:background ,red :foreground ,bg))))
   `(error               ((t (:foreground ,red))))
   `(warning             ((t (:foreground ,yellow))))
   `(success             ((t (:foreground ,green))))
   `(mode-line          ((t (:background ,modeline :foreground ,fg  :box (:line-width (1 . 5) :color ,modeline)))))
   `(mode-line-inactive ((t (:background ,modeline :foreground ,dim :box (:line-width (1 . 5) :color ,modeline)))))

   '(dired-directory      ((t (:foreground "#79AAEB" :weight bold))))
   '(dired-symlink        ((t (:foreground "#C488EC"))))
   '(dired-broken-symlink ((t (:foreground "#F26E74" :weight bold))))
   '(dired-header         ((t (:foreground "#78B892" :weight bold))))
   '(dired-special        ((t (:foreground "#E9967E"))))
   '(dired-mark           ((t (:foreground "#ff9e64" :weight bold))))
   '(dired-marked         ((t (:foreground "#ff9e64" :weight bold))))
   '(dired-flagged        ((t (:foreground "#F26E74" :weight bold))))
   '(dired-warning        ((t (:foreground "#F26E74"))))
   '(dired-perm-write     ((t (:foreground "#ff9e64"))))
   '(dired-ignored        ((t (:foreground "#767B7D"))))))

;; Diagnostics: no recoloring, no underlines (now actually inside the theme)
(custom-theme-set-faces
   'rxyhn
   '(eglot-diagnostic-tag-unnecessary-face ((t (:inherit nil :underline nil))))
   '(eglot-diagnostic-tag-deprecated-face  ((t (:inherit nil :underline nil :strike-through nil))))
   '(eglot-highlight-symbol-face           ((t (:inherit nil :underline nil))))
   '(flymake-error   ((t (:underline nil))))
   '(flymake-warning ((t (:underline nil))))
   '(flymake-note    ((t (:underline nil))))
   '(flymake-error-echo   ((t nil)))
   '(flymake-warning-echo ((t nil)))
   '(flymake-note-echo    ((t nil)))
   '(flymake-end-of-line-diagnostics-face ((t nil)))
   '(flymake-mode-line-error-counter   ((t (:inherit mode-line))))
   '(flymake-mode-line-warning-counter ((t (:inherit mode-line))))
   '(flymake-mode-line-note-counter    ((t (:inherit mode-line))))
   '(flymake-mode-line-exception       ((t (:inherit mode-line))))
   '(flymake-mode-line-lighter         ((t (:inherit mode-line))))
   '(eglot-mode-line                   ((t (:inherit mode-line)))))


(font-lock-add-keywords
 'dired-mode
 '(("^. +\\([-dlcbps][-rwxsStT]+[@.+]?\\) +\\([0-9]+\\) +\\(\\S-+\\) +\\(\\S-+\\) +\\([0-9.,]+[A-Za-z]?\\) +\\([A-Za-z]\\{3\\} +[0-9]+ +[0-9:]+\\)"
    (1 '(:foreground "#78B892"))    ; permissions  green
    (2 '(:foreground "#767B7D"))    ; link count   dim
    (3 '(:foreground "#C488EC"))    ; owner        magenta
    (4 '(:foreground "#C488EC"))    ; group        magenta
    (5 '(:foreground "#E9967E"))    ; size         yellow
    (6 '(:foreground "#79AAEB"))))) ; date        blue


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defface rxyhn-rust-self-face
  '((t :foreground "#ECD28B"))
  "Face for the Rust `self' keyword."
  :group 'rxyhn)

(defface rxyhn-rust-lifetime-face
  '((t :foreground "#C488EC"))
  "Face for Rust lifetimes."
  :group 'rxyhn)

(defun my/rust-ts-extra-highlight ()
  "Extra Rust highlighting: `self' and lifetimes."
  (setq-local treesit-font-lock-settings
              (append treesit-font-lock-settings
                      (treesit-font-lock-rules
                       :language 'rust
                       :feature 'rxyhn-extra
                       :override t
                       '([(self) (lifetime)] @rxyhn-rust-self-face)
                       :language 'rust
                       :feature 'rxyhn-extra
                       :override t
                       '((lifetime (identifier) @rxyhn-rust-lifetime-face)))))
  (push 'rxyhn-extra (nth 3 treesit-font-lock-feature-list)))

(add-hook 'rust-ts-mode-hook #'my/rust-ts-extra-highlight)

(add-hook 'minibuffer-setup-hook
          (lambda ()
            (setq-local corfu-auto nil)
            (corfu-mode -1)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(set-face-attribute 'default nil
                    :font "Terminus"
                    :height 80 ;; 120 for laptop
                    :weight 'normal)

(add-to-list 'major-mode-remap-alist '(rust-mode . rust-ts-mode))

;; icons from the symbols font, applied after the frame and fonts exist
(defun my/setup-icon-fonts ()
  (let ((spec (font-spec :family "Symbols Nerd Font Mono")))
    (dolist (range '((#xe000 . #xf8ff) (#xf0000 . #xfffff)))
      (set-fontset-font t range spec nil 'prepend)
      (set-fontset-font "fontset-default" range spec nil 'prepend))
    (clear-font-cache)))

(add-hook 'window-setup-hook #'my/setup-icon-fonts)

;; shrink fallback fonts so no glyph makes a row taller than a Terminus row
(add-to-list 'face-font-rescale-alist '("Symbols Nerd Font" . 0.75))
(add-to-list 'face-font-rescale-alist '("CJK\\|Gothic\\|Mincho\\|Han Sans\\|Droid Sans Fallback\\|IPA" . 0.75))

;; --- Corfu popup colors ---
(custom-theme-set-faces
 'rxyhn
 '(corfu-default     ((t (:background "#111A1F" :foreground "#A9A9A9"))))
 '(corfu-current     ((t (:background "#333B3F" :foreground "#A9A9A9"))))
 '(corfu-bar         ((t (:background "#767B7D"))))
 '(corfu-border      ((t (:background "#111A1F"))))
 '(corfu-annotations ((t (:foreground "#767B7D"))))
 '(corfu-deprecated  ((t (:foreground "#767B7D" :strike-through t))))
 '(corfu-popupinfo   ((t (:background "#111A1F" :foreground "#A9A9A9"))))
 '(orderless-match-face-0 ((t (:foreground "#79AAEB" :weight bold))))
 '(orderless-match-face-1 ((t (:foreground "#C488EC" :weight bold))))
 '(orderless-match-face-2 ((t (:foreground "#78B892" :weight bold))))
 '(orderless-match-face-3 ((t (:foreground "#E9967E" :weight bold)))))

(provide-theme 'rxyhn)
(enable-theme 'rxyhn)

;; --- NO UNDERLINES, EVER ---
;; Strips :underline from every face (link, button, flymake, eglot, whatever
;; a package defines later). Re-runs whenever new faces appear.
(defvar my/--face-count 0)
(defun my/no-underlines (&rest _)
  (let ((faces (face-list)))
    (unless (= (length faces) my/--face-count)
      (setq my/--face-count (length faces))
      (dolist (f faces)
        (when (face-attribute f :underline nil t)
          (set-face-attribute f nil :underline nil))))))
(add-hook 'after-load-functions #'my/no-underlines)
(add-hook 'emacs-startup-hook #'my/no-underlines)
(my/no-underlines)

(global-corfu-mode)
(setq corfu-auto t
      corfu-auto-prefix 1
      corfu-preview-current nil)
(corfu-popupinfo-mode)
(setq corfu-popupinfo-delay 0.2)

(setq kind-icon-use-icons nil)
(add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter)
(setq kind-icon-default-face 'corfu-default)
(setq corfu-left-margin-width 2)

;; C-j / C-k move through the completion menu (only while it's open)
(defun my/corfu-active-p (cmd)
  (and (bound-and-true-p corfu--candidates) cmd))

(define-key evil-insert-state-map (kbd "C-j")
  `(menu-item "" corfu-next :filter my/corfu-active-p))
(define-key evil-insert-state-map (kbd "C-k")
  `(menu-item "" corfu-previous :filter my/corfu-active-p))

(setq completion-styles '(orderless basic)
      completion-category-defaults nil
      completion-category-overrides '((eglot (styles orderless))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; --- Rust LSP (eglot + rust-analyzer) ---
(with-eval-after-load 'project
  (add-to-list 'project-vc-extra-root-markers "Cargo.toml"))

;; Eglot never enables/manages flymake -> no diagnostics rendered at all.
;; Must be set BEFORE eglot starts managing a buffer.
(setq eglot-stay-out-of '(flymake))

(with-eval-after-load 'eglot
  ;; also stop rust-analyzer from producing diagnostics at all.
  ;; :checkOnSave is what produces the cargo-check ones ("never constructed",
  ;; dead code, visibility), which is why :diagnostics alone did nothing.
  (setq-default eglot-workspace-configuration
                '(:rust-analyzer
                  (:cargo (:allFeatures t)
                   :checkOnSave :json-false
                   :diagnostics (:enable :json-false))))

  (setq eglot-ignored-server-capabilities
        '(:semanticTokensProvider
          :inlayHintProvider
          :documentHighlightProvider))

  (setq eglot-autoshutdown t
        eglot-sync-connect nil
        eglot-events-buffer-config '(:size 0 :format full))

  (setq eglot-code-action-indications nil))

;; belt and suspenders: flymake off in any eglot buffer
(add-hook 'eglot-managed-mode-hook (lambda () (flymake-mode -1)))
(add-hook 'eglot-managed-mode-hook (lambda () (eldoc-mode -1)))

(add-hook 'rust-ts-mode-hook
          (lambda ()
            (when (executable-find "rust-analyzer")
              (eglot-ensure))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; --- Fast fullscreen terminal (M-k toggles terminal <-> previous buffer) ---
(setq vterm-always-compile-module t   ; no y/n prompt when building the module
      vterm-timer-delay 0.01          ; redraw fast (default 0.1)
      vterm-max-scrollback 5000)

(defvar my/term-name "*terminal*")
(defvar my/term-prev-buffer nil)

(defun my/term-create ()
  (if (require 'vterm nil t)
      (let ((vterm-buffer-name my/term-name)) (vterm))
    (ansi-term (or (getenv "SHELL") "/bin/sh") "terminal"))
  (current-buffer))

(defun my/term-toggle ()
  (interactive)
  (let ((buf (get-buffer my/term-name)))
    ;; shell exited? drop the dead buffer
    (when (and buf (not (get-buffer-process buf)))
      (kill-buffer buf)
      (setq buf nil))
    (if (and buf (eq (current-buffer) buf))
        ;; in the terminal -> go back (the shell keeps running)
        (switch-to-buffer
         (if (buffer-live-p my/term-prev-buffer) my/term-prev-buffer (other-buffer buf)))
      ;; elsewhere -> remember where we were, show the terminal full window
      (setq my/term-prev-buffer (current-buffer))
      (if buf (switch-to-buffer buf) (my/term-create)))))

(global-set-key (kbd "M-k") #'my/term-toggle)

;; keys go straight to the shell, no line numbers
(with-eval-after-load 'evil
  (evil-set-initial-state 'term-mode 'emacs)
  (evil-set-initial-state 'vterm-mode 'emacs))
(add-hook 'term-mode-hook  (lambda () (display-line-numbers-mode -1)))
(add-hook 'vterm-mode-hook (lambda () (display-line-numbers-mode -1)))

;; make sure M-k reaches Emacs instead of the shell
(with-eval-after-load 'term
  (define-key term-raw-map (kbd "M-k") #'my/term-toggle))

(with-eval-after-load 'vterm
  (add-to-list 'vterm-keymap-exceptions "M-k")
  (define-key vterm-mode-map (kbd "M-k") #'my/term-toggle))

;; C-c goes straight to the shell (^C / interrupt) in vterm only
(defun my/vterm-ctrl-c ()
  (interactive)
  (vterm-send-key "c" nil nil t))   ; key "c", no shift, no meta, ctrl

(with-eval-after-load 'vterm
  (setq vterm-keymap-exceptions (delete "C-c" vterm-keymap-exceptions))
  (define-key vterm-mode-map (kbd "C-c") #'my/vterm-ctrl-c)
  ;; evil state maps outrank the mode map, so bind it there too
  (evil-define-key '(emacs insert) vterm-mode-map (kbd "C-c") #'my/vterm-ctrl-c))


;; C-x in the terminal: switch to vim normal mode so you can move around the
;; scrollback with vim keys, select and yank text. i / a / I / A returns to the shell.
(defun my/vterm-normal ()
  (interactive)
  (vterm-copy-mode 1)      ; freezes the buffer so it's navigable as normal text
  (evil-normal-state))

(defun my/vterm-back-to-shell ()
  (interactive)
  (vterm-copy-mode -1)     ; jumps the cursor back to the prompt
  (evil-emacs-state))

(with-eval-after-load 'vterm
  (define-key vterm-mode-map (kbd "C-x") #'my/vterm-normal)
  (evil-define-key 'normal vterm-copy-mode-map
    (kbd "i") #'my/vterm-back-to-shell
    (kbd "a") #'my/vterm-back-to-shell
    (kbd "I") #'my/vterm-back-to-shell
    (kbd "A") #'my/vterm-back-to-shell))

(add-hook 'vterm-copy-mode-hook #'evil-normalize-keymaps)

;; terminal colors from your palette (ANSI 0-7 + bright variants)
(custom-theme-set-faces
 'rxyhn
 '(vterm-color-black   ((t (:foreground "#12171D" :background "#12171D"))))
 '(vterm-color-red     ((t (:foreground "#DF5B61" :background "#DF5B61"))))
 '(vterm-color-green   ((t (:foreground "#78B892" :background "#78B892"))))
 '(vterm-color-yellow  ((t (:foreground "#E9967E" :background "#E9967E"))))
 '(vterm-color-blue    ((t (:foreground "#79AAEB" :background "#79AAEB"))))
 '(vterm-color-magenta ((t (:foreground "#C488EC" :background "#C488EC"))))
 '(vterm-color-cyan    ((t (:foreground "#78B892" :background "#78B892"))))
 '(vterm-color-white   ((t (:foreground "#A9A9A9" :background "#A9A9A9"))))
 '(vterm-color-bright-black   ((t (:foreground "#12171D" :background "#767B7D"))))
 '(vterm-color-bright-red     ((t (:foreground "#DF5B61" :background "#DF5B61"))))
 '(vterm-color-bright-green   ((t (:foreground "#78B892" :background "#78B892"))))
 '(vterm-color-bright-yellow  ((t (:foreground "#E9967E" :background "#E9967E"))))
 '(vterm-color-bright-blue    ((t (:foreground "#79AAEB" :background "#79AAEB"))))
 '(vterm-color-bright-magenta ((t (:foreground "#C488EC" :background "#C488EC"))))
 '(vterm-color-bright-cyan    ((t (:foreground "#78B892" :background "#78B892"))))
 '(vterm-color-bright-white   ((t (:foreground "#A9A9A9" :background "#A9A9A9"))))
 ;; same colors for the ansi-term fallback
 '(term-color-black   ((t (:foreground "#12171D" :background "#12171D"))))
 '(term-color-red     ((t (:foreground "#DF5B61" :background "#DF5B61"))))
 '(term-color-green   ((t (:foreground "#78B892" :background "#78B892"))))
 '(term-color-yellow  ((t (:foreground "#E9967E" :background "#E9967E"))))
 '(term-color-blue    ((t (:foreground "#79AAEB" :background "#79AAEB"))))
 '(term-color-magenta ((t (:foreground "#C488EC" :background "#C488EC"))))
 '(term-color-cyan    ((t (:foreground "#78B892" :background "#78B892"))))
 '(term-color-white   ((t (:foreground "#A9A9A9" :background "#A9A9A9")))))


(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-startup-banner "~/.emacs.d/banner.jpg"
        dashboard-banner-logo-title "~ And now, The only balm to still my soul\n  Is to let loose my wrath with heavy hand ~"
        dashboard-center-content t
        dashboard-items '((bookmarks . 5) (recents . 5) (projects . 5))
        dashboard-set-heading-icons nil
        dashboard-set-file-icons nil)

  (setq dashboard-item-names
      '(("Recent Files:" . "◈ Recent Files:")
        ("Bookmarks:"    . "◈ Bookmarks:")
        ("Projects:"     . "◈ Projects:")))

  (setq initial-buffer-choice (lambda () (get-buffer-create "*dashboard*"))))

(set-face-attribute 'dashboard-banner-logo-title nil
                    :foreground "#ff9e64"
                    :weight 'bold)
;; Restore GC after init
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 2 1000 1000)
                  gc-cons-percentage 0.1)))

(provide 'init)
;;; init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(corfu dashboard eglot evil kind-icon markdown-xwidget nerd-icons
	   orderless rust-mode vterm))
 '(package-vc-selected-packages
   '((markdown-xwidget :vc-backend Git :url
		       "https://github.com/cfclrk/markdown-xwidget"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
