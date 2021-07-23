Function Install-updates{
    #Prerequistes
        Install-Module PSWindowsUpdate
    
        $Script = {import-module PSWindowsUpdate; Get-WindowsUpdate -AcceptAll -Install | Out-File C:\PSWindowsUpdate-$(Get-Date -Format yyyy-MM-dd).log}
    
        Invoke-WUjob -ComputerName $computers -Script $Script -Confirm:$false -RunNow
    
    }
    
    Function Validate-Updates{
    
        $body = Invoke-Command -ComputerName $computers -ScriptBlock {
        Get-Item C:\PSWindowsUpdate-$(Get-Date -Format yyyy-MM-dd).log | Select-String -Pattern "failed" -SimpleMatch |
        Select-Object -Property line } | Select-Object -Property Line,PSComputerName | ConvertTo-Html
        $From = "no_reply@archmi.com"
        $To = "ccaudill@archmi.com"
        $Subject = "Patching $(Get-Date -Format yyyy-MM-dd)"
        $SMTPServer = "smtp_internal.cmgmi.local"
        Send-MailMessage -From $From -to $To -Subject $Subject -SmtpServer $SMTPServer -BodyAsHtml $body
    
    $computers = @("")
    Install-updates
    Validate-Updates
