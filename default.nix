# Based on [Ali Abrar](https://github.com/ali-abrar)'s Vim configuration.

{ pkgs ? import <nixpkgs> {}, ... }:

let
  srcs = {
    mkdx = import ./dep/mkdx/thunk.nix;
  };
  # cf. https://nixos.wiki/wiki/Vim#Adding_new_plugins 
  customPlugins = {
    neovim-ghcid = pkgs.vimUtils.buildVimPlugin {
      name = "ghcid";
      src = (pkgs.fetchFromGitHub {
        owner = "ndmitchell";
        repo = "ghcid";
        rev = "dfa37af";
        sha256 = "1cx0bj1c1ynzqqvjx0rrbkbhkql6zs11k6sbpbn7gdch4437cjzs";
      }) + "/plugins/nvim";
    };
    indenthaskell = pkgs.vimUtils.buildVimPlugin {
      name = "indenthaskell";
      src = pkgs.fetchFromGitHub {
        owner = "vim-scripts";
        repo = "indenthaskell.vim";
        rev = "17380713774ea4f3ca5da1de455126fa1cce82f7";
        sha256 = "1cs9qkn40fk3c8a9kvbdm3d6izf944awiagpmllkvlb4ci9m6lk7";
      };
    };
    lastpos = pkgs.vimUtils.buildVimPlugin {
      name = "lastpos";
      src = pkgs.fetchFromGitHub {
        owner = "vim-scripts";
        repo = "lastpos.vim";
        rev = "21a22ce4a11117cae8a0017c1cd9a9094fe5adf2";
        sha256 = "0b4xd87a8pxhdf6g8digvjc1a83y572qk4qfdccda2r5m4knidm4";
      };
    };
    vim-ormolu = pkgs.vimUtils.buildVimPlugin {
      name = "vim-ormolu";
      src = pkgs.fetchFromGitHub {
        owner = "sdiehl";
        repo = "vim-ormolu";
        rev = "4ae4fe1";
        sha256 = "13yn0arxcn8ngc91lvhcqs3nl17zcdmgsw522qvqgn732cpf0ddy";
      };
    };
    vim-which-key = pkgs.vimUtils.buildVimPlugin {
      name = "vim-which-key";
      src = pkgs.fetchFromGitHub {
        owner = "liuchengxu";
        repo = "vim-which-key";
        rev = "4b70b44";
        sha256 = "197rp20hngrq7qdlii0ai4vb81dlilah0q1wlil8hv3qcf4az7qr";
      };
    };
    # Markdown
    mkdx = pkgs.vimUtils.buildVimPlugin {
      name = "mkdx";
      src = srcs.mkdx;
    };
    neuron-vim = pkgs.vimUtils.buildVimPlugin {
      name = "neuron-vim";
      src = ./dep/neuron-v2.vim;
      /* src = pkgs.fetchFromGitHub {
        owner = "chiefnoah";
        repo = "neuron-v2.vim";
        rev = "675ea7db754ea4686d8a2f454827d0fc4986876e";
        sha256 = "sha256:0k5lrh6k9d4r5408bxqv5ain2kk34pdwx6cpk4amjhzh2hj000kz";
      }; */
    };
  };
in
  with pkgs; neovim.override {
    configure = {
      # Builtin packaging
      # List of plugins: nix-env -qaP -A nixos.vimPlugins
      packages.myVimPackage = with pkgs.vimPlugins; {
        # Loaded on launch
        start = [ ];
        # Manually loadable by calling `:packadd $plugin-name
        opt = [ ];
      };

      # VAM
      vam.knownPlugins = pkgs.vimPlugins // customPlugins;
      vam.pluginDictionaries = [
        { name = "goyo"; }  # Distraction free writing
        { name = "vim-auto-save"; }
        { name = "vim-nix"; }
        { name = "haskell-vim"; }
        { name = "vim-gitgutter"; }
        { name = "ctrlp"; }
        { name = "papercolor-theme"; }
        { name = "indenthaskell"; }
        { name = "nerdtree"; }
        { name = "lastpos"; }
        { name = "vim-nix"; }
        { name = "fugitive"; }
        { name = "tslime"; }
        { name = "fzf-vim"; }
        { name = "fzfWrapper"; }
        # { name = "neovim-ghcid"; }
        { name = "coc-nvim"; }
        { name = "vim-airline"; }
        { name = "dhall-vim"; }
        { name = "vim-ormolu"; }
        { name = "vim-which-key"; }
        { name = "vim-sneak"; }
        { name = "mkdx"; }
        { name = "neuron-vim"; }
      ];

      customRC = 
        builtins.readFile ./config.vim + builtins.readFile ./config-coc.vim;
    };
  }
