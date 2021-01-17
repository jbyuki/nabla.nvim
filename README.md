nabla.nvim
-----------

Take your scientific notes in Neovim.

[![Capture.png](https://i.postimg.cc/sDn3nNWj/Capture.png)](https://postimg.cc/PPwGJKK9)

**nabla.nvim** is an ASCII math generator from LaTeX equations.

Install
-------

Install using a plugin manager such as [vim-plug](https://github.com/junegunn/vim-plug).

```
Plug 'jbyuki/nabla.nvim'
```

Configuration
-------------

For example to bind it to <kbd>F5</kbd>:

```
nnoremap <F5> :lua require("nabla").replace_current()<CR>
```

Usage
-----

Press <kbd>F5</kbd> on the math expression line.

Reference
---------

See [test/input.txt](https://github.com/jbyuki/nabla.nvim/blob/master/test/input.txt) for examples.

**Note**: If the notation you need is not present or there is a misaligned expression, feel free to open an [Issue](https://github.com/jbyuki/nabla.nvim/issues).

Credits
-------

* Thanks to jetrosut for his helpful feedback and bug troubleshoot
