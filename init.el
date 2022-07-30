;; .emacs.d/init.el

;; ===================================
;; MELPA Package Support
;; ===================================
;; Enables basic packaging support

;; Setup Package Managers
(require 'package)
(setq package-archives '())
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)
(add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/") t)
(add-to-list 'package-archives '("elpy" . "http://jorgenschaefer.github.io/packages/") t)
(package-initialize)

;; Install use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; Install Quelpa
(unless (package-installed-p 'quelpa)
  (with-temp-buffer
    (url-insert-file-contents "https://raw.githubusercontent.com/quelpa/quelpa/master/quelpa.el")
    (eval-buffer)
    (quelpa-self-upgrade)))

;; Install Quelpa Use-Package
(quelpa
 '(quelpa-use-package
   :fetcher git
   :url "https://github.com/quelpa/quelpa-use-package.git"))
(require 'quelpa-use-package)

;; Some default settings for ease of setup on first run
(use-package better-defaults
  :ensure t)

;; A python mode for Emacs
(use-package elpy
  :ensure t)

;; A javascript mode for Emacs
(use-package js-comint
  :ensure t)

;; A package to export org files to ReactJs presentations
;; https://github.com/hexmode/ox-reveal
(use-package ox-reveal
  :ensure t)

;; The :chords keyword allows you to define key-chord bindings for use-package declarations in the same manner as the :bind keyword.
(use-package use-package-chords
  :ensure t
  :config (key-chord-mode 1))

;; Magit is a git porcelain (wrapper) within emacs
(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status)
  :config (setq magit-diff-refine-hunk 'all))

;; Undo tree allows you to visualize the tree of previous changes using M-x undo-tree-visualize
(use-package undo-tree
  :ensure t
  :diminish undo-tree-mode
  :config (progn (global-undo-tree-mode 1)
                 (setq undo-tree-visualizer-timestamps t)
                 (setq undo-tree-visualizer-diff t)))

;; Which Key suggests command completions with C-[]
(use-package which-key
  :ensure t
  :diminish which-key-mode
  :init (which-key-mode))


;; Khoj Package
(use-package khoj
  :after org
  :quelpa (khoj :fetcher url :url "https://raw.githubusercontent.com/debanjum/khoj/master/src/interface/emacs/khoj.el")
  :bind ("C-c s" . 'khoj))


;; Ivy for completion function everywhere where ido isn't used (for now)
(use-package ivy
  :ensure t
  :diminish
  :bind (("C-c C-r" . ivy-resume)
         ("C-c C-j" . ivy-immediate-done))
  :config (progn
            (ivy-mode)
            (setq
             ivy-wrap t
             ivy-use-virtual-buffers t
             enable-recursive-minibuffers t
             ivy-count-format ""
             ivy-initial-inputs-alist nil
             ivy-sort-matches-functions-alist '((t . nil)) ;; To sort most recent first
             ivy-re-builders-alist '((swiper . ivy--regex-plus)
                                     (t . ivy--regex-fuzzy)))))

;; Provides completion functions using Ivy.
(use-package counsel
  :ensure t
  :after (ivy use-package-chords)
  :diminish
  :chords (("yy" . counsel-yank-pop))
  :config (progn
            (counsel-mode)))

;; An enhanced completion front-end to search using Ivy
(use-package swiper
  :ensure t
  :bind (("C-s" . swiper)
         ("C-r" . swiper-backward)))


;; Including this package resolves a warning in AMX. Replaces stock emacs completion with ido completion wherever it is possible to do so without breaking things.
(use-package ido-completing-read+
  :ensure t
  :config (setq ido-ubiquitous-mode 1))

;; Amx for M-x persistent MRU for auto-completion.
;; Amx can rely on Ivy via counsel-M-x or ido completion backend for fuzzy candidate matching.
(use-package amx
  :ensure t
  :config (amx-mode))

;; Recentf suggests recently opened files on C-x C-r
(use-package recentf
  :ensure t
  :init (recentf-mode t)
  :bind ("C-x C-r" . counsel-recentf)
  :config (setq recentf-max-saved-items 50))


;; ===================================
;; Basic Customization
;; ===================================

(setq inhibit-startup-message t)    ;; Hide the startup message
(setq
 org-agenda-files '("/home/saba/notes/notes.org") ;; Add org file to org-agenda files
 org-agenda-todo-ignore-scheduled 'all ;; Ignore TODOs with schedules
 org-agenda-todo-ignore-deadlines 'all ;; Ignore TODOs with deadline
 org-agenda-tags-todo-honor-ignore-options t

 org-agenda-custom-commands
 '(
   ("A" "Immediate Tasks" todo "TODO"))) ;; Creates custom org agenda cmd to list tasks of the specified TODO types

(setq js-comint-program-command "node") ;; Set node as inferior JS program command.
(setq js-comint-program-arguments '("--interactive"))
(when (version<= "26.0.50" emacs-version )
  (global-display-line-numbers-mode))             ;; Enable line numbers globally
(global-set-key (kbd "C-c a") 'org-agenda)

;; ====================================
;; Development Setup
;; ====================================
(elpy-enable) ;; Enable elpy
(add-hook 'text-mode-hook #'visual-line-mode) ;; Use visual line mode
(global-auto-revert-mode)

;; Start-up with soft-wrap enabled
;;(setq org-startup-truncated nil)

;; Do not validate on HTML export
(setq org-html-validation-link nil)

;; User-Defined init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default bold shadow italic underline bold bold-italic bold])
 '(custom-enabled-themes (quote (misterioso)))
 '(org-tags-column 60)
 '(package-selected-packages
   (quote
    (ox-reveal js2-mode js-comint undo-tree elpy use-package python magit better-defaults))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
