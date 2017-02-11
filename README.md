# igor-MRU
Minimal procedure to manage the **M**ost **R**ecently **U**sed experiments

This procedure records path names of opened experiment files.
The difference of builtin `Recent Experiments` menu is:

- Number of records. The default is 1000. In Igor Pro 6 for Macintosh, all of them is displayed in a menu bar.
- Functions provide recorded path names. User can make advanced functions to manage recently used files.
- Path names are saved in an external file. This file is made in the same directoy as mru.ipf.

## Installation
Download `mru.ipf` into your `Igor Procedures` directory.

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
Just a wrapper of `Execute/P "LOADFILE " + path`.
