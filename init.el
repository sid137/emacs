
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;  Emacs config - Sidney Burks
;;;  sudo apt-get install ecb


(add-to-list 'load-path "~/.emacs.d/")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Emacs Configuration

(defun reload-emacs ()
  "Reload .emacs file without restarting"
  (interactive)
  (load-file "~/.emacs.d/init.el"))

(global-set-key [f9] 'reload-emacs)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Multi-term
(require 'multi-term)
(setq multi-term-program "/bin/zsh")
(global-set-key (kbd "C-c t") 'multi-term)
(global-set-key (kbd "C-c n") 'rename-buffer)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Pastie-Integration
;;; http://chneukirchen.org/blog/category/emacs.html
;; *

;;   pastie-region pastes the current region, shows the URL of the new paste and puts it in the kill buffer for immediate pasting.
;;   pastie-buffer pastes the whole buffer.
;;   pastie-get asks for a Pastie paste id and fetches it into an appropriate buffer.





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Save Desktop Session State
;http://stackoverflow.com/questions/847962/what-alternate-session-managers-are-available-for-emacs


(defvar my-desktop-session-dir
  (concat (getenv "HOME") "/.emacs.d/desktop-sessions/")
  "*Directory to save desktop sessions in")

(defvar my-desktop-session-name-hist nil
  "Desktop session name history")

(defun my-desktop-save (&optional name)
  "Save desktop with a name."
  (interactive)
  (unless name
    (setq name (my-desktop-get-session-name "Save session as: ")))
  (make-directory (concat my-desktop-session-dir name) t)
  (desktop-save (concat my-desktop-session-dir name) t))

(defun my-desktop-read (&optional name)
  "Read desktop with a name."
  (interactive)
  (unless name
    (setq name (my-desktop-get-session-name "Load session: ")))
  (desktop-read (concat my-desktop-session-dir name)))

(defun my-desktop-get-session-name (prompt)
  (completing-read prompt (and (file-exists-p my-desktop-session-dir)
                               (directory-files my-desktop-session-dir))
                   nil nil nil my-desktop-session-name-hist))


(global-set-key (kbd "C-c C-s") 'my-desktop-save)
(global-set-key (kbd "C-c C-r") 'my-desktop-read)





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Personal Emacs tweaks .. probably setable in Custom

;;;Save tmp files to another directory
;; Taken from http://amitp.blogspot.com/2007/03/emacs-move-autosave-and-backup-files.html
(defvar user-temporary-file-directory
  (concat temporary-file-directory user-login-name "/"))
(make-directory user-temporary-file-directory t)
(setq backup-by-copying t)
(setq backup-directory-alist
      `(("." . ,user-temporary-file-directory)
        (,tramp-file-name-regexp nil)))
(setq auto-save-list-file-prefix
      (concat user-temporary-file-directory ".auto-saves-"))
(setq auto-save-file-name-transforms
      `((".*" ,user-temporary-file-directory t)))


;;;;;;;;;;;;;;;;;;;;;;;   RARE  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; Maxima and iMaxima
;; ;;; add autoload of imaxima and maxima.

;; (autoload 'imaxima "imaxima" "Frontend for maxima with Image support" t)

;; (autoload 'maxima "maxima" "Frontend for maxima" t)
;; (setq auto-mode-alist (cons '("\\.max\\'" . maxima-mode) auto-mode-alist))
;; ;;; add autoload of imath.

;; (autoload 'imath-mode "imath" "Imath mode for math formula input" t)


;;  Start GNUServe process when starting up.  This lets us send new files
;; to previously spawned emacs process.
;(load "gnuserv-compat")
;(load-library "gnuserv")
;(gnuserv-start)


;; Auto close parens, quotes, etc...
;;(require 'pair-mode)

;; Python
(add-hook 'python-mode-hook
	  '(lambda ()
	     (pair-mode)))
(add-hook 'python-mode-hook
	  '(lambda ()
	     (flymake-mode)))

(add-hook 'python-mode-hook
      	  '(lambda ()
	      (setq indent-tabs-mode nil)
              (setq c-indent-level 4)))

(when (load "flymake" t)
    (defun flymake-pylint-init ()
       (let* ((temp-file (flymake-init-create-temp-buffer-copy
                      'flymake-create-temp-inplace))
       (local-file (file-relative-name
                      temp-file
                      (file-name-directory buffer-file-name))))
       (list "epylint" (list local-file))))
    
    (add-to-list 'flymake-allowed-file-name-masks
            '("\\.py\\'" flymake-pylint-init)))


;; Python sage
;(setq ipython-command "~/bin/sage")  ;; depends on where your sage is.
;(load "sage") 
;(require 'ipython)

;(fset 'py-shell-fullscreen
;         [?\M-x ?p ?y ?- ?s ?h ?e ?l ?l return ?\C-x ?1])
;(define-key esc-map "i" 'py-shell-fullscreen)

(setq auto-mode-alist (cons '("\\.pxd\\'" . pyrex-mode) auto-mode-alist)) 
(setq auto-mode-alist (cons '("\\.pyx\\'" . pyrex-mode) auto-mode-alist)) 
(setq auto-mode-alist (cons '("\\.pxi\\'" . python-mode) auto-mode-alist))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; append-tuareg.el - Tuareg quick installation: Append this file to .emacs.

(add-to-list 'auto-mode-alist '("\\.ml\\w?" . tuareg-mode))
(autoload 'tuareg-mode "tuareg" "Major mode for editing Caml code" t)
(autoload 'camldebug "camldebug" "Run the Caml debugger" t)
(dolist (ext '(".cmo" ".cmx" ".cma" ".cmxa" ".cmi"))
  (add-to-list 'completion-ignored-extensions ext))





;; Lisp
(add-hook 'lisp-mode-hook
	  '(lambda ()
	     (pair-mode)))

;; Ruby
;(add-hook 'ruby-mode-hook
;	  '(lambda ()
;	     (pair-mode)))

;; had to add after italians emacs-snapshot-gtk 7.10 reinstall
;:;(set-default-font "startup: 18-dot medium")
;; When loading files reuse existing frames.
(setq gnuserv-frame (selected-frame))

(defadvice server-find-file (before server-find-file-in-one-frame activate)
  "Make sure that the selected frame is stored in `gnuserv-frame', and raised."
       (setq gnuserv-frame (selected-frame))
       (raise-frame))

(defadvice server-edit (before server-edit-in-one-frame activate)
  "Make sure that the selected frame is stored in `gnuserv-frame', and lowered."
       (setq gnuserv-frame (selected-frame))
       (lower-frame))


;; Close buffer
(global-set-key [(control f4)] 'kill-this-buffer) 

;; Close Window Frame
(global-set-key [(control f3)] 'delete-frame)

;; Open New frame
(global-set-key [(meta f3)] 'new-frame)

;; allow hitting 'y' or 'n' instead of 'yes' or 'no' for confirmations
(fset 'yes-or-no-p 'y-or-n-p)

;; Turn off that toolbar crap:
(tool-bar-mode 0)

;; Don't show emacs message at startup
(setq inhibit-startup-message t)

;; Auto follow symlinks for version controlled files
(setq vc-follow-symlinks t)

;; Set a narrow and blinking cursor
(blink-cursor-mode t)
(setq-default cursor-type '(bar . 2))

;; Show column number at bottom of screen
(column-number-mode 1)

;; Save as..
(global-set-key (kbd "C-x a s") 'write-file)

;; Multiline comments key-bindings
(global-set-key (kbd "C--") 'uncomment-region)
(global-set-key (kbd "C-=") 'comment-region)

;; VIM like goto-line   alos works with M-g g 
(global-set-key "\C-cg"  'goto-line)


;; Write line numbers to the left side in buffer
;; Map toggle key to f4
(autoload 'linum "linum" "Buffer Line Number toggle" t)
;;(require 'linum)
(global-set-key [f4] 'linum)

;; Puts scroll bar on white sides
(scroll-bar-mode (quote right))





(setq x-select-enable-clipboard t)
(setq interprogram-paste-function 'x-cut-buffer-or-selection-value)

;; Indent c code four spaces
(setq c-basic-offset 4)


;Alredy set to C-s, C-r and M-%
(global-set-key (kbd "M-r")  'query-replace)
;(global-set-key "\C-f"  'search-forward-regexp)


;; Abbrev-def sortcuts reload
;(defun reload-abbrevs ()
;    "This reloads the .abbrevs_ruby and .abbrev_def files"
;    (interactive)
;    (read-abbrev-file "~/.abbrev_defs")
;    (read-abbrev-file "~/.abbrev_ruby")
;)
;(global-set-key "\M-s" 'reload-abbrevs)


(global-set-key "\M-k" 'describe-key)
(global-set-key "\M-f" 'describe-function)

;; Enable highlighting of current line, should appear after color themes are loaded
;; foreground nil to preserve syntax colors
(global-hl-line-mode 1)
(set-face-foreground 'hl-line nil)  
(set-face-background 'hl-line "slate blue")

;;; Fix junk characters in shell mode
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)


;; AucTex Stuff
(setq TeX-electric-escape t) 
(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master "master")
(setq TeX-auto-untabify t)
(add-hook 'TeX-mode-hook (lambda () 
			     (TeX-fold-mode 1)))


(add-hook 'TeXinfo-mode-hook 'outline-minor-mode)
(add-hook 'LaTeX-mode-hook 'outline-minor-mode)
(add-hook 'LaTeX-mode-hook 'flyspell-mode)
(setq auto-mode-alist (cons '("\\.tex$" . LaTeX-mode) auto-mode-alist))



;;  Flyspell stuff
(autoload 'flyspell-mode "flyspell" "On-the-fly spelling checker." t)
(setq flyspell-sort-corrections nil)

;;;   End personal settings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; Folding mode .. must come after C-source mode for my binding to work
;; ;; C-f
;; (load "fold-dwim")
;; (global-set-key (kbd "C-f")      'fold-dwim-toggle)
;; (global-set-key (kbd "<M-left>")    'fold-dwim-hide-all)
;; (global-set-key (kbd "<M-right>")  'fold-dwim-show-all)
;; (setq fold-dwim-outline-style 'nested)
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;; Load ebib for BibTex
(autoload 'ebib "ebib" "Ebib, a BibTeX database manager." t)


;; Enable IPython 
(setq auto-mode-alist (cons '("\\.py$" . python-mode) auto-mode-alist))
(setq interpreter-mode-alist (cons '("python" . python-mode)
				   interpreter-mode-alist))
(autoload 'python-mode "python-mode" "Python editing mode." t)

(setq ipython-command "/usr/bin/ipython")

(require 'ipython) 
;; must be requied in ordr to make work
;;"ipython" "iPython buffer" t)
(require 'pymacs) ;; "pymacs" "PyMacs" t)
(global-set-key [f12] 'py-shell)


;; Haskell mode
(load "~/.emacs.d/haskell-mode/haskell-site-file")
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)


;;;;;;;;;;;;;;;;;;;;;;;   RARE  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; Lush Lisp Numerical Programm
;; (autoload 'lush "lush" "Lush Numerical Lisp" t)

;;;;;;;;;;;;;;;;;;;;;;;   RARE  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; Tramp settings
;;  (setq tramp-default-method "ssh"    tramp-default-user "sid137")

;; ido -- be powerful!
(global-set-key "\C-x\C-b" 'ido-switch-buffer)
(global-set-key "\C-xf" 'ido-find-file)


;; Set directory to load TAGS file 
;; Useful for code definition browsing
(setq tags-table-list  '("~/.emacs.d"))


(add-to-list 'load-path "~/.emacs.d/cucumber.el/feature-mode.el")
;; and load it
(autoload 'feature-mode "feature-mode" "Mode for editing cucumber files" t)
(add-to-list 'auto-mode-alist '("\.feature$" . feature-mode))


;; modes for editing Haml templates
;;;
(add-to-list 'load-path "~/.emacs.d/haml-mode.el")
(require 'haml-mode nil 't)
(add-to-list 'auto-mode-alist '("\\.haml.erb$" . haml-mode))

(add-to-list 'load-path "~/.emacs.d/sass-mode.el")
(require 'sass-mode nil 't)
(add-to-list 'auto-mode-alist '("\\.sass$" . sass-mode))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; http://www.emacswiki.org/emacs/SmartCompile
(require 'smart-compile)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; C - mode customisations
;; http://www.bloomington.in.us/~brutt/emacs-c-dev.html
; (autoload 'cc-mode "cc-mode" "C programming mode" t)
(require 'cc-mode)
;(require 'c-mode)


;; compile command
;; Set to use makefile in current directory, clean, and remake all files
;;(setq compile-command "make clean && make -k")



;; avr compile
(defun avr_make()
   "Sets compile command for when programming ATMEL microcontrollers... usable with F11"
   (interactive)
   (setq compile-command "make clean && make && make hex && make writeflash"))

(global-set-key [M-f11] 'avr_make)

;; compile function
(defun save-compile()
"Save current buffer and compile."
   (interactive)
   (save-buffer)
;;   (compile compile-command)
   (smart-compile)
   (end-of-buffer-other-window 0))

(global-set-key [(f11)] 'save-compile)

;; (setq compilation-window-height 8)
(setq compilation-finish-function
	(lambda (buf str)
	  (if (string-match "exited abnormally" str)
		;;there were errors
		(message "compilation errors, press C-x ` to visit")
	;;no errors, make the compilation window go away in 0.5 seconds
	(run-at-time 0.5 nil 'delete-windows-on buf)
	(message "NO COMPILATION ERRORS!"))))


(c-toggle-hungry-state 1)


;; Use only spaces for indentation with tab key
(defun my-build-tab-stop-list (width)
    (let ((num-tab-stops (/ 80 width))
	  	(counter 1)
			(ls nil))
          (while (<= counter num-tab-stops)
		       (setq ls (cons (* width counter) ls))
		             (setq counter (1+ counter)))
	      (set (make-local-variable 'tab-stop-list) (nreverse ls))))
(defun my-c-mode-common-hook ()
    (setq tab-width 5) ;; change this to taste, this is what K&R uses :)
    (my-build-tab-stop-list tab-width)
    (local-set-key '[(f6)] 'previous-error)
    (local-set-key '[(f7)] 'next-error)
    (setq c-basic-offset tab-width)
    (setq indent-tabs-mode nil)) ;; force only spaces for indentation

(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Ruby Mode instructions
;; Taken from http://wiki.rubygarden.org/Ruby/page/show/InstallingEmacsExtensions

;; Based on http://infolab.stanford.edu/~manku/dotemacs.html
;; svn repo http://svn.ruby-lang.org/cgi-bin/viewvc.cgi/trunk/misc/
(require 'ruby-mode) 
(require 'ruby-electric)
(autoload 'ruby-mode "ruby-mode"
     "Mode for editing ruby source files" t)
 (add-to-list 'auto-mode-alist '("[Cc]apfile$" . ruby-mode))
 (add-to-list 'auto-mode-alist '("[Gg]emfile$" . ruby-mode))
 (add-to-list 'auto-mode-alist '("\\.rb$" . ruby-mode))
 (add-to-list 'auto-mode-alist '("\\.autotest$" . ruby-mode))
 (add-to-list 'interpreter-mode-alist '("ruby" . ruby-mode))
 (autoload 'run-ruby "inf-ruby"
     "Run an inferior Ruby process")
 (autoload 'inf-ruby-keys "inf-ruby"
     "Set local key defs for inf-ruby in ruby-mode")
 (add-hook 'ruby-mode-hook
     '(lambda ()
         (inf-ruby-keys)	 
	 (ruby-electric-mode t)
))


 ;; If you have Emacs 19.2x or older, use rubydb2x
; (autoload 'rubydb "rubydb3x" "Ruby debugger" t)
 ;; uncomment the next line if you want syntax highlighting
; (add-hook 'ruby-mode-hook 'turn-on-font-lock)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Autotest integration
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'toggle)
(require 'autotest)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;Things needed for EMACS-RAILS
(require 'snippet)

(setq load-path (cons "~/.emacs.d/rails" load-path))

(defun try-complete-abbrev (old)
    (if (expand-abbrev) t nil))

(setq hippie-expand-try-functions-list
        '(try-complete-abbrev
	       try-complete-file-name
	           try-expand-dabbrev))

(autoload 'rails "rails" "Rails mode" t)

(setq rails-use-mongrel t)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq rsense-home (expand-file-name "~/core/ext/rsense"))
(add-to-list 'load-path (concat rsense-home "/etc"))
(require 'rsense)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;INSTALL Instructions for msf-abbrev
;;Code located at http://www.bloomington.in.us/~brutt/msf-abbrev.html
;;Must come after all minor modes are loaded!

;;ensure abbrev mode is always on
(setq-default abbrev-mode t)

;;do not bug me about saving my abbreviations
(setq save-abbrevs nil)

;load up abbrevs for these modes
(require 'msf-abbrev)
; next is optional
(setq msf-abbrev-verbose t)
(setq msf-abbrev-root "~/.emacs.d/mode-abbrevs")
(global-set-key (kbd "C-c l") 'msf-abbrev-goto-root)
(global-set-key (kbd "C-c a") 'msf-abbrev-define-new-abbrev-this-mode)
(msf-abbrev-load)

;End msf-abbrev
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;LOAD cedet - Semantic files
;(load-file "~/.emacs.d/cedet-1.0pre4/common/cedet.el")
;;Enabling various SEMANTIC minor modes.  See semantic/INSTALL
(semantic-load-enable-code-helpers)





;;Settings for rcodetools
;;http://eigenclass.org/hiki.rb?rcodetools

(require 'rcodetools);; "rcodetools" "RCodeTools ruby" t)
(require 'icicles-rcodetools)
(icicle-mode 1)
(eval-after-load "icomplete" '(progn (require 'icomplete+)))

(setq w3m-use-tab t)
(define-key ruby-mode-map [(f11)] 'xmp)
;breaks  EVERYTHING 
;(define-key ruby-mode-map [(tab)] 'rct-complete-symbol)


;; Seperate emacs Custom file
(setq custom-file "~/.emacs.d/emacs-custom.el")
(load custom-file 'noerror)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; LOAD ecb - MUST come after cedet and semantic
;;and custom set vars too

(require 'ecb)


;; MY ECB Customisations

;; Activate ECB - disabled until CPU bug fixed
(ecb-activate)

(global-set-key "\C-t"  'ecb-toggle-ecb-windows)
(global-set-key "\C-c\C-w"  'ecb-toggle-layout)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Ido Mode - Varibles must be set by custum before load
;; http://www.cua.dk/ido.html

(require 'ido)
(ido-mode t)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Rinai Rails Editor
;; http://rinari.rubyforge.org/
(add-to-list 'load-path "~/.emacs.d/rinari")
(setq rinari-tags-file-name "TAGS")
(require 'rinari)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;







;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Personal Functions

(defun lw:byte-compile-directory(directory)
  "Byte compile every .el file into a .elc file in the given directory.  See
  `byte-recompile-directory'."
    (interactive
         (list
               (read-file-name "Lisp directory: ")))

      (byte-recompile-directory directory 0 t))


(defun search-google ()
    "Prompt for a query in the minibuffer, launch the web browser and query google."
      (interactive)
        (let ((search (read-from-minibuffer "Google Search: ")))
	      (browse-url (concat "http://www.google.com/search?q=" search))))

(defun search-wikipedia ()
    "Prompt for a query in the minibuffer, launch the web browser and query Wikipedia."
      (interactive)
        (let ((search (read-from-minibuffer "Wikipedia Search: ")))
	      (browse-url (concat "http://en.wikipedia.org/wiki/Special:Search?search=" search))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;







;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Personal Mode associations

(autoload 'css-mode "css-mode")
(setq auto-mode-alist  (cons '("\\.css\\'" . css-mode) auto-mode-alist))


;;  Same to get javascript working
;;(autoload 'javascript-mode "javascript-mode" "JavaScript mode" t)
;;(setq auto-mode-alist (append '(("\\.js$" . javascript-mode))   auto-mode-alist))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; MMM-Mode
(require 'mmm-mode)
(require 'mmm-auto)
(setq mmm-global-mode 'maybe)
(setq mmm-global-mode 't)
(setq mmm-submode-decoration-level 2)
(set-face-background 'mmm-output-submode-face  "LightGrey")
(set-face-background 'mmm-code-submode-face    "white")
(set-face-background 'mmm-comment-submode-face "lightgrey")
(mmm-add-classes
 '((erb-code
    :submode ruby-mode
    :match-face (("<%#" . mmm-comment-submode-face)
                 ("<%=" . mmm-output-submode-face)
                 ("<%"  . mmm-code-submode-face))
    :front "<%[#=]?"
    :back "-?%>"
    :insert ((?% erb-code       nil @ "<%"  @ " " _ " " @ "%>" @)
             (?# erb-comment    nil @ "<%#" @ " " _ " " @ "%>" @)
             (?= erb-expression nil @ "<%=" @ " " _ " " @ "%>" @))
    )))
(add-hook 'html-mode-hook
          (lambda ()
            (setq mmm-classes '(erb-code))
            (mmm-mode-on)))
(add-to-list 'auto-mode-alist '("\.rhtml$" . html-mode))


;; shortcut to reparse the buffer
(global-set-key [f8] 'mmm-parse-buffer)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;








;(setq default-major-mode 'ruby-mode)



;;===== Automatically load abbreviations table =====
;;(read-abbrev-file "~/.abbrev_ruby")
;;(read-abbrev-file "~/.abbrev_defs")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;(add-hook 'dired-mode-hook
;; (define-key dired-mode-map "\C-d" 'dired-flag-file-deletion)
;;	(define-key dired-mode-map "\C-o" 'dired-find-file-other-window)
;;	(define-key dired-mode-map "o" 'dired-display-file))







(add-hook 'LaTeX-mode-hook
  (lambda ()
    (reftex-mode t) ;; References are always useful!
            (turn-on-auto-fill)
  
            (local-set-key '[(f4)] ;; Usual key for compiling the source :-)
              (lambda ()
                (interactive)
                (TeX-command-master)))

            (local-set-key '[return] 'newline-and-indent)
            (local-set-key '[(meta i)] 'reftex-toc) ;; Table of Contents browsing
            (local-set-key '[(control v)] 'reftex-view-crossref) ;; View crossref
            (local-set-key '[(control tab)] 'TeX-complete-symbol)
;;	    (setq compile-command "/home/sid137/bin/mi")

            ;; Fast insertion (with completion) of labels/refs/citations
;;             (local-set-key '[(control c) (control l)] '
;;               (lambda ()
;;                 (interactive)
;;                 (TeX-insert-macro '"label")))
;;             (local-set-key '[(control c) (control r)] '
;;               (lambda ()
;;                 (interactive)
;;                 (TeX-insert-macro '"ref")))
;;             (local-set-key '[(control c) (control c)] '
;;               (lambda ()
;;                 (interactive)
;;                 (TeX-insert-macro '"cite")))
 
            ;; Do not ask a lot of usually unused things when inserting sections (C-c C-s)
            (setq LaTeX-section-hook
                  '(LaTeX-section-heading
                    ;;        LaTeX-section-title
                    ;;        LaTeX-section-toc
                    LaTeX-section-section
                    ;;        LaTeX-section-label
                    ))
            ))


;; Save Emacs temp files to a specific directory
(defvar user-temporary-file-directory
  (concat temporary-file-directory user-login-name "/"))
(make-directory user-temporary-file-directory t)
(setq backup-by-copying t)
(setq backup-directory-alist
      `(("." . ,user-temporary-file-directory)
        (,tramp-file-name-regexp nil)))
(setq auto-save-list-file-prefix
      (concat user-temporary-file-directory ".auto-saves-"))
(setq auto-save-file-name-transforms
      `((".*" ,user-temporary-file-directory t)))





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;  Set Emacs transparency

(defun transparency-set-initial-value ()
  "Set initial value of alpha parameter for the current frame"
  (interactive)
  (if (equal (frame-parameter nil 'alpha) nil)
      (set-frame-parameter nil 'alpha 100)))

(defun transparency-set-value (numb)
  "Set level of transparency for the current frame"
  (interactive "nEnter transparency level in range 0-100: ")
  (if (> numb 100)
      (message "Error! The maximum value for transparency is 100!")
    (if (< numb 0)
	(message "Error! The minimum value for transparency is 0!")
      (set-frame-parameter nil 'alpha numb))))

(defun transparency-increase ()
  "Increase level of transparency for the current frame"
  (interactive)
  (transparency-set-initial-value)
   (if (> (frame-parameter nil 'alpha) 0)
       (set-frame-parameter nil 'alpha (+ (frame-parameter nil 'alpha) -2))
     (message "This is a minimum value of transparency!")))

(defun transparency-decrease ()
  "Decrease level of transparency for the current frame"
  (interactive)
  (transparency-set-initial-value)
  (if (< (frame-parameter nil 'alpha) 100)
      (set-frame-parameter nil 'alpha (+ (frame-parameter nil 'alpha) +2))
    (message "This is a minimum value of transparency!")))

;; sample keybinding for transparency manipulation
(global-set-key (kbd "C-?") 'transparency-set-value)
;; the two below let for smooth transparency control
(global-set-key (kbd "C-,") 'transparency-increase)
(global-set-key (kbd "C-.") 'transparency-decrease)

;;Set default colors and transparency
(set-background-color "#000000")
(modify-frame-parameters nil `((alpha . 80)))





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Real Autosave
;;; http://www.litchie.net/programs/real-auto-save.html

(require 'real-auto-save)
(add-hook 'LaTeX-mode-hook 'turn-on-real-auto-save)
(add-hook 'TeX-mode-hook 'turn-on-real-auto-save)
(setq real-auto-save-interval 5) ;; in seconds
