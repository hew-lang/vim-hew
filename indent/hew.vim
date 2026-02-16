" Vim indent file
" Language: Hew
" Maintainer: hew-lang

if exists('b:did_indent')
  finish
endif
let b:did_indent = 1

setlocal cindent
setlocal cinoptions=L0,(0,Ws,J1,j1
setlocal cinkeys=0{,0},0),!^F,o,O

let b:undo_indent = 'setlocal cindent< cinoptions< cinkeys<'
