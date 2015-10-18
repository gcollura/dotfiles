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

    " Rust lang
    autocmd BufRead,BufNewFile *.rs         set filetype=rust

    " jscs
    autocmd BufRead,BufNewFile .jscsrc      set filetype=json

    " Jade
    autocmd BufRead,BufNewFile *.jade       set filetype=jade

    " Toml
    autocmd BufNewFile,BufRead *.toml       set filetype=toml
    " Rust uses Cargo.toml and Cargo.lock (both are toml files).
    autocmd BufNewFile,BufRead Cargo.lock   set filetype=toml

    " nginx
    autocmd BufRead,BufNewFile /etc/nginx/sites-*/* set filetype=nginx
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
    autocmd FileType javascript,json setl tabstop=2 shiftwidth=2 textwidth=80
    autocmd FileType javascript      call UpdateJsCheckersConf()

    " PHP
    autocmd FileType php             setl omnifunc=phpcomplete#CompletePHP noexpandtab

    " XML
    autocmd FileType xml,xslt        setl noexpandtab
    autocmd FileType xml             setl omnifunc=xmlcomplete#CompleteTags noci
    autocmd FileType html            setl omnifunc=htmlcomplete#CompleteTags noci
    autocmd FileType xml,xslt        let maplocalleader = "_"
    autocmd FileType xslt            setl textwidth=0

    " Jade
    autocmd FileType jade            setl nolinebreak textwidth=0

    " sass
    autocmd FileType scss            setl tabstop=2 shiftwidth=2

augroup END
