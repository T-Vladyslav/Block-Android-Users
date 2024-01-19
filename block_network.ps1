$serverNames = 'wmstest-arr01','wmstest-arr02'
$tsdNetwork = '192.168.72.0/23' , '192.168.74.0/23'
$ruleName = 'Block Android Users'

foreach ($serverName in $serverNames) {  
    Invoke-Command -ComputerName $serverName -ScriptBlock {
        param($ruleName, $serverName, $tsdNetwork)
        
        function Write-Server {
            param([string]$message)
            Write-Host $message -ForegroundColor Cyan
        }
        
        function Write-Success {
            param([string]$message)
            Write-Host $message -ForegroundColor Green
        }
        
        function Write-Warning {
            param([string]$message)
            Write-Host $message -ForegroundColor Yellow
        }
        
        function Write-Error {
            param([string]$message)
            Write-Host $message -ForegroundColor Red
        }

        Write-Server $serverName":"

        if (Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue) {
            $firewallRule = Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue

            if ($firewallRule.Enabled -eq 'False') {
                # Включение правила, если оно выключено
                Enable-NetFirewallRule -DisplayName $ruleName
                Write-Success "`t Правило '$ruleName' было выключено и теперь включено."
            } else {
                Write-Success "`t Правило '$ruleName' уже включено."
            }

        } else {
            Write-Warning "`t Правило '$ruleName' не найдено и будет создано."
            try {
                New-NetFirewallRule -DisplayName "Block Android Users" -Direction Inbound -Action Block -Protocol TCP -LocalPort 443 -RemoteAddress $tsdNetwork -ErrorAction Stop | Out-Null
                Write-Success "`t Правило '$ruleName' успешно создано."
            } catch {
                Write-Error "`t Ошибка при создании правила '$ruleName'."
            }
        }        
    } -ArgumentList $ruleName, $serverName, $tsdNetwork
}