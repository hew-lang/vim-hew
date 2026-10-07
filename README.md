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
:%!hew fmt --stdin
```

The `--stdin` form formats the current buffer, including unsaved edits. Do not
pass `%` to the filter: a path argument formats the disk file in place and
prints a status message that replaces the buffer. If the filter reports an
error, undo it with `u` before saving.

For format on save, preserve the buffer when formatting fails and stop the
write rather than saving formatter error output:

```vim
function! HewFormat() abort
  let formatted = systemlist('hew fmt --stdin', join(getline(1, '$'), "\n") . "\n")
  if v:shell_error != 0
    throw 'hew fmt failed: ' . join(formatted, "\n")
  endif
  let view = winsaveview()
  call setline(1, formatted)
  if line('$') > len(formatted)
    execute (len(formatted) + 1) . ',$delete _'
  endif
  call winrestview(view)
endfunction

autocmd BufWritePre *.hew call HewFormat()
```

`hew` must be on the editor's PATH. Formatting is separate from language-server
features; this plugin supplies syntax highlighting, filetype detection and
indentation, and does not start an LSP client.

## Syntax verification

Run the syntax smoke test with Vim:

```sh
vim -Nu NONE -i NONE -n -es -S test/syntax.vim
HEW_COMPILER=/path/to/hew python3 test/formatting.py
```

The fixture covers dotted paths, `.{ }` imports, and contextual `.Variant`
forms, consuming receivers, generators and plain stream iteration. Retired syntax is highlighted as an error; the compiler names the
legacy path and turbofish diagnostics `E_PATH_LEGACY_SEPARATOR` and
`E_LEGACY_TURBOFISH`; removed glob imports use `E_IMPORT_GLOB_REMOVED`.

## License

Apache-2.0
