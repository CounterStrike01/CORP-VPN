# CORP-VPN
Automated VPN Configuration Script
This PowerShell script automates the creation and configuration of a corporate L2TP/IPsec VPN connection on Windows systems. It is designed for all-user deployment and ensures consistent VPN, DNS, IPv6, and routing configuration across endpoints.
✨ Features

✅ Creates or recreates a standardized L2TP VPN connection (CORP-VPN)
🔁 Safely removes and re-adds the VPN if it already exists
🔐 Configures pre-shared key (PSK) and MS-CHAPv2 authentication
🌐 Applies custom DNS servers to the active VPN interface
🚫 Disables IPv6 on the VPN adapter to prevent routing or DNS issues
🧭 Adds persistent static routes for internal corporate networks
🖥️ Runs fully unattended with minimal user interaction

🛠 What the Script Does

Bypasses execution policy for the current PowerShell session
Checks whether the VPN connection name already exists
Creates or re-creates the VPN using:

L2TP/IPsec
Pre-shared key authentication
Stored credentials
All-user scope


Detects the active WAN Miniport (L2TP) adapter
Applies corporate DNS servers to the VPN interface
Disables IPv6 on the VPN adapter
Adds persistent static routes for internal subnets

📌 Requirements

Windows 10 / 11 or Windows Server
PowerShell running as Administrator
Built-in Windows VPN client
User has permission to create all-user VPN connections and routes

🚀 Usage
Run the script in an elevated PowerShell session:
PowerShell.\Configure-CorpVPN.ps1Show more lines
The VPN connection will be created as CORP-VPN and will be available to all users on the machine.
⚠️ Notes & Considerations

The script assumes the VPN server address, PSK, DNS servers, and routes are correct for your environment.
Static routes are added using route.exe with the -p flag, making them persistent across reboots.
If the VPN interface is not active at runtime, DNS and IPv6 changes may not apply immediately.

🔒 Security Disclaimer
This script contains hard-coded VPN credentials and PSK values for automation purposes.
Do not publish this repository publicly without removing or securing sensitive information.
👤 Intended Audience

System Administrators
Infrastructure Engineers
Enterprise IT teams
Intune / Endpoint management deployments
