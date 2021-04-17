nabla.nvim
-----------

Take your scentific notes in Neovim.

[![Capture.png](https://i.postimg.cc/prmHHkTR/Capture.png)](https://postimg.cc/PvncbWYR)


The next iteration on the ASCII math generator from LaTeX formulas.

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

See [test/docs/dirichlet.txt](https://github.com/jbyuki/nabla.nvim/blob/master/test/docs/dirichlet.txt) for a document using nabla.nvim.

Reference
---------

See [test/input.txt](https://github.com/jbyuki/nabla.nvim/blob/master/test/input.txt) for examples.

**Note**: If the notation you need is not present or there is a misaligned expression, feel free to open an [Issue](https://github.com/jbyuki/nabla.nvim/issues).

Credits
-------

* Thanks to jetrosut for his helpful feedback and bug troubleshoot
* Thanks to nbCloud91 for pointing me to VIM conceals
