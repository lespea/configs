# -*- coding: utf-8 -*-

import os
import vim
import sys

# avoid deprecation warnings to be displayed to the user
import warnings
warnings.simplefilter("ignore", DeprecationWarning)

sys.path.insert(0, os.path.split(
    vim.eval('fnameescape(globpath(&runtimepath, "autoload/tube.py"))'))[0])

import tube.aliasmanager
import tube.utils.settings
import tube.utils.expansion
import tube.utils.echo


class TubePlugin:

    def __init__(self):

        # modules reference shortcuts
        self.settings = tube.utils.settings
        self.expansion = tube.utils.expansion
        self.echo = tube.utils.echo

        self.alias_manager = tube.aliasmanager.AliasManager()
        self.init_settings()

        self.AUTOLOAD_PATH = os.path.split(
            vim.eval('fnameescape(globpath(&runtimepath, "autoload/tube.py"))'))[0]

        # base strings for applescript commands
        self.BASE_CMD_SCRIPTS = "osascript " + self.AUTOLOAD_PATH + "/applescript/"
        self.BASE_CMD = 'osascript -e'

        self.last_command = ''

    def init_settings(self):
        sett = {
            'terminal': 'terminal',
            'always_clear_screen': 0,
            'run_command_background': 1,
            'bufname_expansion': 1,
            'selection_expansion': 1,
            'function_expansion': 1,
            'enable_shortcuts': 0,
            'funargs_separator': '^^'
        }

        for s, val in sett.items():
            if vim.eval("!exists('g:tube_{0}')".format(s)) == '1':
                self.settings.set(s, val)

        self.alias_manager.init_settings()

    ## INTERFACE METHODS

    def RunCommand(self, start, end, cmd, clear=False, parse=True):
        """Inject the proper data in the command if required and run the
        command."""

        if parse:

            if cmd and self.settings.get('bufname_expansion', bool):
                cmd = self.expansion.expand_chars(
                        cmd, '%', vim.current.buffer.name)

            if cmd and self.settings.get('selection_expansion', bool):
                cmd = self.expansion.expand_chars(
                        cmd, '@', '\r'.join(vim.current.buffer[start-1:end]))

            if cmd and self.settings.get('function_expansion', bool):
                try:
                    cmd = self.expansion.expand_functions(cmd)
                except NameError:  # the function does not exist
                    self.echo.echom('unknown function')
                    return
                except ValueError:  # bad arguments
                    self.echo.echom('bad arguments')
                    return

        if (not cmd or clear
            or self.settings.get('always_clear_screen', bool)):
            self.run(cmd, clear=True)
        else:
            self.run(cmd)

        if not self.settings.get('run_command_background', bool):
            self.focus_terminal()

        self.last_command = cmd

    def RunAlias(self, start, end, alias, clear=False):
        """Lookup a command given its alias and execute that command."""
        command = self.alias_manager.get(alias)
        if command:
            self.RunCommand(start, end, command, clear)
            return

        self.echo.echom('alias not found')

    def RunLastCommand(self):
        """Execute the last executed command."""
        if self.last_command:
            self.RunCommand(1, 1, self.last_command, parse=False)
        else:
            self.echo.echom('no last command to execute')

    def InterruptRunningCommand(self):
        """Interrupt the running command in the terminal window."""
        term = self.settings.get('terminal').lower()
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

    def CdIntoVimCwd(self):
        """Send the terminal window a cd command with the vim current working
        directory."""
        self.RunCommand(1, 1, "cd {0}".format(vim.eval("getcwd()")))

    def CloseTerminalWindow(self):
        """Close the terminal window."""
        term = self.settings.get('terminal').lower()
        if term == 'terminal':
            cmd = 'tell application "Terminal" to quit'
        else:
            cmd = 'tell application "iTerm" to quit'

        os.popen("{0} '{1}'".format(self.BASE_CMD, cmd))

    ## INTERNALS

    def run(self, cmd, clear=False):
        """Send the command to the terminal emulator of choice"""
        term = self.settings.get('terminal').lower()
        if term == 'iterm':
            base = self.BASE_CMD_SCRIPTS + 'iterm.scpt'
        else:
            base = self.BASE_CMD_SCRIPTS + 'terminal.scpt'

        clr = 'clear;' if clear else ''
        cmd = cmd.replace('\\', '\\\\')
        cmd = cmd.replace('"', '\\"')
        cmd = cmd.replace('$', '\$')
        os.popen('{0} "{1}"'.format(base, clr + cmd.strip()))

    def focus_terminal(self):
        """Switch focus to the terminal window."""
        term = self.settings.get('terminal').lower()
        if term == 'terminal':
            cmd = 'tell application "Terminal" to activate'
        else:
            cmd = 'tell application "iTerm" to activate'

        os.popen("{0} '{1}'".format(self.BASE_CMD, cmd))

    def toggle_setting(self, sett):
        """Toggle the given setting."""
        self.settings.set(sett, not self.settings.get(sett, bool))
        self.echo_setting_state(sett)

    def echo_setting_state(self, sett):
        """Show the current state of the given setting."""
        sett_state = '{0} = {1}'.format(sett, self.settings.get(sett))
        self.echo.echom(sett_state)
