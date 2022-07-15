" Global configs

set encoding=utf-8

if has('mouse')
  set mouse=a
endif

" typo for :w
command WQ wq
command Wq wq
command W w
command Q q

" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')

" Declare the list of plugins.

let g:python_host_prog='/usr/bin/python3'

" Syntatic checking
Plug 'vim-syntastic/syntastic'
" live update loc list
let g:syntastic_always_populate_loc_list = 1
" don't auto open, but auto close when empty
let g:syntastic_auto_loc_list = 2
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" better statusline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" git support
Plug 'tpope/vim-fugitive'

" mergetool
nnoremap <F2> :diffget //2<CR>
nnoremap <F3> :diffget //3<CR>

" Data/Time arithmetic
Plug 'tpope/vim-speeddating'

" More mapping
Plug 'tpope/vim-unimpaired'

" Dot applying to plugins
Plug 'tpope/vim-repeat'

" pairs
Plug 'tpope/vim-surround'

" autocomplete
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" directory tree
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'

" pair completion {{{
Plug 'jiangmiao/auto-pairs'
" Plug 'Raimondi/delimitMate'
" turn off for xhtml because interfere with completion
" autocmd FileType xhtml let b:delimitMate_autoclose=0
" }}} pair completion

" Easymotion {{{
Plug 'easymotion/vim-easymotion'
" }}

" Coq {{{
augroup CoqtailHighlights
  autocmd!
  autocmd ColorScheme *
    \  hi def CoqtailChecked ctermbg=17 guibg=DarkGreen
    \| hi def CoqtailSent    ctermbg=60 guibg=NavyBlue
augroup END
Plug 'whonore/Coqtail'
" }}}

" Colors {{{
Plug 'tomasr/molokai'
syntax enable
colorscheme molokai
hi diffAdded ctermfg=46  cterm=NONE guifg=#2BFF2B gui=NONE
hi diffRemoved ctermfg=196 cterm=NONE guifg=#FF2B2B gui=NONE
set termguicolors
" let g:molokai_original = 1
" let g:rehash256 = 1
" set background=dark
" }}} Colors

" haskell syntax highlighter
Plug 'neovimhaskell/haskell-vim'

" Autoformater
Plug 'sbdchd/neoformat'
let g:neoformat_cuda_clangformat = {
            \ 'exe': 'clang-format',
            \ 'stdin': 1,
            \ }
let g:neoformat_enabled_cuda = ['clangformat']
let g:neoformat_haskell_ormolu = {
            \ 'exe': 'ormolu',
            \ 'stdin': 1,
            \ }
let g:neoformat_enabled_haskell = ['ormolu']
let g:neoformat_nix_nixpkgsfmt = {
            \ 'exe': 'nixpkgs-fmt',
            \ 'stdin': 1,
            \ }
let g:neoformat_enabled_nix = ['nixpkgsfmt']
let g:neoformat_cabal_cabalfmt = {
            \ 'exe': 'cabal-fmt',
            \ 'stdin': 1,
            \ }
let g:neoformat_enabled_cabal = ['cabalfmt']
let g:neoformat_python_black = {
            \ 'exe': 'black',
            \ 'stdin': 1,
            \ 'args': ['-'],
            \ }
let g:neoformat_enabled_python =['black']

function SetIndent(enable)
    " Enable alignment
    let b:neoformat_basic_format_align = a:enable
    " Enable tab to spaces conversion
    let b:neoformat_basic_format_retab = a:enable
    " Enable trimmming of trailing whitespace
    let b:neoformat_basic_format_trim = a:enable
endfunction


augroup noformat
    autocmd!
    " disable basic formatting
    autocmd FileType markdown call SetIndent(0)
augroup END
augroup fmt
    autocmd!
    autocmd FileType cuda,c,cpp,haskell,nix,cabal,python,ocaml
        \ autocmd BufWritePre <buffer> silent! Neoformat |
        \ call SetIndent(1)
augroup END

" SMT2 syntax highlighter
Plug 'bohlender/vim-smt2'

" rust
Plug 'rust-lang/rust.vim'
" Key binding for cargo check
autocmd FileType rust nnoremap <buffer> <Leader>CC :bo vsp term://cargo check<CR><C-W><C-W>
" nix
Plug 'LnL7/vim-nix'

" fzf
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
nnoremap <C-p> :GFiles<CR>
nnoremap <C-l> :Files<Space>

" Close tag for xhtml (for StandardEbooks production)
Plug 'alvan/vim-closetag'

" Markdown preview
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }

" Closetag config {{{
" filenames like *.xml, *.html, *.xhtml, ...
" These are the file extensions where this plugin is enabled.
"
let g:closetag_filenames = '*.html,*.xhtml,*.phtml'

" filenames like *.xml, *.xhtml, ...
" This will make the list of non-closing tags self-closing in the specified files.
"
let g:closetag_xhtml_filenames = '*.xhtml,*.jsx'

" filetypes like xml, html, xhtml, ...
" These are the file types where this plugin is enabled.
"
let g:closetag_filetypes = 'html,xhtml,phtml'

" filetypes like xml, xhtml, ...
" This will make the list of non-closing tags self-closing in the specified files.
"
let g:closetag_xhtml_filetypes = 'xhtml,jsx'

" integer value [0|1]
" This will make the list of non-closing tags case-sensitive (e.g. `<Link>` will be closed while `<link>` won't.)
"
let g:closetag_emptyTags_caseSensitive = 1

" Shortcut for closing tags, default is '>'
"
let g:closetag_shortcut = '>'

" Add > at current position without closing the current tag, default is ''
"
let g:closetag_close_shortcut = '<leader>>'
" }}} closetag config

call plug#end()

" coc config {{{
" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ CheckBackspace() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Run the Code Lens action on the current line.
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
let g:coc_filetype_map = {
  \ 'xhtml': 'html',
  \ }
" }}} coc config

" Spaces & Tabs {{{
set tabstop=4       " number of visual spaces per TAB
set softtabstop=4   " number of spaces in tab when editing
set shiftwidth=4    " number of spaces to use for autoindent
set expandtab       " tabs are space
set autoindent
set copyindent      " copy indent from the previous line
autocmd FileType haskell setlocal shiftwidth=2
autocmd FileType haskell setlocal tabstop=2
autocmd FileType haskell setlocal softtabstop=2
autocmd FileType ocaml setlocal shiftwidth=2
autocmd FileType ocaml setlocal tabstop=2
autocmd FileType ocaml setlocal softtabstop=2
autocmd FileType vue setlocal shiftwidth=2
autocmd FileType vue setlocal tabstop=2
autocmd FileType vue setlocal softtabstop=2
autocmd FileType cpp setlocal shiftwidth=2
autocmd FileType cpp setlocal tabstop=2
autocmd FileType cpp setlocal softtabstop=2
autocmd FileType cuda setlocal shiftwidth=2
autocmd FileType cuda setlocal tabstop=2
autocmd FileType cuda setlocal softtabstop=2
autocmd FileType sh setlocal shiftwidth=2
autocmd FileType sh setlocal tabstop=2
autocmd FileType sh setlocal softtabstop=2
" }}} Spaces & Tabs

" Clipboard {{{
set clipboard+=unnamed
" }}} Clipboard

" Airline {{{
" let g:airline#extensions#tabline#enabled = 1
let g:airline_theme = 'deus'
let g:airline_powerline_fonts = 1
"
" }}}

" live preview when search and replace
set inccommand=nosplit

" tab shortcuts {{{
"
" change tabs to view
nnoremap <C-Left> :tabprevious<CR>
nnoremap <C-Right> :tabnext<CR>

" move tabs
nnoremap <silent> <A-Left> :tabm -1<CR>
nnoremap <silent> <A-Right> :tabm +1<CR>

" tabv to open a tab to readonly
cabbrev tabv tab sview +setlocal\ nomodifiable

" Use <F8> to toggle `tab ball` and `tabo`
let notabs = 0
nnoremap <silent> <F8> :let notabs=!notabs<Bar>:if notabs<Bar>:tabo<Bar>:else<Bar>:tab ball<Bar>:tabn<Bar>:endif<CR>
" }}} tab shortcuts

syntax on
filetype plugin indent on

" UI Config {{{
set number                   " show line number
set showcmd                  " show command in bottom bar
set wildmenu                 " visual autocomplete for command menu
set wildmode=longest:full,full
" set showmatch                " highlight matching brace
" }}} UI Config

" For StandardEbooks Production
autocmd FileType xhtml setlocal noexpandtab list listchars=tab:»·,eol:↲,nbsp:␣,extends:…,precedes:<,extends:>,trail:·
" let Gdiffsplit wrap
autocmd FileType xhtml nnoremap <F6> :tabdo windo set wrap<CR>
" let <F7> inserts WORD-JOIN and EM-DASH
autocmd FileType xhtml nnoremap <F7> i<C-v>u2014<C-v>u2060<Esc>

