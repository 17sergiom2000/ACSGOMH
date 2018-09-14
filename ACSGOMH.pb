;-by Alexander Pfefferle | github.com/pf3ff3rl3 | gitlab.com/pf3ff3rl3


InitNetwork()
InitSprite()

ExamineDesktops()
Global MainDesktop_Screen_Width=DesktopWidth(0)
Global MainDesktop_Screen_Height=DesktopHeight(0)

Procedure.s URLtoString(URL.s)
  Protected textbuffer.s
  Protected *buffer=ReceiveHTTPMemory(Url.s)
  If *buffer<>0
    textbuffer = PeekS(*buffer, MemorySize(*buffer), #PB_Ascii)
    FreeMemory(*buffer)
  EndIf
  ProcedureReturn textbuffer
EndProcedure

Global CheatName.s="ACSGOMH"

Global hiddenmode=0


XIncludeFile "ATPMemory.pbi"
XIncludeFile "BSPParser.pb"
XIncludeFile "GUI\ACSGOMH_LoadingScreen.pbf"
XIncludeFile "GUI\ACSGOMH_KeyBinds.pbf"
XIncludeFile "GUI\ACSGOMH_ColorSelection.pbf"
XIncludeFile "GUI\ACSGOMH_MainGUI.pbf"


Global ACSGOMHParameter$=ProgramParameter(0)
If ACSGOMHParameter$="/hidden"
  hiddenmode=1
EndIf


#GitHubURL$="https://github.com/pf3ff3rl3/ACSGOMH"
#SigCloudURL$="https://raw.githubusercontent.com/pf3ff3rl3/ACSGOMH/master/Web/Signatures.txt"
#WebRadarBluePrint="https://raw.githubusercontent.com/pf3ff3rl3/ACSGOMH/master/Web/WebRadarBluePrint.txt"

Global AndroidServerSocket.i


Procedure.f fcalc3DVectorMagnitude(xvec.f,yvec.f,zvec.f)
  ProcedureReturn Sqr((xvec*xvec)+(yvec*yvec)+(zvec*zvec))
EndProcedure
Procedure.f fcalc2DVectorMagnitude(xvec.f,yvec.f)
  ProcedureReturn fcalc3DVectorMagnitude(xvec, yvec, 0)
EndProcedure
Procedure.f GetDistance3Dto1D(FirstVecX.f,FirstVecY.f,FirstVecZ.f,SecondVecX.f,SecondVecY.f,SecondVecZ.f)
   Protected diffVecX.f=Abs(FirstVecX-SecondVecX)
   Protected diffVecY.f=Abs(FirstVecY-SecondVecY)
   Protected diffVecZ.f=Abs(FirstVecZ-SecondVecZ)
   ProcedureReturn Sqr((diffVecX*diffVecX)+(diffVecY*diffVecY)+(diffVecZ*diffVecZ))
EndProcedure

Procedure FixAngles(*pitch.Float, *yaw.Float)
  If *pitch\f>89 And  *pitch\f<181
    *pitch\f=89
  EndIf
  If *pitch\f>180
    *pitch\f=*pitch\f-360
  EndIf 
  If *pitch\f < -89
    *pitch\f=-89
  EndIf
  If *yaw\f>180
    *yaw\f=*yaw\f-360
  EndIf
  If *yaw\f<-180
    *yaw\f=*yaw\f+360
  EndIf
EndProcedure

Procedure FixAnglesArray(Array angles.f(1))
  FixAngles(@angles(0), @angles(1))
EndProcedure

Global Offset_ClientCMD = 0
Global Offset_BaseLocalPlayerCMO = 0
Global Offset_EnginePointer = 0
Global Offset_EntityBase = 0
Global Offset_glowObjectManager = 0
Global Offset_PlayerResourcePointer = 0
Global Offset_RadarBasePtr = 0
Global Offset_ForceJump = 0
Global Offset_ForceAttack = 0
Global Offset_Input = 0
Global Offset_bSendPacket = 0
Global Offset_ViewMatrix = 0
Global Offset_SteamID = 0
Global Offset_m_LocalPlayerIndex = 0
Global Offset_ViewAngles = 0
Global Offset_GameDir = 0


Global processId = ATPMemory::GetProcessID("csgo.exe")
Global hProc = ATPMemory::ATPMemory("csgo.exe")

If processId=0
  MessageRequester(CheatName, "Run CS:GO first!")
  End
EndIf

If hProc = 0
  MessageRequester(CheatName, "Cant open a handle to CS:GO!")
  End
EndIf

;------NetVars-----------
XIncludeFile "NetVarManager.pb"
GetNetVars()
;------NetVars-----------



Global ServerModuleBase=ATPMemory::GetModuleBase(processId,"server.dll")
Global ClientModuleBase=ATPMemory::GetModuleBase(processId,"client_panorama.dll")
Global EngineModuleBase=ATPMemory::GetModuleBase(processId,"engine.dll")

Global Offset_m_iCompetitiveRanking     = NetVars("DT_CSPlayerResource->m_iCompetitiveRanking")
Global Offset_m_iCompetitiveWins        = NetVars("DT_CSPlayerResource->m_iCompetitiveWins")
Global Offset_m_iHealth                 = NetVars("DT_CSPlayer->m_iHealth")
Global Offset_m_fFlags                  = NetVars("DT_CSPlayer->m_fFlags")
Global Offset_m_iCrossHairID            = NetVars("DT_CSPlayer->m_bHasDefuser")+$5C
Global Offset_m_iTeamNum                = NetVars("DT_CSPlayer->m_iTeamNum")
Global Offset_m_iShotsFired             = NetVars("DT_CSPlayer->m_iShotsFired")
Global Offset_m_iFov                    = NetVars("DT_CSPlayer->m_iFOV")
Global Offset_m_bSpotted                = NetVars("DT_CSPlayer->m_bSpotted")
Global Offset_m_bSpottedbyMask          = NetVars("DT_CSPlayer->m_bSpottedByMask")
Global Offset_m_vecOrigin               = NetVars("DT_CSPlayer->m_vecOrigin")
Global Offset_m_vecViewOffset           = NetVars("DT_CSPlayer->m_vecViewOffset[0]")
Global Offset_m_aimPunchAngle           = NetVars("DT_CSPlayer->m_aimPunchAngle")
Global Offset_m_flFlashMaxAlpha         = NetVars("DT_CSPlayer->m_flFlashMaxAlpha")
Global Offset_m_flFlashDuration         = NetVars("DT_CSPlayer->m_flFlashDuration")
Global Offset_glowIndex                 = NetVars("DT_CSPlayer->m_flFlashDuration")+$18
Global Offset_m_szLastPlaceName         = NetVars("DT_CSPlayer->m_szLastPlaceName")
Global Offset_BoneMatrix                = NetVars("DT_BaseAnimating->m_nForceBone")+$1C
Global offset_m_vecVelocity             = NetVars("DT_FuncMoveLinear->m_vecVelocity")
 ;-----------SkinChanger----------
Global Offset_hActiveWeapon             = NetVars("DT_CSPlayer->m_hActiveWeapon")
Global Offset_hMyWeapon                 = NetVars("DT_CSPlayer->m_hMyWeapons")
Global Offset_m_iItemDefinitionIndex    = NetVars("DT_BaseAttributableItem->m_iItemDefinitionIndex")
Global Offset_m_iAccountID              = NetVars("DT_BaseAttributableItem->m_iAccountID")
Global Offset_m_OriginalOwnerXuidLow    = NetVars("DT_BaseAttributableItem->m_OriginalOwnerXuidLow")
Global Offset_m_iItemIDHigh             = NetVars("DT_BaseAttributableItem->m_iItemIDHigh")
Global Offset_m_iItemIDLow              = NetVars("DT_BaseAttributableItem->m_iItemIDLow")
Global Offset_m_nFallbackPaintKit       = NetVars("DT_BaseAttributableItem->m_nFallbackPaintKit")
Global Offset_m_nFallbackSeed           = NetVars("DT_BaseAttributableItem->m_nFallbackSeed")
Global Offset_m_flFallbackWear          = NetVars("DT_BaseAttributableItem->m_flFallbackWear")
Global Offset_m_nFallbackStatTrak       = NetVars("DT_BaseAttributableItem->m_nFallbackStatTrak")
Global Offset_m_szCustomName            = NetVars("DT_BaseAttributableItem->m_szCustomName")
Global Offset_m_nModelIndex             = NetVars("DT_BaseAttributableItem->m_nModelIndex")
;-----------SkinChanger-----------
;-----------KnifeChanger-----------
Global Offset_m_iEntityQuality          = NetVars("DT_BaseAttributableItem->m_iEntityQuality")
Global Offset_m_iWorldModelIndex        = NetVars("DT_BaseCombatWeapon->m_iWorldModelIndex")
Global Offset_m_iViewModelIndex         = NetVars("DT_BaseCombatWeapon->m_iViewModelIndex")
Global Offset_m_iWorldDroppedModelIndex = NetVars("DT_BaseCombatWeapon->m_iWorldDroppedModelIndex")
Global Offset_m_iClip1                  = NetVars("DT_BaseCombatWeapon->m_iClip1")
Global Offset_m_hViewModel              = $32DC;
;-----------KnifeChanger-----------
;-----------NetChannel-------------
Global Offset_m_NetChannel = $94;
Global Offset_m_nOutSequenceNum = $18;
;-----------NetChannel-------------
Global Offset_m_MapName = $28C     ;
Global Offset_bDormant=$E9
Global Offset_EntityLoopDistance=$10
Global Offset_RadarStructPtr=$6C
Global Offset_RadarEntityLoopDistance=$168


Global glowpointer=0
Global RadarStructBase=0;
Global LocalPlayerState=0
Global LocalPlayerBase=0


Procedure.s GetApiKeyfromFile()
  Protected apikey$
  Protected x.i
  ReadFile(0, GetEnvironmentVariable("appdata")+"\TS3Client\clientquery.ini")
  For x=0 To 2
    ReadString(0, #PB_Ascii)
  Next x
  apikey$=StringField(ReadString(0, #PB_Ascii), 2, "api_key=")
  CloseFile(0)
  ProcedureReturn apikey$
EndProcedure

Procedure.s GetTS3AuthenticationKey()
  Protected key.s
  key=GetApiKeyfromFile()
  If Len(key) = 29 : ProcedureReturn key : EndIf
EndProcedure

Procedure.s SendString(CQ_Connection.i, tlntmsg.s)
  SendNetworkString(CQ_Connection.i, tlntmsg + #CRLF$)
EndProcedure

Procedure AuthenticateConnection(CQ_Connection.i)
  SendString(CQ_Connection, "auth apikey=" + GetTS3AuthenticationKey())
EndProcedure

Procedure.s ReceiveString(CQ_Connection.i)
  Protected *recvbuffer=AllocateMemory(65536)
  Protected receivedData.s
    ReceiveNetworkData(CQ_Connection, *recvbuffer, 65536)
    receivedData = PeekS(*recvbuffer, 65536, #PB_Ascii)
  ProcedureReturn receivedData
EndProcedure

Procedure TS3TexToSpeech(text.s)
  Protected cid=OpenNetworkConnection("127.0.0.1", 25639)
  If cid<>0
    AuthenticateConnection(cid)
  EndIf
  Delay(1)
  SendString(cid, "sendtextmessage targetmode=1 target=1 msg=!say\s" + ReplaceString(text, " ", "\s"))
EndProcedure

Global LocalAccSteamID.s

Global ACSGOMH_GUI_OnTop=0

Global AndroidControllerState=0
Global CurrentClient.s="No Client connected!"
Global VibratorESP=0
Global RemoteRadar=0
Global AndroidInformationUpdateProtocollIntervall=300

Global SkinChangerState=0
Global RadarState=0
Global TriggerState=0
Global AntiFlashState=0
Global GlowState=0
Global ExternalChamsState=0
Global TeamCheckState=0
Global HealthBased=0
Global WH_highlight_vulnerable=0
Global AimbotState=0
Global AntiAimState=0
Global BunnyHopState=0
Global TS3CalloutState=0
Global TS3TTSCalloutState=0
Global ChatSpamState=0
Global FOVChangerState=0
Global FOVChangerFOVvalue=90
Global NoHandsState=0
Global Glow_WeaponESP=0
Global Glow_GrenadeESP=0
Global Glow_BombESP=0
Global Glow_ChickenESP=0
Global KnifeChangerState=0
Global currentKnifeModelIndex=4
Global AutoForceFullUpdate=0
Global FakeLagState=0
Global FakeLagOnDelay=0
Global FakeLagOffDelay=0
Global ChatSpam_Mode=0
Global ChatSpam_TargetChatMode=0
Global ACSGOMH_3DViewerState=0
Global SyncWithCSGOTickRate=0
Global WebRadarState=0
Global ZeusTriggerState=0

Global SilentAimMode=0

;------------Keybinds------------
Procedure.i GetNextPushedKeyID()
  Protected x.i
  Repeat
    For x=0 To 256
      If GetAsyncKeyState_(x)&$8000
        ProcedureReturn x
      EndIf
    Next x
  ForEver
EndProcedure

Global KeyBind_ToggleExternalChams=#VK_4
Global KeyBind_ToggleRadar=#VK_5
Global KeyBind_ToggleBhop=#VK_6
Global KeyBind_ToggleTriggerbot=#VK_7
Global KeyBind_ToggleAimbot=#VK_NUMPAD0
Global KeyBind_ToggleAntiFlash=#VK_8
Global KeyBind_ToggleGlowESP=#VK_9
Global KeyBind_ToggleAntiAim=#VK_8
Global KeyBind_ToggleSkinChanger=#VK_NUMPAD7
Global KeyBind_ToggleChatSpam=#VK_RCONTROL
Global KeyBind_ToggleAndroidController=#VK_RMENU

Global KeyBind_ForceUpdate=#VK_LMENU
Global KeyBind_AimKey=#VK_LBUTTON
Global KeyBind_TriggerKey=0
;------------Keybinds------------
;-------------Colors-------------
Global Color_Vulnerable=RGB(255, 255, 255)
Global Color_Glow_Weapon=RGB(210, 40, 220)
Global Color_Glow_Bomb=RGB(250, 50, 50)
Global Color_Glow_Chicken=RGB(250, 250, 50)
Global Color_Glow_Grenade=RGB(50, 50, 250)
;-------------Colors-------------
;----------ColorSelectionButtonImages----------
Procedure UpdateImageColor(Image.i, Color.i)
  StartDrawing(ImageOutput(Image))
  Box(0, 0, 40, 20, Color)
  StopDrawing()
EndProcedure

Procedure AdjustButtonImage(Image.i)
  Protected updatedColor.i=ColorRequester()
  UpdateImageColor(Image, updatedColor)
  ProcedureReturn updatedColor
EndProcedure

Global ACSGOMH_Colors_Image_Weapon=0
Global ACSGOMH_Colors_Image_Grenade=1
Global ACSGOMH_Colors_Image_Bomb=2
Global ACSGOMH_Colors_Image_Chicken=3
Global ACSGOMH_Colors_Image_Vulnerable=4

CreateImage(ACSGOMH_Colors_Image_Weapon, 40, 20, 24, Color_Glow_Weapon)
CreateImage(ACSGOMH_Colors_Image_Grenade, 40, 20, 24, Color_Glow_Grenade)
CreateImage(ACSGOMH_Colors_Image_Bomb, 40, 20, 24, Color_Glow_Bomb)
CreateImage(ACSGOMH_Colors_Image_Chicken, 40, 20, 24, Color_Glow_Chicken)
CreateImage(ACSGOMH_Colors_Image_Vulnerable, 40, 20, 24, Color_Vulnerable)
;----------ColorSelectionButtonImages----------


Global Dim Aimbot_enabled(65)
Global Dim Aimbot_TargetBone(65)
Global Dim Aimbot_SmoothingType(65)
Global Dim Aimbot_AimKey(65)
Global Dim Aimbot_FriendlyFire(65)
Global Dim Aimbot_VisibilityCheck(65)
Global Dim Aimbot_SmoothFac.f(65)
Global Dim Aimbot_FOVBased(65)
Global Dim Aimbot_maxFOV.f(65)
Global Dim Aimbot_SilentAimState(65)
Global Dim Triggerbot_enabled(65)
Global Dim Triggerbot_Burst(65)
Global Dim Triggerbot_Delay(65)

Global Dim ViewMatrix.f(16)

Global Aimbot_SelectedWeapon=0
Global Triggerbot_SelectedWeapon=0
Global SkinChanger_SelectedWeapon=0

Global oldActiveWeapon=0

Global KeybindHandlerState=0

Global AndroidControllerThread=0
Global receivedHandlerThreadID=0

Global WebRadarThread=0
Global WebServerID=0

Global TS3CalloutThread=0
Global TS3TTSCalloutThread=0
Global ChatSpamThread=0
Global FakeLagThread=0

Global Dim TargetModes.s(8)

TargetModes(0)="Distance"
TargetModes(1)="FOV"

Global Dim SmoothingTypes.s(1)

SmoothingTypes(0)="Linear SF"
SmoothingTypes(1)="Logarithmic SF"

Global Dim Bones.s(8)

Bones(0)="PELVIS"
Bones(1)="LEAN_ROOT"
Bones(2)="CAM_DRIVER"
Bones(3)="LOWER_BODY"
Bones(4)="CROTCH"
Bones(5)="STOMACH"
Bones(6)="CHEST"
Bones(7)="NECK"
Bones(8)="HEAD"

Global Dim WeaponList.s(523)

WeaponList(1)="Deagle"
WeaponList(2)="Dual Berretas"
WeaponList(3)="Five-SeveN"
WeaponList(4)="Glock"
WeaponList(5)="P228"
WeaponList(6)="USP"
WeaponList(7)="Ak-47"
WeaponList(8)="Aug"
WeaponList(9)="AWP"
WeaponList(10)="Famas"
WeaponList(11)="G3SG1"
WeaponList(12)="Galil"
WeaponList(13)="Galil AR"
WeaponList(14)="M249"
WeaponList(15)="M3"
WeaponList(16)="M4A4"
WeaponList(17)="MAC-10"
WeaponList(18)="MP5Navy"
WeaponList(19)="P90"
WeaponList(20)="Scout"
WeaponList(21)="SG550"
WeaponList(22)="SG552"
WeaponList(23)="MP5-SD"
WeaponList(24)="UMP-45"
WeaponList(25)="XM1014"
WeaponList(26)="PP-Bizon"
WeaponList(27)="Mag-7"
WeaponList(28)="Negev"
WeaponList(29)="Sawed-Off"
WeaponList(30)="Tec-9"
WeaponList(31)="Taser"
WeaponList(32)="P2000"
WeaponList(33)="MP7"
WeaponList(34)="MP9"
WeaponList(35)="Nova"
WeaponList(36)="P250"
WeaponList(37)="Scar-17"
WeaponList(38)="Scar-20"
WeaponList(39)="SG553"
WeaponList(40)="SSG08"
WeaponList(42)="Default-CT-Knife"
WeaponList(43)="Flashbang"
WeaponList(44)="HE-Grenade"
WeaponList(45)="Smoke-Grenade"
WeaponList(46)="Molotov"
WeaponList(47)="Decoy"
WeaponList(48)="Incendiary"
WeaponList(49)="C4"
WeaponList(59)="Default-T-Knife"
WeaponList(60)="M4A1-S"
WeaponList(61)="USP-S"
WeaponList(63)="CZ-75"
WeaponList(64)="R8"
WeaponList(500)="Bayonet"
WeaponList(505)="Flip-Knife"
WeaponList(506)="Gut-Knife"
WeaponList(507)="Karambit"
WeaponList(508)="M9-Bayonet"
WeaponList(509)="Huntsman-Knife"
WeaponList(512)="Falchion-Knife"
WeaponList(514)="Bowie-Knife"
WeaponList(515)="Butterfly-Knife"
WeaponList(516)="Shadow-Daggers"
WeaponList(519)="Ursus-Knife"
WeaponList(520)="Navaja-Knife"
WeaponList(522)="Stiletto-Knife"
WeaponList(523)="Talon-Knife"

Global Dim WeaponSelectList.s(48)

WeaponSelectList(1)="Deagle"
WeaponSelectList(2)="Dual Berretas"
WeaponSelectList(3)="Five-SeveN"
WeaponSelectList(4)="Glock"
WeaponSelectList(5)="Ak-47"
WeaponSelectList(6)="Aug"
WeaponSelectList(7)="AWP"
WeaponSelectList(8)="Famas"
WeaponSelectList(9)="G3SG1"
WeaponSelectList(10)="Galil AR"
WeaponSelectList(11)="M249"
WeaponSelectList(12)="M4A4"
WeaponSelectList(13)="MAC-10"
WeaponSelectList(14)="P90"
WeaponSelectList(15)="MP5-SD"
WeaponSelectList(16)="UMP-45"
WeaponSelectList(17)="XM1014"
WeaponSelectList(18)="PP-Bizon"
WeaponSelectList(19)="Mag-7"
WeaponSelectList(20)="Negev"
WeaponSelectList(21)="Sawed-Off"
WeaponSelectList(22)="Tec-9"
WeaponSelectList(23)="P2000"
WeaponSelectList(24)="MP7"
WeaponSelectList(25)="MP9"
WeaponSelectList(26)="Nova"
WeaponSelectList(27)="P250"
WeaponSelectList(28)="Scar-20"
WeaponSelectList(29)="SG553"
WeaponSelectList(30)="SSG08"
WeaponSelectList(31)="M4A1-S"
WeaponSelectList(32)="USP-S"
WeaponSelectList(33)="CZ-75"
WeaponSelectList(34)="R8"
WeaponSelectList(35)="Bayonet"
WeaponSelectList(36)="Flip-Knife"
WeaponSelectList(37)="Gut-Knife"
WeaponSelectList(38)="Karambit"
WeaponSelectList(39)="M9-Bayonet"
WeaponSelectList(40)="Huntsman-Knife"
WeaponSelectList(41)="Falchion-Knife"
WeaponSelectList(42)="Bowie-Knife"
WeaponSelectList(43)="Butterfly-Knife"
WeaponSelectList(44)="Shadow-Daggers"
WeaponSelectList(45)="Ursus-Knife"
WeaponSelectList(46)="Navaja-Knife"
WeaponSelectList(47)="Stiletto-Knife"
WeaponSelectList(48)="Talon-Knife"

Global Dim MatchList.i(48)

Procedure FillMatchList()
  Protected i.i, x.i
  For i=1 To 48
    For x=1 To 64
      If WeaponList(x) = WeaponSelectList(i) : MatchList(i)=x : EndIf
    Next x
  
    For x=500 To 523
      If WeaponList(x) = WeaponSelectList(i) : MatchList(i)=x : EndIf
    Next x
  Next i
EndProcedure

FillMatchList()

Procedure getWeaponListIndexbySelectedWeaponListIndex(SelectedWeaponIndex.i)
  ProcedureReturn MatchList(SelectedWeaponIndex)
EndProcedure

Global Dim KnifeIndizes.i(14)

KnifeIndizes(1)=500
KnifeIndizes(2)=505
KnifeIndizes(3)=506
KnifeIndizes(4)=507
KnifeIndizes(5)=508
KnifeIndizes(6)=509
KnifeIndizes(7)=512
KnifeIndizes(8)=514
KnifeIndizes(9)=515
KnifeIndizes(10)=516
KnifeIndizes(11)=519
KnifeIndizes(12)=520
KnifeIndizes(13)=522
KnifeIndizes(14)=523

Global Dim KnifeList.s(14)

KnifeList(0)=""
KnifeList(1)="Bayonet"
KnifeList(2)="Flip-Knife"
KnifeList(3)="Gut-Knife"
KnifeList(4)="Karambit"
KnifeList(5)="M9-Bayonet"
KnifeList(6)="Huntsman-Knife"
KnifeList(7)="Falchion-Knife"
KnifeList(8)="Bowie-Knife"
KnifeList(9)="Butterfly-Knife"
KnifeList(10)="Shadow-Daggers"
KnifeList(11)="[B]Ursus-Knife"
KnifeList(12)="[B]Navaja-Knife"
KnifeList(13)="[B]Stiletto-Knife"
KnifeList(14)="[B]Talon-Knife"

Global Dim Ranks.s(18)

Ranks(0)="Undefined"
Ranks(1)="Silver I"
Ranks(2)="Silver II"
Ranks(3)="Silver III"
Ranks(4)="Silver IV"
Ranks(5)="Silver Elite"
Ranks(6)="Silver Elite Meister"
Ranks(7)="Gold Nova I"
Ranks(8)="Gold Nova II"
Ranks(9)="Gold Nova III"
Ranks(10)="Gold Nova Master"
Ranks(11)="Master Guardian I"
Ranks(12)="Master Guardian II"
Ranks(13)="Master Guardian Elite"
Ranks(14)="Distinguished Master Guardian"
Ranks(15)="Legendary Eagle"
Ranks(16)="Legendary Eagle Master"
Ranks(17)="Supreme Master First Class"
Ranks(18)="The Global Elite"

Global Dim ChatSpamModi.s(1)

ChatSpamModi(0)="Advertisement"
ChatSpamModi(1)="Callout/Info"

Global GameDirectory.s=""
Global currentMapName.s=""

;I would prefer to use a Vector3D-structure instead of all those float arrays, but nested structures kinda suck in PB

Structure LocalPlayerInfo
  indexNum.i
  team.i
  health.i
  fFlags.i
  velocity.f
  pos.f[3]
  velocityvec.f[3]
  vecView.f[3]
  viewangles.f[3]
  activeWeaponID.i
EndStructure

Structure EntityInfo
  EntityBase.i
  BoneMatrix.i
  glowIndex.i
  health.i
  team.i
  dormant.b
  spotted.b
  spottedbyMask.i
  fFlags.i
  pos.f[3]
  headpos.f[3]
  distance.f
  rank.i
  wins.i
  lastplacename.s
  fovdistance.f
EndStructure

Structure SkinData
  pkit.i
  seed.i
  wear.f
  stattrak.i
  name.s
EndStructure

Structure ClientCMD_Unrestricted
  command.s{200}
  delay.b
EndStructure

Structure UserCMD
  pVft.i
  m_iCmdTickNumber.i
  m_iTickCount.i
  m_vecViewAngles.f[3]
  m_vecAimDirection.f[3]
  m_flForwardmove.f
  m_flSidemove.f
  m_flUpmove.f
  m_iButtons.i
  m_bImpulse.i
  padding.c[3]
  m_iWeaponSelect.i
  m_iWeaponSubtyp.i
  m_iRandomSeed.i
  m_siMouseDx.i
  m_siMouseDy.i
  m_bHasBeenPredicted.b
  padding2.c[27]
EndStructure

Global RadarWidth.i=512
Global RadarHeight.i=512

Structure MapOverview
  pos_x.f
  pos_y.f
  scale.f
EndStructure

Global NewMap MapData.MapOverview()

Procedure.i GetXPosonRemoteRadarbyXPosinWorld(XPosinWorld.i)
	ProcedureReturn (XPosinWorld+MapData(currentMapName)\pos_x*-1)/(1024*MapData(currentMapName)\scale/RadarWidth)
EndProcedure
Procedure.i GetYPosonRemoteRadarbyYPosinWorld(YPosinWorld.i)
	ProcedureReturn Abs(RadarHeight-((YPosinWorld+1024*MapData(currentMapName)\scale-MapData(currentMapName)\pos_y)/(1024*MapData(currentMapName)\scale/RadarHeight)))
EndProcedure

Global LocalPlayerData.LocalPlayerInfo
Global Dim Entities.EntityInfo(31)
Global Dim WeaponSkins.SkinData(523)
Global FOVTarget.i
Global DistanceTarget.i


Procedure IsWeaponIDValid(AWeaponID.i)
	If (AWeaponID = 0) Or ((AWeaponID > 40) And (AWeaponID < 60 Or AWeaponID > 65))
		ProcedureReturn 0	
	Else
		ProcedureReturn 1
	EndIf
EndProcedure

Procedure Set_ACSGOMH_KeyBinds_GUI_Window_Settings()
  SetGadgetText(ACSGOMH_Keybinds_Buttons_AimKey, Str(KeyBind_AimKey))
  SetGadgetText(ACSGOMH_Keybinds_Buttons_TriggerKey, Str(KeyBind_TriggerKey))
  SetGadgetText(ACSGOMH_Keybinds_Buttons_Radar, Str(KeyBind_ToggleRadar))
  SetGadgetText(ACSGOMH_Keybinds_Buttons_AntiFlash, Str(KeyBind_ToggleAntiFlash))
  SetGadgetText(ACSGOMH_Keybinds_Buttons_SkinChanger, Str(KeyBind_ToggleSkinChanger))
  SetGadgetText(ACSGOMH_Keybinds_Buttons_Triggerbot, Str(KeyBind_ToggleTriggerbot))
  SetGadgetText(ACSGOMH_Keybinds_Buttons_Aimbot, Str(KeyBind_ToggleAimbot))
  SetGadgetText(ACSGOMH_Keybinds_Buttons_ChatSpam, Str(KeyBind_ToggleChatSpam))
  SetGadgetText(ACSGOMH_Keybinds_Buttons_AndroidController, Str(KeyBind_ToggleAndroidController))
  SetGadgetText(ACSGOMH_Keybinds_Buttons_Wallhack, Str(KeyBind_ToggleGlowESP))
  SetGadgetText(ACSGOMH_Keybinds_Buttons_ExternalChams, Str(KeyBind_ToggleExternalChams))
  SetGadgetText(ACSGOMH_Keybinds_Buttons_BunnyHop, Str(KeyBind_ToggleBhop))
  SetGadgetText(ACSGOMH_Keybinds_Buttons_AntiAim, Str(KeyBind_ToggleAntiAim))
  SetGadgetText(ACSGOMH_Keybinds_Buttons_ForceUpdate, Str(KeyBind_ForceUpdate))
EndProcedure

Procedure Set_ACSGOMH_Colors_GUI_Window_Settings()
  UpdateImageColor(ACSGOMH_Colors_Image_Vulnerable, Color_Vulnerable)
  UpdateImageColor(ACSGOMH_Colors_Image_Bomb, Color_Glow_Bomb)
  UpdateImageColor(ACSGOMH_Colors_Image_Chicken, Color_Glow_Chicken)
  UpdateImageColor(ACSGOMH_Colors_Image_Grenade, Color_Glow_Grenade)
  UpdateImageColor(ACSGOMH_Colors_Image_Weapon, Color_Glow_Weapon)
  SetGadgetAttribute(ACSGOMH_Colors_ButtonImage_Bomb, #PB_Button_Image, ImageID(ACSGOMH_Colors_Image_Bomb))
  SetGadgetAttribute(ACSGOMH_Colors_ButtonImage_Chicken, #PB_Button_Image, ImageID(ACSGOMH_Colors_Image_Chicken))
  SetGadgetAttribute(ACSGOMH_Colors_ButtonImage_Grenade, #PB_Button_Image, ImageID(ACSGOMH_Colors_Image_Grenade))
  SetGadgetAttribute(ACSGOMH_Colors_ButtonImage_Weapon, #PB_Button_Image, ImageID(ACSGOMH_Colors_Image_Weapon))
  SetGadgetAttribute(ACSGOMH_Colors_ButtonImage_Vulnerable, #PB_Button_Image, ImageID(ACSGOMH_Colors_Image_Vulnerable))
EndProcedure

Procedure Set_ACSGOMH_GUI_Window_Settings()
  SetGadgetState(ACSGOMH_GUISettings_Wallhack, GlowState)
  SetGadgetState(ACSGOMH_GUISettings_Wallhack_ExternalChams, ExternalChamsState)
  SetGadgetState(ACSGOMH_GUISettings_Wallhack_HealthESP, HealthBased)
  SetGadgetState(ACSGOMH_GUISettings_Wallhack_TeamESP, TeamCheckState)
  SetGadgetState(ACSGOMH_GUISettings_Wallhack_VulnerableESP, WH_highlight_vulnerable)
  SetGadgetState(ACSGOMH_GUISettings_Radarhack, RadarState)
  SetGadgetState(ACSGOMH_GUISettings_Antiflash, AntiFlashState)
  SetGadgetState(ACSGOMH_GUISettings_Triggerbot, TriggerState)
  SetGadgetState(ACSGOMH_GUISettings_ZeusTrigger, ZeusTriggerState)
  SetGadgetState(ACSGOMH_GUISettings_Bunnyhop, BunnyHopState)
  SetGadgetState(ACSGOMH_GUISettings_TS3Callout, TS3CalloutState)
  SetGadgetState(ACSGOMH_GUISettings_ChatSpam, ChatSpamState)
  SetGadgetState(ACSGOMH_GUISettings_AntiAim, AntiAimState)
  SetGadgetState(ACSGOMH_GUISettings_SkinChanger, SkinChangerState)
  SetGadgetState(ACSGOMH_GUISettings_KnifeChanger, KnifeChangerState)
  SetGadgetState(ACSGOMH_GUISettings_KnifeChanger_AutoForceUpdate, AutoForceFullUpdate)
  SetGadgetState(ACSGOMH_GUISettings_Aimbot, AimbotState)
  If IsWeaponIDValid(LocalPlayerData\activeWeaponID)
    SetGadgetState(ACSGOMH_GUISettings_Aimbot_OnAimKey, Aimbot_AimKey(LocalPlayerData\activeWeaponID))
    SetGadgetState(ACSGOMH_GUISettings_Aimbot_FOVBased, Aimbot_FOVBased(LocalPlayerData\activeWeaponID))
    SetGadgetState(ACSGOMH_GUISettings_Aimbot_SilentAim, Aimbot_SilentAimState(LocalPlayerData\activeWeaponID))
    SetGadgetState(ACSGOMH_GUISettings_Aimbot_VisibilityCheck, Aimbot_VisibilityCheck(LocalPlayerData\activeWeaponID))
    SetGadgetState(ACSGOMH_GUISettings_Aimbot_FriendlyFire, Aimbot_FriendlyFire(LocalPlayerData\activeWeaponID))
    SetGadgetState(ACSGOMH_GUISettings_Aimbot_SliderFOV, Aimbot_maxFov(LocalPlayerData\activeWeaponID))
    SetGadgetState(ACSGOMH_GUISettings_Aimbot_SliderLSF, Aimbot_SmoothFac(LocalPlayerData\activeWeaponID)*100)
    SetGadgetState(ACSGOMH_GUISettings_AimSettings_enableAimbot, Aimbot_enabled(LocalPlayerData\activeWeaponID))
    SetGadgetState(ACSGOMH_GUISettings_TriggerSettings_enableTriggerbot, Triggerbot_enabled(LocalPlayerData\activeWeaponID))
    SetGadgetState(ACSGOMH_GUISettings_Triggerbot_Burst, Triggerbot_Burst(LocalPlayerData\activeWeaponID))
    SetGadgetState(ACSGOMH_GUISettings_Triggerbot_SliderDelay, Triggerbot_Delay(LocalPlayerData\activeWeaponID))
  EndIf
  If ChatSpam_TargetChatMode=0
    SetGadgetState(ACSGOMH_GUISettings_ChatSpam_OptionGadget_All, 1)
  Else
    SetGadgetState(ACSGOMH_GUISettings_ChatSpam_OptionGadget_Team, 1)
  EndIf
  SetGadgetState(ACSGOMH_GUISettings_GlowESP_Bombs, Glow_BombESP)
  SetGadgetState(ACSGOMH_GUISettings_GlowESP_Chickens, Glow_ChickenESP)
  SetGadgetState(ACSGOMH_GUISettings_GlowESP_Grenades, Glow_GrenadeESP)
  SetGadgetState(ACSGOMH_GUISettings_GlowESP_Weapons, Glow_WeaponESP)
  SetGadgetState(ACSGOMH_GUISettings_NoHands, NoHandsState)
  SetGadgetState(ACSGOMH_GUISettings_FOVChanger_SliderFOV, FOVChangerFOVvalue)
  SetGadgetState(ACSGOMH_GUISettings_SyncTickRate, SyncWithCSGOTickRate)
  SetGadgetState(ACSGOMH_GUISettings_FakeLag, FakeLagState)
EndProcedure


Procedure toggled()
  If hiddenmode=0
  Set_ACSGOMH_GUI_Window_Settings()
  EndIf
EndProcedure


Procedure ClientCMD(command.s)
  Protected parameter.ClientCMD_Unrestricted
  parameter\command=command
  parameter\delay=0
  functionbaseaddress = EngineModuleBase+Offset_ClientCMD
  virtualParameter = VirtualAllocEx_(hProc, NULL, SizeOf(parameter), #MEM_RESERVE | #MEM_COMMIT, #PAGE_READWRITE)
  WriteProcessMemory_(hProc, virtualParameter, @parameter, SizeOf(parameter), 0)
  hThread = CreateRemoteThread_(hProc, 0, 0, functionbaseaddress, virtualParameter, 0, 0)
  WaitForSingleObject_(hThread, -1)
  VirtualFreeEx_(hProc, virtualParameter, SizeOf(parameter), #MEM_RELEASE)
  CloseHandle_(hThread)
EndProcedure

Procedure.s GetPlayerName(EntityIndex.i)
  ProcedureReturn ATPMemory::RPM_String(hProc, RadarStructBase+(EntityIndex+2)*Offset_RadarEntityLoopDistance+$18, 32)
EndProcedure

Procedure getWeaponEntitybyPlayerEntity(pEntityBase.i)
  ActiveWeaponHandle = ATPMemory::RPM(hProc, pEntityBase + Offset_hActiveWeapon)
  ProcedureReturn ATPMemory::RPM(hProc, ClientModuleBase + Offset_EntityBase + ((ActiveWeaponHandle&$fff)-1)*$10)
EndProcedure

Procedure getAmmoCountbyEntityBase(pEntityBase.i)
  ActiveWeaponEntity = getWeaponEntitybyPlayerEntity(pEntityBase)
  ProcedureReturn ATPMemory::RPM(hProc, ActiveWeaponEntity+Offset_m_iClip1)
EndProcedure

Procedure getAmmoCountofEntity(EntityIndex.i)
  ProcedureReturn getAmmoCountbyEntityBase(Entities(EntityIndex)\EntityBase)
EndProcedure

Procedure getAmmoCount()
  ProcedureReturn getAmmoCountbyEntityBase(LocalPlayerBase)
EndProcedure

Procedure getActiveWeaponIDbyEntityBase(pEntityBase.i)
  ActiveWeaponEntity = getWeaponEntitybyPlayerEntity(pEntityBase)
	ActiveWeaponID = ATPMemory::RPM_Word(hProc, ActiveWeaponEntity + Offset_m_iItemDefinitionIndex)
	ProcedureReturn ActiveWeaponID
EndProcedure

Procedure getActiveWeaponIDofEntity(EntityIndex.i)
  ProcedureReturn getActiveWeaponIDbyEntityBase(Entities(EntityIndex)\EntityBase)
EndProcedure

Procedure getActiveWeaponID()
  ProcedureReturn getActiveWeaponIDbyEntityBase(LocalPlayerBase)
EndProcedure

Procedure IsActiveWeaponValid()
	ActiveWeapon=getActiveWeaponID()
	If (ActiveWeapon = 0) Or ((ActiveWeapon > 40) And (ActiveWeapon < 60 Or ActiveWeapon > 65))
		ProcedureReturn 0
	Else
		ProcedureReturn 1
	EndIf
EndProcedure

Procedure getClassID(CEntityBase.i)
  ProcedureReturn ATPMemory::RPM(hProc, ATPMemory::RPM(hProc, ATPMemory::RPM(hProc, ATPMemory::RPM(hProc, CEntityBase + 8) + 8) + 1) + 20)
EndProcedure

Procedure isClassIDaGrenade(CClassID.i)
  If CClassID=8 Or CClassID=9 Or CClassID=13 Or CClassID=40 Or CClassID=41 Or CClassID=83 Or CClassID=86 Or CClassID=95 Or CClassID=126 Or CClassID=127 Or CClassID=130 Or CClassID=131 Or CClassID=132
    ProcedureReturn 1
  Else
    ProcedureReturn 0
  EndIf
EndProcedure

Procedure IsEnemyVulnerable(Enemy_EntityIndex.i)
  If ATPMemory::RPM_Float(hProc, Entities(Enemy_EntityIndex)\EntityBase+Offset_m_flFlashDuration) > 0 : ProcedureReturn 1 : EndIf
  If IsWeaponIDValid(getActiveWeaponIDofEntity(Enemy_EntityIndex)) = 0 : ProcedureReturn 1 : EndIf
  If getAmmoCountofEntity(Enemy_EntityIndex) = 0 : ProcedureReturn 1 : EndIf
  ProcedureReturn 0
EndProcedure

Procedure fCalcFOVdistance(EntityIndex.i)
  Dim fFOVdelta.d(2)
  Protected tpitch.f
  Protected tyaw.f
  Protected pitchdistance.f
  Protected yawdistance.f
  
  fFOVdelta(0)=LocalPlayerData\pos[0]-Entities(EntityIndex)\pos[0]
  fFOVdelta(1)=LocalPlayerData\pos[1]-Entities(EntityIndex)\pos[1]
  fFOVdelta(2)=LocalPlayerData\pos[2]-Entities(EntityIndex)\pos[2]
  tpitch=ATan(fFOVdelta(2)/(Sqr(fFOVdelta(0)*fFOVdelta(0)+fFOVdelta(1)*fFOVdelta(1))))*57.295779513082
  tyaw=ATan(fFOVdelta(1)/fFOVdelta(0))*57.295779513082
  If fFOVdelta(0)>= 0
    tyaw=tyaw+180
  EndIf
        
  FixAngles(@tpitch, @tyaw)
  
  pitchdistance=LocalPlayerData\viewangles[0]-tpitch
  yawdistance=LocalPlayerData\viewangles[1]-tyaw
  
  If yawdistance < -180
    yawdistance=yawdistance+360
  EndIf
  If yawdistance > 180
    yawdistance=yawdistance-360
  EndIf
  
  ProcedureReturn Sqr(pitchdistance*pitchdistance+yawdistance*yawdistance)
EndProcedure

;if someone prefers to read/write a structure
Structure GlowObjectDefinition_t
  pEntity.i
  red.f
  green.f
  blue.f
  alpha.f
  padding.c[16]
  m_bRenderWhenOccluded.b
  m_bRenderWhenUnoccluded.b
  m_bFullBloom.b
EndStructure

Procedure SetGlowEntity(GlowEntityBaseAdress.i, Color.i)
    ATPMemory::WPM_Float(hProc, GlowEntityBaseAdress+$4, Red(Color)/255)
  	ATPMemory::WPM_Float(hProc, GlowEntityBaseAdress+$8, Green(Color)/255)
  	ATPMemory::WPM_Float(hProc, GlowEntityBaseAdress+$C, Blue(Color)/255)
  	ATPMemory::WPM_Float(hProc, GlowEntityBaseAdress+$10, 242/255)
  	ATPMemory::WPM_Byte(hProc, GlowEntityBaseAdress+$24, 1)
  	ATPMemory::WPM_Byte(hProc, GlowEntityBaseAdress+$25, 0)
  	ATPMemory::WPM_Byte(hProc, GlowEntityBaseAdress+$26, 0)
EndProcedure

Procedure SetGlow()
  Protected TargetColor.i
  glowpointer=ATPMemory::RPM(hProc, ClientModuleBase + Offset_glowObjectManager)
  For x=0 To 31
    If x <> LocalPlayerData\indexNum And Entities(x)\EntityBase <> 0 And Entities(x)\health > 0
      
      If TeamCheckState = 0 And Entities(x)\team = LocalPlayerData\team
        Continue
      EndIf
      
      If Entities(x)\team <> LocalPlayerData\team
          If HealthBased
            TargetColor=RGB((255*Entities(x)\health/100), 10, (255*(100-Entities(x)\health)/100))
          Else
            TargetColor=RGB(255, 10, 0)
          EndIf
      Else
          If HealthBased
            TargetColor=RGB((255*(100-Entities(x)\health)/100), (255*Entities(x)\health/100), 0)
          Else
            TargetColor=RGB(0, 255, 0)
          EndIf
      EndIf
      
      If WH_highlight_vulnerable
        If Entities(x)\team <> LocalPlayerData\team Or TeamCheckState = 0
         If IsEnemyVulnerable(x)
           TargetColor=Color_Vulnerable
         EndIf
        EndIf
      EndIf
			
      If IsWeaponIDValid(LocalPlayerData\activeWeaponID)
        If AimbotState=1 And Aimbot_enabled(LocalPlayerData\activeWeaponID)=1 And (Aimbot_FOVBased(LocalPlayerData\activeWeaponID)=1 And x=FOVTarget) Or (Aimbot_FOVBased(LocalPlayerData\activeWeaponID)=0 And x=DistanceTarget)
          TargetColor=RGB((255*(100-Entities(x)\health)/100), 250, (255*Entities(x)\health/100))
			  EndIf  
			EndIf
			
			
			  SetGlowEntity(glowpointer+Entities(x)\glowIndex*$38, TargetColor)
				If ExternalChamsState=1
				  ATPMemory::WPM_Byte(hProc, glowpointer+Entities(x)\glowIndex*$38+$2C, 1)
				EndIf
				
    EndIf
  Next x
  ProcedureReturn 1
EndProcedure

Procedure GlowEntities()
  glowpointer=ATPMemory::RPM(hProc, ClientModuleBase + Offset_glowObjectManager)
  glowEntitiesAmount=ATPMemory::RPM(hProc, ClientModuleBase + Offset_glowObjectManager + 4)
  For x=0 To glowEntitiesAmount
    currentGlowEntity=glowpointer+x*$38
    currentGlowEntityBase=ATPMemory::RPM(hProc, currentGlowEntity)
    currentGlowEntityClassID=getClassID(currentGlowEntityBase)
    If currentGlowEntityClassID < 250 And currentGlowEntityClassID <> 35
      If Glow_WeaponESP = 1 And  ((currentGlowEntityClassID > 200 And currentGlowEntityClassID < 243) Or currentGlowEntityClassID = 1 Or currentGlowEntityClassID = 39)
        SetGlowEntity(currentGlowEntity, Color_Glow_Weapon)
      EndIf
      If Glow_BombESP = 1 And (currentGlowEntityClassID=29 Or currentGlowEntityClassID=107) : SetGlowEntity(currentGlowEntity, Color_Glow_Bomb) : EndIf
      If Glow_ChickenESP = 1 And currentGlowEntityClassID=31 : SetGlowEntity(currentGlowEntity, Color_Glow_Chicken) : EndIf
      If Glow_GrenadeESP = 1 And isClassIDaGrenade(currentGlowEntityClassID) : SetGlowEntity(currentGlowEntity, Color_Glow_Grenade) : EndIf
    EndIf
  Next x
EndProcedure

Procedure AntiFlash()
  If ATPMemory::RPM_Float(hProc, LocalPlayerBase+Offset_m_flFlashMaxAlpha) > 0.0
     ATPMemory::WPM_Float(hProc, LocalPlayerBase+Offset_m_flFlashMaxAlpha, 0)
  EndIf 
EndProcedure

Procedure NoHands()
  ATPMemory::WPM(hProc, LocalPlayerBase + Offset_m_nModelIndex, 0)
EndProcedure

Procedure FovChanger()
  ATPMemory::WPM(hProc, LocalPlayerBase + Offset_m_iFov, FOVChangerFOVvalue)
EndProcedure

Procedure Radar()
  For x=0 To 31
    If Entities(x)\team <> LocalPlayerData\team And Entities(x)\dormant = 0 And Entities(x)\spotted = 0 And Entities(x)\health>0
      ATPMemory::WPM(hProc, Entities(x)\EntityBase + Offset_m_bSpotted, 1)
    EndIf
  Next x
EndProcedure

Procedure Distance_GetClosestEnemy()
  Protected CurrentNearestEnemyDistance.f=100000
  Protected CurrentNearestEnemyIndex.i=-1
  For x=0 To 31
   If Aimbot_FriendlyFire(LocalPlayerData\activeWeaponID)=0
    If Entities(x)\EntityBase <> 0  And Entities(x)\team <> LocalPlayerData\team And Entities(x)\health > 0 And Entities(x)\dormant=0 And (Aimbot_VisibilityCheck(LocalPlayerData\activeWeaponID)=0 Or (Entities(x)\spottedbyMask&(1 << LocalPlayerData\indexNum)))
    If CurrentNearestEnemyDistance > Entities(x)\distance
      CurrentNearestEnemyDistance = Entities(x)\distance
      CurrentNearestEnemyIndex=x
    EndIf
    EndIf
   Else
     If Entities(x)\EntityBase <> 0  And Entities(x)\health > 0 And Entities(x)\dormant=0 And (Aimbot_VisibilityCheck(LocalPlayerData\activeWeaponID)=0 Or (Entities(x)\spottedbyMask&(1 << LocalPlayerData\indexNum)))
     If CurrentNearestEnemyDistance > Entities(x)\distance
      CurrentNearestEnemyDistance = Entities(x)\distance
      CurrentNearestEnemyIndex=x
    EndIf
    EndIf
   EndIf
 Next x
 ProcedureReturn CurrentNearestEnemyIndex
EndProcedure

Procedure IsEntitySpottedbyMask(EntityIndex.i)
  ProcedureReturn (Entities(EntityIndex)\spottedbyMask&(1 << LocalPlayerData\indexNum)) ;BSP_isvisible(LocalPlayerData\pos[0], LocalPlayerData\pos[1], LocalPlayerData\pos[2], Entities(EntityIndex)\pos[0], Entities(EntityIndex)\pos[1], Entities(EntityIndex)\pos[2])
EndProcedure

Procedure FOV_GetClosestEnemy()
  Protected CurrentNearestEnemyFOVDistance.f=100000
  Protected CurrentNearestEnemyIndex.i=-1
  Protected tempFOVDistance.f
  For x=0 To 31
   If Aimbot_FriendlyFire(LocalPlayerData\activeWeaponID)=0
    If Entities(x)\EntityBase <> 0  And Entities(x)\team <> LocalPlayerData\team And Entities(x)\health > 0 And Entities(x)\dormant=0 And (Aimbot_VisibilityCheck(LocalPlayerData\activeWeaponID)=0 Or IsEntitySpottedbyMask(x))
      tempFOVDistance=Entities(x)\fovdistance
    If CurrentNearestEnemyFOVDistance > tempFOVDistance
      CurrentNearestEnemyFOVDistance = tempFOVDistance
      CurrentNearestEnemyIndex=x
    EndIf
    EndIf
   Else
     If Entities(x)\EntityBase <> 0  And Entities(x)\health > 0 And Entities(x)\dormant=0 And (Aimbot_VisibilityCheck(LocalPlayerData\activeWeaponID)=0 Or IsEntitySpottedbyMask(x))
       tempFOVDistance=Entities(x)\fovdistance
     If CurrentNearestEnemyFOVDistance > tempFOVDistance
      CurrentNearestEnemyFOVDistance = tempFOVDistance
      CurrentNearestEnemyIndex=x
    EndIf
    EndIf
   EndIf
  Next x
  ProcedureReturn CurrentNearestEnemyIndex
EndProcedure

Procedure FOV_GetClosestEnemyinMaximumFOV()
  Protected FOV_closest.i
  FOV_closest=FOV_GetClosestEnemy()
  If FOV_closest<>-1
   If (Aimbot_maxFov(LocalPlayerData\activeWeaponID)=0 Or (Entities(FOV_closest)\fovdistance<Aimbot_maxFov(LocalPlayerData\activeWeaponID)))
     ProcedureReturn FOV_closest
   EndIf
  EndIf
 ProcedureReturn -1
EndProcedure

Procedure SetSendPacket(bState.b)
  ATPMemory::WPM_Byte(hProc, EngineModuleBase + Offset_bSendPacket, bState)
EndProcedure

Procedure setViewAngles(pitch.f, yaw.f)
        ATPMemory::WPM_Float(hProc, LocalPlayerState + Offset_ViewAngles, pitch)
        ATPMemory::WPM_Float(hProc, LocalPlayerState + Offset_ViewAngles+4, yaw)
EndProcedure

Procedure setViewAnglesSilent(pitch.f, yaw.f)
  UserCommand.i = ATPMemory::RPM(hProc, ClientModuleBase + Offset_Input + $EC)
  currentSequenceNum.i = ATPMemory::RPM(hProc, LocalPlayerState+$4CAC)+1
  UserCommandSequenceNum.i = 0
  UserCommand = UserCommand + (currentSequenceNum%150)*$64
  currentUserCMD.UserCMD
  Repeat
    UserCommandSequenceNum=ATPMemory::RPM(hProc, UserCommand + 4)
    LocalPlayerData\viewangles[0] = ATPMemory::RPM_Float(hProc, LocalPlayerState+Offset_ViewAngles)
    LocalPlayerData\viewangles[1] = ATPMemory::RPM_Float(hProc, LocalPlayerState+Offset_ViewAngles+4)
  Until currentSequenceNum =< UserCommandSequenceNum
  
  ReadProcessMemory_(hProc, UserCommand, @currentUserCMD, SizeOf(currentUserCMD), 0)
  currentUserCMD\m_vecViewAngles[0]=pitch
  currentUserCMD\m_vecViewAngles[1]=yaw
  oldForwardMove.f = currentUserCMD\m_flForwardmove
  oldSideMove.f = currentUserCMD\m_flSidemove
  viewyawdelta.f = yaw - LocalPlayerData\viewangles[1]
  fixanglex.f = 0
  fixangley.f = 0
  If LocalPlayerData\viewangles[1] < 0 : fixanglex = 360 + LocalPlayerData\viewangles[1] : Else : fixanglex = LocalPlayerData\viewangles[1] : EndIf
  If yaw < 0 : fixangley = 360 + yaw : Else : fixangley = yaw : EndIf
  If fixanglex > fixangley : viewyawdelta = Abs(fixangley-fixanglex) : Else : viewyawdelta = 360 - Abs(fixanglex-fixangley) : EndIf
  viewyawdelta = 360 - viewyawdelta
  currentUserCMD\m_flSidemove = Sin(viewyawdelta * (#PI/180)) * oldForwardMove + Sin((viewyawdelta+90) * (#PI/180)) * oldSideMove
  currentUserCMD\m_flForwardmove = Cos(viewyawdelta * (#PI/180)) * oldForwardMove + Cos((viewyawdelta+90) * (#PI/180)) * oldSideMove
  If currentUserCMD\m_flSidemove < -450 : currentUserCMD\m_flSidemove = -450 : EndIf
  If currentUserCMD\m_flSidemove > 450 : currentUserCMD\m_flSidemove = 450 : EndIf
  If currentUserCMD\m_flForwardmove < -450 : currentUserCMD\m_flForwardmove = -450 : EndIf
  If currentUserCMD\m_flSidemove > 450 : currentUserCMD\m_flForwardmove = 450 : EndIf
  
  If GetAsyncKeyState_(#VK_LBUTTON) & $8000 : currentUserCMD\m_iButtons = currentUserCMD\m_iButtons | (1 << 0) : EndIf
  If GetAsyncKeyState_(#VK_SPACE) & $8000 : currentUserCMD\m_iButtons = currentUserCMD\m_iButtons | (1 << 1) : EndIf
  If GetAsyncKeyState_(#VK_CONTROL) & $8000 : currentUserCMD\m_iButtons = currentUserCMD\m_iButtons | (1 << 2) : EndIf
  If GetAsyncKeyState_(#VK_R) & 1 : currentUserCMD\m_iButtons = currentUserCMD\m_iButtons | (1 << 13) : EndIf
  If GetAsyncKeyState_(#VK_Q) & 1 : ClientCMD("lastinv") : EndIf
  If GetAsyncKeyState_(#VK_1) & 1 : ClientCMD("slot1") : EndIf
  If GetAsyncKeyState_(#VK_2) & 1 : ClientCMD("slot2") : EndIf
  If GetAsyncKeyState_(#VK_3) & 1 : ClientCMD("slot3") : EndIf
  
  ;this may be the least elegant part :D
  For x=0 To 80
    WriteProcessMemory_(hProc, UserCommand, @currentUserCMD, SizeOf(currentUserCMD), 0)
    setViewAngles(LocalPlayerData\viewangles[0], LocalPlayerData\viewangles[1])
  Next x
EndProcedure

Procedure Aimbot()
  Protected Dim delta.d(2)
  Protected Dim angle.f(2)
  Protected Dim punchangles.f(2)
  Protected Dim TargetAngleCurrentAngleDelta.f(2)
  Protected CTE
  
  
  If (Aimbot_AimKey(LocalPlayerData\activeWeaponID)=0 Or GetAsyncKeyState_(KeyBind_AimKey)&$8000) And (LocalPlayerData\health > 0)
    Protected hypothenuse
    Protected tempshots
    
  If Aimbot_FOVBased(LocalPlayerData\activeWeaponID)=0
    CTE = DistanceTarget
  ElseIf Aimbot_FOVBased(LocalPlayerData\activeWeaponID)=1
    CTE = FOVTarget
  EndIf
    
  If CTE > -1
  ;------------------------------Getting Eyehight---------------------------------------------
  LocalPlayerData\vecView[2]= LocalPlayerData\pos[2] + ATPMemory::RPM_Float(hProc, LocalPlayerBase + Offset_m_vecViewOffset+8)
  ;------------------------------Getting Eyehight---------------------------------------------
  ;------------------------------Getting VecPunch and Shots fired---------------------
  tempshots = ATPMemory::RPM(hProc, LocalPlayerBase + Offset_m_iShotsFired)
  If tempshots > 2
  punchangles(0) = ATPMemory::RPM_Float(hProc, LocalPlayerBase + Offset_m_aimPunchAngle)
  punchangles(1) = ATPMemory::RPM_Float(hProc, LocalPlayerBase + Offset_m_aimPunchAngle + 4)
  EndIf
  ;-------------------------------Getting VecPunch and Shots fired--------------------
  ;------------Getting BonePos----------------------------------------------------------------
  Entities(CTE)\BoneMatrix = ATPMemory::RPM(hProc, Entities(CTE)\EntityBase+Offset_BoneMatrix)
  Entities(CTE)\headpos[0] = ATPMemory::RPM_Float(hProc, Entities(CTE)\BoneMatrix + $30*Aimbot_TargetBone(LocalPlayerData\activeWeaponID) + $c)
  Entities(CTE)\headpos[1] = ATPMemory::RPM_Float(hProc, Entities(CTE)\BoneMatrix + $30*Aimbot_TargetBone(LocalPlayerData\activeWeaponID) + $1c)
  Entities(CTE)\headpos[2] = ATPMemory::RPM_Float(hProc, Entities(CTE)\BoneMatrix + $30*Aimbot_TargetBone(LocalPlayerData\activeWeaponID) + $2c)
  ;Debug BSP_IsVisible(LocalPlayerData\pos[0], LocalPlayerData\pos[1], LocalPlayerData\vecView[2], Entities(CTE)\headpos[0], Entities(CTE)\headpos[1], Entities(CTE)\headpos[2])
  ;------------Getting BonePos-----------------------------------------------------------------

        delta(0)=LocalPlayerData\pos[0]-Entities(CTE)\headpos[0]
        delta(1)=LocalPlayerData\pos[1]-Entities(CTE)\headpos[1]
        delta(2)=LocalPlayerData\vecView[2]-Entities(CTE)\headpos[2]
       
        hypothenuse=Sqr(delta(0)*delta(0)+delta(1)*delta(1))
        angle(0)=ATan(delta(2)/hypothenuse)*(180/#PI)
        angle(1)=ATan(delta(1)/delta(0))*(180/#PI)
        angle(2)=0
        
        ;-------RCS----------
        If tempshots > 2
        angle(0)=angle(0)-punchangles(0)*1.99
        angle(1)=angle(1)-punchangles(1)*1.99
        EndIf
        ;-------RCS----------

        If delta(0) >= 0
          angle(1)=angle(1)+180
        EndIf 
        
        FixAnglesArray(angle())
        
        ;------AimSmooth-----
        If Aimbot_SmoothFac(LocalPlayerData\activeWeaponID)>0
          TargetAngleCurrentAngleDelta(0)=angle(0)-LocalPlayerData\viewangles[0]
          TargetAngleCurrentAngleDelta(1)=angle(1)-LocalPlayerData\viewangles[1]
          If TargetAngleCurrentAngleDelta(0) > 180
            TargetAngleCurrentAngleDelta(0)=TargetAngleCurrentAngleDelta(0)-360
          EndIf
          If TargetAngleCurrentAngleDelta(1)>180
            TargetAngleCurrentAngleDelta(1)=TargetAngleCurrentAngleDelta(1)-360
          EndIf
          If TargetAngleCurrentAngleDelta(1)<-180
            TargetAngleCurrentAngleDelta(1)=TargetAngleCurrentAngleDelta(1)+360
          EndIf
          If Aimbot_SmoothingType(LocalPlayerData\activeWeaponID) = 1
            ;----Logarithmic Smoothing----
            angle(0)=LocalPlayerData\viewangles[0]+((TargetAngleCurrentAngleDelta(0))*Aimbot_SmoothFac(LocalPlayerData\activeWeaponID))
            angle(1)=LocalPlayerData\viewangles[1]+((TargetAngleCurrentAngleDelta(1))*Aimbot_SmoothFac(LocalPlayerData\activeWeaponID))
          Else
            ;----Logarithmic Smoothing----
            delmag.f=fcalc2DVectorMagnitude(TargetAngleCurrentAngleDelta(0), TargetAngleCurrentAngleDelta(1))
            If delmag > Aimbot_SmoothFac(LocalPlayerData\activeWeaponID)
              affactor.f=delmag/Aimbot_SmoothFac(LocalPlayerData\activeWeaponID)
              angle(0)=LocalPlayerData\viewangles[0]+TargetAngleCurrentAngleDelta(0)/affactor
              angle(1)=LocalPlayerData\viewangles[1]+TargetAngleCurrentAngleDelta(1)/affactor
            EndIf
            ;----Linear Smoothing----
          EndIf
        EndIf
        ;------AimSmooth-----
        
        FixAnglesArray(angle())
        
        If angle(0) > 89 Or angle(0) < -89 Or angle(1) > 180 Or angle(1) < -180
          End
        EndIf
        
        If angle(1)<>0
          If Aimbot_SilentAimState(LocalPlayerData\activeWeaponID)=0
              setViewAngles(angle(0), angle(1))
            Else
              setViewAnglesSilent(angle(0), angle(1))
          EndIf
        EndIf
        
      EndIf
  EndIf 
EndProcedure

Procedure AntiAim()
  Protected Dim angle.f(2)
  If (GetAsyncKeyState_(#VK_LBUTTON)&$8000)=0
  angle(0)=Random(178)-89
  angle(1)=Random(358)-179
  FixAnglesArray(angle())
  If angle(0)<>0 And angle(1)<>0
    setViewAnglesSilent(angle(0), angle(1))
  EndIf
  EndIf   
EndProcedure

Procedure BunnyHop()
  If GetAsyncKeyState_(#VK_SPACE)&$8000
    If LocalPlayerData\velocity > 4
      If LocalPlayerData\fFlags=263 Or LocalPlayerData\fFlags=257
        ATPMemory::WPM(hProc, ClientModuleBase + Offset_ForceJump, 6)
      EndIf
    EndIf
  EndIf
EndProcedure

Procedure TimedShot(tsdelay.i)
  Delay(tsdelay)
  ATPMemory::WPM(hProc,ClientModuleBase+Offset_ForceAttack, 6)
EndProcedure

Procedure TriggerBot()
  If GetAsyncKeyState_(KeyBind_TriggerKey) Or Not KeyBind_TriggerKey
   targetplayer=ATPMemory::RPM(hProc,LocalPlayerBase+Offset_m_iCrossHairID)
   If targetplayer>0 And targetplayer < 31
     If Entities(targetplayer-1)\team <> LocalPlayerData\team
      CreateThread(@TimedShot(), Triggerbot_Delay(LocalPlayerData\activeWeaponID))
      If Triggerbot_Burst(LocalPlayerData\activeWeaponID)
        ExtraShots=Random(2)+1
        For x=1 To ExtraShots
          CreateThread(@TimedShot(), Triggerbot_Delay(LocalPlayerData\activeWeaponID)+x*60)
        Next x
      EndIf
     EndIf
   EndIf
  EndIf
EndProcedure

Procedure ZeusTrigger()
  If ZeusTriggerState And getActiveWeaponID()=31
    targetplayer=ATPMemory::RPM(hProc,LocalPlayerBase+Offset_m_iCrossHairID)
   If targetplayer>0 And targetplayer < 31
      If Entities(targetplayer-1)\team <> LocalPlayerData\team And Entities(targetplayer-1)\distance < 184
          ATPMemory::WPM(hProc,ClientModuleBase+Offset_ForceAttack, 6)
      EndIf
    EndIf
  EndIf
EndProcedure

Procedure RankParser(nullptr.i)
  Protected RPOutput.s
  PlayerResourceBase = ATPMemory::RPM(hProc, ClientModuleBase + Offset_PlayerResourcePointer)
      For x=1 To 31
        If x <> LocalPlayerData\indexNum
          Entities(x)\rank=ATPMemory::RPM(hProc, PlayerResourceBase+Offset_m_iCompetitiveRanking+(x-1)*4)
          Entities(x)\wins=ATPMemory::RPM(hProc, PlayerResourceBase+Offset_m_iCompetitiveWins+(x-1)*4)
          If Entities(x)\wins > 0
            RPOutput=RPOutput+GetPlayerName(x)+"|"+Ranks(Entities(x)\rank)+"|"+Str(Entities(x)\wins)+" Wins"+#CRLF$
          EndIf
        EndIf
      Next x
  If RPOutput <> ""
    MessageRequester(CheatName, RPOutput)
  EndIf
EndProcedure

Procedure SetUpWeaponConfig()
  For x=1 To 64
    Aimbot_TargetBone(x)=8
    Aimbot_AimKey(x)=1
    Aimbot_FriendlyFire(x)=0
    Aimbot_VisibilityCheck(x)=1
    Aimbot_SmoothFac(x)=0.000
    Aimbot_FOVBased(x)=1
    Aimbot_maxFov(x)=2
    Aimbot_SilentAimState(x)=0
    Aimbot_enabled(x)=0
    Triggerbot_enabled(x)=0
    Triggerbot_Burst(x)=0
    Triggerbot_Delay(x)=0
  Next x
EndProcedure

Procedure SetUpSkins()
  For y=0 To 523
    WeaponSkins(y)\pkit=416
    WeaponSkins(y)\seed=1
    WeaponSkins(y)\wear=0.0001
    WeaponSkins(y)\stattrak=1337
    WeaponSkins(y)\name=CheatName
  Next y
  WeaponSkins(1)\pkit=37        ;Deagle Blaze
  WeaponSkins(1)\stattrak=-1
  WeaponSkins(2)\pkit=447       ;Duals Duelist
  WeaponSkins(2)\stattrak=-1
  WeaponSkins(4)\pkit=38        ;Glock Fade
  WeaponSkins(4)\stattrak=-1
 	WeaponSkins(7)\pkit=524       ;Ak Fuel Injector
 	WeaponSkins(8)\pkit=33        ;Aug Hot Rod
 	WeaponSkins(8)\stattrak=-1
 	WeaponSkins(9)\pkit=344       ;AWP Dragon Lore
 	WeaponSkins(9)\stattrak=-1
 	WeaponSkins(10)\pkit=429      ;Famas Djinn
 	WeaponSkins(11)\pkit=438      ;G3SG1 Chronos
 	WeaponSkins(11)\stattrak=-1
 	WeaponSkins(13)\pkit=398      ;Galil Chatterbox
 	WeaponSkins(14)\pkit=401      ;M249 System Lock
 	WeaponSkins(17)\pkit=433      ;MAC-10 Neon Rider
 	WeaponSkins(19)\pkit=359      ;P90 Asiimov
 	WeaponSkins(24)\pkit=556      ;UMP Primal Saber
 	WeaponSkins(25)\pkit=393      ;XM1014 Tranquility
 	WeaponSkins(26)\pkit=542      ;Bizon Judgement of Anubis
 	WeaponSkins(27)\pkit=535      ;Mag-7 Praetorian
 	WeaponSkins(28)\pkit=514      ;Negev Power Loader
 	WeaponSkins(29)\pkit=256      ;Sawed-Off The Kraken
 	WeaponSkins(30)\pkit=179      ;Tec-9 Nuclear Threat
 	WeaponSkins(30)\stattrak=-1
 	WeaponSkins(32)\pkit=591      ;P2000 Imperial Dragon
 	WeaponSkins(33)\pkit=102      ;MP7 Whiteout
 	WeaponSkins(33)\stattrak=-1
 	WeaponSkins(34)\pkit=39       ;MP9 Bulldozer
 	WeaponSkins(34)\stattrak=-1
 	WeaponSkins(35)\pkit=286      ;Nova Antique
 	WeaponSkins(36)\pkit=168      ;P250 Nuclear Threat
 	WeaponSkins(36)\stattrak=-1
 	WeaponSkins(38)\pkit=597      ;Scar-20 Bloodsport
 	WeaponSkins(39)\pkit=39       ;SG553 Bulldozer
 	WeaponSkins(39)\stattrak=-1
 	WeaponSkins(40)\pkit=624      ;Scout Dragon Fire
 	WeaponSkins(60)\pkit=326      ;M4a4 Knight
 	WeaponSkins(60)\stattrak=-1
 	WeaponSkins(61)\pkit=504      ;USP Kill Confirmed
 	WeaponSkins(63)\pkit=270      ;CZ Victoria
 	WeaponSkins(64)\pkit=522      ;R8 Fade
EndProcedure

Procedure ForceFullUpdate()
 ATPMemory::WPM(hProc, ATPMemory::RPM(hProc,EngineModuleBase + Offset_EnginePointer)+$174, -1);
EndProcedure

Procedure SkinChanger()
  For x=1 To 4
    currentWeapon_Index = ATPMemory::RPM(hProc, LocalPlayerBase+Offset_hMyWeapon+((x-1)*4))&$fff
    currentWeapon_Entity = ATPMemory::RPM(hProc, ClientModuleBase+Offset_EntityBase+(currentWeapon_Index-1)*$10)
    If currentWeapon_Entity <> 0
    currentWeapon_Type = ATPMemory::RPM_Word(hProc, currentWeapon_Entity+Offset_m_iItemDefinitionIndex)
    currentWeapon_pkit = ATPMemory::RPM(hProc, currentWeapon_Entity+Offset_m_nFallbackPaintKit)
    WeaponOwnerAccID = ATPMemory::RPM(hProc, currentWeapon_Entity+Offset_m_OriginalOwnerXuidLow)
    If ((currentWeapon_Type > 0 And currentWeapon_Type < 65) Or (currentWeapon_Type > 499 And currentWeapon_Type < 524)) And (WeaponSkins(currentWeapon_Type)\pkit <> currentWeapon_pkit)
					ATPMemory::WPM(hProc, currentWeapon_Entity+Offset_m_iItemIDLow, 0)
					ATPMemory::WPM(hProc, currentWeapon_Entity+Offset_m_iItemIDHigh, -1)
					ATPMemory::WPM(hProc, currentWeapon_Entity+Offset_m_nFallbackSeed, WeaponSkins(currentWeapon_Type)\seed)
					ATPMemory::WPM_Float(hProc, currentWeapon_Entity+Offset_m_flFallbackWear, WeaponSkins(currentWeapon_Type)\wear)
					ATPMemory::WPM(hProc, currentWeapon_Entity+Offset_m_nFallbackPaintKit, WeaponSkins(currentWeapon_Type)\pkit)
					ATPMemory::WPM(hProc, currentWeapon_Entity+Offset_m_nFallbackStatTrak, WeaponSkins(currentWeapon_Type)\stattrak)
					ATPMemory::WPM(hProc, currentWeapon_Entity+Offset_m_iAccountID, WeaponOwnerAccID)
					ATPMemory::WPM_String(hProc, currentWeapon_Entity+Offset_m_szCustomName, WeaponSkins(currentWeapon_Type)\name)
		EndIf
					If KnifeChangerState = 1
  					currentActiveWeapon=getActiveWeaponID()
	  				If currentActiveWeapon=currentWeapon_Type And (currentActiveWeapon = 42 Or currentActiveWeapon = 59)
		  			  currentKnifeModel=ATPMemory::RPM(hProc, currentWeapon_Entity+Offset_m_nModelIndex)
			  		  If LocalPlayerData\team = 2
				  	    currentKnifeModel = currentKnifeModel + 37
  					  Else
	  				    currentKnifeModel = currentKnifeModel + 339
		  			  EndIf
			  		  currentKnifeModel = currentKnifeModel + (currentKnifeModelIndex)*3
				  	  ViewModelEntityIndex = ATPMemory::RPM(hProc, LocalPlayerBase+Offset_m_hViewModel+((x-1)*4))&$FFF
					    ViewModelEntityBase = ATPMemory::RPM(hProc, ClientModuleBase+Offset_EntityBase+((ViewModelEntityIndex-1)*$10))
  					  If ATPMemory::RPM(hProc, ViewModelEntityBase+Offset_m_nModelIndex) <> currentKnifeModel
	  	  			  ATPMemory::WPM(hProc, ViewModelEntityBase+Offset_m_nModelIndex, currentKnifeModel)
		  	  			ATPMemory::WPM(hProc, currentWeapon_Entity+Offset_m_nModelIndex, currentKnifeModel)
			  	  		ATPMemory::WPM(hProc, currentWeapon_Entity+Offset_m_iViewModelIndex, currentKnifeModel)
				  	  	ATPMemory::WPM(hProc, currentWeapon_Entity+Offset_m_iWorldModelIndex, currentKnifeModel+1)
					    	ATPMemory::WPM(hProc, currentWeapon_Entity+Offset_m_iWorldDroppedModelIndex, currentKnifeModel+2)
					    	ATPMemory::WPM(hProc, currentWeapon_Entity+Offset_m_iItemDefinitionIndex, KnifeIndizes(currentKnifeModelIndex))
				  	  EndIf
				  	EndIf
				  	If AutoForceFullUpdate
	  			  	If currentActiveWeapon <> oldActiveWeapon And currentActiveWeapon <> 0
		  		  	  If (currentActiveWeapon = 42 Or currentActiveWeapon = 59 Or (currentActiveWeapon > 499 And currentActiveWeapon < 524))
			  	  	    ForceFullUpdate()
				    	  EndIf
				    	  oldActiveWeapon = currentActiveWeapon
				  	  EndIf
				  	EndIf
				  EndIf
    EndIf
  Next x
EndProcedure

Procedure TS3Callout(nullptr.i)
  TS3CQConnectionID=OpenNetworkConnection("localhost",25639)
  If TS3CQConnectionID
    ReceiveString(TS3CQConnectionID)
    SendString(TS3CQConnectionID, "auth apikey="+GetTS3AuthenticationKey())
    ReceiveString(TS3CQConnectionID)
    KeyAcceptanceState$=ReceiveString(TS3CQConnectionID)
    If  FindString(KeyAcceptanceState$, "error id=0 msg=ok")
      Repeat 
        defaultmessage$="\n[[url="+#GitHubURL$+"]ACSGOMH[/url]-TS3Callout]"
        temp$=defaultmessage$
        For x=0 To 31
          If Entities(x)\EntityBase<>0 And Entities(x)\dormant=0 And Entities(x)\health>0 And Entities(x)\team <> LocalPlayerData\team
            temp$=temp$+"\n"+GetPlayerName(x)+" - "+Entities(x)\health+"HP - "+Entities(x)\lastplacename
          EndIf
        Next x
        If temp$<>defaultmessage$
          SendString(TS3CQConnectionID,"sendtextmessage targetmode=2 target=0 msg="+ReplaceString(temp$," ","\s"))
          ReceiveString(TS3CQConnectionID)
        EndIf
      Delay(1000)
      ForEver
    EndIf
  Else
    TS3CalloutState=0
    TS3CalloutThread=0
    toggled()
  EndIf
EndProcedure

;TTS Callout via a TS3-Bot, this was just a test
Procedure TS3TTSCallout(nullptr.i)
  TS3TexToSpeech("Activated T T S Callout")
  Repeat
    For x=0 To 31
      If Entities(x)\EntityBase <> 0 And Entities(x)\dormant=0 And Entities(x)\health > 0 And Entities(x)\team <> LocalPlayerData\team
        TS3TexToSpeech("One Enemy on "+Entities(x)\lastplacename+", he has "+Str(Entities(x)\health)+" h p left")
        Delay(10000)
      EndIf
    Next x
  ForEver
EndProcedure

Procedure GetFirstLivingEnemyinEntityList()
  For x=0 To 30
    If x <> LocalPlayerData\indexNum And Entities(x)\health > 0 And Entities(x)\dormant = 0 And Entities(x)\team <> LocalPlayerData\team
      ProcedureReturn x
    EndIf
  Next x
  ProcedureReturn -1
EndProcedure

Procedure ChatSpam(nullptr.i)
  Protected message.s
  Protected rmid.i
  Repeat
    Delay(500)
    If ChatSpam_Mode = 0
      rmid=Random(3)
      Select rmid
        Case 0
          message=RemoveString(#GitHubURL$, "https://")
        Case 1
          message="A CS:GO Multihack!"
        Case 2
          message="\(*-*)/ <-- With "+CheatName
        Case 3
          message="Wallhack|Aimbot|Triggerbot|TS3Callout|AntiAim|SkinChanger|KnifeChanger|FakeLag|FOV-Changer|Webradar, etc."
      EndSelect
    Else
      ;You could also iterate over the list and always get the next enemy(, instead of the first one), some might prefer that.
      CurrentEnemyEntityListIndex = GetFirstLivingEnemyinEntityList()
      If CurrentEnemyEntityListIndex <> -1
        message = Entities(CurrentEnemyEntityListIndex)\lastplacename+" | "+Entities(CurrentEnemyEntityListIndex)\health+" | "+GetPlayerName(CurrentEnemyEntityListIndex)
      EndIf
    EndIf
    If ChatSpam_TargetChatMode = 0
      ClientCMD("say "+message)
    Else
      ClientCMD("say_team "+message)
    EndIf
  Until 3=4
EndProcedure

Procedure FakeLag(nullptr.i)
  Repeat
    If LocalPlayerData\health > 0
      SetSendPacket(0)
      Delay(FakeLagOffDelay)
      SetSendPacket(1)
      Delay(FakeLagOnDelay)
    EndIf
  ForEver
EndProcedure

Procedure bStringtobValue(bString.s)
  If bString="true"
    ProcedureReturn 1
  Else
    ProcedureReturn 0
  EndIf
EndProcedure

Procedure.s bValuetoString(bState.i)
  If bState
    ProcedureReturn "true"
  Else
    ProcedureReturn "false"
  EndIf
EndProcedure

Procedure UpdateRemotelyToggledFeature(Feature.s,State.i)
  If Feature="VibratorESP"
    VibratorESP=State
  EndIf
  If Feature="RemoteRadar"
    RemoteRadar=State
  EndIf
  If Feature="Wallhack"
    GlowState=State
  EndIf
  If Feature="ExternalChams"
    ExternalChamsState=State
  EndIf
  If Feature="TS3Callout"
    TS3CalloutState=State
    If TS3CalloutState=1
      TS3CalloutThread=CreateThread(@TS3Callout(),0)
    Else
      If IsThread(TS3CalloutThread) : KillThread(TS3CalloutThread) : EndIf
    EndIf
  EndIf
  If Feature="Aimbot"
    AimbotState=State
  EndIf
  If Feature="Radar"
    RadarState=State
  EndIf
  If Feature="SkinChanger"
    SkinChangerState=State
  EndIf
  If Feature="KnifeChanger"
    KnifeChangerState=State
  EndIf
  If Feature="BunnyHop"
    BunnyHopState=State
  EndIf
  If Feature="Triggerbot"
    TriggerState=State
  EndIf
  If Feature="ZeusTrigger"
    ZeusTriggerState=State
  EndIf
  If Feature="AntiFlash"
    AntiFlashState=State
    If AntiFlashState=0
      ATPMemory::WPM_Float(hProc, LocalPlayerBase + Offset_m_flFlashMaxAlpha, 255)
    EndIf
  EndIf
  If Feature="ChatSpam"
    ChatSpamState=State
    If ChatSpamState=1
      ChatSpamThread=CreateThread(@ChatSpam(),0)
    Else
      If IsThread(ChatSpamThread) : KillThread(ChatSpamThread) : EndIf
    EndIf
  EndIf
  If Feature="AntiAim"
    AntiAimState=State
  EndIf
  If Feature="FakeLag"
    FakeLagState=State
    SetGadgetState(ACSGOMH_GUISettings_FakeLag, FakeLagState)
    If FakeLagState=1
      FakeLagThread = CreateThread(@FakeLag(), 0)
    Else
      If IsThread(FakeLagThread) : KillThread(FakeLagThread) : EndIf
    EndIf
  EndIf
  If Feature="Glow_BombESP"
    Glow_BombESP=State
  EndIf
  If Feature="Glow_ChickenESP"
    Glow_ChickenESP=State
  EndIf
  If Feature="Glow_GrenadeESP"
    Glow_GrenadeESP=State
  EndIf
  If Feature="Glow_WeaponESP"
    Glow_WeaponESP=State
  EndIf
  If Feature="Wallhack_TeamCheck"
    TeamCheckState=State
  EndIf
  If Feature="Wallhack_HealthBased"
    HealthBased=State
  EndIf
  If Feature="Wallhack_highlight_vulnerable"
    WH_highlight_vulnerable=State
  EndIf
  If Feature="NoHands"
    NoHandsState=State
  EndIf
  If Feature="Automatic_Force_Full-Update"
    AutoForceFullUpdate=State
  EndIf
  toggled()
EndProcedure

Procedure UpdateRemotelyChangedFeatureSetting(FeatureSetting.s,State.s)
  If FeatureSetting="AIUPI"
    AndroidInformationUpdateProtocollIntervall=Val(State)
  EndIf
  If FeatureSetting="FOVChanger_FOV"
    FOVChangerFOVvalue=Val(State)
    If FOVChangerFOVvalue > 90
      FOVChangerState=1
    Else
      FOVChangerState=0
    EndIf
  EndIf
  toggled()
EndProcedure

Procedure UpdateRemotelyChangedKeybind(KeyBindName.s, KeyID.i)
  Select KeyBindName
    Case "Keybind_AimKey"
      KeyBind_AimKey=KeyID
    Case "KeyBind_ToggleAimbot"
      KeyBind_ToggleAimbot=KeyID
    Case "KeyBind_ToggleAndroidController"
      KeyBind_ToggleAndroidController=KeyID
    Case "KeyBind_ToggleAntiAim"
      KeyBind_ToggleAntiAim=KeyID
    Case "KeyBind_ToggleAntiFlash"
      KeyBind_ToggleAntiFlash=KeyID
    Case "KeyBind_ToggleBhop"
      KeyBind_ToggleBhop=KeyID
    Case "KeyBind_ToggleChatSpam"
      KeyBind_ToggleChatSpam=KeyID
    Case "KeyBind_ToggleExternalChams"
      KeyBind_ToggleExternalChams=KeyID
    Case "KeyBind_ToggleGlowESP"
      KeyBind_ToggleGlowESP=KeyID
    Case "KeyBind_ToggleRadar"
      KeyBind_ToggleRadar=KeyID
    Case "KeyBind_ToggleSkinChanger"
      KeyBind_ToggleSkinChanger=KeyID
    Case "KeyBind_ToggleTriggerbot"
      KeyBind_ToggleTriggerbot=KeyID
    Case "KeyBind_TriggerKey"
      KeyBind_TriggerKey=KeyID
    Case "KeyBind_ForceUpdate"
      KeyBind_ForceUpdate=KeyID
  EndSelect
EndProcedure

Procedure UpdateChangedColor(Color_VarName.s, Color.i)
  Select Color_VarName
    Case "Color_Vulnerable"
      Color_Vulnerable=Color
    Case "Color_Glow_Bomb"
      Color_Glow_Bomb=Color
    Case "Color_Glow_Chicken"
      Color_Glow_Chicken=Color
    Case "Color_Glow_Grenade"
      Color_Glow_Grenade=Color
    Case "Color_Glow_Weapon"
      Color_Glow_Weapon=Color
  EndSelect
EndProcedure

Procedure SaveConfigFile()
  SettingsFilePath$ = GetTemporaryDirectory()+"\ACSGOMH.ATP"
  ACSGOMH_Settings_File = CreateFile(#PB_Any, SettingsFilePath$)
  If ACSGOMH_Settings_File <> 0
  For x=1 To 42
    If IsWeaponIDValid(x) 
      WriteStringN(ACSGOMH_Settings_File, "AimSettings"+"|"+Str(x)+"|"+Str(Aimbot_AimKey(x))+"|"+Str(Aimbot_FOVBased(x))+"|"+Str(Aimbot_SilentAimState(x))+"|"+Str(Aimbot_VisibilityCheck(x))+"|"+Str(Aimbot_FriendlyFire(x))+"|"+Str(Aimbot_maxFov(x))+"|"+StrF(Aimbot_SmoothFac(x))+"|"+Str(Aimbot_enabled(x))+"|"+Str(Aimbot_TargetBone(x))+"|"+Str(Aimbot_SmoothingType(x))) 
      WriteStringN(ACSGOMH_Settings_File, "TriggerSettings"+"|"+Str(x)+"|"+Str(Triggerbot_Burst(x))+"|"+Str(Triggerbot_Delay(x))+"|"+Str(Triggerbot_enabled(x)))
    EndIf
    WriteStringN(ACSGOMH_Settings_File, "SkinChanger"+"|"+Str(x)+"|"+WeaponSkins(x)\name+"|"+Str(WeaponSkins(x)\pkit)+"|"+Str(WeaponSkins(x)\seed)+"|"+Str(WeaponSkins(x)\stattrak)+"|"+StrF(WeaponSkins(x)\wear))
  Next x
  For x=59 To 64
    If IsWeaponIDValid(x) 
      WriteStringN(ACSGOMH_Settings_File, "AimSettings"+"|"+Str(x)+"|"+Str(Aimbot_AimKey(x))+"|"+Str(Aimbot_FOVBased(x))+"|"+Str(Aimbot_SilentAimState(x))+"|"+Str(Aimbot_VisibilityCheck(x))+"|"+Str(Aimbot_FriendlyFire(x))+"|"+Str(Aimbot_maxFov(x))+"|"+StrF(Aimbot_SmoothFac(x))+"|"+Str(Aimbot_enabled(x))+"|"+Str(Aimbot_TargetBone(x))+"|"+Str(Aimbot_SmoothingType(x)))
      WriteStringN(ACSGOMH_Settings_File, "TriggerSettings"+"|"+Str(x)+"|"+Str(Triggerbot_Burst(x))+"|"+Str(Triggerbot_Delay(x))+"|"+Str(Triggerbot_enabled(x)))
    EndIf
    WriteStringN(ACSGOMH_Settings_File, "SkinChanger"+"|"+Str(x)+"|"+WeaponSkins(x)\name+"|"+Str(WeaponSkins(x)\pkit)+"|"+Str(WeaponSkins(x)\seed)+"|"+Str(WeaponSkins(x)\stattrak)+"|"+StrF(WeaponSkins(x)\wear))
  Next x
  For x=500 To 523
    WriteStringN(ACSGOMH_Settings_File, "SkinChanger"+"|"+Str(x)+"|"+WeaponSkins(x)\name+"|"+Str(WeaponSkins(x)\pkit)+"|"+Str(WeaponSkins(x)\seed)+"|"+Str(WeaponSkins(x)\stattrak)+"|"+StrF(WeaponSkins(x)\wear))
  Next x
  WriteStringN(ACSGOMH_Settings_File, "toggle|Wallhack|"+bValuetoString(GlowState))
  WriteStringN(ACSGOMH_Settings_File, "toggle|ExternalChams|"+bValuetoString(ExternalChamsState))
  WriteStringN(ACSGOMH_Settings_File, "toggle|Aimbot|"+bValuetoString(AimbotState))
  WriteStringN(ACSGOMH_Settings_File, "toggle|Radar|"+bValuetoString(RadarState))
  WriteStringN(ACSGOMH_Settings_File, "toggle|SkinChanger|"+bValuetoString(SkinChangerState))
  WriteStringN(ACSGOMH_Settings_File, "toggle|KnifeChanger|"+bValuetoString(KnifeChangerState))
  WriteStringN(ACSGOMH_Settings_File, "toggle|Automatic_Force_Full-Update|"+bValuetoString(AutoForceFullUpdate))
  WriteStringN(ACSGOMH_Settings_File, "toggle|BunnyHop|"+bValuetoString(BunnyHopState))
  WriteStringN(ACSGOMH_Settings_File, "toggle|Triggerbot|"+bValuetoString(TriggerState))
  WriteStringN(ACSGOMH_Settings_File, "toggle|ZeusTrigger|"+bValuetoString(ZeusTriggerState))
  WriteStringN(ACSGOMH_Settings_File, "toggle|AntiFlash|"+bValuetoString(AntiFlashState))
  WriteStringN(ACSGOMH_Settings_File, "toggle|Glow_BombESP|"+bValuetoString(Glow_BombESP))
  WriteStringN(ACSGOMH_Settings_File, "toggle|Glow_ChickenESP|"+bValuetoString(Glow_ChickenESP))
  WriteStringN(ACSGOMH_Settings_File, "toggle|Glow_GrenadeESP|"+bValuetoString(Glow_GrenadeESP))
  WriteStringN(ACSGOMH_Settings_File, "toggle|Glow_WeaponESP|"+bValuetoString(Glow_WeaponESP))
  WriteStringN(ACSGOMH_Settings_File, "toggle|Wallhack_TeamCheck|"+bValuetoString(TeamCheckState))
  WriteStringN(ACSGOMH_Settings_File, "toggle|Wallhack_HealthBased|"+bValuetoString(HealthBased))
  WriteStringN(ACSGOMH_Settings_File, "toggle|Wallhack_highlight_vulnerable|"+bValuetoString(WH_highlight_vulnerable))
  WriteStringN(ACSGOMH_Settings_File, "toggle|NoHands|"+bValuetoString(NoHandsState))
  WriteStringN(ACSGOMH_Settings_File, "setting|FOVChanger_FOV|"+Str(FOVChangerFOVvalue))
  WriteStringN(ACSGOMH_Settings_File, "keybind|Keybind_AimKey|"+Str(KeyBind_AimKey))
  WriteStringN(ACSGOMH_Settings_File, "keybind|KeyBind_ToggleAimbot|"+Str(KeyBind_ToggleAimbot))
  WriteStringN(ACSGOMH_Settings_File, "keybind|KeyBind_ToggleAndroidController|"+Str(KeyBind_ToggleAndroidController))
  WriteStringN(ACSGOMH_Settings_File, "keybind|KeyBind_ToggleAntiAim|"+Str(KeyBind_ToggleAntiAim))
  WriteStringN(ACSGOMH_Settings_File, "keybind|KeyBind_ToggleAntiFlash|"+Str(KeyBind_ToggleAntiFlash))
  WriteStringN(ACSGOMH_Settings_File, "keybind|KeyBind_ToggleBhop|"+Str(KeyBind_ToggleBhop))
  WriteStringN(ACSGOMH_Settings_File, "keybind|KeyBind_ToggleChatSpam|"+Str(KeyBind_ToggleChatSpam))
  WriteStringN(ACSGOMH_Settings_File, "keybind|KeyBind_ToggleExternalChams|"+Str(KeyBind_ToggleExternalChams))
  WriteStringN(ACSGOMH_Settings_File, "keybind|KeyBind_ToggleGlowESP|"+Str(KeyBind_ToggleGlowESP))
  WriteStringN(ACSGOMH_Settings_File, "keybind|KeyBind_ToggleRadar|"+Str(KeyBind_ToggleRadar))
  WriteStringN(ACSGOMH_Settings_File, "keybind|KeyBind_ToggleSkinChanger|"+Str(KeyBind_ToggleSkinChanger))
  WriteStringN(ACSGOMH_Settings_File, "keybind|KeyBind_ToggleTriggerbot|"+Str(KeyBind_ToggleTriggerbot))
  WriteStringN(ACSGOMH_Settings_File, "keybind|KeyBind_TriggerKey|"+Str(KeyBind_TriggerKey))
  WriteStringN(ACSGOMH_Settings_File, "keybind|KeyBind_ForceUpdate|"+Str(KeyBind_ForceUpdate))
  WriteStringN(ACSGOMH_Settings_File, "color|Color_Vulnerable|"+Str(Color_Vulnerable))
  WriteStringN(ACSGOMH_Settings_File, "color|Color_Glow_Bomb|"+Str(Color_Glow_Bomb))
  WriteStringN(ACSGOMH_Settings_File, "color|Color_Glow_Chicken|"+Str(Color_Glow_Chicken))
  WriteStringN(ACSGOMH_Settings_File, "color|Color_Glow_Grenade|"+Str(Color_Glow_Grenade))
  WriteStringN(ACSGOMH_Settings_File, "color|Color_Glow_Weapon|"+Str(Color_Glow_Weapon))
  CloseFile(ACSGOMH_Settings_File)
  EndIf
EndProcedure

Procedure LoadConfigFile()
  SettingsFilePath$ = GetTemporaryDirectory()+"\ACSGOMH.ATP"
  ACSGOMH_Settings_File = ReadFile(#PB_Any, SettingsFilePath$)
  If ACSGOMH_Settings_File <> 0
  Repeat
    DataToParse$=ReadString(ACSGOMH_Settings_File)
    If StringField(DataToParse$, 1, "|") = "AimSettings"
      currentWeaponID=Val(StringField(DataToParse$, 2, "|"))
      Aimbot_AimKey(currentWeaponID)=Val(StringField(DataToParse$, 3, "|"))
      Aimbot_FOVBased(currentWeaponID)=Val(StringField(DataToParse$, 4, "|"))
      Aimbot_SilentAimState(currentWeaponID)=Val(StringField(DataToParse$, 5, "|"))
      Aimbot_VisibilityCheck(currentWeaponID)=Val(StringField(DataToParse$, 6, "|"))
      Aimbot_FriendlyFire(currentWeaponID)=Val(StringField(DataToParse$, 7, "|"))
      Aimbot_maxFov(currentWeaponID)=Val(StringField(DataToParse$, 8, "|"))
      Aimbot_SmoothFac(currentWeaponID)=ValF(StringField(DataToParse$, 9, "|"))
      Aimbot_enabled(currentWeaponID)=Val(StringField(DataToParse$, 10, "|"))
      Aimbot_TargetBone(currentWeaponID)=Val(StringField(DataToParse$, 11, "|"))
      Aimbot_SmoothingType(currentWeaponID)=Val(StringField(DataToParse$, 12, "|"))
    EndIf
    If StringField(DataToParse$, 1, "|") = "TriggerSettings"
      currentWeaponID=Val(StringField(DataToParse$, 2, "|"))
      Triggerbot_Burst(currentWeaponID)=Val(StringField(DataToParse$, 3, "|"))
      Triggerbot_Delay(currentWeaponID)=Val(StringField(DataToParse$, 4, "|"))
      Triggerbot_enabled(currentWeaponID)=Val(StringField(DataToParse$, 5, "|"))
    EndIf
    If StringField(DataToParse$, 1, "|") = "SkinChanger"
      currentWeaponID=Val(StringField(DataToParse$, 2, "|"))
      WeaponSkins(currentWeaponID)\name=StringField(DataToParse$, 3, "|")
      WeaponSkins(currentWeaponID)\pkit=Val(StringField(DataToParse$, 4, "|"))
      WeaponSkins(currentWeaponID)\seed=Val(StringField(DataToParse$, 5, "|"))
      WeaponSkins(currentWeaponID)\stattrak=Val(StringField(DataToParse$, 6, "|"))
      WeaponSkins(currentWeaponID)\wear=ValF(StringField(DataToParse$, 7, "|"))
    EndIf
    If StringField(DataToParse$, 1, "|") = "toggle"
      toggledFeature$=StringField(DataToParse$,2,"|")
      toggledFeatureState=bStringtobValue(StringField(DataToParse$,3,"|"))
      UpdateRemotelyToggledFeature(toggledFeature$,toggledFeatureState)
    EndIf
    If StringField(DataToParse$, 1, "|") = "setting"
      changedFeatureSetting$=StringField(DataToParse$,2,"|")
      changedFeatureSettingState$=StringField(DataToParse$,3,"|")
      UpdateRemotelyChangedFeatureSetting(changedFeatureSetting$,changedFeatureSettingState$)
    EndIf
    If StringField(DataToParse$, 1, "|") = "keybind"
      KeyBind_Name$=StringField(DataToParse$,2,"|")
      KeyBind_KeyId=Val(StringField(DataToParse$,3,"|"))
      UpdateRemotelyChangedKeybind(KeyBind_Name$, KeyBind_KeyId)
    EndIf
    If StringField(DataToParse$, 1, "|") = "color"
      Color_VarName$=StringField(DataToParse$,2,"|")
      UpdatedColor=Val(StringField(DataToParse$,3,"|"))
      UpdateChangedColor(Color_VarName$, UpdatedColor)
    EndIf
  Until Eof(ACSGOMH_Settings_File) <> 0
  CloseFile(ACSGOMH_Settings_File)
  EndIf
EndProcedure

Procedure CallRemotelyToggledFunction(Function.s,FunctionParameter.s)
  If Function="Force-Update"
    ForceFullUpdate()
  EndIf
  If Function="ClientCMD"
    ClientCMD(FunctionParameter)
  EndIf
  If Function="LoadConfig"
    LoadConfigFile()
  EndIf
  If Function="SaveConfig"
    SaveConfigFile()
  EndIf
EndProcedure

Procedure UpdateSkins(cWeaponID.s,cWeaponpKit.s,cWeaponSeed.s,cWeaponWear.s,cWeaponStattrak.s)
  Protected cWeaponIndex.i
  cWeaponIndex=Val(cWeaponID)
  WeaponSkins(cWeaponIndex)\pkit=Val(cWeaponpKit)
  WeaponSkins(cWeaponIndex)\seed=Val(cWeaponSeed)
  WeaponSkins(cWeaponIndex)\wear=ValF(cWeaponWear)
  WeaponSkins(cWeaponIndex)\stattrak=Val(cWeaponStattrak)
EndProcedure

;the "AndroidController" is basically just an API for the cheat, but I originally created it to be used with an Android-app,
;so thats the reason for the name

Procedure receivedHandlerThread(AC_ConnectionID.i)
 Repeat
   If NetworkServerEvent(AndroidServerSocket)=#PB_NetworkEvent_Data
     receiveddata$=ReceiveString(AC_ConnectionID)
     Debug receiveddata$
        If receiveddata$<>""
          If hiddenmode=1
            If receiveddata$="[disconnect]"
              End
            EndIf
          EndIf
          If StringField(receiveddata$,2,"|")="toggle"
            toggledFeature$=StringField(receiveddata$,3,"|")
            toggledFeatureState=bStringtobValue(StringField(receiveddata$,4,"|"))
            UpdateRemotelyToggledFeature(toggledFeature$,toggledFeatureState)
          EndIf
          If StringField(receiveddata$,2,"|")="setting"
            changedFeatureSetting$=StringField(receiveddata$,3,"|")
            changedFeatureSettingState$=StringField(receiveddata$,4,"|")
            UpdateRemotelyChangedFeatureSetting(changedFeatureSetting$,changedFeatureSettingState$)
          EndIf
          If StringField(receiveddata$,2,"|")="call"
            calledFunction$=StringField(receiveddata$,3,"|")
            calledFunctionParameter$=StringField(receiveddata$,4,"|")
            CallRemotelyToggledFunction(calledFunction$,calledFunctionParameter$)
          EndIf
          If StringField(receiveddata$,2,"|")="skins"
            cweaponid$=StringField(receiveddata$,3,"|")
            cweaponpkit$=StringField(receiveddata$,4,"|")
            cweaponseed$=StringField(receiveddata$,5,"|")
            cweaponwear$=StringField(receiveddata$,6,"|")
            cweaponstattrak$=StringField(receiveddata$,7,"|")
            UpdateSkins(cweaponid$,cweaponpkit$,cweaponseed$,cweaponwear$,cweaponstattrak$)
          EndIf
          If StringField(receiveddata$, 2, "|") = "AimSettings"
            currentWeaponID=getWeaponListIndexbySelectedWeaponListIndex(Val(StringField(receiveddata$, 3, "|")))
            Aimbot_AimKey(currentWeaponID)=Val(StringField(receiveddata$, 4, "|"))
            Aimbot_FOVBased(currentWeaponID)=Val(StringField(receiveddata$, 5, "|"))
            Aimbot_SilentAimState(currentWeaponID)=Val(StringField(receiveddata$, 6, "|"))
            Aimbot_VisibilityCheck(currentWeaponID)=Val(StringField(receiveddata$, 7, "|"))
            Aimbot_FriendlyFire(currentWeaponID)=Val(StringField(receiveddata$, 8, "|"))
            Aimbot_maxFov(currentWeaponID)=Val(StringField(receiveddata$, 9, "|"))
            Aimbot_SmoothFac(currentWeaponID)=ValF(StringField(receiveddata$, 10, "|"))
            Aimbot_enabled(currentWeaponID)=Val(StringField(receiveddata$, 11, "|"))
            Aimbot_SmoothingType(currentWeaponID)=Val(StringField(receiveddata$, 12, "|"))
            Aimbot_TargetBone(currentWeaponID)=Val(StringField(receiveddata$, 13, "|"))
            toggled()
          EndIf
          Triggerbot_enabled(currentWeaponID)=Val(StringField(receiveddata$, 12, "|"))
          If StringField(receiveddata$, 2, "|") = "TriggerSettings"
            currentWeaponID=getWeaponListIndexbySelectedWeaponListIndex(Val(StringField(receiveddata$, 3, "|")))
            Triggerbot_Burst(currentWeaponID)=Val(StringField(receiveddata$, 4, "|"))
            Triggerbot_Delay(currentWeaponID)=Val(StringField(receiveddata$, 5, "|"))
            Triggerbot_enabled(currentWeaponID)=Val(StringField(receiveddata$, 5, "|"))
          EndIf
        EndIf
    EndIf
  Until NetworkServerEvent(AndroidServerSocket)=#PB_NetworkEvent_Disconnect
  CurrentClient="No Client connected!"
  toggled()
  If hiddenmode=1
    End
  EndIf
EndProcedure

Procedure AndroidController(nullptr.i)
  AndroidServerSocket=CreateNetworkServer(0,815)
  lastSentRemoteRadarData$=""
  Repeat
    Delay(10)
  Until NetworkServerEvent(AndroidServerSocket)=#PB_NetworkEvent_Connect
  AndroidClient=EventClient()
  Repeat
    Delay(10)
  Until NetworkServerEvent(AndroidServerSocket)=#PB_NetworkEvent_Data
  CurrentClient="["+IPString(GetClientIP(AndroidClient))+"|"+ReceiveString(AndroidClient)+"]"
  toggled()
  CreateThread(@receivedHandlerThread(), AndroidClient)
  Repeat
    Delay(AndroidInformationUpdateProtocollIntervall)
    If VibratorESP=1
     If FOVTarget<>-1
        If Entities(FOV_GetClosestEnemy())\fovdistance < 10
          SendNetworkString(AndroidClient,"vibrate"+#CRLF$, #PB_Ascii)
        EndIf
     EndIf
    EndIf
    If RemoteRadar=1
      CurrentRemoteRadarData.s=""
      CurrentRemoteRadarEntityAmount=0
      For x=0 To 31
        If x = LocalPlayerData\indexNum
          CurrentRemoteRadarData=CurrentRemoteRadarData+"|0|"+Str(GetXPosonRemoteRadarbyXPosinWorld(LocalPlayerData\pos[0]))+"|"+Str(GetYPosonRemoteRadarbyYPosinWorld(LocalPlayerData\pos[1]))
          CurrentRemoteRadarEntityAmount=CurrentRemoteRadarEntityAmount+1
        Else
          If Entities(x)\health > 0 And Entities(x)\dormant = 0
            If Entities(x)\team = LocalPlayerData\team
              CurrentRemoteRadarData=CurrentRemoteRadarData+"|1|"+Str(GetXPosonRemoteRadarbyXPosinWorld(Entities(x)\pos[0]))+"|"+Str(GetYPosonRemoteRadarbyYPosinWorld(Entities(x)\pos[1]))
            Else
              CurrentRemoteRadarData=CurrentRemoteRadarData+"|2|"+Str(GetXPosonRemoteRadarbyXPosinWorld(Entities(x)\pos[0]))+"|"+Str(GetYPosonRemoteRadarbyYPosinWorld(Entities(x)\pos[1]))
            EndIf
            CurrentRemoteRadarEntityAmount=CurrentRemoteRadarEntityAmount+1
          EndIf
        EndIf
      Next x
      If CurrentRemoteRadarData <> lastSentRemoteRadarData$
        SendNetworkString(AndroidClient, "radar|"+Str(CurrentRemoteRadarEntityAmount)+CurrentRemoteRadarData+#CRLF$)
        lastSentRemoteRadarData$=CurrentRemoteRadarData
      EndIf
    EndIf
  Until NetworkServerEvent(AndroidServerSocket)=#PB_NetworkEvent_Disconnect
  CurrentClient="No Client connected!"
  VibratorESP=0
  RemoteRadar=0
  toggled()
  If hiddenmode=1
    End
  EndIf
EndProcedure

Procedure.i WorldToScreen(Array world.f(1), Array screen.f(1))
  Protected width = ScreenWidth()
  Protected height = ScreenHeight()
		screen(0) = ViewMatrix(0) * world(0) + ViewMatrix(1) * world(1) + ViewMatrix(2) * world(2) + ViewMatrix(3);
		screen(1) = ViewMatrix(4) * world(0) + ViewMatrix(5) * world(1) + ViewMatrix(6) * world(2) + ViewMatrix(7);
		screen(2) = ViewMatrix(12) * world(0) + ViewMatrix(13) * world(1) + ViewMatrix(14) * world(2) + ViewMatrix(15);
		If screen(2) < 0.01 : ProcedureReturn 0 : EndIf
		screen(0) = screen(0) / screen(2)
		screen(1) = screen(1) / screen(2)
		screen(0) = width*0.5 + 0.5*screen(0)*width + 0.5
		screen(1) = height*0.5 - 0.5*screen(1)*height + 0.5
		ProcedureReturn 1
EndProcedure

Procedure ACSGOMH_3DViewer()
  Protected midx = ScreenWidth()*0.5
  Protected midy = ScreenHeight()*0.5
  
  Protected Dim tempworldvec.f(2)
  Protected Dim tempscreenvec.f(2)
  
  For x=0 To 15
    ViewMatrix(x)=ATPMemory::RPM_Float(hProc, ClientModuleBase + Offset_ViewMatrix + x*4) ;(could also replace that by e.g. reading it once via a struct/as an array)
  Next x
    
  WaitWindowEvent(1)
    
    StartDrawing(ScreenOutput())
    
    DrawingMode(#PB_2DDrawing_Outlined)
    ;DrawingFont(FontID(1))
    
    LineXY(midx-10, midy-10, midx+10, midy+10, RGB(100, 100, 255))
    LineXY(midx+10, midy-10, midx-10, midy+10, RGB(100, 100, 255))
    
    For x=0 To 31
      If Entities(x)\EntityBase <> 0 And Entities(x)\health > 0 And Entities(x)\dormant=0 And x <> LocalPlayerData\indexNum
        tempworldvec(0) = Entities(x)\pos[0]
        tempworldvec(1) = Entities(x)\pos[1]
        tempworldvec(2) = Entities(x)\pos[2]+65
        If WorldToScreen(tempworldvec(), tempscreenvec())
          If Entities(x)\team = LocalPlayerData\team
            Box(tempscreenvec(0)-10, tempscreenvec(1)-10, 20, 20, RGB(100, 255, 100))
          Else
            ;If BSP_IsVisible(LocalPlayerData\pos[0], LocalPlayerData\pos[1], LocalPlayerData\pos[2]+65, Entities(x)\pos[0], Entities(x)\pos[1], Entities(x)\pos[2])
              ;DrawText(tempscreenvec(0)+15, tempscreenvec(1)+25, "Visible", RGB(50, 50, 255))
            ;EndIf
            Box(tempscreenvec(0)-10, tempscreenvec(1)-10, 20, 20, RGB(255, 100, 100))
            DrawText(tempscreenvec(0)+15, tempscreenvec(1)-5, Entities(x)\lastplacename, RGB(255, 100, 100))
            DrawText(tempscreenvec(0)+15, tempscreenvec(1)+10, Str(Entities(x)\health) + "HP", RGB(255, 100, 100))
          EndIf
        EndIf
      EndIf
    Next x
    
    StopDrawing()
    
    FlipBuffers()
    ClearScreen(RGB(0, 0, 0))
    Delay(4)
EndProcedure

Procedure UpdateKeybindHandler()
  
    If GetAsyncKeyState_(KeyBind_ToggleRadar)&1
     If RadarState = 0
       RadarState = 1
     Else 
       RadarState = 0
     EndIf 
     toggled()
    EndIf 
    
    If GetAsyncKeyState_(KeyBind_ToggleTriggerbot)&1
     If TriggerState = 0
       TriggerState = 1
     Else 
       TriggerState = 0
     EndIf 
     toggled()
    EndIf 
    
    If GetAsyncKeyState_(KeyBind_ToggleAntiFlash)&1
     If AntiFlashState = 0
       AntiFlashState = 1
     Else 
       ATPMemory::WPM_Float(hProc, LocalPlayerBase + Offset_m_flFlashMaxAlpha, 255)
       AntiFlashState = 0
     EndIf 
     toggled()
    EndIf 
    
    If GetAsyncKeyState_(KeyBind_ToggleGlowESP)&1
      If GlowState = 0
        GlowState = 1
      Else 
        GlowState = 0
      EndIf 
      toggled()
    EndIf 
 
    If GetAsyncKeyState_(KeyBind_ToggleAimbot)&1
      If AimbotState = 0
        AimbotState = 1
      Else 
        AimbotState = 0
      EndIf 
      toggled()
    EndIf 
    
    If GetAsyncKeyState_(KeyBind_ToggleBhop)&1
      If BunnyHopState = 0
        BunnyHopState = 1
      Else 
        BunnyHopState = 0
      EndIf 
      toggled()
    EndIf
    
    If GetAsyncKeyState_(KeyBind_ToggleAntiAim)&1
      If AntiAimState = 0
        AntiAimState = 1
      Else 
        AntiAimState = 0
      EndIf 
      toggled()
    EndIf
    
    If GetAsyncKeyState_(KeyBind_ToggleExternalChams)&1
      If ExternalChamsState = 0
        ExternalChamsState = 1
      Else 
        ExternalChamsState = 0
      EndIf 
      toggled()
    EndIf 
    
    If GetAsyncKeyState_(KeyBind_ToggleSkinChanger)&1
      If SkinChangerState = 0
        SkinChangerState = 1
      Else 
        SkinChangerState = 0
      EndIf 
      toggled()
    EndIf
    
    If GetAsyncKeyState_(KeyBind_ToggleChatSpam)&1
      If ChatSpamState = 0
        ChatSpamState = 1
        ChatSpamThread=CreateThread(@ChatSpam(),0)
      Else 
        ChatSpamState = 0
        If IsThread(ChatSpamThread) : KillThread(ChatSpamThread) : EndIf
      EndIf 
      toggled()
    EndIf
    
    If GetAsyncKeyState_(KeyBind_ToggleAndroidController)&1
      If AndroidControllerState = 0
        AndroidControllerState = 1
        AndroidControllerThread=CreateThread(@AndroidController(),0)
      Else 
        AndroidControllerState = 0
        If IsThread(AndroidControllerThread) : KillThread(AndroidControllerThread) : EndIf
        If receivedHandlerThreadID<>0
          If IsThread(receivedHandlerThreadID) : KillThread(receivedHandlerThreadID) : EndIf
        EndIf
        CurrentClient="No Client connected!"
      EndIf 
      toggled()
    EndIf
    
    If GetAsyncKeyState_(#VK_0)&1
      CreateThread(@RankParser(), 0)
    EndIf
    
EndProcedure

Procedure SilentAimListener()
  If AimbotState=1
    If IsWeaponIDValid(LocalPlayerData\activeWeaponID)
      If SilentAimMode=0 And Aimbot_SilentAimState(LocalPlayerData\activeWeaponID)=1
          ClientCMD("unbind mouse1")
          SilentAimMode=1
      EndIf
      If SilentAimMode=1 And Aimbot_SilentAimState(LocalPlayerData\activeWeaponID)=0
          ClientCMD("bind mouse1 +attack")
          SilentAimMode=0
      EndIf
    Else
      If SilentAimMode=1
          ClientCMD("bind mouse1 +attack")
          SilentAimMode=0
      EndIf
    EndIf 
  Else
    If SilentAimMode=1
        ClientCMD("bind mouse1 +attack")
        SilentAimMode=0
    EndIf
  EndIf
EndProcedure

Procedure.s getCanvasDrawingData()
  CanvasScriptData.s=""
  CircleRadius=4
  For x=0 To 31
    If LocalPlayerData\indexNum = x
      xpos=GetXPosonRemoteRadarbyXPosinWorld(LocalPlayerData\pos[0])
      ypos=GetYPosonRemoteRadarbyYPosinWorld(LocalPlayerData\pos[1])
      CanvasScriptData = CanvasScriptData + #CRLF$ + "ctx.fillStyle='rgb(0, 200, 255)'";
			CanvasScriptData = CanvasScriptData + #CRLF$ + "ctx.beginPath();";
			CanvasScriptData = CanvasScriptData + #CRLF$ + "ctx.arc("+xpos+", "+ypos+", "+CircleRadius+", 0, 2*Math.PI);";
			CanvasScriptData = CanvasScriptData + #CRLF$ + "ctx.closePath();";
			CanvasScriptData = CanvasScriptData + #CRLF$ + "ctx.fill()";
			CanvasScriptData = CanvasScriptData + #CRLF$ + "ctx.stroke()";
    Else
      If Entities(x)\EntityBase <> 0 And Entities(x)\health > 0 And Entities(x)\dormant=0
        xpos=GetXPosonRemoteRadarbyXPosinWorld(Entities(x)\pos[0])
				ypos=GetYPosonRemoteRadarbyYPosinWorld(Entities(x)\pos[1])
        If Not (Entities(x)\team = LocalPlayerData\team)
          If Not IsEnemyVulnerable(x)
            CanvasScriptData = CanvasScriptData + #CRLF$ + "ctx.fillStyle='rgb(255, 0, 0)'";
          Else
            CanvasScriptData = CanvasScriptData + #CRLF$ + "ctx.fillStyle='rgb("+Red(Color_Vulnerable)+", "+Green(Color_Vulnerable)+", "+Blue(Color_Vulnerable)+")'";
          EndIf
        Else
          CanvasScriptData = CanvasScriptData + #CRLF$ + "ctx.fillStyle='rgb(0, 255, 0)'";
        EndIf
        CanvasScriptData = CanvasScriptData + #CRLF$ + "ctx.beginPath();";
				CanvasScriptData = CanvasScriptData + #CRLF$ + "ctx.arc("+xpos+", "+ypos+", "+CircleRadius+", 0, 2*Math.PI);";
				CanvasScriptData = CanvasScriptData + #CRLF$ + "ctx.fillText('"+WeaponList(getActiveWeaponIDofEntity(x))+"', "+Str(xpos+5)+", "+Str(ypos-5)+");";
				CanvasScriptData = CanvasScriptData + #CRLF$ + "ctx.fillText('"+Str(Entities(x)\health)+" HP', "+Str(xpos+5)+", "+Str(ypos+15)+");";
				CanvasScriptData = CanvasScriptData + #CRLF$ + "ctx.closePath();";
				CanvasScriptData = CanvasScriptData + #CRLF$ + "ctx.fill()";
				CanvasScriptData = CanvasScriptData + #CRLF$ + "ctx.stroke()";
      EndIf
    EndIf
  Next x
  ProcedureReturn CanvasScriptData
EndProcedure

Procedure WebRadarSever(nullptr.i)
  Protected currentWebRadar.s=""
  WebRadarBluePrint.s = URLtoString(#WebRadarBluePrint)
  WebServerReply_header.s = "HTTP/1.0 200 OK" + #CRLF$
  WebServerID = CreateNetworkServer(#PB_Any, 8080)
  Repeat
    ServerEvent=NetworkServerEvent(WebServerID)
    If ServerEvent=#PB_NetworkEvent_Data
      currentWebRadar=WebRadarBluePrint
      WebClient=EventClient()
      ;Debug IPString(GetClientIP(WebClient))
      ReceiveString(WebClient)
      currentWebRadar = ReplaceString(currentWebRadar, "----this----", getCanvasDrawingData())
      If Not currentMapName="de_dust2"
        currentWebRadar = ReplaceString(currentWebRadar, "de_dust2", currentMapName)
      EndIf
      SendNetworkString(WebClient, WebServerReply_header + #CRLF$ + currentWebRadar, #PB_Ascii)
      CloseNetworkConnection(WebClient)
    EndIf
    Delay(1)
  ForEver
EndProcedure

Procedure Setup_ACSGOMH_GUI_Window()
  For x=0 To 1
    AddGadgetItem(ACSGOMH_GUISettings_Aimbot_SmoothingType,-1, SmoothingTypes(x))
  Next x
  SetGadgetState(ACSGOMH_GUISettings_Aimbot_SmoothingType, 0)
  For x=0 To 8
    AddGadgetItem(ACSGOMH_GUISettings_Aimbot_TargetBone,-1, Bones(x))
  Next x
  SetGadgetState(ACSGOMH_GUISettings_Aimbot_TargetBone, 8)
  For x=0 To 33
    AddGadgetItem(ACSGOMH_GUISettings_Aimbot_TargetWeapon,-1, WeaponSelectList(x))
  Next x
  SetGadgetState(ACSGOMH_GUISettings_Aimbot_TargetWeapon, 0)
  For x=0 To 33
    AddGadgetItem(ACSGOMH_GUISettings_Triggerbot_TargetWeapon,-1, WeaponSelectList(x))
  Next x
  SetGadgetState(ACSGOMH_GUISettings_Triggerbot_TargetWeapon, 0)
  For x=0 To 48
    AddGadgetItem(ACSGOMH_GUISettings_SkinChanger_TargetWeapon,-1, WeaponSelectList(x))
  Next x
  SetGadgetState(ACSGOMH_GUISettings_SkinChanger_TargetWeapon, 1)
  For x=0 To 14
    AddGadgetItem(ACSGOMH_GUISettings_KnifeChanger_TargetKnife,-1, KnifeList(x))
  Next x
  SetGadgetState(ACSGOMH_GUISettings_KnifeChanger_TargetKnife, 4)
  For x=0 To 1
    AddGadgetItem(ACSGOMH_GUISettings_ChatSpam_ComboBoxGadget_Modus,-1, ChatSpamModi(x))
  Next x
  SetGadgetState(ACSGOMH_GUISettings_ChatSpam_ComboBoxGadget_Modus, 0)
EndProcedure

Procedure Get_ACSGOMH_GUI_Window_Settings()
  ChatSpam_TargetChatMode=GetGadgetState(ACSGOMH_GUISettings_ChatSpam_OptionGadget_Team)
  ChatSpam_Mode=GetGadgetState(ACSGOMH_GUISettings_ChatSpam_ComboBoxGadget_Modus)
  GlowState=GetGadgetState(ACSGOMH_GUISettings_Wallhack)
  ExternalChamsState=GetGadgetState(ACSGOMH_GUISettings_Wallhack_ExternalChams)
  TeamCheckState=GetGadgetState(ACSGOMH_GUISettings_Wallhack_TeamESP)
  HealthBased=GetGadgetState(ACSGOMH_GUISettings_Wallhack_HealthESP)
  WH_highlight_vulnerable=GetGadgetState(ACSGOMH_GUISettings_Wallhack_VulnerableESP)
  Glow_WeaponESP=GetGadgetState(ACSGOMH_GUISettings_GlowESP_Weapons)
  Glow_GrenadeESP=GetGadgetState(ACSGOMH_GUISettings_GlowESP_Grenades)
  Glow_ChickenESP=GetGadgetState(ACSGOMH_GUISettings_GlowESP_Chickens)
  Glow_BombESP=GetGadgetState(ACSGOMH_GUISettings_GlowESP_Bombs)
  RadarState=GetGadgetState(ACSGOMH_GUISettings_Radarhack)
  BunnyHopState=GetGadgetState(ACSGOMH_GUISettings_Bunnyhop)
  TriggerState=GetGadgetState(ACSGOMH_GUISettings_Triggerbot)
  ZeusTriggerState=GetGadgetState(ACSGOMH_GUISettings_ZeusTrigger)
  If GetGadgetState(ACSGOMH_GUISettings_Antiflash) <> AntiFlashState
    AntiFlashState=GetGadgetState(ACSGOMH_GUISettings_Antiflash)
    If AntiFlashState = 0
      ATPMemory::WPM_Float(hProc, LocalPlayerBase + Offset_m_flFlashMaxAlpha, 255)
    EndIf
  EndIf
  If TS3CalloutState <> GetGadgetState(ACSGOMH_GUISettings_TS3Callout)
    TS3CalloutState=GetGadgetState(ACSGOMH_GUISettings_TS3Callout)
    If TS3CalloutState = 1
      TS3CalloutThread=CreateThread(@TS3Callout(),0)
    Else
      KillThread(TS3CalloutThread)
    EndIf
  EndIf
  If ChatSpamState <> GetGadgetState(ACSGOMH_GUISettings_ChatSpam)
    ChatSpamState=GetGadgetState(ACSGOMH_GUISettings_ChatSpam)
    If ChatSpamState = 1
      ChatSpamThread=CreateThread(@ChatSpam(),0)
    Else
      KillThread(ChatSpamThread)
    EndIf
  EndIf
  If FakeLagOnDelay <> Val(GetGadgetText(ACSGOMH_GUISettings_FakeLag_StringGadget_Delay_On))
    FakeLagOnDelay=Val(GetGadgetText(ACSGOMH_GUISettings_FakeLag_StringGadget_Delay_On))
  EndIf
  If FakeLagOffDelay <> Val(GetGadgetText(ACSGOMH_GUISettings_FakeLag_StringGadget_Delay_Off))
    FakeLagOffDelay=Val(GetGadgetText(ACSGOMH_GUISettings_FakeLag_StringGadget_Delay_Off))
  EndIf
  If FakeLagState <> GetGadgetState(ACSGOMH_GUISettings_FakeLag)
    FakeLagState=GetGadgetState(ACSGOMH_GUISettings_FakeLag)
    If FakeLagState = 1
      FakeLagThread=CreateThread(@FakeLag(),0)
    Else
      KillThread(FakeLagThread)
      SetSendPacket(1)
    EndIf
  EndIf
  If ACSGOMH_3DViewerState <> GetGadgetState(ACSGOMH_GUISettings_3DViewer)
    ACSGOMH_3DViewerState=GetGadgetState(ACSGOMH_GUISettings_3DViewer)
    If ACSGOMH_3DViewerState = 1
      OpenWindow(0, 10, 10, 800, 600, CheatName+"-3DViewer")
      OpenWindowedScreen(WindowID(0), 0, 0, 800, 600)
    Else
      CloseScreen()
      CloseWindow(0)
    EndIf
  EndIf
  AntiAimState=GetGadgetState(ACSGOMH_GUISettings_AntiAim)
  SkinChangerState=GetGadgetState(ACSGOMH_GUISettings_SkinChanger)
  KnifeChangerState=GetGadgetState(ACSGOMH_GUISettings_KnifeChanger)
  currentKnifeModelIndex=GetGadgetState(ACSGOMH_GUISettings_KnifeChanger_TargetKnife)
  AutoForceFullUpdate=GetGadgetState(ACSGOMH_GUISettings_KnifeChanger_AutoForceUpdate)
  SyncWithCSGOTickRate=GetGadgetState(ACSGOMH_GUISettings_SyncTickRate)
  If NoHandsState <> GetGadgetState(ACSGOMH_GUISettings_NoHands)
    NoHandsState=GetGadgetState(ACSGOMH_GUISettings_NoHands)
    ForceFullUpdate()
  EndIf
  AimbotState=GetGadgetState(ACSGOMH_GUISettings_Aimbot)
  FOVChangerFOVvalue=GetGadgetState(ACSGOMH_GUISettings_FOVChanger_SliderFOV)
   If FOVChangerFOVvalue <> 90
     FOVChangerState = 1
   Else
     FOVChangerState = 0
   EndIf
  If GetGadgetText(ACSGOMH_GUISettings_Aimbot_SliderFOVDisplay) <> Str(Aimbot_maxFov(Aimbot_SelectedWeapon))+"°"
    SetGadgetText(ACSGOMH_GUISettings_Aimbot_SliderFOVDisplay, Str(Aimbot_maxFov(Aimbot_SelectedWeapon))+"°")
  EndIf
  If Aimbot_SmoothingType(Aimbot_SelectedWeapon)=0
    If GetGadgetText(ACSGOMH_GUISettings_Aimbot_SliderLSFDisplay) <> Str(Aimbot_SmoothFac(Aimbot_SelectedWeapon)*100)+"%"
      SetGadgetText(ACSGOMH_GUISettings_Aimbot_SliderLSFDisplay, Str(Aimbot_SmoothFac(Aimbot_SelectedWeapon)*100)+"%")
    EndIf
  Else
    If GetGadgetText(ACSGOMH_GUISettings_Aimbot_SliderLSFDisplay) <> Str(Aimbot_SmoothFac(Aimbot_SelectedWeapon)*100)+"°"
      SetGadgetText(ACSGOMH_GUISettings_Aimbot_SliderLSFDisplay, Str(Aimbot_SmoothFac(Aimbot_SelectedWeapon)*100)+"°")
    EndIf
  EndIf
  If GetGadgetText(ACSGOMH_GUISettings_FOVChanger_SliderFOVDisplay) <> Str(FOVChangerFOVvalue)+"°"
    SetGadgetText(ACSGOMH_GUISettings_FOVChanger_SliderFOVDisplay, Str(FOVChangerFOVvalue)+"°")
  EndIf
  If Aimbot_SelectedWeapon <> getWeaponListIndexbySelectedWeaponListIndex(GetGadgetState(ACSGOMH_GUISettings_Aimbot_TargetWeapon))
    Aimbot_SelectedWeapon=getWeaponListIndexbySelectedWeaponListIndex(GetGadgetState(ACSGOMH_GUISettings_Aimbot_TargetWeapon))
    SetGadgetState(ACSGOMH_GUISettings_Aimbot_OnAimKey, Aimbot_AimKey(Aimbot_SelectedWeapon))
    SetGadgetState(ACSGOMH_GUISettings_Aimbot_TargetBone, Aimbot_TargetBone(Aimbot_SelectedWeapon))
    SetGadgetState(ACSGOMH_GUISettings_Aimbot_SmoothingType, Aimbot_SmoothingType(Aimbot_SelectedWeapon))
    SetGadgetState(ACSGOMH_GUISettings_Aimbot_FOVBased, Aimbot_FOVBased(Aimbot_SelectedWeapon))
    SetGadgetState(ACSGOMH_GUISettings_Aimbot_FriendlyFire, Aimbot_FriendlyFire(Aimbot_SelectedWeapon))
    SetGadgetState(ACSGOMH_GUISettings_Aimbot_VisibilityCheck, Aimbot_VisibilityCheck(Aimbot_SelectedWeapon))
    SetGadgetState(ACSGOMH_GUISettings_Aimbot_SilentAim, Aimbot_SilentAimState(Aimbot_SelectedWeapon))
    SetGadgetState(ACSGOMH_GUISettings_Aimbot_SliderFOV, Aimbot_maxFov(Aimbot_SelectedWeapon))
    SetGadgetState(ACSGOMH_GUISettings_Aimbot_SliderLSF, Aimbot_SmoothFac(Aimbot_SelectedWeapon)*100)
    SetGadgetState(ACSGOMH_GUISettings_AimSettings_enableAimbot, Aimbot_enabled(Aimbot_SelectedWeapon))
  EndIf
  Aimbot_AimKey(Aimbot_SelectedWeapon)=GetGadgetState(ACSGOMH_GUISettings_Aimbot_OnAimKey)
  Aimbot_TargetBone(Aimbot_SelectedWeapon)=GetGadgetState(ACSGOMH_GUISettings_Aimbot_TargetBone)
  Aimbot_SmoothingType(Aimbot_SelectedWeapon)=GetGadgetState(ACSGOMH_GUISettings_Aimbot_SmoothingType)
  Aimbot_FOVBased(Aimbot_SelectedWeapon)=GetGadgetState(ACSGOMH_GUISettings_Aimbot_FOVBased)
  Aimbot_FriendlyFire(Aimbot_SelectedWeapon)=GetGadgetState(ACSGOMH_GUISettings_Aimbot_FriendlyFire)
  Aimbot_VisibilityCheck(Aimbot_SelectedWeapon)=GetGadgetState(ACSGOMH_GUISettings_Aimbot_VisibilityCheck)
  Aimbot_SilentAimState(Aimbot_SelectedWeapon)=GetGadgetState(ACSGOMH_GUISettings_Aimbot_SilentAim)
  Aimbot_maxFov(Aimbot_SelectedWeapon)=GetGadgetState(ACSGOMH_GUISettings_Aimbot_SliderFOV)
  Aimbot_SmoothFac(Aimbot_SelectedWeapon)=GetGadgetState(ACSGOMH_GUISettings_Aimbot_SliderLSF)/100
  Aimbot_enabled(Aimbot_SelectedWeapon)=GetGadgetState(ACSGOMH_GUISettings_AimSettings_enableAimbot)
  If Triggerbot_SelectedWeapon <> getWeaponListIndexbySelectedWeaponListIndex(GetGadgetState(ACSGOMH_GUISettings_Triggerbot_TargetWeapon))
    Triggerbot_SelectedWeapon = getWeaponListIndexbySelectedWeaponListIndex(GetGadgetState(ACSGOMH_GUISettings_Triggerbot_TargetWeapon))
    SetGadgetState(ACSGOMH_GUISettings_TriggerSettings_enableTriggerbot, Triggerbot_enabled(Triggerbot_SelectedWeapon))
    SetGadgetState(ACSGOMH_GUISettings_Triggerbot_Burst, Triggerbot_Burst(Triggerbot_SelectedWeapon))
    SetGadgetState(ACSGOMH_GUISettings_Triggerbot_SliderDelay, Triggerbot_Delay(Triggerbot_SelectedWeapon))
  EndIf
  Triggerbot_enabled(Triggerbot_SelectedWeapon)=GetGadgetState(ACSGOMH_GUISettings_TriggerSettings_enableTriggerbot)
  Triggerbot_Burst(Triggerbot_SelectedWeapon)=GetGadgetState(ACSGOMH_GUISettings_Triggerbot_Burst)
  Triggerbot_Delay(Triggerbot_SelectedWeapon)=GetGadgetState(ACSGOMH_GUISettings_Triggerbot_SliderDelay)
  If GetGadgetText(ACSGOMH_GUISettings_Triggerbot_SliderDelay_Display) <> Str(Triggerbot_Delay(Triggerbot_SelectedWeapon))+"ms"
    SetGadgetText(ACSGOMH_GUISettings_Triggerbot_SliderDelay_Display, Str(Triggerbot_Delay(Triggerbot_SelectedWeapon))+"ms")
  EndIf
  If SkinChanger_SelectedWeapon <> getWeaponListIndexbySelectedWeaponListIndex(GetGadgetState(ACSGOMH_GUISettings_SkinChanger_TargetWeapon))
    SkinChanger_SelectedWeapon=getWeaponListIndexbySelectedWeaponListIndex(GetGadgetState(ACSGOMH_GUISettings_SkinChanger_TargetWeapon))
    SetGadgetText(ACSGOMH_GUISettings_SkinChanger_StringGadget_NameTag, WeaponSkins(SkinChanger_SelectedWeapon)\name)
    SetGadgetText(ACSGOMH_GUISettings_SkinChanger_StringGadget_SkinID, Str(WeaponSkins(SkinChanger_SelectedWeapon)\pkit))
    SetGadgetText(ACSGOMH_GUISettings_SkinChanger_StringGadget_Pattern, Str(WeaponSkins(SkinChanger_SelectedWeapon)\seed))
    SetGadgetText(ACSGOMH_GUISettings_SkinChanger_StringGadget_Wear, StrF(WeaponSkins(SkinChanger_SelectedWeapon)\wear))
    If WeaponSkins(SkinChanger_SelectedWeapon)\stattrak = -1
      SetGadgetState(ACSGOMH_GUISettings_SkinChanger_Stattrak, 0)
    Else
      SetGadgetState(ACSGOMH_GUISettings_SkinChanger_Stattrak, 1)
    EndIf
  EndIf
  If GetGadgetState(ACSGOMH_GUI_Button_SkinChanger)
    WeaponSkins(SkinChanger_SelectedWeapon)\pkit=Val(GetGadgetText(ACSGOMH_GUISettings_SkinChanger_StringGadget_SkinID))
    WeaponSkins(SkinChanger_SelectedWeapon)\seed=Val(GetGadgetText(ACSGOMH_GUISettings_SkinChanger_StringGadget_Pattern))
    If GetGadgetState(ACSGOMH_GUISettings_SkinChanger_Stattrak)
      WeaponSkins(SkinChanger_SelectedWeapon)\stattrak=1337
    Else
      WeaponSkins(SkinChanger_SelectedWeapon)\stattrak=-1
    EndIf
    WeaponSkins(SkinChanger_SelectedWeapon)\wear=ValF(GetGadgetText(ACSGOMH_GUISettings_SkinChanger_StringGadget_Wear))
    WeaponSkins(SkinChanger_SelectedWeapon)\name=GetGadgetText(ACSGOMH_GUISettings_SkinChanger_StringGadget_NameTag)
    SetGadgetState(ACSGOMH_GUI_Button_SkinChanger,0)
  EndIf
  If GetGadgetState(ACSGOMH_GUI_Button_RankParser)
    CreateThread(@RankParser(),0)
    SetGadgetState(ACSGOMH_GUI_Button_RankParser, 0)
  EndIf
  KeybindHandlerState=GetGadgetState(ACSGOMH_GUISettings_KeyBindHandler)
  If WebRadarState <> GetGadgetState(ACSGOMH_GUISettings_WebRadar)
    WebRadarState=GetGadgetState(ACSGOMH_GUISettings_WebRadar)
    If WebRadarState=1
      WebRadarThread=CreateThread(@WebRadarSever(),0)
    Else
      KillThread(WebRadarThread)
      CloseNetworkServer(WebServerID)
    EndIf
  EndIf
  If GetGadgetState(ACSGOMH_GUI_Button_Config_Load)
    LoadConfigFile()
    SetGadgetState(ACSGOMH_GUI_Button_Config_Load, 0)
  EndIf
  If GetGadgetState(ACSGOMH_GUI_Button_Config_Save)
    SaveConfigFile()
    SetGadgetState(ACSGOMH_GUI_Button_Config_Save, 0)
  EndIf
  If GetGadgetState(ACSGOMH_GUI_Button_GitHub)
    RunProgram(#GitHubURL$)
    SetGadgetState(ACSGOMH_GUI_Button_GitHub, 0)
  EndIf
  If GetGadgetState(ACSGOMH_GUI_Button_EditKeybinds)
    OpenACSGOMH_Keybinds()
    Set_ACSGOMH_KeyBinds_GUI_Window_Settings()
    SetWindowTitle(ACSGOMH_Keybinds, CheatName + "- Keybinds")
    Repeat
      ACSGOMH_Keybinds_GUI_Event=WindowEvent()
      If GetGadgetState(ACSGOMH_Keybinds_Buttons_AimKey) : KeyBind_AimKey=GetNextPushedKeyID() : SetGadgetState(ACSGOMH_Keybinds_Buttons_AimKey, 0) : EndIf
      If GetGadgetState(ACSGOMH_Keybinds_Buttons_TriggerKey) : KeyBind_TriggerKey=GetNextPushedKeyID() : SetGadgetState(ACSGOMH_Keybinds_Buttons_TriggerKey, 0) : EndIf
      If GetGadgetState(ACSGOMH_Keybinds_Buttons_Radar) : KeyBind_ToggleRadar=GetNextPushedKeyID() : SetGadgetState(ACSGOMH_Keybinds_Buttons_Radar, 0) : EndIf
      If GetGadgetState(ACSGOMH_Keybinds_Buttons_Bunnyhop) : KeyBind_ToggleBhop=GetNextPushedKeyID() : SetGadgetState(ACSGOMH_Keybinds_Buttons_Bunnyhop, 0) : EndIf
      If GetGadgetState(ACSGOMH_Keybinds_Buttons_AntiFlash) : KeyBind_ToggleAntiFlash=GetNextPushedKeyID() : SetGadgetState(ACSGOMH_Keybinds_Buttons_AntiFlash, 0) : EndIf
      If GetGadgetState(ACSGOMH_Keybinds_Buttons_ChatSpam) : KeyBind_ToggleChatSpam=GetNextPushedKeyID() : SetGadgetState(ACSGOMH_Keybinds_Buttons_ChatSpam, 0) : EndIf
      If GetGadgetState(ACSGOMH_Keybinds_Buttons_Wallhack) : KeyBind_ToggleGlowESP=GetNextPushedKeyID() : SetGadgetState(ACSGOMH_Keybinds_Buttons_Wallhack, 0) : EndIf
      If GetGadgetState(ACSGOMH_Keybinds_Buttons_ExternalChams) : KeyBind_ToggleExternalChams=GetNextPushedKeyID() : SetGadgetState(ACSGOMH_Keybinds_Buttons_ExternalChams, 0) : EndIf
      If GetGadgetState(ACSGOMH_Keybinds_Buttons_AndroidController) : KeyBind_ToggleAndroidController=GetNextPushedKeyID() : SetGadgetState(ACSGOMH_Keybinds_Buttons_AndroidController, 0) : EndIf
      If GetGadgetState(ACSGOMH_Keybinds_Buttons_AntiAim) : KeyBind_ToggleAntiAim=GetNextPushedKeyID() : SetGadgetState(ACSGOMH_Keybinds_Buttons_AntiAim, 0) : EndIf
      If GetGadgetState(ACSGOMH_Keybinds_Buttons_Aimbot) : KeyBind_ToggleAimbot=GetNextPushedKeyID() : SetGadgetState(ACSGOMH_Keybinds_Buttons_Aimbot, 0) : EndIf
      If GetGadgetState(ACSGOMH_Keybinds_Buttons_Triggerbot) : KeyBind_ToggleTriggerbot=GetNextPushedKeyID() : SetGadgetState(ACSGOMH_Keybinds_Buttons_Triggerbot, 0) : EndIf
      If GetGadgetState(ACSGOMH_Keybinds_Buttons_SkinChanger) : KeyBind_ToggleSkinChanger=GetNextPushedKeyID() : SetGadgetState(ACSGOMH_Keybinds_Buttons_SkinChanger, 0) : EndIf
      If GetGadgetState(ACSGOMH_Keybinds_Buttons_ForceUpdate) : KeyBind_ForceUpdate=GetNextPushedKeyID() : SetGadgetState(ACSGOMH_Keybinds_Buttons_ForceUpdate, 0) : EndIf
      Set_ACSGOMH_KeyBinds_GUI_Window_Settings()
    Until ACSGOMH_Keybinds_GUI_Event=#PB_Event_CloseWindow
    CloseWindow(ACSGOMH_Keybinds)
    SetGadgetState(ACSGOMH_GUI_Button_EditKeybinds, 0)
  EndIf
  If GetGadgetState(ACSGOMH_GUI_Button_EditColors)
    OpenACSGOMH_Colors()
    Set_ACSGOMH_Colors_GUI_Window_Settings()
    SetWindowTitle(ACSGOMH_Colors, CheatName + " - Colors")
    Repeat
      ACSGOMH_Colors_GUI_Event=WindowEvent()
      If GetGadgetState(ACSGOMH_Colors_ButtonImage_Bomb) : Color_Glow_Bomb=AdjustButtonImage(ACSGOMH_Colors_Image_Bomb) : SetGadgetState(ACSGOMH_Colors_ButtonImage_Bomb, 0) : EndIf
      If GetGadgetState(ACSGOMH_Colors_ButtonImage_Chicken) : Color_Glow_Chicken=AdjustButtonImage(ACSGOMH_Colors_Image_Chicken) : SetGadgetState(ACSGOMH_Colors_ButtonImage_Chicken, 0) : EndIf
      If GetGadgetState(ACSGOMH_Colors_ButtonImage_Grenade) : Color_Glow_Grenade=AdjustButtonImage(ACSGOMH_Colors_Image_Grenade) : SetGadgetState(ACSGOMH_Colors_ButtonImage_Grenade, 0) : EndIf
      If GetGadgetState(ACSGOMH_Colors_ButtonImage_Weapon) : Color_Glow_Weapon=AdjustButtonImage(ACSGOMH_Colors_Image_Weapon) : SetGadgetState(ACSGOMH_Colors_ButtonImage_Weapon, 0) : EndIf
      If GetGadgetState(ACSGOMH_Colors_ButtonImage_Vulnerable) : Color_Vulnerable=AdjustButtonImage(ACSGOMH_Colors_Image_Vulnerable) : SetGadgetState(ACSGOMH_Colors_ButtonImage_Vulnerable, 0) : EndIf
    Until ACSGOMH_Colors_GUI_Event=#PB_Event_CloseWindow
    CloseWindow(ACSGOMH_Colors)
    SetGadgetState(ACSGOMH_GUI_Button_EditColors, 0)
  EndIf
  If GetGadgetState(ACSGOMH_GUI_Button_SkinChanger_ImportByInspectLink)
    inspecturl$=InputRequester(CheatName, "Enter the Inspect URL:", "")
    If Not inspecturl$=""
      response$=URLtoString("https://api.csgofloat.com:1738/?url="+inspecturl$)
      Debug response$
      If CountString(response$, "floatvalue")
        itemdefinitionindex = Val(StringField(StringField(response$,2,Chr(34)+"defindex"+Chr(34)+":"),1,","+Chr(34)+"paintindex"+Chr(34)+":"))
        WeaponSkins(itemdefinitionindex)\pkit = Val(StringField(StringField(response$,2,Chr(34)+"paintindex"+Chr(34)+":"),1,","+Chr(34)+"rarity"+Chr(34)+":"))
        WeaponSkins(itemdefinitionindex)\wear = ValF(StringField(StringField(response$,2,Chr(34)+"floatvalue"+Chr(34)+":"),1,","+Chr(34)+"itemid_int"+Chr(34)+":"))
        WeaponSkins(itemdefinitionindex)\seed = Val(StringField(StringField(response$,2,Chr(34)+"paintseed"+Chr(34)+":"),1,","+Chr(34)+"killeaterscoretype"+Chr(34)+":"))
        stattrak$ = StringField(StringField(response$,2,Chr(34)+"killeatervalue"+Chr(34)+":"),1,","+Chr(34)+"customname"+Chr(34)+":")
        If stattrak$="null"
	        stattrak$="-1"
	      EndIf
	      WeaponSkins(itemdefinitionindex)\stattrak = Val(stattrak$)
	      customname$ = StringField(StringField(response$,2,Chr(34)+"customname"+Chr(34)+":"),1,","+Chr(34)+"stickers"+Chr(34)+":")
	      If Not customname$="null"
	        WeaponSkins(itemdefinitionindex)\name = customname$
	      EndIf
	      ForceFullUpdate()
      EndIf
    EndIf
    SetGadgetState(ACSGOMH_GUI_Button_SkinChanger_ImportByInspectLink, 0)
  EndIf
EndProcedure

Procedure WaitForNextTick()
  minExpiredMilliseconds=0
  lastTick=ATPMemory::RPM(hProc, LocalPlayerState+$4CAC)
  Repeat
    Delay(1)
    minExpiredMilliseconds+1
    currentTick=ATPMemory::RPM(hProc, LocalPlayerState+$4CAC)
  Until (Not lastTick=currentTick) Or minExpiredMilliseconds = 20
EndProcedure

;----------------SigScanTest----------------
Global FinishedScanThreads.i=0

Structure SIGSCANDATA
  modulename.s
  extra.i
  offset.i
  signature.s
  offsetpointer.i
  fRead.b
  fSubstract.b
EndStructure

Global Dim sigs.SIGSCANDATA(14)

Procedure SetSigScanData(*currentsig.SIGSCANDATA, offsetpointer.i, modulename.s, extra.i, offset.i, signature.s, fRead.b=1, fSubstract.b=1)
  *currentsig\modulename=modulename
  *currentsig\extra=extra
  *currentsig\offset=offset
  *currentsig\signature=signature
  *currentsig\offsetpointer=offsetpointer
  *currentsig\fRead=fRead
  *currentsig\fSubstract=fSubstract
EndProcedure

;---SigCloud---

Procedure.s minify(text.s)
  ProcedureReturn RemoveString(RemoveString(RemoveString(text, Chr(9)), Chr(10)), Chr(13))
EndProcedure

Procedure getVarPointerbyVarName(VarName.s)
  Select VarName
    Case "Offset_ClientCMD"
      ProcedureReturn @Offset_ClientCMD
    Case "Offset_BaseLocalPlayerCMO"
      ProcedureReturn @Offset_BaseLocalPlayerCMO
    Case "Offset_EnginePointer"
      ProcedureReturn @Offset_EnginePointer
    Case "Offset_EntityBase"
      ProcedureReturn @Offset_EntityBase
    Case "Offset_PlayerResourcePointer"
      ProcedureReturn @Offset_PlayerResourcePointer
    Case "Offset_RadarBasePtr"
      ProcedureReturn @Offset_RadarBasePtr
    Case "Offset_glowObjectManager"
      ProcedureReturn @Offset_glowObjectManager
    Case "Offset_ForceJump"
      ProcedureReturn @Offset_ForceJump
    Case "Offset_ForceAttack"
      ProcedureReturn @Offset_ForceAttack
    Case "Offset_Input"
      ProcedureReturn @Offset_Input
    Case "Offset_bSendPacket"
      ProcedureReturn @Offset_bSendPacket
    Case "Offset_ViewMatrix"
      ProcedureReturn @Offset_ViewMatrix
    Case "Offset_m_LocalPlayerIndex"
      ProcedureReturn @Offset_m_LocalPlayerIndex
    Case "Offset_ViewAngles"
      ProcedureReturn @Offset_ViewAngles
    Case "Offset_SteamID"
      ProcedureReturn @Offset_SteamID
    Case "Offset_GameDir"
      ProcedureReturn @Offset_GameDir
  EndSelect
EndProcedure

Procedure SyncCloudSignatures()

SigList.s=minify(URLtoString(#SigCloudURL$))
SigsAmount.i=CountString(SigList, ";")

For x=1 To SigsAmount
  sc_currententry.s=StringField(SigList, x, ";")
  sc_varname.s=StringField(sc_currententry, 1, ":")
  sc_params.s=StringField(sc_currententry, 2, ":")
  sc_params_module.s=StringField(StringField(sc_params, 1, ","), 2, Chr(34))
  sc_params_extra=Val(ReplaceString(StringField(sc_params, 2, ","), "0x", "$"))
  sc_params_offset=Val(ReplaceString(StringField(sc_params, 3, ","), "0x", "$"))
  sc_params_signature.s=StringField(StringField(sc_params, 4, ","), 2, Chr(34))
  sc_params_fRead=bStringtobValue(StringField(sc_params, 5, ","))
  sc_params_fSubstract=bStringtobValue(StringField(sc_params, 6, ","))
  SetSigScanData(sigs(x-1), getVarPointerbyVarName(sc_varname), sc_params_module, sc_params_extra, sc_params_offset, sc_params_signature, sc_params_fRead, sc_params_fSubstract)
Next x

EndProcedure

SyncCloudSignatures()

;---SigCloud---


Procedure ScanThread(*currentsig.SIGSCANDATA)
  PokeI(*currentsig\offsetpointer, ATPMemory::ScanSignature(hProc, processId, *currentsig\modulename, *currentsig\extra, *currentsig\offset, *currentsig\signature, *currentsig\fRead, *currentsig\fSubstract))
  FinishedScanThreads+1
EndProcedure

; SetSigScanData(sigs(0), @Offset_ClientCMD, "engine.dll", 0, 0, "55 8B EC 8B ? ? ? ? ? 81 F9 ? ? ? ? 75 0C A1 ? ? ? ? 35 ? ? ? ? EB 05 8B 01 FF 50 34 50 A1", 0)
; SetSigScanData(sigs(1), @Offset_BaseLocalPlayerCMO, "client_panorama.dll", 1, $10, "A3 ? ? ? ? C7 05 ? ? ? ? ? ? ? ? E8 ? ? ? ? 59 C3 6A ?")
; SetSigScanData(sigs(2), @Offset_EnginePointer, "engine.dll", 2, 0, "8B 3D ? ? ? ? 8A F9")
; SetSigScanData(sigs(3), @Offset_EntityBase, "client_panorama.dll", 1, 0, "BB ? ? ? ? 83 FF 01 0F 8C ? ? ? ? 3B F8")
; SetSigScanData(sigs(4), @Offset_PlayerResourcePointer, "client_panorama.dll", 2, 0, "8B 3D ? ? ? ? 85 FF 0F 84 ? ? ? ? 81 C7")
; SetSigScanData(sigs(5), @Offset_RadarBasePtr, "client_panorama.dll", 1, 0, "A1 ? ? ? ? 8B 0C B0 8B 01 FF 50 ? 46 3B 35 ? ? ? ? 7C EA 8B 0D")
; SetSigScanData(sigs(6), @Offset_glowObjectManager, "client_panorama.dll", 1, 4, "A1 ? ? ? ? A8 01 75 4B")
; SetSigScanData(sigs(7), @Offset_ForceJump, "client_panorama.dll", 2, 0, "89 0D ? ? ? ? 8B 0D ? ? ? ? 8B F2 8B C1 83 CE 08")
; SetSigScanData(sigs(8), @Offset_ForceAttack, "client_panorama.dll", 2, 0, "89 0D ? ? ? ? 8B 0D ? ? ? ? 8B F2 8B C1 83 CE 04")
; SetSigScanData(sigs(9), @Offset_Input, "client_panorama.dll", 1, 0, "B9 ? ? ? ? F3 0F 11 04 24 FF 50 10")
; SetSigScanData(sigs(10), @Offset_bSendPacket, "engine.dll", 1, 0, "B3 01 8B 01 8B 40 10 FF D0 84 C0 74 0F 80 BF ? ? ? ? ? 0F 84")
; SetSigScanData(sigs(11), @Offset_ViewMatrix, "client_panorama.dll", 3, $B0, "0F 10 05 ? ? ? ? 8D 85 ? ? ? ? B9")
; SetSigScanData(sigs(12), @Offset_m_LocalPlayerIndex, "engine.dll", 2, 0, "8B 80 ? ? ? ? 40 C3", 1, 0)
; SetSigScanData(sigs(13), @Offset_ViewAngles, "engine.dll", 4, 0, "F3 0F 11 80 ? ? ? ? D9 46 04 D9 05", 1, 0)
; SetSigScanData(sigs(14), @Offset_GameDir, "engine.dll", 1, 0, "68 ? ? ? ? 8D 85 ? ? ? ? 50 68 ? ? ? ? 68")
; SetSigScanData(sigs(15), @Offset_SteamID, "client_panorama.dll", 0, 0, "37 36 35 ? ? ? ? 38 33 37 32 39 36 39 33 34 36", 0, 1)

Procedure ScanSignatures()
  If hiddenmode=0
    OpenACSGOMH_LoadingScreen(MainDesktop_Screen_Width-(470), 20)
    SetWindowTitle(ACSGOMH_LoadingScreen, CheatName + " - SigScanning")
    StickyWindow(ACSGOMH_LoadingScreen, #True)
  EndIf
  st=ElapsedMilliseconds()
  
  For x=0 To 14
    CreateThread(@ScanThread(), sigs(x))
  Next x
  
  Repeat
    Delay(1)
    If hiddenmode=0
      If GetGadgetState(ACSGOMH_LoadingScreen_ProgressBar) <> FinishedScanThreads
        SetGadgetState(ACSGOMH_LoadingScreen_ProgressBar, FinishedScanThreads)
      EndIf
      WindowEvent()
    EndIf
  Until FinishedScanThreads=15
  
  Debug "0x"+Hex(Offset_ClientCMD)
  Debug "0x"+Hex(Offset_BaseLocalPlayerCMO)
  Debug "0x"+Hex(Offset_EnginePointer)
  Debug "0x"+Hex(Offset_EntityBase)
  Debug "0x"+Hex(Offset_PlayerResourcePointer)
  Debug "0x"+Hex(Offset_RadarBasePtr)
  Debug "0x"+Hex(Offset_glowObjectManager)
  Debug "0x"+Hex(Offset_ForceJump)
  Debug "0x"+Hex(Offset_ForceAttack)
  Debug "0x"+Hex(Offset_Input)
  Debug "0x"+Hex(Offset_bSendPacket)
  Debug "0x"+Hex(Offset_ViewMatrix)
  Debug "0x"+Hex(Offset_m_LocalPlayerIndex)
  Debug "0x"+Hex(Offset_ViewAngles)
  Debug "0x"+Hex(Offset_GameDir)
  ;Debug "0x"+Hex(Offset_SteamID)
  
  Debug "Scantime:"+Str(ElapsedMilliseconds()-st)+"ms"
  If hiddenmode=0
    CloseWindow(ACSGOMH_LoadingScreen)
  EndIf
EndProcedure
;----------------SigScanTest----------------

ScanSignatures()

SetUpWeaponConfig()
SetUpSkins()

GameDirectory=ATPMemory::RPM_String(hProc, EngineModuleBase+Offset_GameDir, 255)
RadarStructBase=ATPMemory::RPM(hProc, ATPMemory::RPM(hProc, ClientModuleBase+Offset_RadarBasePtr)+Offset_RadarStructPtr)

Procedure ParseOverview(MapName.s)
  ReadFile(0, GameDirectory+"\resource\overviews\"+MapName+".txt")
  Protected content.s=minify(ReadString(0, #PB_Ascii|#PB_File_IgnoreEOL))
  CloseFile(0)
  MapData(MapName)\pos_x=ValF(StringField(StringField(content, 2, Chr(34)+"pos_x"+Chr(34)+Chr(34)), 1, Chr(34)))
  MapData(MapName)\pos_y=ValF(StringField(StringField(content, 2, Chr(34)+"pos_y"+Chr(34)+Chr(34)), 1, Chr(34)))
  MapData(MapName)\scale=ValF(StringField(StringField(content, 2, Chr(34)+"scale"+Chr(34)+Chr(34)), 1, Chr(34)))
EndProcedure

;If you want to use other maps in the WebRadar aswell, just parse their overview file here and upload the respective image
ParseOverview("de_dust2")
ParseOverview("de_mirage")

If hiddenmode=0
  OpenACSGOMH_GUI_Window((MainDesktop_Screen_Width/2)-(340/2), (MainDesktop_Screen_Height/2)-(360/2))
  SetWindowTitle(ACSGOMH_GUI_Window, CheatName)
  Setup_ACSGOMH_GUI_Window()
Else
  AndroidControllerState=1
  AndroidControllerThread=CreateThread(@AndroidController(),0)
EndIf

toggled()

;Not using the BSP-Parser, because even tho it is faster than bSpottedbyMask, you would need to parse additional files to have a reliable VisibilityCheck
;ParseBSP()

Procedure SetForeignWindowActive(WindowTitle.s="Counter-Strike: Global Offensive")
  hForeignWindow=FindWindow_(0, WindowTitle)
  SetForegroundWindow_(hForeignWindow)
EndProcedure

Repeat
  
  ;startTime=ElapsedMilliseconds()
  
  If hiddenmode=0
    currentWindowEvent=WindowEvent()
    If currentWindowEvent <> 0
      Get_ACSGOMH_GUI_Window_Settings()
      If currentWindowEvent = #PB_Event_CloseWindow
         CloseWindow(ACSGOMH_GUI_Window)
         If SilentAimMode=1
           ClientCMD("bind mouse1 +attack")
         EndIf
         If FakeLagState=1
           KillThread(FakeLagThread)
           SetSendPacket(1)
         EndIf
         End
      EndIf
    EndIf
    ;-----------SGUIW-----------
    If GetAsyncKeyState_(#VK_INSERT)&1
      StickyWindow(ACSGOMH_GUI_Window, #True)
      StickyWindow(ACSGOMH_GUI_Window, #False)
    EndIf
    ;-----------SGUIW-----------
  EndIf
  
  
  LocalPlayerBase=ATPMemory::RPM(hProc, ClientModuleBase + Offset_BaseLocalPlayerCMO)
  LocalPlayerState=ATPMemory::RPM(hProc, EngineModuleBase+Offset_EnginePointer)
  LocalPlayerData\indexNum=ATPMemory::RPM(hProc, LocalPlayerState + Offset_m_LocalPlayerIndex)
  LocalPlayerData\team=ATPMemory::RPM(hProc, LocalPlayerBase+Offset_m_iTeamNum)
  LocalPlayerData\health=ATPMemory::RPM(hProc, LocalPlayerBase+Offset_m_iHealth)
  LocalPlayerData\fFlags=ATPMemory::RPM(hProc, LocalPlayerBase+Offset_m_fFlags)
  LocalPlayerData\pos[0]=ATPMemory::RPM_Float(hProc, LocalPlayerBase+Offset_m_vecOrigin)
  LocalPlayerData\pos[1]=ATPMemory::RPM_Float(hProc, LocalPlayerBase+Offset_m_vecOrigin+4)
  LocalPlayerData\pos[2]=ATPMemory::RPM_Float(hProc, LocalPlayerBase+Offset_m_vecOrigin+8)
  LocalPlayerData\viewangles[0]=ATPMemory::RPM_Float(hProc, LocalPlayerState+Offset_ViewAngles)
  LocalPlayerData\viewangles[1]=ATPMemory::RPM_Float(hProc, LocalPlayerState+Offset_ViewAngles+4)
  LocalPlayerData\activeWeaponID=getActiveWeaponID()
  
  
  If BunnyHopState=1
    LocalPlayerData\velocityvec[0]=ATPMemory::RPM_Float(hProc, LocalPlayerBase+offset_m_vecVelocity)
    LocalPlayerData\velocityvec[1]=ATPMemory::RPM_Float(hProc, LocalPlayerBase+offset_m_vecVelocity+4)
    LocalPlayerData\velocityvec[2]=ATPMemory::RPM_Float(hProc, LocalPlayerBase+offset_m_vecVelocity+8)
    LocalPlayerData\velocity=fcalc3DVectorMagnitude(LocalPlayerData\velocityvec[0],LocalPlayerData\velocityvec[1],LocalPlayerData\velocityvec[2])
  EndIf
  
  For x=0 To 31
  If x <> LocalPlayerData\indexNum
      Entities(x)\EntityBase=ATPMemory::RPM(hProc, ClientModuleBase+Offset_EntityBase + x*Offset_EntityLoopDistance)
      Entities(x)\glowIndex=ATPMemory::RPM(hProc, Entities(x)\EntityBase + Offset_glowIndex)
      Entities(x)\health=ATPMemory::RPM(hProc, Entities(x)\EntityBase + Offset_m_iHealth)
      Entities(x)\team=ATPMemory::RPM(hProc, Entities(x)\EntityBase + Offset_m_iTeamNum)
      Entities(x)\fFlags=ATPMemory::RPM(hProc, Entities(x)\EntityBase + Offset_m_fFlags)
      Entities(x)\dormant=ATPMemory::RPM(hProc, Entities(x)\EntityBase + Offset_bDormant)
      Entities(x)\spotted=ATPMemory::RPM(hProc, Entities(x)\EntityBase + Offset_m_bSpotted)
      Entities(x)\spottedbyMask=ATPMemory::RPM(hProc, Entities(x)\EntityBase + Offset_m_bSpottedbyMask)
      Entities(x)\pos[0]=ATPMemory::RPM_Float(hProc, Entities(x)\EntityBase + Offset_m_vecOrigin)
      Entities(x)\pos[1]=ATPMemory::RPM_Float(hProc, Entities(x)\EntityBase + Offset_m_vecOrigin+4)
      Entities(x)\pos[2]=ATPMemory::RPM_Float(hProc, Entities(x)\EntityBase + Offset_m_vecOrigin+8)
      Entities(x)\lastplacename=ATPMemory::RPM_String(hProc,Entities(x)\EntityBase + Offset_m_szLastPlaceName, 32)
      Entities(x)\distance=GetDistance3Dto1D(LocalPlayerData\pos[0],LocalPlayerData\pos[1],LocalPlayerData\pos[2],Entities(x)\pos[0],Entities(x)\pos[1],Entities(x)\pos[2])
      Entities(x)\fovdistance=fCalcFOVdistance(x)
  EndIf
  Next x

  currentMapName=ATPMemory::RPM_String(hProc, LocalPlayerState+Offset_m_MapName, 32)
  
  If ACSGOMH_3DViewerState
    ACSGOMH_3DViewer()
  EndIf
  
  If (AimbotState=1 Or GlowState=1) And IsWeaponIDValid(LocalPlayerData\activeWeaponID)
    FOVTarget=FOV_GetClosestEnemyinMaximumFOV()
    DistanceTarget=Distance_GetClosestEnemy()
  EndIf
  
    SilentAimListener()
     
    If Not ((GetAsyncKeyState_(#VK_F12) & $8000) Or (GetAsyncKeyState_(#VK_F5) & $8000))
      If GlowState=1 : SetGlow() : EndIf
      If Glow_WeaponESP=1 Or Glow_GrenadeESP=1 Or Glow_ChickenESP=1 Or Glow_BombESP=1
        GlowEntities()
      EndIf
    EndIf
    
    If AntiFlashState=1 : AntiFlash() : EndIf
    
    If IsWeaponIDValid(LocalPlayerData\activeWeaponID)
      If AimbotState=1 : If Aimbot_enabled(LocalPlayerData\activeWeaponID)=1 : Aimbot() : EndIf : EndIf
      If TriggerState=1 : If Triggerbot_enabled(LocalPlayerData\activeWeaponID)=1 : TriggerBot() : EndIf : EndIf
    EndIf
    
    If BunnyHopState=1 : BunnyHop() : EndIf
    If RadarState=1 : Radar() : EndIf
    If AntiAimState=1 : AntiAim() : EndIf
    If SkinChangerState=1 : SkinChanger() : EndIf
    If NoHandsState=1 : NoHands() : EndIf
    If FOVChangerState=1 : FovChanger() : EndIf
    If ZeusTriggerState=1 : ZeusTrigger() : EndIf
    
    If hiddenmode=0 And KeybindHandlerState=1
      UpdateKeybindHandler()
    EndIf
    
    If GetAsyncKeyState_(KeyBind_ForceUpdate)&1 And SkinChangerState
      ForceFullUpdate()
    EndIf
    
    If SyncWithCSGOTickRate
      WaitForNextTick()
    Else
      Delay(1)
    EndIf
    
    ;Debug "IT:" + Str(ElapsedMilliseconds()-startTime)
    
ForEver


; IDE Options = PureBasic 5.43 LTS (Windows - x86)
; CursorPosition = 1487
; FirstLine = 711
; Folding = BAAAAAACAAABAAAA+
; EnableThread
; EnableXP
; Executable = ..\..\PBBuilds\ACSGOMH.exe