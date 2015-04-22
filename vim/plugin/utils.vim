" If already loaded, we're done...
if exists("g:loaded_utils")
    finish
endif
let g:loaded_utils = 1

let s:save_cpo = &cpo
set cpo&vim

" Highlight for few seconds the current selected search result
function! HLNext(blinktime)
    let [bufnum, lnum, col, off] = getpos('.')
    let matchlen = strlen(matchstr(strpart(getline('.'),col-1),@/))
    let target_pat = '\c\%#'.@/
    let ring = matchadd('Error', target_pat, 101)
    redraw
    exec 'sleep ' . float2nr(a:blinktime * 1000) . 'm'
    call matchdelete(ring)
    redraw
endfunction

" Remove all the damned whitespaces
function! utils#strip_trailing_whitespaces()
    " Save cursor position
    let pos = getpos(".")
    " Save last search
    let search = getreg('/')

    " Delete whitespaces
    %s/\s\+$//e

    " Restore everything
    call setpos('.', pos)
    call setreg('/', search)
endfunction

function! utils#putdir(dir)
    let dir = expand(a:dir)
    if !isdirectory(dir)
        call mkdir(dir, 'p')
    endif
endfunction

command! StripTrailingWhitespaces call utils#strip_trailing_whitespaces()

let &cpo = s:save_cpo
unlet s:save_cpo

