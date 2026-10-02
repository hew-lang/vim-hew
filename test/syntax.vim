set nomore
set runtimepath^=.
syntax enable

edit test.hew
setlocal filetype=hew
runtime! syntax/hew.vim
syntax sync fromstart

function! s:assert_group(pattern, expected) abort
  call cursor(1, 1)
  let [line, column] = searchpos(a:pattern, 'W')
  call assert_true(line > 0, 'missing syntax fixture token: ' . a:pattern)
  if line == 0
    return
  endif
  let actual = synIDattr(synID(line, column, 1), 'name')
  call assert_equal(a:expected, actual, a:pattern)
endfunction

call s:assert_group('collections\zs\.', 'hewOperator')
call s:assert_group('collections\.{\zsHashMap', 'hewType')
call s:assert_group('HashSet\.\zsnew', 'hewFuncCall')
call s:assert_group('\zs\.[A-Z]\w*', 'hewVariant')
call s:assert_group('import \zscollections::\*', 'hewLegacyGlobImport')
call s:assert_group('import \zscollections\.\*', 'hewLegacyGlobImport')
call s:assert_group('Result\zs\.Ok', 'hewOperator')
call s:assert_group('HashSet\zs::new', 'hewLegacyPathSeparator')
call s:assert_group('HashSet\zs::<u32>', 'hewLegacyTurbofish')

call s:assert_group('close(\zsconsume', 'hewConsume')
call s:assert_group('fn \zsconsume', 'hewFuncCall')
call s:assert_group('let \zsasync', '')
call s:assert_group('^\zsgen fn values', 'hewDecl')
call s:assert_group('^\zsfor item', 'hewControl')
call s:assert_group('^\zsasync gen', 'hewRetired')
call s:assert_group('^\zsfor await', 'hewRetired')
call s:assert_group('work() \zs| after', 'hewRetired')
call s:assert_group('fn\[\zsvar', 'hewCallableCapability')
call s:assert_group('var, \zssuspends', 'hewCallableCapability')
call s:assert_group('^let bump = \zscapture', 'hewCapture')
call s:assert_group('found \zs??', 'hewOperator')
call s:assert_group('^\zsawait_restart', 'hewRetired')
call s:assert_group('^let \zsclone_copy', '')
call s:assert_group(') -> i64 \zsfails', 'hewFailureWord')
call s:assert_group('^fn deposit(account: Account) \zsfails', 'hewFailureWord')
call s:assert_group('^    return \zserror "bad"', 'hewFailureWord')
call s:assert_group('^    return \zserror \.Invalid', 'hewFailureWord')
call s:assert_group('^    return \zserror;', 'hewContextual')
call s:assert_group('^    return \zserror + 1', 'hewContextual')
call s:assert_group('Push(i64) \zs@1', 'hewWireTag')
call s:assert_group('^    \zs#\[offload', 'hewAttribute')

if len(v:errors)
  for error in v:errors
    echomsg error
  endfor
  cquit
endif
quit
