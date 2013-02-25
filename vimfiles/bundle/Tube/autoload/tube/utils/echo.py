# -*- coding: utf-8 -*-

import vim


def echom(msg):
    """Display a simple feedback to the user via the command line."""
    vim.command('echom "[tube] {0}"'.format(msg))


def echoerr(msg):
    """Display a simple error feedback to the user via the command line."""
    vim.command('echoerr "[tube] {0}"'.format(msg))
