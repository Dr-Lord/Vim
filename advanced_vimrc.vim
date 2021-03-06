"""" INTRODUCTION """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
"   Author:
"       Dr-Lord
"   Version:
"       0.4 - 06-07/02/2014
"
"   Repository:
"       https://github.com/Dr-Lord/Vim
"
"   Description:
"       Advanced non-extension related part of the personal vim configuration
"       of Dr-Lord. This configuration file contains all the non essential
"       but very useful settings which make Vim awsome. Some of them might
"       be overridden by extensions and their configurations.
"
"   Sections:
"       1 - Basics
"       2 - User Interface
"       3 - Text, Font and Colours
"       4 - Usability
"       5 - Search
"       6 - Indentation
"       7 - Motions and Moving Around
"       8 - Buffers and Tabs
"       9 - Other Options
"       0 - Helper Functions



"""" 1 - BASICS """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""" 2 - USER INTERFACE """"""""""""""""""""""""""""""""""""""""""""""""""""""""


"""" 3 - TEXT, FONT AND COLOURS """"""""""""""""""""""""""""""""""""""""""""""""

" Make the 81st column of long lines stand out
highlight ColorColumn guibg=DarkGreen
call matchadd('ColorColumn', '\%81v', 100)



"""" 4 - USABILITY """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Delete trailing white space on save
autocmd BufWrite * :call DeleteTrailingWS()

" Work out what the comment character is, by filetype
autocmd FileType             *sh,awk,python,perl,perl6,ruby    let b:cmt = exists('b:cmt') ? b:cmt : '#'
autocmd FileType             vim                               let b:cmt = exists('b:cmt') ? b:cmt : '"'
autocmd FileType             haskell                           let b:cmt = exists('b:cmt') ? b:cmt : '--'
autocmd BufNewFile,BufRead   *.vim,.vimrc                      let b:cmt = exists('b:cmt') ? b:cmt : '"'
autocmd BufNewFile,BufRead   *                                 let b:cmt = exists('b:cmt') ? b:cmt : '#'
autocmd BufNewFile,BufRead   *.p[lm],.t                        let b:cmt = exists('b:cmt') ? b:cmt : '#'
autocmd BufNewFile,BufRead   *.hs,.cabal                       let b:cmt = exists('b:cmt') ? b:cmt : '--'


""" MAPPINGS """

" NORMAL OR VISUAL: Toggle (respectively), line and selection lines commenting
nmap <silent> <leader>k :call ToggleComment()<CR>
vmap <silent> <leader>k :call ToggleBlock()<CR>

" INSERT: If a matching quote or bracket is detected, inserting becomes skipping
inoremap <silent> ) <Esc>:call SkipMatching(')')<CR>a
inoremap <silent> ] <Esc>:call SkipMatching(']')<CR>a
inoremap <silent> } <Esc>:call SkipMatching('}')<CR>a

inoremap <silent> ` <Esc>:call SkipMatching('`')<CR>a
inoremap <silent> ' <Esc>:call SkipMatching("'")<CR>a
inoremap <silent> " <Esc>:call SkipMatching('"')<CR>a



"""" 5 - SEARCH """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


""" MAPPINGS """

" NORMAL: Hilight matches when jumping to next
nnoremap <silent> n   n:call HLNext(0.1)<CR>
nnoremap <silent> N   N:call HLNext(0.1)<CR>

" Search and replace the selected text
vnoremap <leader>sg :call VisualSelection('replace', '')<CR>

" VISUAL: * and # search for the current selection forwards and backwards
vnoremap <silent> * :call VisualSelection('f', '')<CR>
vnoremap <silent> # :call VisualSelection('b', '')<CR>



"""" 6 - INDENTATION """""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""" 7 - MOTIONS AND MOVING AROUND """""""""""""""""""""""""""""""""""""""""""""


""" MAPPINGS """

" VISUAL: Drag around Selection (slightly different from Alt based maps defined
" in the main file). It sometimes presents weird behaviour. Vastly improved
" upon by dragvisuals.vim extension.
vnoremap J xp`[V`]
vnoremap K xkP`[V`]
vnoremap H <gv
vnoremap L >gv



"""" 8 - BUFFERS AND TABS """"""""""""""""""""""""""""""""""""""""""""""""""""""


"""" 9 - OTHER OPTIONS """""""""""""""""""""""""""""""""""""""""""""""""""""""""


""" MAPPINGS """

" VISUAL: Preserve only unique lines from visual selection
vmap  q :call Uniq()<CR>
vmap  Q :call Uniq('ignore whitespace')<CR>



"""" 0 - HELPER FUNCTIONS """"""""""""""""""""""""""""""""""""""""""""""""""""""

" Delete trailing White Space
func! DeleteTrailingWS()
    exe "normal mz"
    %s/\s\+$//ge
    exe "normal `z"
endfunc


" Work out whether the line has a comment then reverse that condition
function! ToggleComment ()
    " Determine the comment character(s)
    let comment_char = exists('b:cmt') ? b:cmt : '#'

    " Grab the line and work out whether it's commented
    let currline = getline(".")

    " If so, remove it and rewrite the line
    if currline =~ '^' . comment_char
        let repline = substitute(currline, '^' . comment_char, "", "")
        call setline(".", repline)

    " Otherwise, insert it
    else
        let repline = substitute(currline, '^', comment_char, "")
        call setline(".", repline)
    endif
endfunction

" Toggle comments down an entire visual selection of lines
function! ToggleBlock () range
    " Determine the comment character(s)
    let comment_char = exists('b:cmt') ? b:cmt : '#'

    " Start at the first line
    let linenum = a:firstline

    " Get all the lines, and decide their comment state by examining the first
    let currline = getline(a:firstline, a:lastline)
    if currline[0] =~ '^' . comment_char
        " If the first line is commented, decomment all
        for line in currline
            let repline = substitute(line, '^' . comment_char, "", "")
            call setline(linenum, repline)
            let linenum += 1
        endfor
    else
        " Otherwise, encomment all
        for line in currline
            let repline = substitute(line, '^\('. comment_char . '\)\?', comment_char, "")
            call setline(linenum, repline)
            let linenum += 1
        endfor
    endif
endfunction


" Draw a ring around the next match
function! HLNext (blinktime)
    highlight RedOnRed guifg=Black guibg=DarkOrange
    let [bufnum, lnum, col, off] = getpos('.')
    let matchlen = strlen(matchstr(strpart(getline('.'),col-1),@/))
    echo matchlen
    let ring_pat = (lnum > 1 ? '\%'.(lnum-1).'l\%>'.max([col-4,1]) .'v\%<'.(col+matchlen+3).'v.\|' : '')
        \ . '\%'.lnum.'l\%>'.max([col-4,1]) .'v\%<'.col.'v.'
        \ . '\|'
        \ . '\%'.lnum.'l\%>'.max([col+matchlen-1,1]) .'v\%<'.(col+matchlen+3).'v.'
        \ . '\|'
        \ . '\%'.(lnum+1).'l\%>'.max([col-4,1]) .'v\%<'.(col+matchlen+3).'v.'
    let ring = matchadd('RedOnRed', ring_pat, 101)
    redraw
    exec 'sleep ' . float2nr(a:blinktime * 1000) . 'm'
    call matchdelete(ring)
    redraw
endfunction


" INSERT: If a matching quote or bracket is detected, inserting becomes skipping
function! SkipMatching(thing)
    " Store contents of unnamed registers
    let l:saved_reg = @"

    " Copy the current and next characters
    execute "normal! vly"

    " Unless already in quotes, quotes need to auto-match themselves
    if a:thing =~ "[`'\"]"
        if @" == a:thing . a:thing
            execute "normal! l"
        else
            execute "normal! a" . a:thing . a:thing . "\<Esc>h"
        endif
    " Skip right brackets
    elseif (  (a:thing == ")" && @" == "()") ||
            \ (a:thing == "]" && @" == "[]") ||
            \ (a:thing == "}" && @" == "{}")   )
        execute "normal! l"
    else
        execute "normal! a" . a:thing
    endif

    " Restore unnamed register
    let @" = l:saved_reg
endfunction


" Provide specific actions on a visual selection
function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    "" The next two lines would require the Ack.vim extension
    ""elseif a:direction == 'gv'
        ""call CmdLine("Ack \"" . l:pattern . "\" " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '//g<Left><Left>')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

" Command string wrapper
function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction


" Normalize the whitespace in a string
function! TrimWS (str)
    " Remove whitespace fore and aft
    let trimmed = substitute(a:str, '^\s\+\|\s\+$', '', 'g')

    " Then condense internal whitespaces
    return substitute(trimmed, '\s\+', ' ', 'g')
endfunction

" Reduce a range of lines to only the unique ones, preserving order
function! Uniq (...) range
    " Ignore whitespace differences, if asked to
    let ignore_ws_diffs = len(a:000)

    " Nothing unique seen yet
    let seen = {}
    let uniq_lines = []

    " Walk through the lines, remembering only the hitherto unseen ones
    for line in getline(a:firstline, a:lastline)
        let normalized_line = '>' . (ignore_ws_diffs ? TrimWS(line) : line)
        if !get(seen,normalized_line)
            call add(uniq_lines, line)
            let seen[normalized_line] = 1
        endif
    endfor

    " Replace the range of original lines with just the unique lines
    exec a:firstline . ',' . a:lastline . 'delete'
    call append(a:firstline-1, uniq_lines)
endfunction
