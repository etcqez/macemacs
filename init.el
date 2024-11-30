;; clm/open-command-log-buffer C-c o
;; evll C-c C-e

(desktop-save-mode 1)
;; (tool-bar-mode -1)
;; (tooltip-mode -1)
;; (menu-bar-mode -1)
(global-display-line-numbers-mode 1)
(save-place-mode 1)
(setq auto-save-default nil)


(recentf-mode 1)
(savehist-mode 1)
;; (add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))

;; Initialize package sources
(require 'package)
(setq package-archives '(("gnu" . "https://mirrors.ustc.edu.cn/elpa/gnu/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("melpa" . "https://mirrors.ustc.edu.cn/elpa/melpa/")
                         ("nongnu" . "https://mirrors.ustc.edu.cn/elpa/nongnu/")))
(package-initialize)
(setq use-package-always-ensure t)
(unless package-archive-contents
  (package-refresh-contents))
(require 'use-package)
(setq use-package-always-ensure t)

;; 计时器
(use-package popup
  :config
  (setq pyim-page-tooltip 'popup)
  )

;;; Vim Bindings
(use-package evil
  :demand t
  ;; :bind (
  ;; ("<escape>" . evil-force-normal-state)
  ;; )
  :init
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1)
  (evil-set-undo-system 'undo-fu)
  )
;;
(use-package evil-commentary
  :demand t
  :config
  (evil-commentary-mode)
  (define-key evil-motion-state-map (kbd "g c") 'evil-commentary-line)
  )
;;; Vim Bindings Everywhere else
(use-package evil-collection
  :after evil
  :config
  (setq evil-want-integration t)
  (evil-collection-init))
(use-package evil-surround
  :ensure t
  :config
  (global-evil-surround-mode 1))


(use-package vertico
  :ensure t
  :config
  (setq vertico-cycle t)
  (setq vertico-resize nil)
  (vertico-mode 1)
  )
(use-package marginalia
  :ensure t
  :config
  (marginalia-mode 1))
(progn
  (vertico-mode 'toggle)
  (marginalia-mode 'toggle))
(vertico-mode 1)
(marginalia-mode 1)


(save-place-mode 1)

(global-set-key "\C-x\C-\\" 'goto-last-change)

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
;; (load custom-file)

(use-package orderless
  :ensure t
  :config
  (setq completion-styles '(orderless basic)))

;; consult
(use-package consult
  :ensure t
  :bind (;; A recursive grep
         ("M-s M-g" . consult-grep)
         ;; Search for files names recursively
         ("M-s M-f" . consult-find)
         ;; Search through the outline (headings) of the file
         ("M-s M-o" . consult-outline)
         ;; Search the current buffer
         ("M-s M-l" . consult-line)
         ;; Switch to another buffer, or bookmarked file, or recently
         ;; opened file.
         ("M-s M-b" . consult-buffer)))
(use-package embark
  :ensure t
  :bind (("C-." . embark-act)
         :map minibuffer-local-map
         ("C-c C-c" . embark-collect)
         ("C-c C-e" . embark-export)))
(use-package embark-consult
  :ensure t)
(use-package rainbow-mode
  :demand t
  :config
  (rainbow-mode)
  )

;; vim
(with-eval-after-load 'evil
  (define-key evil-motion-state-map (kbd "0") 'evil-first-non-blank)
  )
(defun phg/kill-to-bol ()
  "Kill from point to beginning of line."
  (interactive)
  (kill-line 0))
(define-key evil-insert-state-map (kbd "C-u") 'phg/kill-to-bol)
;; vim-numbers
(define-key evil-normal-state-map (kbd "C-a") 'evil-numbers/inc-at-pt)
(define-key evil-normal-state-map (kbd "C-e") 'evil-numbers/dec-at-pt)
(define-key evil-normal-state-map (kbd "=") 'lsp-format-buffer)
(define-key evil-normal-state-map (kbd "+") 'format-all-buffer)
(use-package format-all
  :commands format-all-mode
  :hook (prog-mode . format-all-mode)
  :config
  (setq-default format-all-formatters
                '(("C"     (astyle "--mode=c"))
                  ("Shell" (shfmt "-i" "4" "-ci")))))

;; scrolloff
(setq scroll-step 1)
(setq scroll-margin 5)
(setq scroll-conservatively 9999)

;; emacs
(define-key evil-insert-state-map (kbd "C-e") #'end-of-line)
(define-key evil-insert-state-map (kbd "C-a") #'evil-insert-line)
(define-key evil-insert-state-map (kbd "C-k") #'kill-line)
(define-key evil-normal-state-map (kbd "C-h") #'evil-window-left)
(define-key evil-normal-state-map (kbd "C-j") #'evil-window-down)
(define-key evil-normal-state-map (kbd "C-k") #'evil-window-up)
(define-key evil-normal-state-map (kbd "C-l") #'evil-window-right)
(define-key evil-insert-state-map (kbd "C-d") #'evil-paste-last-insertion)

;; C-s
(defun save-with-normal (number)       ; Interactive version.
  (interactive "p")
  (save-buffer)
  (evil-normal-state))
(define-key global-map (kbd "C-s") 'save-with-normal)

(define-key evil-insert-state-map (kbd "C-n") #'next-line)
(define-key evil-insert-state-map (kbd "C-p") #'previous-line)
(define-key evil-insert-state-map (kbd "C-t") #'transpose-chars)
(define-key evil-normal-state-map (kbd "<tab>") #'evil-shift-right)
(define-key evil-normal-state-map (kbd "s") #'avy-goto-char-timer)
(use-package avy
  :ensure t
  :config)
(define-key evil-insert-state-map (kbd "C-y") #'yank)

;; s
(setq avy-background t)
(setq avy-keys (number-sequence ?a ?z))
(setq avy-all-windows t)

;; u C-r
(define-key evil-normal-state-map (kbd "u") #'undo)
(define-key evil-normal-state-map (kbd "C-r") #'undo-redo)

(with-eval-after-load 'org
  (define-key evil-motion-state-map (kbd "C-d") #'evil-forward-paragraph)
  )

;; 切换最近buffer
(defun switch-to-last-buffer ()
  (interactive)
  (switch-to-buffer nil))
(global-set-key (kbd "C-<backspace>") 'switch-to-last-buffer)
(defadvice switch-to-buffer (before save-buffer-now activate)
  (when buffer-file-name (save-buffer)))
(defadvice other-window (before other-window-now activate)
  (when buffer-file-name (save-buffer)))
(defadvice other-frame (before other-frame-now activate)
  (when buffer-file-name (save-buffer)))

(setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo")))

;; 在treemacs中, 使用emacs键绑定
(evil-set-initial-state 'treemacs-mode 'emacs)

;; 禁用光标闪烁
(blink-cursor-mode 0)

;; 光标颜色
(setq evil-default-cursor       '("DodgerBlue1" box)
      evil-normal-state-cursor  '("DeepPink" box)
      evil-emacs-state-cursor   '("orange" bar)
      evil-motion-state-cursor  '("SeaGreen1" box)
      evil-insert-state-cursor  '("white" bar)
      evil-visual-state-cursor  '("white" bar)
      evil-replace-state-cursor '("pink" box))
(setopt use-short-answers t)

;; 字体
(set-face-attribute 'default nil :height 150)
;; v模式颜色
(set-face-attribute 'region nil :background "SpringGreen4")
(set-face-attribute 'mouse-drag-and-drop-region nil :background "#be369c")
(set-face-attribute 'mode-line nil :foreground "FloralWhite" :background "RoyalBlue")
;; 搜索颜色
(set-face-attribute 'lazy-highlight nil :foreground "black" :background "DarkOliveGreen3")
(set-face-attribute 'isearch nil :foreground "black" :background "red")
;; 括号颜色
(set-face-attribute 'show-paren-match nil :foreground "DeepPink" :background "#00000000")
;; vertico
(set-face-attribute 'vertico-current nil :foreground "black" :background "DarkSeaGreen3")
;; marginalia
(set-face-attribute 'marginalia-documentation nil :foreground "dark red")
;; avy
(set-face-attribute 'avy-goto-char-timer-face nil :foreground "black" :background "aquamarine4")
(set-face-attribute 'avy-lead-face nil :foreground "black" :background "OrangeRed4")
(set-face-attribute 'avy-lead-face-0 nil :foreground "black" :background "OrangeRed4")
(set-face-attribute 'avy-lead-face-1 nil :foreground "black" :background "OrangeRed4")
(set-face-attribute 'avy-lead-face-2 nil :foreground "black" :background "OrangeRed4")
;; 行号
(set-face-attribute 'line-number-current-line nil :foreground "CadetBlue1")

(use-package treemacs
  :ensure t
  :config
  (define-key evil-normal-state-map (kbd "C-t") 'treemacs)
  (define-key evil-emacs-state-map (kbd "C-t") 'treemacs)
  )

(setq make-backup-files nil)


;; 暂时没用
;; (define-key evil-normal-state-map (kbd "C-t") 'treemacs-display-current-project-exclusively)
;; 在vim的插入模式使用emacs
;; (define-key evil-normal-state-map (kbd "i") #'evil-emacs-state)
;; (define-key evil-emacs-state-map (kbd "<escape>") #'evil-force-normal-state)
