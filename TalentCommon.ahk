DetectHiddenWindows True
SetTimer WatchCaret, 100
global caretX := 0
global caretY := 0
global caretTime

WatchCaret() {
    if CaretGetPos(&x, &y) {
		caretX:= x
		caretY:= y
	} else {
		MouseGetPos(&x, &y)
		caretX:= x
		caretY:= y
	}

}

; Common Function
TextMenu(TextOptions)
{
	Sleep 200
  MyMenu := Menu()
  Loop Parse, TextOptions, ","
  {
    Item := A_LoopField
    MyMenu.Add Item, MenuHandler
  }
  	
	Run("SendDown500.ahk")
	
	MyMenu.Show((caretX + 50), caretY)
  
}

ShowMenu(menu) {
	menu.Show((caretX + 50), caretY)
}

MenuHandler(Item, *) {
	SendInput StrSplit(Item, "|")[1]
}

/* 
 * Switch same app windows 	
 */
; Extract AppTitle ( sample - Google Chrome => Google Chrome)

ExtractAppTitle(FullTitle)
{
	AppTitle := SubStr(FullTitle, InStr(FullTitle, "-", false, -1) + 1)
	If (InStr(FullTitle, "IntelliJ IDEA", false, -1) > 0) {
		AppTitle := "IntelliJ IDEA"
	}
	Return AppTitle
}

SwitchWindowsBetweenApp() {
ActiveProcess := WinGetProcessName("A")
OpenWindowsAmount := WinGetCount("ahk_exe " . ActiveProcess)
;MsgBox(OpenWindowsAmount)
If OpenWindowsAmount = 1  ; If only one Window exist, do nothing
    Return	
Else
	{
		FullTitle := WinGetTitle("A")
 		AppTitle := ExtractAppTitle(FullTitle)

		SetTitleMatchMode(2)
  		WindowsWithSameTitleList := WinGetList(AppTitle)
  		
  		If WindowsWithSameTitleList.length > 1 ; If several Window of same type (title checking) exist
  		{
  			WinActivate "ahk_id " . WindowsWithSameTitleList[WindowsWithSameTitleList.length]	; Activate next Window	
  		}
 
	}
}

DelaySend(content, delay) {
	Sleep(delay)
	Send(content)
}
