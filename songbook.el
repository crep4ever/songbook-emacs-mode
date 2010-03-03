;;; songbook-mode-el -- Major mode for editing the song files of Patacrep songbook

;; Author: Romain Goffe <romain.goffe@gmail.com>
;; Created: Feb 28 2010
;; Keywords: patacrep songbook major-mode

;; Copyright (C) 2010 Romain Goffe <romain.goffe@gmail.com>

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 2 of
;; the License, or (at your option) any later version.

;; This program is distributed in the hope that it will be
;; useful, but WITHOUT ANY WARRANTY; without even the implied
;; warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
;; PURPOSE.  See the GNU General Public License for more details.

;; You should have received a copy of the GNU General Public
;; License along with this program; if not, write to the Free
;; Software Foundation, Inc., 59 Temple Place, Suite 330, Boston,
;; MA 02111-1307 USA

;;; Commentary:
;; This mode was higly inspired from the work of 
;; Scott Andrew Borton <scott@pp.htv.fi>
;; through is tutorial on emacs modes:
;; http://two-wugs.net/emacs/mode-tutorial.html

;; songbook mode
(defvar songbook-mode-hook nil)
(defvar songbook-mode-map
  (let ((songbook-mode-map (make-keymap)))
    (define-key songbook-mode-map "\C-j" 'newline-and-indent)
    songbook-mode-map)
  "Keymap for Songbook major mode")

(defconst songbook-font-lock-keywords-1
  (list
					;songbook environments
   '("\\\\\\(begin{tab}\\|end{tab}\\|begin\\(song\\|verse\\|chorus\\)\\|end\\(song\\|verse\\|chorus\\)\\)" . font-lock-type-face)
   '("\\('\\w*'\\)" . font-lock-variable-name-face))
  "Minimal highlighting expressions for Songbook mode.")

(defconst songbook-font-lock-keywords-2
  (append songbook-font-lock-keywords-1
	  (list
					; songbook commands
	   '("\\\\\\(capo\\|gtab\\|lilypond\\|rep\\|echo\\|dots\\|cover\\|image\\|musicnote\\|textnote\\)" . font-lock-keyword-face)
	   '("\\\\\\[[^\]]+\]\\|\\\\bar" . 'font-lock-variable-name-face) ;chords are in the form \[C7]
	   '("\\\\single" . font-lock-constant-face) ; tab's environment commands
	   '("``.+" . font-lock-string-face))) ; latex style strings //fixme: catch between `` and ''
  "Additional Keywords to highlight in Songbook mode.")

(defconst songbook-font-lock-keywords-3
  (append songbook-font-lock-keywords-2
	  (list
					; songbook preprocessing
	   '("\\<\\(songcolumns\\)\\>" . font-lock-preprocessor-face)))
  "Balls-out highlighting in SONGBOOK mode.")

(defvar songbook-font-lock-keywords songbook-font-lock-keywords-3
  "Default highlighting expressions for Songbook mode.")

(defun songbook-indent-line ()
  "Indent current line as SONGBOOK code."
  (interactive)
  (beginning-of-line)
  (if (bobp)
      (indent-line-to 0)	   ; First line is always non-indented
    (let ((not-indented t) cur-indent)
      (if (looking-at "^[ \t]*\\(\\\\end\\(song\\|verse\\|chorus\\)\\)") ; If the line we are looking at is the end of a block, then decrease the indentation
	  (progn
	    (save-excursion
	      (forward-line -1)
	      (setq cur-indent (- (current-indentation) 2)))
	    (if (< cur-indent 0) ; We can't indent past the left margin
		(setq cur-indent 0)))
	(save-excursion
	  (while not-indented ; Iterate backwards until we find an indentation hint
	    (forward-line -1)
	    (if (looking-at "^[ \t]*\\(\\\\end\\(song\\|verse\\|chorus\\)\\)") ; This hint indicates that we need to indent at the level of the END_ token
		(progn
		  (setq cur-indent (current-indentation))
		  (setq not-indented nil))
	      (if (looking-at "^[ \t]*\\(\\\\begin\\(song\\|verse\\|chorus\\)\\)") ; This hint indicates that we need to indent an extra level
		  (progn
		    (setq cur-indent (+ (current-indentation) 2)) ; Do the actual indenting
		    (setq not-indented nil))
		(if (bobp)
		    (setq not-indented nil)))))))
      (if cur-indent
	  (indent-line-to cur-indent)
	(indent-line-to 0))))) ; If we didn't see an indentation hint, then allow no indentation

(defvar songbook-mode-syntax-table
  (let ((songbook-mode-syntax-table (make-syntax-table)))
    
					; Latex comment style
    (modify-syntax-entry ?% "<" songbook-mode-syntax-table)
    (modify-syntax-entry ?\n ">" songbook-mode-syntax-table)
    songbook-mode-syntax-table)
  "Syntax table for songbook-mode")

(defun songbook-mode ()
  (interactive)
  (kill-all-local-variables)
  (use-local-map songbook-mode-map)
  (set-syntax-table songbook-mode-syntax-table)
  ;; Set up font-lock
  (set (make-local-variable 'font-lock-defaults) '(songbook-font-lock-keywords))
  ;; Register our indentation function
  (set (make-local-variable 'indent-line-function) 'songbook-indent-line)  
  (setq major-mode 'songbook-mode)
  (setq mode-name "Songbook")
  (run-hooks 'songbook-mode-hook))

(provide 'songbook-mode)

;;; songbook-mode.el ends here
