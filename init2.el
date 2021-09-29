;; init.el --- Emacs configuration

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

;; Change mode-line font size
;; (set-face-attribute 'mode-line nil :font "DejaVu Sans Mono-10")

;; User defined fct :
(defun smarter-move-beginning-of-line (arg)
  "Move point back to indentation of beginning of line.

Move point to the first non-whitespace character on this line.
If point is already there, move to the beginning of the line.
Effectively toggle between the first non-whitespace character and
the beginning of the line.

If ARG is not nil or 1, move forward ARG - 1 lines first.  If
point reaches the beginning or end of the buffer, stop there."
  (interactive "^p")
  (setq arg (or arg 1))

  ;; Move lines first
  (when (/= arg 1)
    (let ((line-move-visual nil))
      (forward-line (1- arg))))

  (let ((orig-point (point)))
    (back-to-indentation)
    (when (= orig-point (point))
      (move-beginning-of-line 1))))

;; Open header of fits file
(defun open-fits-header(input-file)
  "This function takes a fits file in argument and display its
  header contents inside a new buffer called with the name of the
  fits file (without the extension)
  "
  (interactive "FFits Filename: ")
  (generate-new-buffer (file-name-base input-file))
  (switch-to-buffer (file-name-base input-file))
  (conf-mode)
  (call-process "fitsheader" nil t nil (expand-file-name input-file))
  )


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; User defined hooks ;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;Check before exiting
(add-hook 'kill-emacs-query-functions
          (lambda () (y-or-n-p "Do you really want to exit Emacs? "))
          'append)
;; Change theme for org mode
;; (add-hook 'org-mode-hook
;; 	  (lambda nil (load-theme-buffer-local 'tsdh-dark (current-buffer))))

(add-hook 'prog-mode-hook
	  #'rainbow-delimiters-mode 1)
(add-hook 'prog-mode-hook
	  #'highlight-numbers-mode 1)
(add-hook 'prog-mode-hook
	  #'which-function-mode 1)
;; delete trailing white space when saving
(add-hook 'before-save-hook 'delete-trailing-whitespace)

(add-hook 'after-init-hook #'global-flycheck-mode)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; Load packages and install if not found ;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'package)
(add-to-list 'package-archives '("elpy" . "http://jorgenschaefer.github.io/packages/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))

;; activate all packages
(package-initialize)

;; INSTALL PACKAGES
;; --------------------------------------

(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))


(defvar myPackages
  '(better-defaults
    ;; material-theme
    ;; zenburn-theme
    ;; solarized-theme
    gruvbox-theme
    elpy
    pyenv-mode))

(mapc #'(lambda (package)
    (unless (package-installed-p package)
      (package-install package)))
      myPackages)

(setq inhibit-startup-message t)   ;; hide the startup message
(global-linum-mode t)              ;; enable line numbers globally
(setq linum-format "%4d \u2502 ")  ;; format line number spacing
;; Allow hash to be entered
(global-set-key (kbd "M-3") '(lambda () (interactive) (insert "#")))


;;;;;;;;;;;
;; THEME ;;
;;;;;;;;;;;

;; (when (display-graphic-p)
; (load-theme 'material t)
; (load-theme 'zenburn t)
; (load-theme 'solarized-dark t)
(load-theme 'gruvbox-dark-hard t)

;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; Python ;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;

(elpy-enable)
(pyenv-mode)
(setq python-shell-interpreter "ipython"
      python-shell-interpreter-args "-i --simple-prompt")
(define-key elpy-mode-map (kbd "M-ù") 'elpy-goto-definition)

;; Yas
(add-to-list 'load-path
              "~/.emacs.d/plugins/yasnippet")
(require 'yasnippet)
(yas-minor-mode 1)
(define-key yas-minor-mode-map (kbd "C-c <tab>") #'yas-expand)


;;;;;;;;;;;;;;;;;;;;
;;;;;;; Helm ;;;;;;; Source : https://tuhdo.github.io/helm-intro.html
;;;;;;;;;;;;;;;;;;;;

(require 'helm)
(require 'helm-config)
(global-set-key (kbd "M-x") 'helm-M-x)

(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to run persistent action
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB work in terminal
(define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z
(global-set-key (kbd "C-x C-f")  'helm-find-files) ; list actions using C-z

(setq helm-split-window-in-side-p           t ; open helm buffer inside current window, not occupy whole other window
      helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
      helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
      helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
      helm-ff-file-name-history-use-recentf t
      helm-echo-input-in-header-line t)

(helm-mode 1)
(helm-autoresize-mode 1)

;;;;;;;;;;;;;;;
;; MODE LINE ;;
;;;;;;;;;;;;;;;

;; Use spaceline
(require 'spaceline)
(require 'spaceline-config)
(spaceline-emacs-theme)
(spaceline-helm-mode 1)
(spaceline-toggle-minor-modes-off)

;;;;;;;;;;;;;;;;;;;;;
;; BETTER DEFAULTS ;;
;;;;;;;;;;;;;;;;;;;;;

(require 'better-defaults)

;;;;;;;;;;;
;; DIRED ;;
;;;;;;;;;;;

(setq dired-listing-switches "-alh")


;;;;;;;;;;;;;;;;
;; HIGHLIGHTS ;;
;;;;;;;;;;;;;;;;

(require 'highlight-symbol)
(highlight-symbol-mode 1)

;;;;;;;;;;;;;;;;;;;;;;
;; CUSTOM VARIABLES ;;
;;;;;;;;;;;;;;;;;;;;;;

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("4cf9ed30ea575fb0ca3cff6ef34b1b87192965245776afa9e9e20c17d115f3fb" "51ec7bfa54adf5fff5d466248ea6431097f5a18224788d0bd7eb1257a4f7b773" "830877f4aab227556548dc0a28bf395d0abe0e3a0ab95455731c9ea5ab5fe4e1" default)))
 '(elpy-modules
   (quote
    (elpy-module-company elpy-module-eldoc elpy-module-pyvenv elpy-module-highlight-indentation elpy-module-yasnippet elpy-module-django elpy-module-sane-defaults)))
 '(inhibit-startup-screen t)
 '(magit-submodule-arguments nil)
 '(package-selected-packages
   (quote
    (wgrep-helm flycheck gruvbox-theme solarized-theme zenburn-theme helm-swoop highlight-symbol spaceline helm-pydoc helm highlight-numbers yasnippet-snippets rainbow-delimiters pyenv-mode rainbow-identifiers material-theme markdown-mode magit ini-mode elpy company-quickhelp company-jedi cmake-mode better-defaults auctex))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(font-lock-function-name-face ((t (:foreground "cyan"))))
 '(font-lock-keyword-face ((t (:foreground "#fff59d" :weight extra-bold))))
 '(highlight-numbers-number ((t (:foreground "chartreuse")))))


;;;;;;;;;;;
;; SWOOP ;;
;;;;;;;;;;;

(require 'helm-swoop)

;; Change keybinds to whatever you like :)
(global-set-key (kbd "M-i") 'helm-swoop)
(global-set-key (kbd "M-I") 'helm-swoop-back-to-last-point)
(global-set-key (kbd "C-c M-i") 'helm-multi-swoop)
(global-set-key (kbd "C-x M-i") 'helm-multi-swoop-all)

;; When doing isearch, hand the word over to helm-swoop
(define-key isearch-mode-map (kbd "M-i") 'helm-swoop-from-isearch)
(define-key helm-swoop-map (kbd "M-i") 'helm-multi-swoop-all-from-helm-swoop)

;; If this value is t, split window inside the current window
(setq helm-swoop-split-with-multiple-windows t)

;; Split direction.  'split-window-vertically or 'split-window-horizontally
(setq helm-swoop-split-direction 'split-window-vertically)

;; Go to the opposite side of line from the end or beginning of line
(setq helm-swoop-move-to-line-cycle t)
;; Face name is `helm-swoop-line-number-face`
(setq helm-swoop-use-line-number-face t)


;;;;;;;;;
;; EUH ;;
;;;;;;;;;
