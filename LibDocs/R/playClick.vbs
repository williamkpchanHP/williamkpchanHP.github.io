Dim mpPlayer
Set mpPlayer = CreateObject("WMPlayer.OCX")
mpPlayer.URL = "C:\WINDOWS\Media\Windows Battery Low.wav"
mpPlayer.controls.play 
While mpPlayer.playState <> 1 ' 1 = Stopped
  WScript.Sleep 100
Wend
mpPlayer.close
