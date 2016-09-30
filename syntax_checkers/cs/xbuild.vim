if exists('g:loaded_syntastic_cs_xbuild_checker')
  finish
endif
let g:loaded_syntastic_cs_xbuild_checker = 1

let s:save_cpo = &cpo
set cpo&vim

function! SyntaxCheckers_cs_xbuild_IsAvailable() dict
  return executable(self.getExec())
endfunction

function! SyntaxCheckers_cs_xbuild_GetLocList() dict
  let makeprg = self.getExec()
  let errorformat =
        \ '%f(%l\,%c): %trror %m,' .
        \ '%f(%l\,%c): %tarning %m'

  let loclist = SyntasticMake({
        \ 'makeprg': makeprg,
        \ 'errorformat': errorformat,
        \ 'cwd': expand('%:p:h', 1),
        \ })
  return loclist
endfunction

call g:SyntasticRegistry.CreateAndRegisterChecker({
      \ 'filetype': 'cs',
      \ 'name': 'xbuild',
      \ 'defaults': {'bufnr': bufnr('')},
      \ })

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: set sw=2 sts=2 et fdm=marker:
