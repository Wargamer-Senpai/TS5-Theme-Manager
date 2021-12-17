###########
#Variables#
###########
Write-Output "Starting..." > $logfile
$compatibleAddons=@('de.wargamer.lol.teamspeak'; 'de.wargamer.anime.teamspeak'; 'de.leonmarcelhd.colorful.teamspeak', 'de.julianimhof.cleanspeak') 
$userOnGithub=@{'de.wargamer.lol.teamspeak' = 'Wargamer-Senpai'; 'de.wargamer.anime.teamspeak' = 'Wargamer-Senpai'; 'de.leonmarcelhd.colorful.teamspeak' = 'LeonMarcel-HD'; 'de.julianimhof.cleanspeak' = 'Gamer92000' }
$repoOnGithub=@{'de.wargamer.lol.teamspeak' = 'LoLSpeak'; 'de.wargamer.anime.teamspeak' = 'teamspeak5-Theme-Anime'; 'de.leonmarcelhd.colorful.teamspeak' = 'Colorful-TeamSpeak'; 'de.julianimhof.cleanspeak' = 'CleanSpeak' }
$BaseDir="C:\Users\$env:username\AppData\Roaming\TeamSpeak\Default\extensions"
$logfile="$env:temp\SilentAutoUpdater.log"
$NameToFind="speak"
$foundFolders=Get-ChildItem $BaseDir -Recurse | Where-Object { $_.PSIsContainer -and $_.Name.EndsWith($NameToFind) }
Write-Output "Folders in extensions: $foundFolders.Name" >> $logfile
#$foundFolders.Name

########
# Main #
########
#check if exists, if yes remove, else just create temp directory for unzipping
if (Test-path "C:\Users\$env:username\AppData\Local\Temp\TS5_Themes.de.Wargamer" ) { Remove-Item –path "C:\Users\$env:username\AppData\Local\Temp\TS5_Themes.de.Wargamer" -Recurse }
New-Item -Path "C:\Users\$env:username\AppData\Local\Temp\TS5_Themes.de.Wargamer" -ItemType Directory

foreach ($folderName in $foundFolders.Name) {
    
    if (Compare-Object -ReferenceObject $compatibleAddons -DifferenceObject $folderName -IncludeEqual) {
        Write-Output "" >> $logfile
        Write-Output "found $folderName" >> $logfile
        $gitUser = $userOnGithub[$folderName]
        $gitRepo = $repoOnGithub[$folderName]
        $curZip = $folderName + '.zip'
        
        ##Getting Local Version
        $jsonArray = Get-Content "C:\Users\$env:username\AppData\Roaming\TeamSpeak\Default\extensions\$folderName\package.json" | Out-String | ConvertFrom-Json
        $versionLocal = $jsonArray.version

        #Getting Web Version, limited request amount per hour/day
        $jsonGithubArray = Invoke-RestMethod "https://api.github.com/repos/$gitUser/$gitRepo/releases/latest"
        Write-Output "response from Web:" >> $logfile
        Write-Output $jsonGithubArray >> $logfile
        $versionWeb = $jsonGithubArray.tag_name


        if ($versionLocal -ne $versionWeb) {
            Write-Output "not equal ... need to download (Web: $versionWeb, Local: $versionLocal)" >> $logfile
            Write-Output "get from link https://github.com/$gitUser/$gitRepo/releases/latest/download/$curZip" >> $logfile
            Invoke-WebRequest -uri "https://github.com/$gitUser/$gitRepo/releases/latest/download/$curZip" -OutFile "C:\Users\$env:username\AppData\Local\Temp\TS5_Themes.de.Wargamer\$curZip" 
            Expand-Archive "C:\Users\$env:username\AppData\Local\Temp\TS5_Themes.de.Wargamer\$curZip" -destinationpath "C:\Users\$env:username\AppData\Local\Temp\TS5_Themes.de.Wargamer"
            if (Test-path "C:\Users\$env:username\AppData\Roaming\TeamSpeak\Default\extensions\$folderName") { Remove-Item "C:\Users\$env:username\AppData\Roaming\TeamSpeak\Default\extensions\$folderName" -Recurse }
            Move-Item -Path "C:\Users\$env:username\AppData\Local\Temp\TS5_Themes.de.Wargamer\$folderName" -Destination "C:\Users\$env:username\AppData\Roaming\TeamSpeak\Default\extensions"
            Remove-Item –path "C:\Users\$env:username\AppData\Local\Temp\TS5_Themes.de.Wargamer\$curZip" -Recurse
        }
        else {
            Write-Output "equal, no need to download (Web: $versionWeb, Local: $versionLocal)" >> $logfile

        }
    } else {
        Write-Output "Couldnt find $folderName in Compatible list" >> $logfile

    }
}
Write-Output "...finished" >> $logfile




