" --- keymaps ---
nnoremap <Esc><Esc> :nohlsearch<CR> 
nnoremap <Leader>. :tabnew ~/.vimrc<CR>
nnoremap <C-G><C-G> :Ripgrep <C-R><C-W><CR>
nnoremap <Leader>re :%s;\<<C-R><C-W>\>;g<Left><Left>;

" open terminal
nnoremap <Leader>tt :<C-u>tabnew<CR><BAR>:terminal<CR>

" move tab
nnoremap <C-l> gt
nnoremap <C-h> gT
nnoremap cm ct

" remove insert mode in terminal
tnoremap <C-]> <C-\><C-n>

" Home / End
nnoremap H ^
nnoremap L $
vnoremap H ^
vnoremap L $
onoremap H ^
onoremap L $

" Emacs like in Insert/Command
inoremap <C-d> <Del>
inoremap <C-k> <C-o>C
inoremap <silent> <C-f> <Right>
inoremap <silent> <C-b> <Left>
inoremap <silent> <C-e> <C-o>A
inoremap <silent> <C-a> <C-o>I
cnoremap <C-d> <Del>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>

nnoremap x "_x
nnoremap s "_s
nnoremap c "_c

" move pair ()
nnoremap <Tab><Leader> %

" better <
nnoremap < <<
nnoremap > >>

" swap ; and :
" nnoremap ; :
" nnoremap : ;
" vnoremap ; :
" vnoremap : ;
nnoremap ' :
vnoremap ' :

nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k

" less key motion
onoremap 9 i(
onoremap [ i[
onoremap { i{
onoremap a9 a(

nnoremap v9 vi(
nnoremap v[ vi[
nnoremap v{ vi{
nnoremap va9 va(

onoremap ' i'
onoremap " i"

nnoremap Y y$

nnoremap [b <Cmd>bnext<CR>
nnoremap ]b <Cmd>bprevious<CR>
nnoremap [<Space> O<ESC>cc<ESC>
nnoremap ]<Space> o<ESC>cc<ESC>

nnoremap <C-j> }
nnoremap <C-k> {
vnoremap <C-j> }
vnoremap <C-k> {

" split window
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sh <C-w>h
nnoremap ss :<C-u>sp<CR><C-w>j
nnoremap sv :<C-u>vs<CR><C-w>l
