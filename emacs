(require 'package)
(push '("marmalade" . "http://marmalade-repo.org/packages/")
      package-archives)
(push '("melpa" . "http://melpa.milkbox.net/packages/")
      package-archives)
(package-initialize)

(require 'evil)
(evil-mode 1)

; Save tmpfiles in /tmp rather than the current directory.
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))

(defun my-move-key (keymap-from keymap-to key)
  "Moves key binding from one keymap to anther, deleting from the old location."
  (define-key keymap-to key (lookup-key keymap-from key))
  (define-key keymap-from key nil))
(my-move-key evil-motion-state-map evil-normal-state-map (kbd "RET"))
(my-move-key evil-motion-state-map evil-normal-state-map " ")

(define-key evil-normal-state-map (kbd "RET") 'save-buffer)

(require 'xcscope)
(define-key evil-normal-state-map (kbd "C-]")
            'cscope-find-global-definition-no-prompting)
(define-key evil-normal-state-map (kbd "C-\\ c")
            'cscope-find-functions-calling-this-function)
(define-key evil-normal-state-map (kbd "C-\\ g")
            'cscope-find-global-definition-no-prompting)
(define-key evil-normal-state-map (kbd "C-\\ f") 'cscope-find-this-file)
(define-key evil-normal-state-map (kbd "C-\\ s") 'cscope-find-this-symbol)
(define-key evil-normal-state-map (kbd "C-\\ a")
            'cscope-find-assignments-to-this-symbol)
(define-key evil-normal-state-map (kbd "C-t") 'cscope-pop-mark)

; Show the current line and column.
(setq column-number-mode t)
(setq line-number-mode t)

; Underscores aren't word boundaries.
(modify-syntax-entry ?_ "w")

; If I open a symlink, follow the symlink.
(setq find-file-visit-truename t)

; Don't create a welcome screen.
(setq inhibit-splash-screen t)