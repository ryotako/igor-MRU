#pragma rtGlobals = 3	// Use modern global access method and strict wave access.
#pragma ModuleName = MRU

static constant MRU_MaxEntries = 1000 // `inf` is available

//==============================================================================
// Minimal procedure to manage the Most Recently Used experiments
// 
// This procedure records path names of opened experiment files.
// The difference of builtin `Recent Experiments` menu is:
// 
// - The default number of records is 1000. You can change this limit.
// - In Igor Pro 6 for Macintosh, all of them is displayed in a menu bar.
// - You can get recorded path names with the function.
// - The path names are saved in an external file `mru.txt`.
//   (This file is made in the same directoy as mru.ipf)
// 
// This procedure do not make any waves nor variables in Igor Pro. 
// So you can send your experiment file to your colleague without extra info.
//==============================================================================

// Public Functions
// 
// MRU_Wave() : Return recorded path names as a text wave.
// MRU_Open(path_to_experiment) : Open an igor experiment.

Function/WAVE MRU_Wave()
	return MRU_Load()
End

Function MRU_Open(path) // just a wrapper of 'Execute/P "LOADFILE ..."'
	String path
	Execute/P "LOADFILE " + path
End

// Menu
//
// The MRU menu is displayed on the FILE tab.
// If you do not want to display this, use #include "mru" menus=0 

Menu "File", dynamic
	SubMenu "MRU"
		MRU#MRU_MenuItems(), /Q, MRU#MRU_MenuCommand()
	End
End

static Function/S MRU_MenuItems()
	WAVE/T w = MRU_Wave()
	String list = ""

	Variable i, N = DimSize(w, 0)
	for(i = 0; i < N; i += 1)
		list = AddListItem("\M0" + w[i], list, ";", inf)
	endfor
	
	return list
End

static Function MRU_MenuCommand()
	GetLastUserMenuInfo
	MRU_Open(S_Value)
End

// Hooks
//
// Hook functions to save the opened experiments.
// These functions are called when you open or save experiments.  

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

// Add the current experiment into external log file.
static Function MRU_Add(path)
	String path

	WAVE/T w = MRU_Load()	
	Extract/T/O w, w, cmpstr(w, path)
	InsertPoints 0, 1, w
	w[0] = path
	
	MRU_Save(w)
End

// Save a text wave as the external log file.
static Function MRU_Save(paths)
	WAVE/T paths
	
	Extract/T/FREE paths, w, p < MRU_MaxEntries
	
	NewPath/C/O/Q MRU, ParseFilePath(1, FunctionPath(""), ":", 1, 0)
	if(V_Flag == 0)
		// To close the file explicitly,
		// use 'wprintf' to save a wave instead of 'Save' operation.
		Variable ref
		Open/P=MRU/Z ref as "mru.txt"
		if(V_Flag == 0)
			wfprintf ref, "%s\n", w
			Close ref
		endif	
		KillPath/Z MRU
	endif
End

// Load the external log file as a text wave.
static Function/WAVE MRU_Load()
	
	// The log file is saved at the same location as 
	NewPath/C/O/Q MRU, ParseFilePath(1, FunctionPath(""), ":", 1, 0)

	if(!V_Flag)
		Variable ref
		Open/P=MRU/R/Z ref as "mru.txt"	
		if(!V_Flag)
			String buf = ""
			do
				String line
				FReadLine ref, line
				buf += SelectString(strlen(line), "", line)
			while(strlen(line))
			Close ref			
			Make/FREE/T/N=(ItemsInList(buf, "\r")) w = StringFromList(p, buf, "\r")
			KillPath/Z MRU
			return w		
		endif
		KillPath MRU
	endif
	Make/FREE/T/N=0 w
	return w
End
