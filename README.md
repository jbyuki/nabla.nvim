ptformula.nvim
--------------

ptformula (plain-text formula)

**work-in-progress**

experimental math expression to ascii art visualizer

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

* `(x+2)^2 + x^4`

**Output**:
```
(x + 2)² + x⁴
```

* `(1/n+1)^n`

**Output**:
```
⎛1    ⎞ⁿ
⎜― + 1⎟ 
⎝n    ⎠ 
```
