#appcenter-post-clone.ps1
Write-Host 'Begin appcenter-post-clone.ps1 begin'

Write-Host '######################################'
Write-Host 'Command Prompt fsutil'
Write-Host '######################################'
fsutil
Write-Host '######################################'

Write-Host '######################################'
Write-Host 'List all files under current directory'
Write-Host '######################################'
ls
Write-Host '######################################'

Write-Host '######################################'
Write-Host 'Print APPCENTER_SOURCE_DIRECTORY'
Write-Host '######################################'

$env:APPCENTER_SOURCE_DIRECTORY

Write-Host '######################################'
Write-Host 'Recusive List of Directoies'
Write-Host '######################################'

$directory = $env:APPCENTER_SOURCE_DIRECTORY + '\RemoveMe\'
$directory
$dirList = [System.IO.Directory]::GetDirectories($directory)
$dirList

ForEach ($dir in $dirList)
{
    $dirAttribute =  [System.IO.File]::GetAttributes($dir)
    $dirAttribute
    if ($dirAttribute.ToString().Contains('ReparsePoint'))
    {
        $dir
    }
}


Write-Host '######################################'
Write-Host 'Remove Directory'
Write-Host '######################################'

rm -r -fo $env:APPCENTER_SOURCE_DIRECTORY\RemoveMe\

Write-Host '######################################'
Write-Host 'List all files under current directory'
Write-Host '######################################'
ls -Recurse
Write-Host '######################################'

#Write-Host '######################################'
#Write-Host 'List All Environment Variables'
#Write-Host '######################################'
#dir env:

Write-Host '######################################'
Write-Host 'End appcenter-post-clone.ps1 begin'
Write-Host '######################################'
