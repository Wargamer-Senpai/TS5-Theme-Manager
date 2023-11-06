###########
# IMPORTS #
###########
from tkinter import *
from time import *
from os import *
from urllib.error import *
from urllib import request
from tkinter.ttk import Progressbar
import webbrowser
import zipfile
import threading
#import json
import sys

#############
# VARIABLES #
#############
global progressbar
downloadLinks = []
url = 'https://www.google.com'
themeArray = {
    'displayArray': ['Colorful TeamSpeak (by LeonMarcelHD)', 'CleanSpeak (by Gamer92000)', 'AnimeSpeak (by Wargamer-Senpai)', 'LoLSpeak (by Wargamer-Senpai)', 'TS5 Nue Style Theme (by qeinz)', 'Windows 11 Inspired (by Shiina) [BROKEN]'],
    'gitRepo': ['Colorful-TeamSpeak', 'CleanSpeak', 'teamspeak5-Theme-Anime', 'LoLSpeak', 'TS5-Nue-Style-Theme', 'TeamSpeak-5-Dark'],
    'gitUser': ['LeonMarcel-HD', 'Gamer92000', 'Wargamer-Senpai', 'Wargamer-Senpai', 'qeinz', 'AikoMidori'],
    'zipFileName': ['de.leonmarcelhd.colorful.teamspeak', 'de.julianimhof.cleanspeak', 'de.wargamer.anime.teamspeak', 'de.wargamer.lol.teamspeak', 'de.qeinz.teamspeak', 'com.shiinaskins.teamspeak']
}

#early function for getting the absolut path for the icon file 
def resource_path(relative_path):
    """ Get absolute path to resource, works for dev and for PyInstaller """
    try:
        # PyInstaller creates a temp folder and stores path in _MEIPASS
        base_path = sys._MEIPASS
    except Exception:
        base_path = path.abspath(".")

    return path.join(base_path, relative_path)
windowIco=resource_path("window.ico")

######################
# DESIGN MAIN WINDOW #
######################
mainWindow = Tk()
mainWindow.title('TS5 Theme Manager')
mainWindow.geometry("320x220+550+250")
mainWindow.resizable(0, 0)
mainWindow.option_add( "*font", "Arial_Greek 11" )
#mainWindow.config(bg = '#000')
#!replace with wanted icon
mainWindow.iconbitmap(windowIco)

#text header
text1 = Label(text="Choose one or more Theme/s.\nSelect with click drag or \nselect with ctrl(strg)/shift click.", justify=LEFT, anchor='w', font=('Arial_Greek bold',13))
text1.pack(fill='both', padx=9, pady=5)

#############
# FUNCTIONS #
############# 

#copy paste from https://stackoverflow.com/questions/7674790
#increase progress of progessbar
def progress(STEP):
    global progressbar
    if progressbar['value'] < 100:
        progressbar['value'] += STEP
        secondWindow.update()
    if progressbar['value'] == 100:
        button4 = Button(secondWindow, text="Finish",command=finish_up, width=8)
        button4.place(x=100, y=50)
        secondWindow.update()

#main function to install the theme/s
def install_themes():
    global secondWindow
    global progressbar
    selection = listBox.curselection()
    if selection:
        #DEBUGGING
        #debug_output = Label(mainWindow, text=selection, bg="orange")
        #debug_output.pack()

        #deactivate main window 
        listBox["state"]="disabled"
        button1["state"]="disabled"
        button2["state"]="disabled"
        button3["state"]="disabled"
        mainWindow.update() # instant refresh the main window
        #remove x from titlebar

        #generat second window with progressbar
        secondWindow = Toplevel(mainWindow)
        secondWindow.title("Progress....")
        secondWindow.geometry("270x100+560+260")
        secondWindow.lift()
        secondWindow.attributes("-topmost", True)
        secondWindow.iconbitmap(windowIco)
        # progressbar 
        progressbar = Progressbar(secondWindow, orient='horizontal', mode='determinate', length=250)
        # place the progressbar
        progressbar.grid(column=0, row=0, columnspan=2, padx=10, pady=20)
        secondWindow.update()
        
        downloadLinks=[] #cleanup list if installation is triggered a second time without restarting
        for item in selection:
            #get download link
            downloadLinks.append("https://github.com/"+themeArray['gitUser'][item]+"/"+themeArray['gitRepo'][item]+"/releases/latest/download/"+themeArray['zipFileName'][item]+".zip")
        print(downloadLinks)

        #start download, move and unzip
        STEP = 100 / len(selection)
        for url in downloadLinks:
            threading.Thread(target=download_theme(url,STEP)).start()
            secondWindow.update()
    else:
        print("nothing selected")
        flash()


#download file, move, unzip and cleanup afterwards
def download_theme(url,STEP):
    downloadDir=getenv('TEMP')
    if url.find('/'):
        filename=url.rsplit('/', 1)[1]

    try:
        request.urlretrieve(url, downloadDir+'\\'+filename)
    except HTTPError:
        try:
            #######################################
            ## doesnt work need to think over it ##
            #######################################
            error_window(url) #trigger error window
            progressbar.after(1000, lambda: progress(STEP))
            # #second try, this time it trys to get the source code of the release
            # print("ERROR WHILE DOWNLOADING, trying zipball")

            # userLink=url.rsplit('/')[3]
            # repoLink=url.rsplit('/')[4]
            # githubInfo="https://codeload.github.com/"+userLink+"/"+repoLink+"/zip/refs/tags/1.0.6"
            # req=request.urlopen(githubInfo); 
            # urlZipball=json.loads(req.read())['zipball_url']
            # request.urlretrieve(urlZipball, downloadDir+'\\'+filename)

            # #unzip and move
            # zip = zipfile.ZipFile(downloadDir+'\\'+filename)
            # appdata=getenv('APPDATA')
            # tsExtension=appdata+"\\TeamSpeak\\Default\\extensions"
            # zip.extractall(path=tsExtension)
            # print(tsExtension)
            # remove(tsExtension+'\\'+filename
            # zip.close()


        except HTTPError:
            error_window(url)
            progressbar.after(1000, lambda: progress(STEP))
    else:
        #print('successfully downloaded')        
        progressbar.after(1000, lambda: progress(STEP))
        
        #unzip and move
        zip = zipfile.ZipFile(downloadDir+'\\'+filename)
        appdata=getenv('APPDATA')
        tsExtension=appdata+"\\TeamSpeak\\Default\\extensions"
        zip.extractall(path=tsExtension)
        zip.close()
        remove(downloadDir+'\\'+filename)

#send error to user if download fails
def error_window(url):
    errorWindow=Tk()
    errorWindow.title("Error while downloading...")
    errorWindow.geometry("750x100+600+300")
    errorWindow.lift()
    errorWindow.attributes("-topmost", True)
    errorWindow.update()
    errorWindow.iconbitmap(windowIco)

    errorLabel = Text(errorWindow, height=3, width=90,borderwidth=0, bg="#f0f0f0")
    errorLabel.insert(1.0,"Error while trying to download:\n"+url)
    errorLabel.config(font=("tahoma", "11", "normal"))
    errorLabel.configure(inactiveselectbackground=errorLabel.cget("selectbackground"))
    errorLabel.pack()
    errorButton = Button(errorWindow, text="OK", width=6, command=errorWindow.destroy)
    errorButton.pack()


#terminate second window and activate main window
def finish_up():
    listBox["state"]="normal"
    button1["state"]="active"
    button2["state"]="active"
    button3["state"]="active"
    mainWindow.update()
    secondWindow.destroy()
    

#when button github was pressed, the website is opend from the creator
def open_creator_website(url):
    selection = listBox.curselection()
    if selection:
        for item in selection:
            mainWindow.update()
            URL='https://github.com/'+themeArray['gitUser'][item]+'/'+themeArray['gitRepo'][item]
            webbrowser.open_new(URL)
        #DEBUGGING
        #debug_output = Label(mainWindow, text=selection, bg="blue")
        #debug_output.pack()
    else:
        print("nothing selected")
        flash()


#if it was possible to press the button without selecting something
def flash():
    listBox.config(bg = 'red')
    listBox.after(100, lambda: listBox.config(bg = 'white'))


#as soon the user selects an item the buttons will be reactivated
def onselect(arg):
    button1["state"]="active"
    button2["state"]="active"

############
# TOOLTIPS #
############
#copy paste from source: https://stackoverflow.com/questions/20399243/
class ToolTip(object):

    def __init__(self, widget):
        self.widget = widget
        self.tipwindow = None
        self.id = None
        self.x = self.y = 0

    def showtip(self, text):
        "Display text in tooltip window"
        self.text = text
        if self.tipwindow or not self.text:
            return
        x, y, cx, cy = self.widget.bbox("insert")
        x = x + self.widget.winfo_rootx() + 57
        y = y + cy + self.widget.winfo_rooty() +27
        self.tipwindow = tw = Toplevel(self.widget)
        tw.wm_overrideredirect(1)
        tw.wm_geometry("+%d+%d" % (x, y))
        label = Label(tw, text=self.text, justify=LEFT,
                      background="#ffffe0", relief=SOLID, borderwidth=1,
                      font=("tahoma", "8", "normal"))
        label.pack(ipadx=1)

    def hidetip(self):
        tw = self.tipwindow
        self.tipwindow = None
        if tw:
            tw.destroy()

def create_tool_tip(widget, text):
    toolTip = ToolTip(widget)
    def enter(event):
        toolTip.showtip(text)
    def leave(event):
        toolTip.hidetip()
    widget.bind('<Enter>', enter)
    widget.bind('<Leave>', leave)

###########
# LISTBOX #
###########
#define and create listbox
listBox = Listbox(mainWindow, activestyle='none') #activestyle -> remove underline from selectionbox
listBox["selectmode"] = "extended" #allow multi selection
listBox.place(x=10, y=70, width=300, height=110)
for item in themeArray['displayArray']:
    listBox.insert("end", item)
listBox.bind('<<ListboxSelect>>', onselect)

###########
# BUTTONS #
###########
#define buttons
button1 = Button(mainWindow, text="Install", command=install_themes, width=8, state=DISABLED)
button2 = Button(mainWindow, text="GitHub", command=lambda aurl=url:open_creator_website(aurl), width=8, state=DISABLED)
button3 = Button(mainWindow, text="Exit...", width=8, command=mainWindow.destroy)

#create tool tipps for buttons
create_tool_tip(button1, text='Installs all selected Themes...\nHint: if the selected theme is installed it will be overwriten')
create_tool_tip(button2, text='Opens the GitHub website of the creator, from the theme u selected (multiple possible)')
create_tool_tip(button3, text='exits the program....lul')

#place buttons
button1.place(x=10, y=185)
button2.place(x=118, y=185)
button3.place(x=227, y=185)


mainWindow.mainloop()