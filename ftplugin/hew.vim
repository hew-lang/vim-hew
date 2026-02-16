" Vim ftplugin file
" Language: Hew
" Maintainer: hew-lang

if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

setlocal commentstring=//\ %s
setlocal comments=s1:/*,mb:*,ex:*/,://
setlocal tabstop=4
setlocal shiftwidth=4
setlocal expandtab
setlocal suffixesadd=.hew

let b:undo_ftplugin = 'setlocal commentstring< comments< tabstop< shiftwidth< expandtab< suffixesadd<'
