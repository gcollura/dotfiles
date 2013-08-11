" Custom functions and autocmd

function! <SID>StripTrailingWhitespaces()
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
