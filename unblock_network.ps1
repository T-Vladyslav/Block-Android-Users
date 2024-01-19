$serverNames = 'wmstest-arr01','wmstest-arr02'
$ruleName = 'Block Android Users'

foreach ($serverName in $serverNames) {  
    Invoke-Command -ComputerName $serverName -ScriptBlock {
        param($ruleName, $serverName)

        function Write-Server {
            param([string]$message)
            Write-Host $message -ForegroundColor Cyan
        }
        
        function Write-Success {
            param([string]$message)
            Write-Host $message -ForegroundColor Green
        }

        Write-Server $serverName":"

        if (Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue) {
            $firewallRule = Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue

            if ($firewallRule.Enabled -eq 'True') {
                # Выключение правила, если оно включено
                Disable-NetFirewallRule -DisplayName $ruleName
                Write-Success "`t Правило '$ruleName' было выключено."
            } else {
                Write-Success "`t Правило '$ruleName' уже выключено."
            }
        } else {
            Write-Success "`t Правило '$ruleName' не существует. Ничего делать не надо."
        } 
    } -ArgumentList $ruleName, $serverName
}