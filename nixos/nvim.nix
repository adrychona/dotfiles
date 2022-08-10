{ pkgs, config, ... }: {

  config = {
    environment.systemPackages = with pkgs;
      [

        (neovim.override {
          configure = {
            customRC = ''
                                                                                                                                                      		syntax on
                                                                                                                                                      		set number
                                                                                                                                                      		set smartindent
                                                                                                                          					set mouse=a
                                                                                                                          					set clipboard+=unnamedplus
                                                                                                                          					set cursorline
                                                                                                                          					set cursorcolumn
              																		colorscheme onedark
                                                                                                                          					highlight CursorLine guibg=#2b2b2b 
                                                                                                                          					highlight CursorColumn guibg=#2b2b2b
                                                                                                                          					set wildmode=longest,list,full
                                                                                                                          					set splitbelow splitright
                            set guifont=Cascadia\ Code:h15
                                    let g:neovide_floating_blur_amount_x = 2.0
                                                                                                                                                              map <C-n> :NERDTreeToggle<CR>
                                                                                                                                                              set termguicolors 
                                                                                                                                                              autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
                                                                                                                          			                autocmd VimEnter * TSEnable highlight indent
                                                                                                  						                :autocmd BufWritePost *.nix  :silent %!nixfmt  
                                                        													:autocmd BufWritePost *.css  :CocCommand prettier.forceFormatDocument

                                                        													:autocmd BufWritePost *.html  :CocCommand prettier.forceFormatDocument

                                                        													:autocmd BufWritePost *.json  :CocCommand prettier.forceFormatDocument
                                          autocmd BufWritePost ~/.local/share/chezmoi/* ! chezmoi apply --source-path "%"
            '';
            packages.myVimPackage = with pkgs.vimPlugins; {
              # see examples below how to use custom packages
              start = [
                vimPlugins.coc-prettier
                vim-airline
                coc-nvim
                nerdtree
                indentLine
                onedark-vim
                YouCompleteMe
                (nvim-treesitter.withPlugins (plugins:
                  with plugins; [
                    tree-sitter-nix
                    tree-sitter-python
                    tree-sitter-css
                    tree-sitter-html
                    tree-sitter-regex
                  ]))
              ];
              opt = [ ];
            };
          };
        })
      ];

    nixpkgs.overlays = [
      (self: super: {
        neovim = super.neovim.override {
          viAlias = true;
          vimAlias = true;
        };
      })
    ];

  };
}
