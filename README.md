# Access Blocking/Unblocking Script for IIS
The scripts is designed to block/unblock a specific port for one or several subnets on a IIS web servers. The blocking is implemented by adding a rule for incoming traffic in Windows Firewall. If the rule already exists in Windows Firewall and is not active, the script will activate the rule. The unlocking is carried out through the deactivation of the rule.

## Features

- Checking for the presence of the rule in Firewall
- Adding the rule if it is absent
- Enabling the rule if it already exists
- Checking for errors when adding the rule
- Information messages with the execution status
- Disabling the rule with a check for its presence

## Usage

To run the blocking script, first you need to specify your variables for the file block_network.ps1:

**$serverNames** - Name of the server or multiple servers. 
Example: $serverNames = 'wmstest-arr01', 'wmstest-arr02'

**$tsdNetwork** - Specific IP address/addresses or subnet/subnets.
Example: $tsdNetwork = '192.168.72.0/23', '192.168.74.0/23', '192.168.76.5/24'

**$ruleName** - The name with which the rule will be created.
Example: $ruleName = 'Block Android Users'

Run PowerShell as a user who has the rights to make changes in the Windows Firewall on the servers listed in the $serverNames variable and navigate to the directory with the scripts using the cd command. And then run the script with the command:
```sh
.\block_network.ps1
```
For the unblocking script, you need to specify the variables **$serverNames** and **$ruleName**. And then run the script with the command:
```sh
.\unblock_network.ps1
```