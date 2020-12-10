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

| Name | Expression |
|------|------------|
| square root | `sqrt(x)` |
| integral | `integral(A, B, f(x))` |
| sum | `sum(A, B, f(x))` or `sum(f(x))` |
| limit | `lim(x, a, f(x))` |
| superscript | `x^a` |
| subscript | `x_a` |
| special symbols | `alpha`, `inf`, `nabla`, ... |
| vector, matrix | `[x,y;z,w]` |
| derivative | `d(x, f(x))` |
| partial derivative | `dp(x, f(x))` |

**Note**: If the notation you need is not present or there is a misaligned expression, feel free to open an [Issue](https://github.com/jbyuki/nabla.nvim/issues).
