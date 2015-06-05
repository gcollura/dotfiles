""" File type support

if exists("did_load_filetypes")
    finish
endif

augroup filetypedetect
    autocmd!
    " EJS
    autocmd BufRead,BufNewFile *.ejs        set filetype=jst

    " jQuery
    autocmd BufRead,BufNewFile jquery.*.js  set filetype=javascript syntax=jquery

    " Markdown
    autocmd BufRead,BufNewFile *.md         set filetype=markdown

    " Gradle
    autocmd BufRead,BufNewFile *.gradle     set filetype=groovy

    " LaTeX
    autocmd BufNewFile *.tex                set filetype=tex

    " jshint
    autocmd BufRead,BufNewFile .jshintrc    set filetype=json
augroup END

augroup localoptions
    autocmd!
    " HTML
    autocmd FileType html,xhtml,xml  setl tabstop=4 shiftwidth=4 matchpairs+=<:>

    " Vala
    autocmd FileType vala            setl errorformat=%f:%l.%c-%[%^:]%#:\ %t%[%^:]%#:\ %m

    " Python
    autocmd FileType python          setl smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class

    " LaTeX
    autocmd FileType tex             setl wrap linebreak textwidth=0 spell spelllang=it
    autocmd FileType tex             let maplocalleader = "_"

    " VimScript
    autocmd FileType vim             setl iskeyword+=:,#

    " Javascript
    autocmd FileType javascript,json setl tabstop=2 shiftwidth=2
    autocmd FileType javascript      call UpdateJsHintConf()
augroup END
