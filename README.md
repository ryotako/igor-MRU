# igor-MRU
Minimal Procedure to manage Most Recently Used experiments

# Functions

### MRU_Wave()
Return full paths of recently used experiments as a text wave.

```
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
