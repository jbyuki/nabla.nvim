nabla.nvim
-----------

[![Capture.png](https://i.postimg.cc/pTK8w7fR/Capture.png)](https://postimg.cc/MMKvR93F)

This might be the next iteration for **nabla.nvim**. Following Issue #2, nbCloud91 brought the idea the have a non-destructive conceal layer which would render the ASCII formulas. The main reason, it could not be realised is because conceals only allow for a single character replacement through `cchar`. Not to mention the multline problem.

This is an attempt to realise this wish without conceals. There are several "tricks" at play to pull this off.

It improves over the previous version by:

  * Completely concealing the LaTeX formulas for less noise
  * Overriding the standard save/write, so that it omits the ASCII formulas
  * Syntax highlighting of formulas

Requirements
------------

* Neovim nightly: It uses several cutting-edge features of Neovim, this means the nightly version is mandatory.

* Treesitter: Currently it uses treesitter highligh groups to color the equation. It can be easily changed to remove this dependency.

Usage
-----

This is the current workflow.

  * First, initiate **nabla.nvim** with `lua require"nabla".attach()` on the buffer file. This will:
    * Init conceal syntax
    * Override save
    * Attach to the buffer so that extmarks are handeld correctly. The default behaviour doesn't delete extmark on line deletion.
    * Place all valid formulas inline
  * Regenerate ASCII with `lua require"nabla".place_inline()`

For convenience, these commands should be keybindinded, or triggered on an autocommand.
