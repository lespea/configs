# -*- coding: utf-8 -*-

import vim
import tube.utils.settings
import tube.utils.echo


class AliasManager:

    def __init__(self):

        # modules reference shortcuts
        self.settings = tube.utils.settings
        self.echo = tube.utils.echo

        self.init_settings()

        self.aliases = self.settings.get('aliases')

    ## INTERNALS

    def init_settings(self):
        sett = {
            'aliases': {}
        }

        for s, val in sett.items():
            if vim.eval("!exists('g:tube_{0}')".format(s)) == '1':
                self.settings.set(s, val)

    def get(self, alias):
        """To return an alias if exists."""
        return self.aliases.get(alias)

    ## INTERFACE METHODS

    def AddAlias(self, args):
        """Add a new alias.

           this method accept a string where the first token represent the
           alias name whereas the rest is interpreted as the command.
        """
        try:
            alias, command = args.split(' ', 1)
            self.aliases[alias] = command
        except:
            self.echo.echom('bad argument')
        else:
            self.echo.echom('alias successfully added')

    def RemoveAlias(self, alias):
        """Remove an alias.

           This has a temporary effect if the g:tube_aliases vim variable
           is defined.
        """
        try:
            del self.aliases[alias]
        except:
            self.echo.echom('alias not found')
        else:
            self.echo.echom('alias successfully removed')

    def RemoveAllAliases(self):
        """Remove all defined aliases.

           This has a temporary effect if the g:tube_aliases vim variable
           is defined.
        """
        self.aliases.clear()
        self.echo.echom('all aliases successfully removed')

    def ShowAliases(self):
        """Show all defined aliases."""
        if not self.aliases:
            self.echo.echom('nothing found')
            return

        n = len(self.aliases)
        print('+ aliases')
        for i, alias in enumerate(self.aliases):
            if i == (n - 1):
                conn = '└─ '
            else:
                conn = '├─ '
            print(conn + alias + ': ' + self.aliases[alias])

    def ReloadAliases(self):
        """Reload the alias dictionary from the vim variable g:tube_alias.

            This might be needed when the user change the g:tube_aliases
            variable at run time.
        """
        self.aliases = self.settings.get('aliases')
        self.echo.echom('aliases successfully reloaded')
