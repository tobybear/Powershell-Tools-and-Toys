# Beigeworm's Telegram C2 Client 
![telec2](https://github.com/beigeworm/Powershell-Tools-and-Toys/assets/93350544/58ec957d-4792-4d5a-9f06-ced4ccc3408d)

**SYNOPSIS**

Using a Telegram Bot's Chat to Act as a Command and Control Platform.

Telegram Bots are able to both receive AND send messages. so can you use it as a C2? ....Enter my proof of concept :)

**INFORMATION**

This script will wait until it is called in chat by the computer name to take commands from telegram.

A list of Modules can be accessed by typing 'options' in chat, or you can use the chat to act simply as a reverse shell.

**FEATURES**

Session Queue          - While running, this script waits for a start phrase (the computer name) before connecting, allowing multiple computers to wait for interaction.

Botnet Mode            - Add simultaneous sessions to control multiple computers at once. (enter computer names one after the other into chat)

Persistance            - Can add itself to startup folder (RemovePersistance command will undo this)

Options List           - Once connected type "Options" to see a list of operations. ("ExtraInfo" will show more command info)

Pause Session          - exits the current session and script waits for re-authrentication.

Key Capture Standby    - only sends messages if keys are pressed and remains idle otherwise.

File Size Intellegence - Auto split Uploads over 50mb.

Privilege Escalation   - The ability to send the user a UAC prompt for this script and restart if succesful.

Toggle Error Messaging - Turn On or Off returning error messages to the chat. (Off by default)

Killswitch             - Any Modules such as "KeyCapture" and "Exfiltrate" can be killed by typing "KILL" into chat
                         (this returns the session so it can accept further commands (does not kill the connection.))

**SETUP INSTRUCTIONS**
1. visit https://t.me/botfather, click open in telegram and make a bot.
2. 
3. add your new bot API TOKEN to this script.
4. 
5. search for bot in top left box in telegram and start a chat then type /start.
6. 
7. Run Script on target System
8. 
9. Check telegram chat for 'waiting to connect' message.
10. 
11. type in the computer name from that message into telegram bot chat to open the session.

**MODULES INFORMATION**
Kill              : Killswitch for 'KeyCapture' and 'Exfiltrate' commands

ExtraInfo         : Extra command information and examples

Close             : Close the Session completely

PauseSession      : Kills this session and restarts a new instance of the script

ToggleErrors      : Toggle error messages to the chat ON or OFF

FolderTree        : Gets Directory trees for User folders and sends it zipped to the chat

Screenshot        : Sends a screenshot of the desktop as a png file

Keycapture        : Capture Keystrokes and send them (collected keystrokes are only sent after 10 seconds of keyboard inactivity)

Systeminfo        : Send System info as text file

Softwareinfo      : Send Software info as text file

Historyinfo       : Send History info as text file

AddPersistance    : Add Telegram C2 to Startup

RemovePersistance : Remove Startup Persistance

IsAdmin           : Checks if session has admin Privileges

AttemptElevate    : Send user a prompt to gain Admin

Exfiltrate        : Sends files (see below for info)

 EXFILTRATION EXAMPLE COMMAND  =  Exfiltrate -path [FOLDERS] -filetype [FILETYPES]
 
 FOLDERS = Documents, Desktop, Downloads, OneDrive, Pictures, Videos
 
 FILETYPES = log, db, txt, doc, pdf, jpg, jpeg, png, wdoc, xdoc, cer, key, xls, xlsx, cfg, conf, docx, rft

 # If you like my work please leave a star. ⭐
