" Vim syntax file
" Language: Hew
" Maintainer: hew-lang

if exists('b:current_syntax')
  finish
endif

" ---- Comments ----
syn keyword hewTodo TODO FIXME XXX NOTE HACK contained
syn match   hewLineComment   "//.*$"  contains=hewTodo
syn match   hewDocComment    "///.*$" contains=hewTodo
syn region  hewBlockComment  start="/\*" end="\*/" contains=hewBlockComment,hewTodo

" ---- Strings ----
syn match   hewEscape  "\\[nrt\\\"0]"              contained
syn match   hewEscape  "\\x[0-9a-fA-F]\{2\}"       contained
syn region  hewString  start='"' skip='\\"' end='"' contains=hewEscape
syn region  hewRawStr  start='r"'           end='"'
syn region  hewFmtStr  start='f"' skip='\\"' end='"' contains=hewEscape,hewFmtInterp
syn region  hewFmtInterp start='{' end='}' contained contains=TOP
syn region  hewRawRegex start='re"' end='"'
syn match   hewChar    "'\(\\[nrt\\'0]\|\\x[0-9a-fA-F]\{2\}\|[^']\)'"

" ---- Numbers ----
syn match   hewNumber  "\<0[xX][0-9a-fA-F][0-9a-fA-F_]*\>"
syn match   hewNumber  "\<0[bB][01][01_]*\>"
syn match   hewNumber  "\<0[oO][0-7][0-7_]*\>"
syn match   hewNumber  "\<[0-9][0-9_]*\.[0-9][0-9_]*\([eE][+-]\?[0-9][0-9_]*\)\?\>"
syn match   hewNumber  "\<[0-9][0-9_]*\(ns\|us\|ms\|s\|m\|h\)\>"
syn match   hewNumber  "\<[0-9][0-9_]*\>"

" ---- Attributes ----
syn region  hewAttribute start="#\[" end="\]" contains=hewString

" ---- Keywords ----
syn keyword hewControl     if else match loop for in while break continue return
syn keyword hewControl     try catch select join yield cooperate after from await
syn keyword hewControl     scope launch cancel

syn keyword hewDecl        let var const fn gen type struct enum trait impl
syn keyword hewDecl        import pub export super where as mut

syn keyword hewActor       actor receive init spawn async move mailbox overflow

syn keyword hewSupervisor  supervisor child restart budget strategy

syn keyword hewWire        wire reserved optional deprecated default list

syn keyword hewOther       dyn unsafe extern package pure

syn keyword hewBool        true false
syn keyword hewNone        None
syn keyword hewSelf        self
syn keyword hewSelfType    Self

syn keyword hewStrategy    one_for_one one_for_all rest_for_one
syn keyword hewStrategy    permanent transient temporary
syn keyword hewStrategy    block drop_new drop_old fail coalesce fallback

" ---- Reserved keywords ----
syn keyword hewReserved    and or race foreign isolated

" ---- Types ----
syn keyword hewType        i8 i16 i32 i64 u8 u16 u32 u64 f32 f64 isize usize
syn keyword hewType        bool char string bytes void duration
syn keyword hewType        Result Option Vec HashMap HashSet Box Arc Rc Weak
syn keyword hewType        Actor ActorRef Task Scope Generator AsyncGenerator ActorStream
syn keyword hewType        Send Frozen Copy Drop Clone Eq Ord Hash Display Debug
syn keyword hewType        Default Iterator AsyncIterator IntoIterator Into From Try Allocator
syn match   hewType        "\<[A-Z][a-zA-Z0-9_]*\>"

" ---- Functions ----
syn match   hewFuncDef     "\<fn\s\+\zs[a-zA-Z_][a-zA-Z0-9_]*"
syn match   hewFuncCall    "\<[a-zA-Z_][a-zA-Z0-9_]*\ze\s*("

" ---- Operators ----
syn match   hewOperator    "->\|=>\|<-\|\.\.\(=\)\?\|::"
syn match   hewOperator    "==\|!=\|=\~\|!\~\|<=\|>=\|<\|>"
syn match   hewOperator    "<<=\|>>=\|&=\||=\|\^=\|+=\|-=\|\*=\|/=\|%="
syn match   hewOperator    "<<\|>>"
syn match   hewOperator    "[+\-*/%=!?@&|\^~]"

" ---- Labels ----
syn match   hewLabel       "'[a-zA-Z_][a-zA-Z0-9_]*"

" ---- Highlighting ----
hi def link hewLineComment   Comment
hi def link hewDocComment    SpecialComment
hi def link hewBlockComment  Comment
hi def link hewTodo          Todo

hi def link hewString        String
hi def link hewRawStr        String
hi def link hewFmtStr        String
hi def link hewRawRegex      String
hi def link hewChar          Character
hi def link hewEscape        SpecialChar

hi def link hewNumber        Number

hi def link hewAttribute     PreProc

hi def link hewControl       Conditional
hi def link hewDecl          Keyword
hi def link hewActor         Keyword
hi def link hewSupervisor    Keyword
hi def link hewWire          Keyword
hi def link hewOther         Keyword

hi def link hewBool          Boolean
hi def link hewNone          Constant
hi def link hewSelf          Identifier
hi def link hewSelfType      Type
hi def link hewStrategy      Constant

hi def link hewType          Type
hi def link hewFuncDef       Function
hi def link hewFuncCall      Function

hi def link hewReserved      Keyword
hi def link hewOperator      Operator
hi def link hewLabel         Label

let b:current_syntax = 'hew'
