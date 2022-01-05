
<img src="https://user-images.githubusercontent.com/77844672/148182316-e14e6f7f-e919-4c88-8940-19b0db0fa9ff.png" width="75%" height="75%">
There are two versions of it:

1. **With** GUI (Graphical User Interface), the User can specifically tell the script what should be updated/installed<br>
1.1 You can Select a single theme to install/update
<img src="https://user-images.githubusercontent.com/77844672/148187188-5bba7657-15d5-4bee-b5ef-35317f68f150.png" width="27%" height="27%">
1.2 or you can make a multi select with ctrl(strg) or by draging the mouse over 
<img src="https://user-images.githubusercontent.com/77844672/148187162-69490e74-0a61-4c47-a95d-208d8686c689.png" width="28%" height="28%">

<br><br>
2. **Without** GUI (Graphical User Interface), the script looks in your extension folder and updates every compatible<sup>***1**</sup> components (Filename: silentUpdateTS5Themes.exe)<br><br><br> <br>


<img src="https://user-images.githubusercontent.com/77844672/148183859-f3a245c0-38b1-4d79-bf23-cddecfd9dc2c.png" width="75%" height="75%">


How to:

Download Updater/Installer from here:
1. <a href="https://github.com/Wargamer-Senpai/updateTS5Themes/releases/latest/download/UpdateTS5Themes.exe">with GUI</a>
2. <a href="https://github.com/Wargamer-Senpai/updateTS5Themes/releases/latest/download/silentUpdateTS5Themes.exe">without GUI</a>


<br>
With GUI you can just executed it and install/update what you want.

Without GUI you can for example put in the Windows startup folder, `windows` + `r` and type `shell:startup`, copy it in the folder. Now it gets executed everytime you start your PC.
Can be simply deactivated, if you delete/move it from the `shell:startup`  or you can deactivate it in the task manager.
If you dont want it on startup you can either executed it manually or create a windows task in the task scheduler (<a href="https://openwritings.net/pg/task-scheduler/task-scheduler-run-task-every-hour-after-startup">short tutorial</a>).
<br>


<img src="https://user-images.githubusercontent.com/77844672/148183999-142601b1-d520-4e6b-a1cd-61fb6983aa8c.png" width="75%" height="75%">


<h2>Known:</h2>

Chrome/Firefox/etc. will say its a weird file and will say something like: 

<img src="https://user-images.githubusercontent.com/77844672/148185201-79752da6-e5cd-4b74-8bbd-b82f05e4c4cc.png" width="40%" height="40%">
normaly you can just ignore it, like:

<img src="https://user-images.githubusercontent.com/77844672/148185359-6ebbd65b-c4c6-48d1-b674-cc3eb363fd85.png" width="10%" height="10%">

**Reason: Its not signed with any Certificate and it has been converted with <a href="https://github.com/MScholtes/PS2EXE">PS2EXE</a>**




***1**: The Silent Updater Ignores everything, except for the compatible files, currently these themes are: CleanSpeak, Colorfull, Windows 11 inspired, AnimeSpeak and LoLSpeak. 
If you want your theme added just PM me on TS5,in the forum or make an issue, then i can add your theme to the source code. 

