" Key binding for Neovim out of the box.
"
" @author Maciej Bedra

" More handy insert mode exit
"inoremap jk <Esc>
"inoremap kj <Esc>
"
"" Navigation between splits
"nnoremap <C-h> <C-w>h
"nnoremap <C-j> <C-w>j
"nnoremap <C-k> <C-w>k
"nnoremap <C-l> <C-w>l
"
"" Splits resizing
"nnoremap <M-j> :resize -2<CR>
"nnoremap <M-k> :resize +2<CR>
"nnoremap <M-h> :vertical resize -2<CR>
"nnoremap <M-l> :vertical resize +2<CR>
"
"" Editor tabs navigation
nnoremap <TAB> :tabnext<CR>
nnoremap <S-TAB> :tabprevious<CR>
"
"" Completion
"inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
"
"" More handy line 'tabbing'
"vnoremap < <gv
"vnoremap > >gv
"
function! CopyFileAndOpen()
  call inputsave()
  let name = input('Enter file name: ')
  call inputrestore()
  execute 'saveas' expand('%:h') . '/' . name
endfunction

" use ";" as leader
let mapleader=";"
" my shortcuts
nnoremap Q :q<CR>
nnoremap W :w<CR>
nnoremap qq :wq<CR>
nnoremap vv <C-w>v
nnoremap <leader>e <C-w>s
nnoremap gis :Gstatus<CR>
nnoremap gic :Git commit -a<CR>
nnoremap gip :Gpush<CR>
nnoremap gil :Glog<CR>

" for fuzzy finder
nnoremap <leader>f :Files<CR>
nnoremap <leader>m :Marks<CR>
nnoremap <leader>g :Rg<CR>
nnoremap <leader>c :call CopyFileAndOpen()<CR>

nnoremap <leader>b :Buffers<CR>
nnoremap <leader>t :terminal<CR>izsh<CR>

nnoremap <leader>l <C-w><C-l>
nnoremap <leader>h <C-w><C-h>
nnoremap <leader>j <C-w><C-j>
nnoremap <leader>k <C-w><C-k>

tnoremap <leader>l <C-\><C-n><C-w><C-l>
tnoremap <leader>h <C-\><C-n><C-w><C-h>
tnoremap <leader>j <C-\><C-n><C-w><C-j>
tnoremap <leader>k <C-\><C-n><C-w><C-k>
tnoremap <ESC> <C-\><C-n>

" Key binding used to format code
nmap <leader>cf <Plug>(coc-format)

" Key binding for code action (optimize imports, generate code, etc.)
nmap <leader>ca <Plug>(coc-codeaction)

" Key binding used for symbol rename
nmap <F2> <Plug>(coc-rename)

" Key binding used to go to definition
nmap <leader>d <Plug>(coc-definition)

" Key binding used to go to type definition
nmap <leader>ct <Plug>(coc-type-definition)

" Key binding used to to to implementation
nmap <leader>ci <Plug>(coc-implementation)

" Key binding used to go to declaration
nmap <leader>cr <Plug>(coc-declaration)

" Key binding used to find usages
nmap <leader>cu <Plug>(coc-references)

" Key binding for quick fix
nmap <leader>cq <Plug>(coc-fix-current)

" Key binding used to show code errors, warnings, etc.
nmap <leader>ce :CocList diagnostics<CR>

" Key binding for code outline
nmap <M-7> :CocList outline<CR>

" Key binding used to find symbol
nmap <leader>cs :CocList -I symbols<CR>
