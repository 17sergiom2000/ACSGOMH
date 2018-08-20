;-by Alexander Pfefferle | github.com/pf3ff3rl3 | gitlab.com/pf3ff3rl3

DeclareModule ATPMemory
  Declare.l GetProcessID(ProcessName.s)
  Declare.l ATPMemory(ProcessName.s)
  Declare.l GetModuleBase(ProcessID.l, ModuleName.s)
  Declare.l GetModuleSize(ProcessID.l, ModuleName.s)
  Declare.l RPM(p.l, addr.l)
  Declare.b RPM_Byte(p.l, addr.l)
  Declare.c RPM_Char(p.l, addr.l)
  Declare.w RPM_Word(p.l, addr.l)
  Declare.f RPM_Float(p.l, addr.l)
  Declare.s RPM_String(p.l, addr.l, len.l)
  Declare.s RPM_UnicodeString(p.l, addr.l, len.l)
  Declare.l WPM(p.l, addr.l, value.l)
  Declare.l WPM_Word(p.l, addr.l, value.w)
  Declare.l WPM_Float(p.l, addr.l, value.f)
  Declare.l WPM_String(p.l, addr.l, value.s)
  Declare.l WPM_Byte(p.l, addr.l, value.b)
  Declare InjectDll(ProcessName.s, DLLPath.s)
  Declare.l ScanSignature(ProcessHandle.l, ProcessID.i, ModuleName.s, Extra.i, Offset.i, Signature.s, fRead=1, fSubtract.i=1)
EndDeclareModule

Module ATPMemory

Global kernel32=OpenLibrary(#PB_Any, "kernel32.dll")

Procedure.l GetProcessID(ProcessName.s)
   Protected hSnapshot.i
   Protected ProcessInfo.PROCESSENTRY32
   If kernel32
      hSnapshot=CreateToolhelp32Snapshot_(#TH32CS_SNAPPROCESS, 0)
      If hSnapshot
         ProcessInfo\dwSize=SizeOf(PROCESSENTRY32)
         If Process32First_(hSnapshot, @ProcessInfo)
            Repeat
               If ProcessName=PeekS(@ProcessInfo\szExeFile, -1, #PB_Ascii)
                  ProcedureReturn ProcessInfo\th32ProcessID
               EndIf
            Until Not Process32Next_(hSnapshot, @ProcessInfo)
         EndIf
         CloseHandle_(hSnapshot)
      EndIf
   EndIf
   ProcedureReturn -1
EndProcedure

Procedure.l ATPMemory(ProcessName.s)
  ProcedureReturn OpenProcess_(#PROCESS_ALL_ACCESS, 0, GetProcessID(ProcessName))
EndProcedure

Procedure.l GetModuleBase(ProcessID.l, ModuleName.s)
   Protected hSnapshot.i
   Protected ModuleInfo.MODULEENTRY32
   If kernel32
      hSnapshot=CreateToolhelp32Snapshot_(#TH32CS_SNAPMODULE | #TH32CS_SNAPMODULE32, ProcessID)
      If hSnapshot
         ModuleInfo\dwSize=SizeOf(MODULEENTRY32)
         If Module32First_(hSnapshot, @ModuleInfo)
            Repeat
               Protected moduleName$=PeekS(@ModuleInfo\szModule, -1, #PB_Ascii)
               If moduleName$=ModuleName
                  ProcedureReturn ModuleInfo\modBaseAddr
               EndIf
            Until Not Module32Next_(hSnapshot, @ModuleInfo)
         EndIf
         CloseHandle_(hSnapshot)
      EndIf
   EndIf
   ProcedureReturn -1
EndProcedure
 
Procedure.l GetModuleSize(ProcessID.l, ModuleName.s)
   Protected hSnapshot.i
   Protected ModuleInfo.MODULEENTRY32
   If kernel32
      hSnapshot=CreateToolhelp32Snapshot_(#TH32CS_SNAPMODULE | #TH32CS_SNAPMODULE32, ProcessID)
      If hSnapshot
         ModuleInfo\dwSize=SizeOf(MODULEENTRY32)
         If Module32First_(hSnapshot, @ModuleInfo)
            Repeat
               Protected moduleName$=PeekS(@ModuleInfo\szModule, -1, #PB_Ascii)
               If moduleName$=ModuleName
                  ProcedureReturn ModuleInfo\modBaseSize
               EndIf
            Until Not Module32Next_(hSnapshot, @ModuleInfo)
         EndIf
         CloseHandle_(hSnapshot)
      EndIf
   EndIf
   ProcedureReturn -1
EndProcedure
 
;----Read----;

Procedure.l RPM(p.l, addr.l)
  Protected itr.i
  If addr <> 0
    ReadProcessMemory_(p, addr.l, @itr, SizeOf(itr), 0)
    ProcedureReturn itr
  EndIf
EndProcedure

Procedure.b RPM_Byte(p.l, addr.l)
  Protected itr.b
  If addr <> 0
    ReadProcessMemory_(p, addr.l, @itr, SizeOf(itr), 0)
    ProcedureReturn itr
  EndIf
EndProcedure

Procedure.c RPM_Char(p.l, addr.l)
  Protected ctr.c
  If addr <> 0
    ReadProcessMemory_(p, addr.l, @ctr, SizeOf(ctr), 0)
    ProcedureReturn ctr
  EndIf
EndProcedure

Procedure.w RPM_Word(p.l, addr.l)
  Protected wtr.w
  If addr <> 0
    ReadProcessMemory_(p, addr.l, @wtr, SizeOf(wtr), 0)
    ProcedureReturn wtr
  EndIf
EndProcedure

Procedure.f RPM_Float(p.l, addr.l)
  Protected ftr.f
  If addr <> 0
    ReadProcessMemory_(p, addr.l, @ftr, SizeOf(ftr), 0)
    ProcedureReturn ftr
  EndIf
EndProcedure

Procedure.s RPM_String(p.l, addr.l, len.l)
  Protected str.s=Space(len.l)
  If addr <> 0
    ReadProcessMemory_(p, addr.l, @str, len+1, 0)
    ProcedureReturn str
  EndIf
EndProcedure

Procedure.s RPM_UnicodeString(p.l, addr.l, len.l)
  Protected *unicodebuffer=0
  Protected str.s=Space(len.l)
  If addr <> 0
    *unicodebuffer=AllocateMemory(len*2)
    ReadProcessMemory_(p, addr.l, *unicodebuffer, len*2, 0)
    str=PeekS(*unicodebuffer, len*2, #PB_Unicode)  
    FreeMemory(*unicodebuffer)
    ProcedureReturn str
  EndIf
EndProcedure

;----Write----;

Procedure.l WPM(p.l, addr.l, value.l)
  If addr <> 0
    ProcedureReturn WriteProcessMemory_(p, addr.l, @value, SizeOf(value), 0)
  EndIf
EndProcedure

Procedure.l WPM_Word(p.l, addr.l, value.w)
  If addr <> 0
    ProcedureReturn WriteProcessMemory_(p, addr.l, @value, SizeOf(value), 0)
  EndIf
EndProcedure

Procedure.l WPM_Float(p.l, addr.l, value.f)
  If addr <> 0
    ProcedureReturn WriteProcessMemory_(p, addr.l, @value, SizeOf(value), 0)
  EndIf
EndProcedure

Procedure.l WPM_String(p.l, addr.l, value.s)
  If addr <> 0
    ProcedureReturn WriteProcessMemory_(p, addr.l, @value, Len(value)+1, 0)
  EndIf
EndProcedure

Procedure.l WPM_Byte(p.l, addr.l, value.b)
  If addr <> 0
    ProcedureReturn WriteProcessMemory_(p, addr.l, @value, SizeOf(value), 0)
  EndIf
EndProcedure

;----LoadLibraryDLLInjection----;

Procedure InjectDll(ProcessName.s, DLLPath.s)
Protected hProc.i
Protected LoadLibraryAddress.i
Protected virtualParameter.i
Protected hThread.i

hProc=OpenProcess_(#PROCESS_ALL_ACCESS, 0, GetProcessID(ProcessName))
LoadLibraryAddress=GetFunction(kernel32, "LoadLibraryA")
virtualParameter=VirtualAllocEx_(hProc, 0, Len(DLLPath), #MEM_RESERVE | #MEM_COMMIT, #PAGE_READWRITE)
WriteProcessMemory_(hProc, virtualParameter, @DLLPath, Len(DLLPath), 0)
hThread=CreateRemoteThread_(hProc, 0, 0, LoadLibraryAddress, virtualParameter, 0, 0)
WaitForSingleObject_(hThread, -1)
CloseHandle_(hThread)
CloseHandle_(hProc)
ProcedureReturn 1
EndProcedure

;----SignatureScanning----;

Procedure HextoByte(HexValue.s)
  Protected temp.i
  temp=Val("$" + HexValue)
  If temp > 127
    ProcedureReturn temp - 256
  Else
    ProcedureReturn temp
  EndIf
EndProcedure

Procedure compareData(Array ModuleData.b(1), currentOffset.i, Array Sig.b(1), Array Mask.b(1))
  Protected x.i
  For x=0 To ArraySize(Sig())
    If Mask(x) And Not (Sig(x) = ModuleData(currentOffset+x))
      ProcedureReturn 0
    EndIf
  Next x
  ProcedureReturn 1
EndProcedure

Procedure.l ScanSignature(ProcessHandle.l, ProcessID.i, ModuleName.s, Extra.i, Offset.i, Signature.s, fRead=1, fSubtract.i=1)
  Protected x.i
  Protected moduleBase.i
  Protected maxScanOffset.i
  Protected Sigsize=CountString(Signature, " ")+1
  
  Dim sig.b(Sigsize-1)
  Dim mask.b(Sigsize-1)
  
  For x=0 To Sigsize-1
    sig(x)=HextoByte(StringField(ReplaceString(Signature, "?", "00"), x+1, " "))
    If StringField(Signature, x+1, " ") = "?"
      mask(x)=0
    Else
      mask(x)=1
    EndIf
  Next x 
  
  moduleBase = GetModuleBase(ProcessID, ModuleName)
  maxScanOffset = GetModuleSize(ProcessID, ModuleName) - Sigsize
  
  Dim ModuleData.b(maxScanOffset + Sigsize - 1)
  ReadProcessMemory_(ProcessHandle, moduleBase, @ModuleData(), maxScanOffset + Sigsize, 0)
  
  For x=0 To maxScanOffset
    If compareData(ModuleData(), x, sig(), mask())
      x + moduleBase + Extra
      If fRead
        x = RPM(ProcessHandle, x)
      EndIf
      If fSubtract
        x - moduleBase
      EndIf
      x + Offset
      ProcedureReturn x
    EndIf
  Next x
  ProcedureReturn -1
EndProcedure

EndModule

; IDE Options = PureBasic 5.43 LTS (Windows - x86)
; CursorPosition = 1
; Folding = ----
; EnableXP