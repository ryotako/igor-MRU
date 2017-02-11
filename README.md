# igor-MRU
Minimal procedure to manage the **M**ost **R**ecently **U**sed experiments

This procedure records path names of opened experiment files.
The difference of builtin `Recent Experiments` menu is:

- Number of records. The default is 1000. In Igor Pro 6 for Macintosh, all of them is displayed in a menu bar.
- Functions provide recorded path names. Users can make advanced functions to manage recently used files.
- Path names are saved in an external file `mru.txt`. This file is made in the same directoy as mru.ipf.

This procedure do not make any waves nor variables in Igor Pro. So you can send your experiment file to your colleague without extra information.

## Installation
Download `mru.ipf` into your `Igor Procedures` directory.

### Another way to install
Download `mru.ipf` into your `User Procedures` directory and write `#include "mru"` on a procedure file located in your `Igor Procedures` directory. Using `Igor Procedures` is easier way but the log file `mru.txt` is also autoloaded into Igor Pro. If you want to avoid this, use the `User Procedures` directory.

## Functions

### MRU_Wave()
Return full paths of recently used experiments as a text wave.
```
// Example
Function/WAVE MRU_Grep(pattern)
  String pattern
  
  WAVE/T w = MRU_Wave()
  Extract/T/O w, w, GrepString(w, pattern)
  return w
End
```

### MRU_List()
Return full paths of recently used experiments as a list.

### MRU_Open(path)
Open an experiment file pointed by `path`.
Just a wrapper function of `Execute/P "LOADFILE " + path`.
