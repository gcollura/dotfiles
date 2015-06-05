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


" From http://got-ravings.blogspot.com/2008/07/vim-pr0n-visual-search-mappings.html

" makes * and # work on visual mode too.  global function so user mappings can call it.
" specifying 'raw' for the second argument prevents escaping the result for vimgrep
" TODO: there's a bug with raw mode.  since we're using @/ to return an unescaped
" search string, vim's search highlight will be wrong.  Refactor plz.
function! VisualStarSearchSet(cmdtype,...)
    let temp = @"
    normal! gvy
    if !a:0 || a:1 != 'raw'
        let @" = escape(@", a:cmdtype.'\*')
    endif
    let @/ = substitute(@", '\n', '\\n', 'g')
    let @" = temp
endfunction


" Zoom / Restore window.
function! utils#zoom_toggle() abort
    if exists('t:zoomed') && t:zoomed
        execute t:zoom_winrestcmd
        let t:zoomed = 0
    else
        let t:zoom_winrestcmd = winrestcmd()
        resize
        vertical resize
        let t:zoomed = 1
    endif
endfunction


function! s:find_jshintrc(dir)
    let l:found = globpath(a:dir, '.jshintrc')
    if filereadable(l:found)
        return l:found
    endif

    let l:parent = fnamemodify(a:dir, ':h')
    if l:parent != a:dir
        return s:find_jshintrc(l:parent)
    endif

    return "~/.jshintrc"
endfunction


function! UpdateJsHintConf()
    let l:dir = expand('%:p:h')
    let l:jshintrc = s:find_jshintrc(l:dir)
    let g:syntastic_javascript_jshint_args = '--config ' . l:jshintrc
endfunction


command! ZoomToggle call utils#zoom_toggle()
command! StripTrailingWhitespaces call utils#strip_trailing_whitespaces()


let &cpo = s:save_cpo
unlet s:save_cpo
