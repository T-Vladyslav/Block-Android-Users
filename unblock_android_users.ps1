$serverNames = 'wmstest-arr01','wmstest-arr02'
$ruleName = 'Block Android Users'

foreach ($serverName in $serverNames) {  
    Invoke-Command -ComputerName $serverName -ScriptBlock {
        param($ruleName, $serverName)
        
        Write-Host $serverName":"

        if (Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue) {
            $firewallRule = Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue
            Write-Host $serverName":"

            if ($firewallRule.Enabled -eq 'True') {
                # Выключение правила, если оно включено
                Disable-NetFirewallRule -DisplayName $ruleName
                Write-Host "`t Правило '$ruleName' было выключено."
            } else {
                Write-Host "`t Правило '$ruleName' уже выключено."
            }
        } else {
            Write-Host "`t Правило '$ruleName' не существует. Ничего делать не надо."
        } 
    } -ArgumentList $ruleName, $serverName
}