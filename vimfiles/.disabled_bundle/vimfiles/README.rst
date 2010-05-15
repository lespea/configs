.. _overview:

==================
Overview
==================

This repository serves as the home for several vim and vim related plugins I've
developed which include plugins for `vim`_, `vimperator`_, and `rxvt-unicode`_
(urxvt).

vim plugins
-----------

- `supertab`_ - allows you to use <tab> for all your insert completion needs
- `screen`_ - simulate a split shell in vim using gnu screen or tmux
- ack - run ack and load the results in vim's quickfix
- copyright - check for out of date copyright years on file save and prompt to
  update the years if necessary (add ``let g:CopyrightEnabled = 1`` to your
  vimrc to enable)
- dailylog - keep track of and report time spent working on tasks
- notebook - manage notes using vim's help files syntax and tags
- scratch - open a filetype scratch buffer (auto saves the previous contents in
  case they need to be recovered)
- translate - translate text using google's translation service (requires java
  to be installed)

vimperator plugins
------------------

- firebug - commands to interact with firebug
- noscript - commands to interact with noscript
- stylish - commands to interact with stylish
- readability - command to view the current page using `readability`_
- search - use your configured search engine to search the current website
- translate - translate the current page using yahoo's babel fish.
- wincmd - provide vim style :wincmd and <c-w> commands to navigate frames
- contrast - provides a command which attempts to alter the current page's
  background and text color to improve readability (intended for text heavy
  sites whose default colors are too bright or dark to read comfortably)

**Note**: Vimperator plugins require vimperator 2.1 or above, with the
exception of wincmd which requires vimperator 2.2 or above.

rxvt-unicode plugins
--------------------

- vim-scrollback - provides a vim like scrollback mode and pasting

  See the file header for a list of features, etc.

  Example configuration in .Xdefaults where alt-s (default is alt-v if not
  configured) starts the scrollback mode and alt-r initiates the vim like paste
  mode (requiring xclip to be installed):

  ::

    ! configure perl extensions
    urxvt*perl-lib: /home/ervandew/vimfiles/urxvt
    urxvt*perl-ext-common: vim-scrollback

    ! configure vim-scrollback
    urxvt*vim-scrollback: Mod1-s
    urxvt*vim-scrollback-paste: Mod1-r
    urxvt*vim-scrollback-bg: 10
    urxvt*vim-scrollback-fg: 18
    urxvt*urlLauncher: xdg-open
    urxvt*pattern.1: (.*[ \"',(\\[{><]|^)(.*?)([ \"',)\\]}<>].*|$)
    urxvt*launcher.1: urxvt +sb -geometry 125x50 -e vim $2

.. _using:

===================
Using these plugins
===================

If you would like to give these plugins a shot, you can checkout the code and
add the appropriate path to the configuration of the corresponding app.

::

  $ git clone http://github.com/ervandew/vimfiles.git vimfiles

- **vim** - To use the vim plugins update your .vimrc file (or _vimrc on
  windows) and add the vim directory of the cloned vimfiles repository to your
  runtime path:

  ::

    set rtp+=~/vimfiles/vim

- **vimperator** - Similar to vim, you can add the vimperator directory that
  you've cloned to your runtimepath via your .vimperatorrc:

  ::

    set runtimepath+=~/vimfiles/vimperator

- **rxvt-unicode** - To utilize the urxvt plugin, you can set the directory
  where urxvt looks for perl extensions in your .Xdefaults file (Note: in this
  case you need to supply the literal path without ~ or $HOME).

  ::

    urxvt*perl-lib: /home/ervandew/vimfiles/urxvt

.. _license:

=======
License
=======

For the most part the plugins share the same license as the parent program,
with the exception of the vim plugins:

- vim plugins: BSD License
- vimperator plugins: MIT License
- rxvt-unicode plugins: GPL-v2

.. _vim: http://www.vim.org
.. _vimperator: http://www.vimperator.org
.. _rxvt-unicode: http://software.schmorp.de/pkg/rxvt-unicode.html
.. _supertab: http://www.vim.org/scripts/script.php?script_id=1643
.. _screen: http://www.vim.org/scripts/script.php?script_id=2711
.. _readability: http://lab.arc90.com/experiments/readability/
