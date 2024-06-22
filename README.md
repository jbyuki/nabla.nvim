nabla.nvim
-----------

Take your scentific notes in Neovim.

<img src="https://i.postimg.cc/CL9MPM7g/Capture.png" width="400">
<img src="https://user-images.githubusercontent.com/16160544/138817005-d326f3ef-d0b0-4372-9cf3-560fd2ec5dd3.png" width="400">
<img src="https://raw.githubusercontent.com/jbyuki/gifs/main/nabla.png" width="600">

The colorscheme used here is [tokyonight](https://github.com/folke/tokyonight.nvim).

An ASCII math generator from LaTeX equations.

Requirements
------------

* Neovim nightly
* A colorscheme which supports treesitter [see here](https://github.com/rockerBOO/awesome-neovim#tree-sitter-supported-colorscheme)
* Tree-sitter : [nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
  (Not a dependency, but recommended to install parsers).
* Latex parser : Install with `TSInstall latex`.

Install
-------

<details>
  <summary>Using <a href="https://github.com/junegunn/vim-plug">vim-plug</a></summary>

  ```vim
  Plug 'jbyuki/nabla.nvim'
  ```
</details>

<details>
  <summary>Using <a href="https://github.com/wbthomason/packer.nvim">packer.nvim</a></summary>

  ```vim
  use 'jbyuki/nabla.nvim'
  ```
</details>

<details>
  <summary>Using the built-in package manager</summary>

  * Create a folder `pack/<a folder name of your choosing>/start`
  * Inside the `start` folder `git clone` nabla.nvim
    * `git clone https://github.com/jbyuki/nabla.nvim`
  * In your init.lua, add the pack folder to packpath (see `:help packpath`)
    ```lua
    vim.o.packpath = vim.o.packpath .. ",<path to where pack/ is located>"
    ```

  * `git pull` in the plugin folder to update it. You want something more viable
  though, that's why package managers are useful.
</details>

Configuration
-------------

Bind the following command:

```vim
nnoremap <leader>p :lua require("nabla").popup()<CR> " Customize with popup({border = ...})  : `single` (default), `double`, `rounded`
```

See [here](https://github.com/jbyuki/nabla.nvim/issues/35) for virt_lines support.

Usage
-----

* Press <kbd>leader + p</kbd> while the cursor is on a math expression to open floating menu

Reference
---------

See [test/input.txt](https://github.com/jbyuki/nabla.nvim/blob/master/test/input.txt) for examples.

**Note**: If the notation you need is not present or there is a misaligned expression, feel free to open an [Issue](https://github.com/jbyuki/nabla.nvim/issues).

Credits
-------

* Thanks to jetrosut for his helpful feedback and bug troubleshoot.
* Thanks to nbCloud91 for pointing me to VIM conceals.
* Thanks to clstb for giving suggestions on how to enhance the interaction.
* Thanks to aspeddro for adding preview popups.
* Thanks to Areustle for adding more than 500 new symbols.
* Thanks to kkharji for pointing out virt_lines.
* Thanks to max397574 for a proper treesitter implementation.

Contribute
----------

See [here](https://github.com/jbyuki/ntangle.nvim/wiki/How-to-use-ntangle.nvim).
