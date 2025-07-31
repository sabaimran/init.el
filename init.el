;; .emacs.d/init.el

;; ===================================
;; MELPA Package Support
;; ===================================
;; Enables basic packaging support

;; Setup Package Managers
(require 'package)

;; Bootstrap straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; Integrate use-package with straight.el
(straight-use-package 'use-package)
(setq straight-use-package-by-default t)

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
  :straight (khoj :type git :host github :repo "khoj-ai/khoj" :files ("src/interface/emacs/khoj.el"))
  :bind ("C-c s" . khoj))

;; To upgrade^ run C-u M-x quelpa RET. Then enter package name.

; Required for displaying emojis
(use-package all-the-icons
  :ensure t)

; Add emojify https://github.com/iqbalansari/emacs-emojify/tree/cfa00865388809363df3f884b4dd554a5d44f835
(use-package emojify
  :hook (after-init . global-emojify-mode))

;; Emoji: 😄, 🤦, 🏴󠁧󠁢󠁳󠁣󠁴󠁿

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

;; Writeroom mode provides an even more focused writing environment
;; https://github.com/joostkremers/writeroom-mode
(use-package writeroom-mode
  :ensure t
  :bind ("C-x w" . writeroom-mode))

;; Enable smoother scrolling inside the window
;; https://github.com/io12/good-scroll.el
(use-package good-scroll
  :init (good-scroll-mode)
  :ensure t)

;; Use rainbow delimeters for elisp
(use-package rainbow-delimiters
  :ensure t
  :hook ((emacs-lisp-mode . rainbow-delimiters-mode)))

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

;; Create a capture template for work-related tasks
(setq org-capture-templates
      '(("wo" "Create new todo" entry (file+headline "~/notes/probablygenetic.org" "Active")
         "* TODO %?\n :PROPERTIES:\n :CREATED: %t\n  :WORKITEM:\n :OKR:\n :END:")
        ("g" "Gratitute entry" entry (file+olp "~/notes/notes.org" "Areas" "Gratitude")
         "* TODO %?\n :SCHEDULED: %t\n1.\n2.\n3.\n\n")
        ("w" "Create new Khoj todo" entry (file+headline "~/notes/khoj.org" "Active")
         "* TODO %?\n :PROPERTIES:\n :CREATED: %t\n  :WORKITEM:\n :END:")
        ))

(setq js-comint-program-command "node") ;; Set node as inferior JS program command.
(setq js-comint-program-arguments '("--interactive"))
(when (version<= "26.0.50" emacs-version )
  (global-display-line-numbers-mode))             ;; Enable line numbers globally
(global-set-key (kbd "C-c a") 'org-agenda)

(good-scroll-mode 1)


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
