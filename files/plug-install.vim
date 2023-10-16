call plug#begin()

" Load plugins
" VIM enhancements
Plug 'ciaranm/securemodelines'
Plug 'editorconfig/editorconfig-vim'

" GUI enhancements
Plug 'itchyny/lightline.vim'
Plug 'machakann/vim-highlightedyank'
Plug 'andymass/vim-matchup'

" Fuzzy finder
Plug 'airblade/vim-rooter'
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Use release branch
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Syntactic language support
Plug 'cespare/vim-toml'
Plug 'stephpy/vim-yaml'
Plug 'rust-lang/rust.vim'
Plug 'rhysd/vim-clang-format'
"Plug 'fatih/vim-go'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'tikhomirov/vim-glsl'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-abolish'

Plug 'chrisbra/Colorizer'
Plug 'folke/tokyonight.nvim'
" Plug 'github/copilot.vim'

call plug#end()
