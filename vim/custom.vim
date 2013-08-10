" Custom functions and autocmd

function! <SID>StripTrailingWhitespaces()
    " Save cursor position
    let l = line(".")
    let c = col(".")
    " Save last search
    let _s=@/

    " Delete whitespaces
    %s/\s\+$//e

    " Restore everything
    call cursor(l, c)
    let @/=_s
endfunction

autocmd FileType c,cpp,java,php,ruby,python,vim autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()
command! StripTrailingWhitespaces call <SID>StripTrailingWhitespaces()
