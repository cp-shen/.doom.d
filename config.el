(setq user-full-name "Cresce Shen"
      user-mail-address "scp@archlinuxscp.dev")

(setq doom-font (font-spec
                 :family "JetBrainsMono Nerd Font"
                 :size 18 :weight 'normal))

(setq doom-theme 'doom-one)

(setq display-line-numbers-type t)
(setq fancy-splash-image nil)
(setq doom-modeline-height 18)
(setq all-the-icons-scale-factor 1.0)

(setq mpv-default-options '("--no-vid" "--shuffle"))

(setq org-directory "~/org/")

(after! org
  (setq
   org-highest-priority ?A
   org-default-priority ?B
   org-lowest-priority ?E)
  (setq org-priority-faces
   '((?A . error)
     (?B . warning)
     (?C . warning)
     (?D . success)
     (?E . success)))
  (setq org-startup-folded 'content)
  (setq org-cycle-emulate-tab nil)
  (setq org-agenda-start-with-log-mode t)
  (setq org-agenda-start-with-clockreport-mode nil)
  (setq org-agenda-start-day "-7d")
  (setq org-agenda-span 15)
  (setq org-agenda-show-current-time-in-grid nil)
  (setq org-agenda-use-time-grid nil)
  (setq org-agenda-log-mode-items '(clock))
  (setq org-log-into-drawer t)
  (setq org-log-done 'time))

(after! org
  ;; Ob-sagemath supports only evaluating with a session.
  (setq org-babel-default-header-args:sage '((:session . t)
                                          (:results . "output")))
  ;; C-c c for asynchronous evaluating (only for SageMath code blocks).
  ;; (with-eval-after-load "org"
  ;; (define-key org-mode-map (kbd "C-c c") 'ob-sagemath-execute-async))

  ;; Do not confirm before evaluation
  (setq org-confirm-babel-evaluate nil)

  ;; Do not evaluate code blocks when exporting.
  (setq org-export-use-babel nil)

  ;; Show images when opening a file.
  (setq org-startup-with-inline-images t)

  ;; Show images after evaluating code blocks.
  (add-hook 'org-babel-after-execute-hook 'org-display-inline-images))

(after! evil
  (setq evil-want-fine-undo t)
  (setq evil-ex-substitute-global t))

(map! :g "C-s" #'save-buffer)
(map! (:when (modulep! :ui workspaces)
       :g "M-["   #'+workspace:switch-previous
       :g "M-]"   #'+workspace:switch-next
       :n "C-S-t" #'+workspace/new
       :n "M-t"   #'+workspace/display
       :n "C-t"   #'+workspace/display))
(map! (:when (and (modulep! :tools lsp) (not (modulep! :tools lsp +eglot)))
       :leader (:prefix "c" :desc "LSP lens toggle" "L" #'lsp-lens-mode)))
(map! (:map magit-diff-section-map
        :g "S-<return>" #'magit-diff-visit-file-other-window
        :g "M-<return>" #'magit-diff-visit-file-other-window
        ))
(map! (:map  vterm-mode-map "C-M-]"  nil "M-]" nil))

(after! lsp-ui
  ;; lsp-ui-doc
  (setq lsp-ui-doc-show-with-mouse nil
        lsp-ui-doc-show-with-cursor nil
        lsp-ui-doc-max-height 20
        lsp-ui-doc-max-width 100
        lsp-ui-doc-delay 0.2
        lsp-ui-doc-use-childframe t
        lsp-ui-doc-use-webkit nil
        lsp-ui-doc-position 'top))

(after! lsp-mode
  ;; lsp lens
  (setq lsp-lens-enable t)
  ;; lsp eldoc
  (setq lsp-eldoc-enable-hover t)
  ;; lsp headerline
  (setq lsp-headerline-breadcrumb-enable nil)
  ;; lsp signature
  ;; (setq lsp-signature-auto-activate nil)
  (setq lsp-signature-render-documentation nil))

(setq lsp-clients-clangd-args '("-j=3"
				"--background-index"
				"--clang-tidy"
				"--completion-style=detailed"
				"--header-insertion=never"
				"--header-insertion-decorators=0"))
(after! lsp-clangd (set-lsp-priority! 'clangd 2))
(after! lsp-rust (setq lsp-rust-analyzer-server-display-inlay-hints t)
    (add-hook 'lsp-after-open-hook (lambda ()
                                 (when (lsp-find-workspace 'rust-analyzer nil)
                                   (lsp-rust-analyzer-inlay-hints-mode)))))

;; (after! ccls
;;   (setq ccls-initialization-options '(:index (:comments 2) :completion (:detailedLabel t)))
;;   (set-lsp-priority! 'ccls 2)) ; optional as ccls is the default in Doom

(after! lsp-nix
  (setq lsp-nix-nil-formatter ["nixpkgs-fmt"]
        lsp-nix-nil-server-path "nil"))
