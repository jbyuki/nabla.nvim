nabla.nvim
-----------

Take your scientific notes in Neovim.

[![Capture.png](https://i.postimg.cc/sDn3nNWj/Capture.png)](https://postimg.cc/PPwGJKK9)

**nabla.nvim** is an ASCII math generator.

**Work in progress**

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

* square root: `sqrt(x)`
* integral: `int(A, B, f(x))`
* limit: `lim(x, A, f(x))`
* superscript: `x^a`
* subscript: `x_a`
* special symbols: `pi`, `inf`, `nabla`, ...
* vector, matrix: `[1,2;3,4]`
