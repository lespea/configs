" ============================================================================
" File: autoload/tube.vim
" Description: MacVim and terminal interaction made easy
" Mantainer: Giacomo Comitti (https://github.com/gcmt)
" Url: https://github.com/gcmt/tube.vim
" License: MIT
" Version: 0.3.1
" Last Changed: 2 Feb 2013
" ============================================================================

function! tube#Init()
    let py_module = fnameescape(globpath(&runtimepath, 'autoload/tube.py'))
    exe 'pyfile ' . py_module
    py tube_plugin = TubePlugin()
endfunction

call tube#Init()


function! tube#RunCommand(start, end, args)
    py tube_plugin.RunCommand(int(vim.eval('a:start')), int(vim.eval('a:end')), vim.eval('a:args'))
endfunction

function! tube#RunCommandClear(start, end, args)
    py tube_plugin.RunCommand(int(vim.eval('a:start')), int(vim.eval('a:end')), vim.eval('a:args'), clear=True)
endfunction

function! tube#RunLastCommand()
    py tube_plugin.RunLastCommand()
endfunction

function! tube#InterruptRunningCommand()
    py tube_plugin.InterruptRunningCommand()
endfunction

function! tube#CdIntoVimCwd()
    py tube_plugin.CdIntoVimCwd()
endfunction

function! tube#CloseTerminalWindow()
    py tube_plugin.CloseTerminalWindow()
endfunction


function! tube#Alias(start, end, args)
    py tube_plugin.RunAlias(int(vim.eval('a:start')), int(vim.eval('a:end')), vim.eval('a:args'))
endfunction

function! tube#AliasClear(start, end, args)
    py tube_plugin.RunAlias(int(vim.eval('a:start')), int(vim.eval('a:end')), vim.eval('a:args'), clear=True)
endfunction

function! tube#RemoveAlias(alias)
    py tube_plugin.alias_manager.RemoveAlias(vim.eval('a:alias'))
endfunction

function! tube#AddAlias(args)
    py tube_plugin.alias_manager.AddAlias(vim.eval('a:args'))
endfunction

function! tube#ReloadAliases()
    py tube_plugin.alias_manager.ReloadAliases()
endfunction

function! tube#ShowAliases()
    py tube_plugin.alias_manager.ShowAliases()
endfunction

function! tube#RemoveAllAliases()
    py tube_plugin.alias_manager.RemoveAllAliases()
endfunction


function! tube#ToggleClearScreen()
    py tube_plugin.ToggleSetting('always_clear_screen')
endfunction

function! tube#ToggleRunBackground()
    py tube_plugin.ToggleSetting('run_command_background')
endfunction

function! tube#ToggleBufnameExp()
    py tube_plugin.ToggleSetting('bufname_expansion')
endfunction

function! tube#ToggleFunctionExp()
    py tube_plugin.ToggleSetting('function_expansion')
endfunction

function! tube#ToggleSelectionExp()
    py tube_plugin.ToggleSetting('selection_expansion')
endfunction
