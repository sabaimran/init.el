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

(use-package better-defaults
  :ensure t)

(use-package elpy
  :ensure t)

(use-package js-comint
  :ensure t)

(use-package ox-reveal
  :ensure t)

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

;; Which Key suggests command complaetions with C-[]
(use-package which-key
  :ensure t
  :diminish which-key-mode
  :init (which-key-mode))

;; Org-Semantic Search Library
(use-package semantic-search
  :quelpa (semantic-search :fetcher url :url "https://raw.githubusercontent.com/debanjum/semantic-search/master/interface/emacs/semantic-search.el")
  :bind ("C-c s" . 'semantic-search))

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
