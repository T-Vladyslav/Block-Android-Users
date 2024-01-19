$serverNames = 'wmstest-arr01','wmstest-arr02'
$tsdNetwork = '192.168.72.0/23' , '192.168.74.0/23'
$ruleName = 'Block Android Users'

foreach ($serverName in $serverNames) {  
    Invoke-Command -ComputerName $serverName -ScriptBlock {
        param($ruleName, $serverName, $tsdNetwork)
        
        Write-Host $serverName":"

        if (Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue) {
            $firewallRule = Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue

            if ($firewallRule.Enabled -eq 'False') {
                # Включение правила, если оно выключено
                Enable-NetFirewallRule -DisplayName $ruleName
                Write-Host "`t Правило '$ruleName' было выключено и теперь включено."
            } else {
                Write-Host "`t Правило '$ruleName' уже включено."
            }

        } else {
            Write-Host "`t Правило '$ruleName' не найдено и будет создано."
            try {
                New-NetFirewallRule -DisplayName "Block Android Users" -Direction Inbound -Action Block -Protocol TCP -LocalPort 443 -RemoteAddress $tsdNetwork -ErrorAction Stop | Out-Null
                Write-Host "`t Правило '$ruleName' успешно создано."
            } catch {
            Write-Host "`t Ошибка при создании правила '$ruleName'."
            }
        }        
    } -ArgumentList $ruleName, $serverName, $tsdNetwork
}