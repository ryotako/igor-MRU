#pragma rtGlobals = 3	// Use modern global access method and strict wave access.
#pragma ModuleName = MRU

static constant MRU_MaxEntries = 1000 // `inf` is available

// Public Functions

Function/WAVE MRU_Wave()
	return MRU_Load()
End

Function/S MRU_List()
	WAVE/T w = MRU_Wave()
	String list = ""
	Variable i, N = DimSize(w, 0)
	for(i = 0; i < N; i += 1)
		list = AddListItem(w[i], list, ";", inf)
	endfor
	return list
End

Function MRU_Open(path)
	String path
	Execute/P "LOADFILE " + path
End

// Menu

Menu "File"
	SubMenu "MRU"
		"\M0" + MRU_List(), /Q, MRU#MRU_MenuCommand()
	End
End

static Function MRU_MenuCommand()
	GetLastUserMenuInfo
	MRU_Open(S_Value)
End

// Hooks

static Function AfterFileOpenHook(rN, fileName, path, type, creator, kind)
   Variable rN, kind
   String fileName, path, type, creator

	PathInfo $path
	MRU_Add( S_path + fileName )
End

static Function BeforeExperimentSaveHook(rN, fileName, path, type, creator, kind)
   Variable rN, kind
   String fileName, path, type, creator

	PathInfo $path
	MRU_Add( S_path + fileName )
End


// Static Functions

static Function MRU_Add(path)
	String path

	WAVE/T w = MRU_Load()	
	Extract/T/O w, w, cmpstr(w, path)
	InsertPoints 0, 1, w
	w[0] = path
	
	MRU_Save(w)
End

static Function MRU_Save(paths)
	WAVE/T paths
	
	Extract/T/FREE paths, w, p < MRU_MaxEntries
	
	NewPath/C/Q MruTmpPath, ParseFilePath(1, FunctionPath(""), ":", 1, 0)
	if(V_Flag == 0)
		Variable ref
		Open/P=MruTmpPath/Z ref as "mru.txt"
		if(V_Flag == 0)
			wfprintf ref, "%s\n", w
			Close ref
		endif	
		KillPath MruTmpPath
	endif
End

static Function/WAVE MRU_Load()
	NewPath/C/Q MruTmpPath, ParseFilePath(1, FunctionPath(""), ":", 1, 0)
	if(!V_Flag)
		Variable ref
		Open/P=MruTmpPath/R/Z ref as "mru.txt"	
		if(!V_Flag)
			String buf = ""
			do
				String line
				FReadLine ref, line
				buf += SelectString(strlen(line), "", line)
			while(strlen(line))
			Close ref			
			Make/FREE/T/N=(ItemsInList(buf, "\r")) w = StringFromList(p, buf, "\r")
			KillPath MruTmpPath
			return w		
		endif
		KillPath MruTmpPath
	endif
	Make/FREE/T/N=0 w
	return w
End