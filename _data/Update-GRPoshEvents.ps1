


Function Update-GRPoshEvents ($LocalRepoPath)
{

    Import-Module posh-git
    $AllEvents = @()
    $AllEvents += ((Invoke-WebRequest -Uri "http://groupspaces.com/GRPosh/api/events?alt=json&published-min=2008-01-01T00:00:00").Content | ConvertFrom-Json).items

    

    foreach ($Event in $AllEvents)
    {
        #Trimming out groupspaces crummy HTML tags
        $Event.Summary = $Event.Summary -replace '<[^>]*>',''
        $Event.summary = $Event.summary -replace '\n', "<br /><br />"

    }

    #Converting back to JSON for easy parsing in the browser
    $AllEvents = "[$($AllEvents | ConvertTo-Json)]"

    $AllEvents | Out-File -Encoding UTF8 -FilePath $LocalRepoPath\_data\events.json -Force
  
    Start-SshAgent

    cd $LocalRepoPath
    git commit -m 'Latest Events' \events.json
    git push 

}