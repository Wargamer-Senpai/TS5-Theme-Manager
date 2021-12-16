Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Data Entry Form'
$form.Size = New-Object System.Drawing.Size(300,200)
$form.StartPosition = 'CenterScreen'

$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Point(75, 133)
$OKButton.Size = New-Object System.Drawing.Size(75,23)
$OKButton.Text = 'OK'
$OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $OKButton
$form.Controls.Add($OKButton)

$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Point(160,133)
$CancelButton.Size = New-Object System.Drawing.Size(75,23)
$CancelButton.Text = 'Cancel'
$CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $CancelButton
$form.Controls.Add($CancelButton)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(300,30)
$label.Text = 'Please make a selection from the list below multi select with ctrl(strg) or drag:'
$form.Controls.Add($label)

$listBox = New-Object System.Windows.Forms.Listbox
$listBox.Location = New-Object System.Drawing.Point(10,60)
$listBox.Size = New-Object System.Drawing.Size(260,20)

$listBox.SelectionMode = 'MultiExtended'

[void] $listBox.Items.Add('AnimeSpeak (by Wargamer-Senpai)')
[void] $listBox.Items.Add('Colorful TeamSpeak (by LeonMarcelHD)')
[void] $listBox.Items.Add('LoLSpeak (by Wargamer-Senpai)')
#[void] $listBox.Items.Add('Item 3')
#[void] $listBox.Items.Add('Item 4')
#[void] $listBox.Items.Add('Item 5')

$listBox.Height = 70
$form.Controls.Add($listBox)
$form.Topmost = $true

$result = $form.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::OK){
    $SelectedItems = $listBox.SelectedItems
    
  $ArrayLinks = @{'AnimeSpeak (by Wargamer-Senpai)' = 'https://github.com/Wargamer-Senpai/teamspeak5-Theme-Anime/releases/latest/download/de.wargamer.anime.teamspeak.zip'; 'LoLSpeak (by Wargamer-Senpai)' = 'https://github.com/Wargamer-Senpai/LoLSpeak/releases/latest/download/de.wargamer.lol.teamspeak.zip'; 'Colorful TeamSpeak (by LeonMarcelHD)' = 'https://github.com/LeonMarcel-HD/Colorful-TeamSpeak/releases/latest/download/de.leonmarcelhd.colorful.teamspeak.zip'}
  $ArrayDirectory = @{'AnimeSpeak (by Wargamer-Senpai)' = 'de.wargamer.anime.teamspeak'; 'LoLSpeak (by Wargamer-Senpai)' = 'de.wargamer.lol.teamspeak'; 'Colorful TeamSpeak (by LeonMarcelHD)' = 'de.leonmarcelhd.colorful.teamspeak' }
  $ArrayDirectoryZip = @{'AnimeSpeak (by Wargamer-Senpai)' = 'de.wargamer.anime.teamspeak.zip'; 'LoLSpeak (by Wargamer-Senpai)' = 'de.wargamer.lol.teamspeak.zip'; 'Colorful TeamSpeak (by LeonMarcelHD)' = 'de.leonmarcelhd.colorful.teamspeak.zip' }


    foreach ($item in $SelectedItems){
    $curLink=$ArrayLinks[$item]
    $curDir=$ArrayDirectory[$item]
    $curZip=$ArrayDirectoryZip[$item]
    Invoke-WebRequest -uri "$curLink" -OutFile "C:\Users\$env:username\AppData\Local\Temp\$curZip" 
    if (Test-path "C:\Users\$env:username\AppData\Local\Temp\TS5_Themes.de.Wargamer" ) { Remove-Item –path "C:\Users\$env:username\AppData\Local\Temp\TS5_Themes.de.Wargamer" -Recurse }
    New-Item -Path "C:\Users\$env:username\AppData\Local\Temp\TS5_Themes.de.Wargamer" -ItemType Directory
    Expand-Archive "C:\Users\$env:username\AppData\Local\Temp\$curZip" -destinationpath "C:\Users\$env:username\AppData\Local\Temp\TS5_Themes.de.Wargamer"
    if (Test-path "C:\Users\$env:username\AppData\Roaming\TeamSpeak\Default\extensions\$curDir") { Remove-Item "C:\Users\$env:username\AppData\Roaming\TeamSpeak\Default\extensions\$curDir" -Recurse }
    Move-Item -Path "C:\Users\$env:username\AppData\Local\Temp\TS5_Themes.de.Wargamer\$curDir" -Destination "C:\Users\$env:username\AppData\Roaming\TeamSpeak\Default\extensions"
    Remove-Item –path "C:\Users\$env:username\AppData\Local\Temp\TS5_Themes.de.Wargamer" -Recurse
    Remove-Item –path "C:\Users\$env:username\AppData\Local\Temp\$curZip" -Recurse
    }
	echo "Finished...."
	sleep(2)
}