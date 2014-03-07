" Custom functions and autocmd

function! <SID>StripTrailingWhitespaces()
    if (g:no_strip_whitespaces)
        return
    endif
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

autocmd FileType c,cpp,java,php,ruby,python,vim autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()
command! StripTrailingWhitespaces call <SID>StripTrailingWhitespaces()
let g:no_strip_whitespaces = 0
