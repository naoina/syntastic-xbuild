if exists('g:loaded_syntastic_cs_xbuild_checker')
  finish
endif
let g:loaded_syntastic_cs_xbuild_checker = 1

let s:save_cpo = &cpo
set cpo&vim

function! s:path2file(path, fname) abort
  let parent = a:path

  while 1
    let path = parent . '/' . a:fname
    let candidate = glob(path)
    if !isdirectory(candidate) && filereadable(candidate)
      return candidate
    endif
    let next = fnamemodify(parent, ':h')
    if next == parent
      return ''
    endif
    let parent = next
  endwhile
endfunction

function! s:path2csproj(path) abort
  return s:path2file(a:path, '*.csproj')
endfunction

function! s:path2sln(path) abort
  return s:path2file(a:path, '*.sln')
endfunction

function! s:path2projectfile(path) abort
  let path = s:path2sln(a:path)
  if path
    return path
  endif
  return s:path2csproj(a:path)
endfunction

function! SyntaxCheckers_cs_xbuild_IsAvailable() dict
  return executable(self.getExec())
endfunction

function! SyntaxCheckers_cs_xbuild_GetLocList() dict
  let projectfile = s:path2projectfile(expand('%:p:h'))
  let makeprg = self.makeprgBuild({
        \ 'fname': projectfile,
        \ })
  let errorformat =
        \ '%f(%l\,%c): %trror %m,' .
        \ '%f(%l\,%c): %tarning %m'

  let loclist = SyntasticMake({
        \ 'makeprg': makeprg,
        \ 'errorformat': errorformat,
        \ 'cwd': fnamemodify(projectfile, ':h'),
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
