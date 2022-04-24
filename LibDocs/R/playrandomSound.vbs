
Randomize
With CreateObject("WMPlayer.OCX")
    .URL = "C:\WINDOWS\Media\ringout.wav"
    .controls.play 
    Do While .playState <> 1
        WScript.Sleep 100
    Loop
    .close
End With
