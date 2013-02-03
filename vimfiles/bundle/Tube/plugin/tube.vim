" ============================================================================
" File: tube.vim
" Description: MacVim and terminal interaction made easy
" Mantainer: Giacomo Comitti (https://github.com/gcmt)
" Url: https://github.com/gcmt/tube.vim
" License: MIT
" Version: 0.3.1
" Last Changed: 22 Jan 2013
" ============================================================================
"
" TODO: 
"   - commands history
"

" Intit -------------------------------------- {{{

if exists("g:tube_loaded") || !has('python')
    finish
endif
let g:tube_loaded = 1

" }}}

python << END

# -*- coding: utf-8 -*-

import vim
import os
import re
from itertools import groupby

# avoid deprecation warnings to be displayed to the user
import warnings
warnings.simplefilter("ignore", DeprecationWarning)


class TubeUtils: 

    @staticmethod
    def feedback(msg): # {{{
        """Display a simple feedback to the user via the command line."""
        TubeUtils.echom(u'[tube] ' + msg)
    # }}}

    @staticmethod
    def echom(msg): # {{{
        vim.command(u'echom "{0}"'.format(msg))
    # }}}

    @staticmethod
    def let(name, value): # {{{
        """To set a vim variable to a given value."""
        prefix = u'g:tube_'

        if isinstance(value, basestring):
            val = u"'{0}'".format(value)
        elif isinstance(value, bool):
            val = u"{0}".format(1 if value else 0)
        else:
            val = value # list or number type

        vim.command(u"let {0} = {1}".format(prefix + name, val))
    # }}}

    @staticmethod
    def setting(name, fmt=str): # {{{
        """To get the value of a vim variable."""
        prefix = u'g:tube_'

        raw_val = vim.eval(prefix + unicode(name, 'utf8'))
        if isinstance(raw_val, list):
            return raw_val
        elif fmt is bool:
            return False if raw_val == '0' else True
        elif fmt is str:
            return unicode(raw_val, 'utf8')
        else:
            try:
                return fmt(raw_val)
            except ValueError:
                return None
    # }}}

    @staticmethod
    def expand_chars(raw_str, target, repl): # {{{
        """Expand the character (target) in a string (raw_str) with another 
        string (repl) .
        
            If n consecutive target characters are found they are replaced with
            n - 1 target characters, and no expansion is done.
        """
        if target not in raw_str:
            return raw_str

        out = ''
        for char_group in [''.join(g) for k, g in groupby(raw_str)]:
            if char_group == target:
                if repl:
                    out += repl
                else:
                    out += ''
            elif char_group.startswith(target):
                out += char_group[:-1]
            else:
                out += char_group

        return out
    # }}}

    @staticmethod
    def expand_functions(raw_str): # {{{
        """Inject the return value of a function in the string where the
           function is specified as #{function_name}.

           The function is a vim function.
           FIX: not so awesome code
        """
        def escape(a):
            """Escape user input."""
            if a[0] == "'" and a[-1] == "'":
                a = '"' + a[1:-1]  + '"'

            if a[0] == '"' and a[-1] == '"' and len(a) > 1:
                r = a[1:-1].replace('\\', '\\\\').replace('"', '\\"')
                return a[0] + r + a[-1]

            elif re.match("\d+(\.\d+)?", a): # is number
                return a

            else:
                raise ValueError

        def callf(match):
            """Call the matched function and inject its return value."""
            fun_name = match.group('fun')
            args = match.group('args')
            args_separator = TubeUtils.setting('funargs_separator')

            if args:   
                argv = [escape(a.strip()) 
                        for a in args.split(args_separator)]
            else:
                argv = []

            if fun_name:
                if '1' == vim.eval("exists('*{0}')".format(fun_name)):
                    try:
                        return vim.eval("call('{0}',[{1}])".format(
                                    fun_name, ','.join(argv)))
                    except vim.error:
                        pass
                else:
                    raise NameError  # unkwown function

        return re.sub('#{(?P<fun>\w*)(\((?P<args>.*)\))?}', callf, raw_str)   
    # }}}
        

class Tube:

    def __init__(self): # {{{
        self.init_settings()
        self.PLUGIN_PATH = vim.eval("expand('<sfile>:h')")
        self.BASE_CMD_SCRIPTS = "osascript " + self.PLUGIN_PATH + "/applescript/"
        self.BASE_CMD = 'osascript -e'
        self.aliases = TubeUtils.setting('aliases', fmt=dict)
        self.last_command = ''
    # }}}

    def init_settings(self): # {{{
        settings = {
            'terminal' : 'terminal',
            'always_clear_screen' : 0,
            'aliases': {},
            'run_command_background': 1,
            'bufname_expansion': 1,
            'selection_expansion': 1,
            'function_expansion': 1,
            'enable_shortcuts': 0,
            'funargs_separator': '^^'
        }

        for s in settings:
            if vim.eval("!exists('g:tube_{0}')".format(s)) == '1':
                TubeUtils.let(s, settings[s])
    # }}}

    def run(self, command, clear=False): # {{{
        """Send the command to the terminal emulator of choice"""
        term = TubeUtils.setting('terminal').lower()
        if term == 'iterm':
            base = self.BASE_CMD_SCRIPTS + 'execute_iterm.scpt' 
        else:
            base = self.BASE_CMD_SCRIPTS + 'execute_terminal.scpt' 

        clr = 'clear;' if clear else ''
        os.popen('{0} "{1}"'.format(
            base, clr + command.replace('"', '\\"').replace('$', '\$').strip()))
    # }}}

    def run_command(self, start, end, cmd, clear=False, parse=True): # {{{
        """Inject the proper data in the command if required and run the 
        command."""

        if parse:

            cmd = cmd.replace('\\', '\\\\')

            if cmd and TubeUtils.setting('bufname_expansion', fmt=bool):
                cmd = TubeUtils.expand_chars(cmd, '%', vim.current.buffer.name)

            if cmd and TubeUtils.setting('selection_expansion', fmt=bool):
                cmd = TubeUtils.expand_chars(
                        cmd, '@', '\r'.join(vim.current.buffer[start-1:end]))

            if cmd and TubeUtils.setting('function_expansion', fmt=bool):
                try:
                    cmd = TubeUtils.expand_functions(cmd)
                except NameError: # the function does not exist
                    TubeUtils.feedback('unknown function')
                    return
                except ValueError: # bad arguments
                    TubeUtils.feedback('bad arguments')
                    return

        if (not cmd or clear 
            or TubeUtils.setting('always_clear_screen', fmt=bool)):
            self.run(cmd, clear=True)
        else:
            self.run(cmd)

        if not TubeUtils.setting('run_command_background', fmt=bool):
            self.focus_terminal()

        self.last_command = cmd
    # }}}

    def run_last_command(self): # {{{
        """Execute the last executed command."""
        if self.last_command:
            self.run_command(1, 1, self.last_command, parse=False)
        else:
            TubeUtils.feedback('no last command to execute')
    # }}}

    def interrupt_running_command(self): # {{{
        """Interrupt the running command in the terminal window."""
        term = TubeUtils.setting('terminal').lower()
        cmd = """
            tell application "{0}" to activate

            tell application "System Events"
                keystroke "c" using control down
            end tell

            tell application "MacVim" to activate"""

        if term == 'terminal':
            cmd = cmd.format("Terminal")
        else:
            cmd = cmd.format("iTerm")

        os.popen("{0} '{1}'".format(self.BASE_CMD, cmd))
    # }}}

    def cd_into_vim_cwd(self): # {{{
        """Send the terminal window a cd command with the vim current working
        directory."""
        self.run_command(1, 1, "cd {0}".format(vim.eval("getcwd()")))
    # }}}

    def close(self): # {{{
        """Close the terminal window."""
        term = TubeUtils.setting('terminal').lower()
        if term == 'terminal':
            cmd = 'tell application "Terminal" to quit'
        else:
            cmd = 'tell application "iTerm" to quit'
        
        os.popen("{0} '{1}'".format(self.BASE_CMD, cmd))
    # }}}

    def focus_terminal(self): # {{{
        """Switch focus to the terminal window."""
        term = TubeUtils.setting('terminal').lower()
        if term == 'terminal':
            cmd = 'tell application "Terminal" to activate'
        else:
            cmd = 'tell application "iTerm" to activate'
        
        os.popen("{0} '{1}'".format(self.BASE_CMD, cmd))
    # }}}

    ## ALIASES

    def run_alias(self, start, end, alias, clear=False): # {{{
        """Lookup a command given its alias and execute that command."""
        command = self.aliases.get(alias, None)
        if command:
            self.run_command(start, end, command, clear)
            return
    
        TubeUtils.feedback('alias not found')
    # }}}

    def add_alias(self, args): # {{{
        """Add a new alias.
        
           this method accept a string where the first token represent the
           alias name whereas the rest is interpreted as the command.
        """
        try:
            alias, command = args.split(' ', 1)
            self.aliases[alias] = command
        except:
            TubeUtils.feedback('bad argument')
        else:
            TubeUtils.feedback('alias successfully added')
    # }}}
            
    def remove_alias(self, alias): # {{{
        """Remove an alias.
        
           This has a temporary effect if the g:tube_aliases vim variable
           is defined.
        """
        try:
            del self.aliases[alias]
        except:
            TubeUtils.feedback('alias not found')
        else:
            TubeUtils.feedback('alias successfully removed')
    # }}}

    def remove_all_aliases(self): # {{{
        """Remove all defined aliases.
        
           This has a temporary effect if the g:tube_aliases vim variable
           is defined.
        """
        self.aliases.clear()
        TubeUtils.feedback('all aliases successfully removed')
    # }}}

    def show_aliases(self): # {{{
        """Show all defined aliases."""
        if not self.aliases:
            TubeUtils.feedback('nothing found')
            return 
        
        n = len(self.aliases)
        print('+ aliases')
        for i, alias in enumerate(self.aliases):
            if i  == n - 1:
                conn = '└─ '
            else:
                conn = '├─ '
            print(conn + alias + ': ' + self.aliases[alias])
    # }}}

    def reload_aliases(self): # {{{
        """Reload the alias dictionary from the vim variable g:tube_alias.

            This might be needed when the user change the g:tube_aliases 
            variable at run time. 
        """
        self.aliases = TubeUtils.setting('aliases', fmt=dict)
        TubeUtils.feedback('aliases successfully reloaded')
    # }}}

    ## SETTINGS

    def toggle_setting(self, sett): # {{{
        """Toggle the given setting."""
        TubeUtils.let(sett, not TubeUtils.setting(sett, fmt=bool))
        self.echo_setting_state(sett)
    # }}}

    def echo_setting_state(self, sett): # {{{
        """Show the current state of the given setting."""
        sett_state = '{0} = {1}'.format(sett, TubeUtils.setting(sett))       
        TubeUtils.feedback(sett_state)  
    # }}}


tube = Tube()

END

command! -nargs=1 -range TubeAlias python tube.run_alias(<line1>, <line2>, <q-args>)
command! -nargs=1 -range TubeAliasClear python tube.run_alias(<line1>, <line2>, <q-args>, clear=True)
command! -nargs=1 TubeRemoveAlias python tube.remove_alias(<q-args>)
command! -nargs=+ TubeAddAlias python tube.add_alias(<q-args>)
command! TubeReloadAliases python tube.reload_aliases()
command! TubeAliases python tube.show_aliases()
command! TubeRemoveAllAliases python tube.remove_all_aliases()

command! -nargs=* -range Tube python tube.run_command(<line1>, <line2>, <q-args>)
command! -nargs=* -range TubeClear python tube.run_command(<line1>, <line2>, <q-args>, clear=True)
command! TubeLastCommand python tube.run_last_command()
command! TubeInterruptCommand python tube.interrupt_running_command()
command! TubeCd python tube.cd_into_vim_cwd()
command! TubeClose python tube.close()

command! TubeToggleClearScreen python tube.toggle_setting('always_clear_screen')
command! TubeToggleRunBackground python tube.toggle_setting('run_command_background')
command! TubeToggleBufnameExp python tube.toggle_setting('bufname_expansion')
command! TubeToggleFunctionExp python tube.toggle_setting('function_expansion')
command! TubeToggleSelectionExp python tube.toggle_setting('selection_expansion')

if g:tube_enable_shortcuts

    command! -nargs=1 -range Ta python tube.run_alias(<line1>, <line2>, <q-args>)
    command! -nargs=1 -range Tac python tube.run_alias(<line1>, <line2>, <q-args>, clear=True)
    command! -nargs=1 Tar python tube.remove_alias(<q-args>)
    command! -nargs=+ Tad python tube.add_alias(<q-args>)
    command! Tall python tube.show_aliases()

    command! -nargs=* -range T python tube.run_command(<line1>, <line2>, <q-args>)
    command! -nargs=* -range Tc python tube.run_command(<line1>, <line2>, <q-args>, clear=True)
    command! Tl python tube.run_last_command()
    command! Ti python tube.interrupt_running_command()
    command! Tcd python tube.cd_into_vim_cwd()

endif
