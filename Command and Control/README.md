# Beigeworm's Telegram C2 Client 
![telec2](https://github.com/beigeworm/Powershell-Tools-and-Toys/assets/93350544/58ec957d-4792-4d5a-9f06-ced4ccc3408d)

**SYNOPSIS**

Using a Telegram Bot's Chat to Act as a Command and Control Platform.

Telegram Bots are able to both receive AND send messages. so can you use it as a C2? ....Enter a proof of concept :)

-----------------------------------------------------------------------------------------------------------------------------

**INFORMATION**

This script will wait until it is called in chat by the computer name to take commands from telegram.

A list of Modules can be accessed by typing 'options' in chat, or you can use the chat to act simply as a reverse shell.

-----------------------------------------------------------------------------------------------------------------------------

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

Reverse shell          - apart from running the modules, once connected the chat can act as a reverse shell.

Killswitch             - Any Modules such as "KeyCapture" and "Exfiltrate" can be killed by typing "KILL" into chat
                         (this returns the session so it can accept further commands (does not kill the connection.))
                         
-----------------------------------------------------------------------------------------------------------------------------

**SETUP INSTRUCTIONS**

1. visit https://t.me/botfather, click open in telegram and make a bot.
  
2. add your new bot API TOKEN to this script.
   
3. search for bot in top left box in telegram and start a chat then type /start.
   
4. Run Script on target System
   
5. Check telegram chat for 'waiting to connect' message.
    
6. type in the computer name from that message into telegram bot chat to open the session.

7. Click either "enter commands" or "options" to begin the session and use these commands below.
8. 
-----------------------------------------------------------------------------------------------------------------------------

**MODULES INFORMATION**

Options           : Show a menu in chat listing all the below functions

Kill              : Killswitch for 'KeyCapture' and 'Exfiltrate' commands (can take a few seconds to kill.)

ExtraInfo         : Extra command information and examples sent to the chat

Close             : Close the Session completely

PauseSession      : Kills this session and restarts a new instance of the script

ToggleErrors      : Toggle error messages to the chat ON or OFF and returns the current state to chat

FolderTree        : Gets Directory trees for User folders and sends it zipped to the chat

Screenshot        : Sends a screenshot of the desktop as a png file

Keycapture        : Capture Keystrokes and send them (collected keystrokes are only sent after 10 seconds of keyboard inactivity)

Systeminfo        : Send System info as text file (system, user, hardware, ip information and more)

Softwareinfo      : Send Software info as text file (installed programs, services, drivers and other software info)

Historyinfo       : Send History info as text file (browser and powershell history, clipoard contents)

AddPersistance    : Add Telegram C2 to Startup (Copy the script to a default windows location and a vbs script to the startup folder)

RemovePersistance : Remove Startup Persistance (Remove the ps1 script and vbs file)

IsAdmin           : Checks if session has admin Privileges and returns the result

AttemptElevate    : Send user a prompt to grant Administrator privilages in a new session. (if the user accepts the prompt)

Exfiltrate        : Searches for, and sends, files to the chat as zip files split into 50mb each (Telegram max upload limit.)

 EXFILTRATION EXAMPLE COMMAND  =  Exfiltrate -path [FOLDERS] -filetype [FILETYPES]
 
 FOLDERS = Documents, Desktop, Downloads, OneDrive, Pictures, Videos
 
 FILETYPES = log, db, txt, doc, pdf, jpg, jpeg, png, wdoc, xdoc, cer, key, xls, xlsx, cfg, conf, docx, rft
 
-----------------------------------------------------------------------------------------------------------------------------

 # If you like my work please leave a star. ⭐
