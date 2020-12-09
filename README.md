ptformula.nvim
--------------

ptformula (plain-text formula) experimental math expression to ascii art visualizer

**Work in progress**

Install
-------

Install using a plugin manager such as [vim-plug](https://github.com/junegunn/vim-plug).

```
Plug 'jbyuki/ptformula.nvim'
```

Configuration
-------------

Out of the box, the plugin doesn't provide any command. You will need to bind commands or keyshortcuts to use it.

For example to bind it to <kbd>F5</kbd>:

```
nnoremap <F5> :lua require("ptformula").replace_current()<CR>
```

Usage
-----

Hover the cursor on a mathematical expression and call ptformula.nvim. If the expression is correct, it will replace it with an ASCII art respresentation.

Examples
--------

* `1/(1+1/(1+1/(1+2))) + 2`

**Output**:
```
      1          
――――――――――――― + 2
        1        
1 + ―――――――――    
          1      
    1 + ―――――    
        1 + 2    
```

Reference
---------

* sqrt: `sqrt(x)`
* integral: `int(A, B, f(x))`
* limit: `int(x, A, f(x))`
* superscript: `x^a`
* subscript: `x_a`
* special symbols: `pi`, `inf`, `nabla`, ...
* matrix: `[1,2;3,4]`
