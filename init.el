;; initialize the package manager
(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
		    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (when no-ssl
    (warn "\
Your version of Emacs does not support SSL connections,
which is unsafe because it allows man-in-the-middle attacks.
There are two things you can do about this warning:
1. Install an Emacs version that does support SSL and be safe.
2. Remove this warning from your init file so you won't see it again."))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives (cons "gnu" (concat proto "://elpa.gnu.org/packages/")))))
(package-initialize)

;; use a spell-checker
(setq-default ispell-program-name "aspell")

;; theme & font
(load-theme 'dracula t)
(add-to-list 'default-frame-alist '(font . "DejaVu Sans Mono-12"))
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)

;; hide annoying things
(setq inhibit-startup-message t)
(tool-bar-mode -1)
(require 'cl-lib)
(defadvice save-buffers-kill-emacs (around no-query-kill-emacs activate)
  "Prevent annoying \"Active processes exist\" query when you quit Emacs."
  (cl-letf (((symbol-function #'process-list) (lambda ())))
    ad-do-it))
(setq make-backup-files nil)
(setq auto-save-default nil)

;; show paired parens
(show-paren-mode 1)

;; enable control-c control-v for copy and paste
(cua-mode t)

;; allow emojis
;; (add-hook 'after-init-hook #'global-emojify-mode)

;; auto-complete
(company-mode t)
;; see https://tabnine.com/
(require 'company-tabnine)
(add-to-list 'company-backends #'company-tabnine)
(setq company-idle-delay 0)
(setq company-show-numbers t)

;; show line numbers and column numbers
(global-linum-mode t)
(column-number-mode t)

;; set starting directory
(setq default-directory "~/")

;; short-cut for googling
;; (google-this-mode 1)
;; (global-set-key (kbd "C-c g") 'google-this)

;; load stuff on Duncan
(when (eq system-type 'gnu/linux)
  (progn
    (setq exec-path (append exec-path '("/home/mvc/.cabal/bin")))
    (setenv "PATH" (concat (getenv "PATH") ":/home/mvc/.cabal/bin"))
    (setq exec-path (append exec-path '("/home/mvc/.local/bin")))
    (setenv "PATH" (concat (getenv "PATH") ":/home/mvc/.local/bin"))
    ))

;; load stuff on mac
(when (eq system-type 'darwin)
  (progn
    (setq exec-path (append exec-path '("/Applications/Racket v7.5/bin")))
    (setenv "PATH" (concat (getenv "PATH") ":/Applications/Racket v7.5/bin"))
    (setq exec-path (append exec-path '("/Users/mvc/Library/Haskell/bin")))
    (setenv "PATH" (concat (getenv "PATH") ":/Users/mvc/Library/Haskell/bin"))
    (setq exec-path (append exec-path '("/Users/mvc/.local/bin")))
    (setenv "PATH" (concat (getenv "PATH") ":/Users/mvc/.local/bin"))
    (setq exec-path (append exec-path '("/usr/local/bin/")))
    (setenv "PATH" (concat (getenv "PATH") ":/usr/local/bin/"))
    ))

;; enable vim key-bindings
; (require 'evil)
(evil-mode 1)
(setq evil-toggle-key "")
(setcdr evil-insert-state-map nil)
(define-key evil-insert-state-map [escape] 'evil-normal-state)

;; enable paredit mode
(paredit-mode t)

;; tweak for Agda
; (load-file (let ((coding-system-for-read 'utf-8))
; 	     (shell-command-to-string "agda-mode locate")))
; (require 'agda-input)
; (add-hook 'agda2-mode-hook (lambda () (local-set-key (kbd "RET") 'newline-and-indent)))
; (add-hook 'agda2-mode-hook 'company-mode)

;; tweak for elisp
(add-hook 'emacs-lisp-mode-hook 'company-mode)
(add-hook 'emacs-lisp-mode-hook 'paredit-mode)
(add-hook 'emacs-lisp-mode-hook 'evil-paredit-mode)
(add-hook 'emacs-lisp-mode-hook (lambda () (local-set-key [tab] 'company-complete)))

;; tweak for racket
(add-hook 'racket-mode-hook 'company-mode)
(add-hook 'racket-mode-hook 'paredit-mode)
(add-hook 'racket-mode-hook 'evil-paredit-mode)
; (add-hook 'racket-mode-hook (lambda () (set-input-method "Agda")))
(add-hook 'racket-mode-hook (lambda () (local-set-key (kbd "RET") 'newline-and-indent)))
(add-hook 'racket-mode-hook (lambda () (local-set-key [tab] 'company-complete)))
(add-hook 'racket-repl-mode-hook 'company-mode)
(add-hook 'racket-repl-mode-hook 'paredit-mode)
(add-hook 'racket-repl-mode-hook 'evil-paredit-mode)
; (add-hook 'racket-repl-mode-hook (lambda () (set-input-method "Agda")))
(add-hook 'racket-mode-hook (lambda () (put 'go-on 'racket-indent-function 1)))
(add-hook 'racket-mode-hook (lambda () (put 'fresh 'racket-indent-function 1)))
(add-hook 'racket-mode-hook (lambda () (put 'all 'racket-indent-function 1)))
(add-hook 'racket-mode-hook (lambda () (put '⊃ 'racket-indent-function 1)))
(add-hook 'racket-mode-hook (lambda () (put 'new-name 'racket-indent-function 1)))
(add-hook 'racket-mode-hook (lambda () (put 'λS 'racket-indent-function 1)))
(add-hook 'racket-mode-hook (lambda () (put 'run 'racket-indent-function 2)))
(add-hook 'racket-mode-hook (lambda () (put 'union-case 'racket-indent-function 2)))

;; tweak for scheme
(add-to-list 'auto-mode-alist '("\\.scm\\'" . racket-mode))

;; tweak for pie
(add-to-list 'auto-mode-alist '("\\.pie\\'" . racket-mode))
(add-hook 'racket-mode-hook (lambda () (put 'claim 'racket-indent-function 1)))
(add-hook 'racket-mode-hook (lambda () (put 'which-Nat 'racket-indent-function 1)))
(add-hook 'racket-mode-hook (lambda () (put 'iter-Nat 'racket-indent-function 1)))
(add-hook 'racket-mode-hook (lambda () (put 'rec-Nat 'racket-indent-function 1)))
(add-hook 'racket-mode-hook (lambda () (put 'ind-Nat 'racket-indent-function 1)))
(add-hook 'racket-mode-hook (lambda () (put 'Π 'racket-indent-function 1)))
(add-hook 'racket-mode-hook (lambda () (put 'Σ 'racket-indent-function 1)))
(add-hook 'racket-mode-hook (lambda () (put '→ 'racket-indent-function 1)))
(add-hook 'racket-mode-hook (lambda () (put 'ind-List 'racket-indent-function 1)))
(add-hook 'racket-mode-hook (lambda () (put 'rec-List 'racket-indent-function 1)))
(add-hook 'racket-mode-hook (lambda () (put 'ind-Vec 'racket-indent-function 2)))
(add-hook 'racket-mode-hook (lambda () (put 'replace 'racket-indent-function 1)))
(add-hook 'racket-mode-hook (lambda () (put 'ind-Either 'racket-indent-function 1)))

;; tweak for python
(add-hook 'python-mode-hook 'company-mode)
;; python is gabbage
(setq python-indent-offset 4)

; ;; tweak for teyjus
; (load "~/Apps/teyjus/emacs/teyjus.el")
; (add-hook 'teyjus-mode-hook 'company-mode)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("a9b0c91fe54820797a8caafa6f102714c884358335e8238bef38a2603097271a" "a452345f40a4e1db132963ee8fee1a3018c13115871cb2658db153fad8a0db85" default)))
 '(package-selected-packages
   (quote
    (linum-relative dracula-theme emojify company-tabnine rust-mode racket-mode proof-general package-lint organic-green-theme haskell-mode google-this fireplace evil-paredit csv-mode company-coq))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Zac
(linum-relative-mode t)
(setq linum-relative-current-symbol "")
