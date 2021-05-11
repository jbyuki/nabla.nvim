nabla.nvim
-----------

Take your scentific notes in Neovim.

<img src="https://i.postimg.cc/CL9MPM7g/Capture.png" width="400">

The colorscheme used here is [tokyonight](https://github.com/folke/tokyonight.nvim).

An ASCII math generator from LaTeX equations.

Requirements
------------

* Neovim nightly
* A colorscheme which supports treesitter [see here](https://github.com/rockerBOO/awesome-neovim#treesitter-supported-colorschemes)

Install
-------

Using [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'jbyuki/nabla.nvim'
```

Configuration
-------------

Bind the following command:

```vim
nnoremap <F5> :lua require("nabla").place_inline()<CR>
```

Usage
-----

* Press <kbd>F5</kbd> to initiate **nabla.nvim**.
* Press <kbd>F5</kbd> on a LaTeX formula to generate the ASCII Formula.
  * `$ ... $` : inline form
  * `$$ ... $$` : wrapped form

Reference
---------

See [test/input.txt](https://github.com/jbyuki/nabla.nvim/blob/master/test/input.txt) for examples.

**Note**: If the notation you need is not present or there is a misaligned expression, feel free to open an [Issue](https://github.com/jbyuki/nabla.nvim/issues).

Credits
-------

* Thanks to jetrosut for his helpful feedback and bug troubleshoot
* Thanks to nbCloud91 for pointing me to VIM conceals
