# typkit

typkit (typst tool kit) is a library that provides utility helpers for various operations.

the utilities come in 3 forms
    - math utils
    - standard utils
    - prose utils

the math utils are:
    - slope
    - shortest
    - longest

for a complete guide on how to use these utilities, see the manual.

<table><tr>
  <td>
    <a href="gallery/karls-picture.typ">
      <img src="gallery/karls-picture.png" width="250px">
    </a>
  </td>
  <td>
    <a href="gallery/tree.typ">
      <img src="gallery/tree.png" width="250px">
    </a>
  </td>
  <td>
    <a href="gallery/waves.typ">
      <img src="gallery/waves.png" width="250px">
    </a>
  </td>
</tr></table>

*Click on the example image to jump to the code.*


To use this package, simply add the following code to your document:

```
#import "@preview/typkit:0.1.0"

#typkit.math.slope((0,0), (1, 1)) // 1
```

