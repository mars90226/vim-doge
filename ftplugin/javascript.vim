" ==============================================================================
" Filename: javascript.vim
" Maintainer: Kim Koomen <koomen@protonail.com>
" License: MIT
" ==============================================================================
"
" The javascript documentation should follow the 'jsdoc' conventions.
" see https://jsdoc.app

let s:save_cpo = &cpoptions
set cpoptions&vim

let b:doge_patterns = []

""
" Matches regular and typed functions with default parameters.
"
" {match}: Should match at least the following scenarios:
"     - function myFunction(...) {
"
"   Regex explanation
"     \m
"       Use magic notation.
"
"     ^
"       Matches the position before the first character in the string.
"
"     function \([^(]\+\)\s*(\(.\{-}\))\s*{
"       Match two groups where group #1 is the function name,
"       denoted as: 'function \([^(]\+\)'
"
"       Followed by 0 or more spaces, denoted as '\s*'.
"
"       Followed by group #2 which contains the parameters,
"       denoted as: '(\(.\{-}\))'. We use \{-} to ensure it will match as few
"       matches as possible, which prevents wrong parsing when the input
"       contains nested functions.
"
"       Followed by 0 or more spaces and then an opening curly brace,
"       denoted as '\s*{'.
"
" {parameters.match}: Should match at least the following scenarios:
"   - param1
"   - param1 = 5
"   - param1 = 'string'
"   - param1: bool
"   - param1: bool = 5
"   - param1: Person = false
"   - param1: string = 'string'
"
"   Regex explanation
"     \m
"       Use magic notation.
"
"     \([^,:]\+\)
"       This group should match the parameter name.
"       ------------------------------------------------------------------------
"       Matches a group which may contain every character besides ',' or ':'.
"
"     \%(\%(\s*:\s*\([a-zA-Z_]\+\)\)\)\?
"       This group
"       ------------------------------------------------------------------------
"       Matches an optional non-capturing group containing 1 sub-group which may
"       contain 1 or more of the following characters: [a-zA-Z_].
"
"     \%(\s*=\s*.\+\)\?
"       This group should match the parameter default value.
"       ------------------------------------------------------------------------
"       Matches an optional and non-capturing group where it should match
"       the format ' = VALUE'.
call add(b:doge_patterns, {
      \   'match': '\m^function \([^(]\+\)\s*(\(.\{-}\))\%(\s*:\s*\(.\{-}\)\)\?{',
      \   'match_group_names': ['funcName', 'parameters', 'returnType'],
      \   'parameters': {
      \     'match': '\m\([^,:]\+\)\%(\%(\s*:\s*\([a-zA-Z_]\+\)\)\)\?\%(\s*=\s*[^,]\+\)\?',
      \     'match_group_names': ['name', 'type'],
      \     'format': ['@param', '!{{type|*}}', '{name}', 'TODO'],
      \   },
      \   'comment': {
      \     'insert': 'above',
      \     'opener': '/**',
      \     'closer': '*/',
      \     'template': [
      \       '/**',
      \       ' * {parameters}',
      \       '! * @return {{returnType}}: TODO',
      \       ' */',
      \     ],
      \   },
      \ })

let &cpoptions = s:save_cpo
unlet s:save_cpo