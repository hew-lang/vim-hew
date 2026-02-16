# vim-hew

Vim/Neovim syntax highlighting and editor support for the [Hew](https://hew.sh) programming language.

## Installation

### [lazy.nvim](https://github.com/folke/lazy.nvim) (Neovim)

```lua
{ 'hew-lang/vim-hew' }
```

### [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'hew-lang/vim-hew'
```

### [packer.nvim](https://github.com/wbthomason/packer.nvim) (Neovim)

```lua
use 'hew-lang/vim-hew'
```

### Manual

Copy the contents to your Vim runtime directory:

```sh
# Vim
mkdir -p ~/.vim && cp -r syntax ftdetect ftplugin indent ~/.vim/

# Neovim
mkdir -p ~/.config/nvim && cp -r syntax ftdetect ftplugin indent ~/.config/nvim/
```

## Features

- Full syntax highlighting (keywords, types, actors, supervisors, strings, numbers, comments, operators, attributes)
- Filetype detection for `.hew` files
- Comment formatting (`//`, `/* */`)
- Indentation support (cindent-based)

## Formatting

If you have the `hew` compiler installed, you can format the current buffer with:

```vim
:%!hew fmt %
```

Or add an autocommand to format on save:

```vim
autocmd BufWritePre *.hew silent! execute ':%!hew fmt %'
```

## License

MIT OR Apache-2.0
