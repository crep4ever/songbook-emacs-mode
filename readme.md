# Description

This [emacs](http://www.gnu.org/software/emacs/) mode provides a major
mode for the song files ".sg" of the [Patacrep
Songbook](http://www.patacrep.com).

# Screenshot

![songbook-emacs-mode](http://www.patacrep.com/data/images/songbook-emacs-mode.png)

# Install

Move the file `songbook.el` in the emacs load path. For example :

>     mkdir -p ~/.config/emacs/
>     cp songbook.el ~/.config/emacs/


Then, configure your `.emacs' to associate automatically the
songbook-mode with sg files :

>     echo "(setq load-path (cons \"~/.config/emacs\" load-path))" >> ~/.emacs
>     echo "(setq auto-mode-alist (cons '(\"\\.sg$\" . songbook-mode) auto-mode-alist))" >> ~/.emacs
>     echo "(setq auto-mode-alist (cons '(\"\\.sbd$\" . songbook-mode) auto-mode-alist))" >> ~/.emacs
>     echo "(autoload 'songbook-mode \"songbook\" \"Major mode for Patacrep's songbooks\" t)" >> ~/.emacs

=====