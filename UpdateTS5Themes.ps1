###########
#   GUI   #
###########
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Select Theme'
$form.Size = New-Object System.Drawing.Size(325,250)
$form.StartPosition = 'CenterScreen'

$form1 = New-Object System.Windows.Forms.Form
$form1.Text = 'Finished ....'
$form1.Size = New-Object System.Drawing.Size(230, 115)
$form1.StartPosition = 'CenterScreen'

#create ok button
$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Point(75, 183)
$OKButton.Size = New-Object System.Drawing.Size(75,23)
$OKButton.Text = 'OK'
$OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
#create second ok button
$OKButton1 = New-Object System.Windows.Forms.Button
$OKButton1.Location = New-Object System.Drawing.Point(75, 50)
$OKButton1.Size = New-Object System.Drawing.Size(75, 23)
$OKButton1.Text = 'OK'
$OKButton1.DialogResult = [System.Windows.Forms.DialogResult]::OK

#Add both OK button to windows 
$form.AcceptButton = $OKButton
$form.Controls.Add($OKButton)
$form1.AcceptButton = $OKButton1
$form1.Controls.Add($OKButton1)

#create cancel button
$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Point(160,183)
$CancelButton.Size = New-Object System.Drawing.Size(75,23)
$CancelButton.Text = 'Cancel'
$CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $CancelButton
$form.Controls.Add($CancelButton)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(300,30)
$label.Text = 'Please make a selection from the list belowm, *multiselect* with ctrl(strg) or drag:'

$label1 = New-Object System.Windows.Forms.Label
$label1.Location = New-Object System.Drawing.Point(10, 20)
$label1.Size = New-Object System.Drawing.Size(300, 30)
$label1.Text = 'Finished updating/installing Themes....'

$form.Controls.Add($label)
$form1.Controls.Add($label1)



$listBox = New-Object System.Windows.Forms.Listbox
$listBox.Location = New-Object System.Drawing.Point(10,60)
$listBox.Size = New-Object System.Drawing.Size(290,20)

$listBox.SelectionMode = 'MultiExtended'

#List of all skins
[void] $listBox.Items.Add('AnimeSpeak ( by Wargamer-Senpai )')
[void] $listBox.Items.Add('Colorful TeamSpeak ( by LeonMarcelHD )')
[void] $listBox.Items.Add('CleanSpeak ( by Gamer92000 )')
[void] $listBox.Items.Add('LoLSpeak ( by Wargamer-Senpai )')
[void] $listBox.Items.Add('Windows 11 inspired ( by Shiina )')


$listBox.Height = 120
$form.Controls.Add($listBox)
$form.Topmost = $true

$result = $form.ShowDialog()

###########
#   Main  #
###########
if ($result -eq [System.Windows.Forms.DialogResult]::OK){
    $SelectedItems = $listBox.SelectedItems
    
  $userOnGithub = @{'AnimeSpeak ( by Wargamer-Senpai )' = 'Wargamer-Senpai'; 'LoLSpeak ( by Wargamer-Senpai )' = 'Wargamer-Senpai'; 'Colorful TeamSpeak ( by LeonMarcelHD )' = 'LeonMarcel-HD';
                   'CleanSpeak ( by Gamer92000 )' = 'Gamer92000'; 'Windows 11 inspired ( by Shiina )' = 'AikoMidori' }
  $repoOnGithub = @{'AnimeSpeak ( by Wargamer-Senpai )' = 'teamspeak5-Theme-Anime'; 'LoLSpeak ( by Wargamer-Senpai )' = 'LoLSpeak'; 'Colorful TeamSpeak ( by LeonMarcelHD )' = 'Colorful-TeamSpeak';
                   'CleanSpeak ( by Gamer92000 )' = 'CleanSpeak'; 'Windows 11 inspired ( by Shiina )' = 'TeamSpeak-5-Dark' }
  $ArrayDirectory = @{'AnimeSpeak ( by Wargamer-Senpai )' = 'de.wargamer.anime.teamspeak'; 'LoLSpeak ( by Wargamer-Senpai )' = 'de.wargamer.lol.teamspeak';
                     'Colorful TeamSpeak ( by LeonMarcelHD )' = 'de.leonmarcelhd.colorful.teamspeak'; 'CleanSpeak ( by Gamer92000 )' = 'de.julianimhof.cleanspeak';
                      'Windows 11 inspired ( by Shiina )' = 'com.shiinaskins.teamspeak' }
  
  #check if directory exists, if yes remove, else just create temp directory for unzipping
  if (Test-path "C:\Users\$env:username\AppData\Local\Temp\TS5_Themes.de.Wargamer" ) { Remove-Item –path "C:\Users\$env:username\AppData\Local\Temp\TS5_Themes.de.Wargamer" -Recurse }
  New-Item -Path "C:\Users\$env:username\AppData\Local\Temp\TS5_Themes.de.Wargamer" -ItemType Directory

    foreach ($item in $SelectedItems){
    $curDir=$ArrayDirectory[$item]
    $curZip = $curDir + '.zip'
    $gitUser = $userOnGithub[$item]
    $gitRepo = $repoOnGithub[$item]

    Invoke-WebRequest -uri "https://github.com/$gitUser/$gitRepo/releases/latest/download/$curZip" -OutFile "C:\Users\$env:username\AppData\Local\Temp\TS5_Themes.de.Wargamer\$curZip" 
    Expand-Archive "C:\Users\$env:username\AppData\Local\Temp\TS5_Themes.de.Wargamer\$curZip" -destinationpath "C:\Users\$env:username\AppData\Local\Temp\TS5_Themes.de.Wargamer"
    if (Test-path "C:\Users\$env:username\AppData\Roaming\TeamSpeak\Default\extensions\$curDir") { Remove-Item "C:\Users\$env:username\AppData\Roaming\TeamSpeak\Default\extensions\$curDir" -Recurse }
    Move-Item -Path "C:\Users\$env:username\AppData\Local\Temp\TS5_Themes.de.Wargamer\$curDir" -Destination "C:\Users\$env:username\AppData\Roaming\TeamSpeak\Default\extensions"
    Remove-Item –path "C:\Users\$env:username\AppData\Local\Temp\TS5_Themes.de.Wargamer\$curZip" -Recurse
  }
  #Remove Temp directory
  Remove-Item –path "C:\Users\$env:username\AppData\Local\Temp\TS5_Themes.de.Wargamer" -Recurse
	#Write-Output "Finished...."
  $form1.ShowDialog()
}
