;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Cp Shen"
      user-mail-address "scp@archlinuxscp.xyz")

(setq doom-font (font-spec
                 :family "CaskaydiaCove Nerd Font"
                 :size 18 :weight 'normal))
;; (setq doom-unicode-font doom-font)
;; Don't set this, let unicode-fonts delects fonts for glyphs

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.





;; appearance settings --------------
;;
(setq fancy-splash-image nil)
(setq doom-modeline-height 18)
(setq all-the-icons-scale-factor 1.0)

;; evil settings --------------
;;
(after! evil
  (setq evil-want-fine-undo t)
  (setq evil-ex-substitute-global t))

;; org mode settings --------------
;;
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

;; keybindings -----------------
;;
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

;; lsp settings --------------
;;
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

;; (after! ccls
;;   (setq ccls-initialization-options '(:index (:comments 2) :completion (:detailedLabel t)))
;;   (set-lsp-priority! 'ccls 2)) ; optional as ccls is the default in Doom
