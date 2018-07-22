{ vimUtils, vimPlugins, fetchFromGitHub }:

let
  customConfigs = {
    ackConf = ''
      nnoremap <Leader>q :cclose<CR>
      nnoremap <Leader>n :cnext<CR>
      nnoremap <Leader>p :cprev<CR>
      nnoremap <Leader>o :copen<CR>
      nnoremap <Leader>g :Ack<CR>
      command -nargs=* AckWord :Ack <cword> <args>
    '';
    tagbarConf = ''
      nmap <Leader>t :TagbarToggle<cr>
      let g:tagbar_left = 1
      let g:tagbar_autoclose = 1
    '';
    localvimrcConf = ''
      let g:localvimrc_sandbox = 0
      let g:localvimrc_ask = 0
      let g:localvimrc_name = [ ".lvimrc", ".git/localvimrc" ]
    '';
    airlineConf = "let g:airline_section_z = '%3p%% (0x%2B) %#__accent_bold#%4l%#__restore__#:%3c'";
    hybridConf = "let g:hybrid_reduced_contrast = 1";
    buffergator = "let g:buffergator_viewport_split_policy = 'T'";
  };
  bdall = vimUtils.buildVimPlugin {
    name = "bdall";
    src = ./configs/nvim/bdall;
  };
  plantuml = vimUtils.buildVimPlugin {
    name = "plantuml";
    src = fetchFromGitHub {
      owner = "aklt";
      repo = "plantuml-syntax";
      rev = "41eeca5";
      sha256 = "1v11dj4vwk5hyx0zc8qkl0a5wh91zfmwhcq2ndl8zwp78h9yf5wr";
    };
  };
  smarthomekey = vimUtils.buildVimPlugin {
    name = "smarthomekey";
    src = builtins.fetchTarball https://api.github.com/repos/chenkaie/smarthomekey.vim/tarball/master;
  };

in rec {
  customRC = ''
    ${builtins.readFile configs/nvim/init.vim}
    ${builtins.concatStringsSep "\n" (builtins.attrValues customConfigs)}
  '';

  packages.myVimPackage = {
    start = with vimPlugins; [
      ack-vim
      supertab
      tagbar
      vim-localvimrc
      vim-dirdiff
      denite
      airline
      vim-nix
      multiple-cursors
      bdall
      plantuml
      vim-buffergator
      vim-grammarous
      smarthomekey
    ];
    opt = [ ];
  };
}
