;; custom key bindings
(defun scroll-up-half-screen ()
  "<C-d> a la Vim"
  (interactive)
  (scroll-up-command)
  (recenter))
(global-set-key (kbd "C-;") 'scroll-up-half-screen)
(defun scroll-down-half-screen ()
  "<C-u> a la Vim"
  (interactive)
  (scroll-down-command)
  (recenter))
(global-set-key (kbd "C-'") 'scroll-down-half-screen)

(load-file (let ((coding-system-for-read 'utf-8))
                (shell-command-to-string "agda-mode locate")))

;; auto-load agda-mode for .agda and .lagda.md
(setq auto-mode-alist
   (append
     '(("\\.agda\\'" . agda2-mode)
       ("\\.lagda.md\\'" . agda2-mode))
     auto-mode-alist))
