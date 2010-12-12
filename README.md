# Emacs configuration files

## Installation
The emacs initializer is init.el instead of the typical ~/.emacs   Create a
.emacs symlink in your home directory


    ln -s .emacs.d/init.el ~/.emacs


## Features


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Save Desktop Session State
;http://stackoverflow.com/questions/847962/what-alternate-session-managers-are-available-for-emacs

Save session:  C-c  C-s session_name
Load session:  C-r  C-r session_name


;;;Save tmp files to another directory
;; Taken from http://amitp.blogspot.com/2007/03/emacs-move-autosave-and-backup-files.html

Automatically run python lint (Flymake) on python buffers


Tweaks:

Close buffer C-F4


Yes or no replaced by y or n
