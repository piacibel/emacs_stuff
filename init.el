;; init.el --- Emacs configuration

;;;;;;;;;;;;;;
;; PACKAGES ;;
;;;;;;;;;;;;;;

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
;; and `package-pinned-packages`. Most users will not need or want to do this.
;;(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

(require 'better-defaults)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;; General settings ;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Concat following to current line
(defun concat-lines ()
  (interactive)
  (next-line)
  (join-line)
  (delete-horizontal-space))
(global-set-key (kbd "M-j") 'concat-lines)

;; Disable some HUD
(line-number-mode nil)
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode 0)
(show-paren-mode 1)

;; New shortcut
(global-set-key (kbd "C-x p") 'previous-multiframe-window) ;; Go to previous buffer (possibly inside another frame)
(global-set-key (kbd "C-x o") 'next-multiframe-window) ;; Go to next buffer (possibly inside another frame)
(global-set-key "\C-cy" '(lambda ()
			   (interactive)
			   (popup-menu 'yank-menu)))
;;(global-set-key "\C-S" 'isearch-forward-regexp)  ;; trnasfomr seach into regexp searcho
;; remap C-a to `smarter-move-beginning-of-line'
(global-set-key [remap move-beginning-of-line]
                'smarter-move-beginning-of-line)
;; Magit
(global-set-key (kbd "C-x g") 'magit-status)
