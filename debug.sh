#!/bin/bash
 
APP_NAME="sumo_mangment-srv"
 
echo -e "\n\e[1;34m🛠️  Starting CAPM Live Debugging Setup for $APP_NAME...\e[0m"
 
# Step 1: CF login check
if ! cf oauth-token > /dev/null 2>&1; then
    echo -e "\n\e[1;33m🔐 You are not logged in to Cloud Foundry.\e[0m"
    echo -e "👉 Please log in manually using: \e[1;36mcf login --sso\e[0m"
    exit 1
else
    echo -e "\e[1;32m✅ Already logged in to Cloud Foundry.\e[0m"
fi
 
# Step 2: Enable SSH (only if not already enabled)
echo -e "\n🔍 Checking if SSH is enabled for $APP_NAME..."
cf ssh-enabled "$APP_NAME" | grep -q "enabled"
 
if [ $? -eq 0 ]; then
    echo -e "\e[1;32m✅ SSH is already enabled for $APP_NAME.\e[0m"
else
    echo -e "\e[1;33m⚙️  Enabling SSH for $APP_NAME...\e[0m"
    cf enable-ssh "$APP_NAME"
fi
 
# Step 3: Restart the app
echo -e "\n🔄 Restarting $APP_NAME to apply SSH settings..."
cf restart "$APP_NAME"
 
# Step 4: SSH into the app
echo -e "\n🔐 Connecting to $APP_NAME via SSH..."
echo -e "📋 Once inside, run:\e[1;36m ps aux | grep node\e[0m"
echo -e "📝 Note the main Node.js PID (the one running cds-serve), then \e[1;35mexit\e[0m the SSH session."
cf ssh "$APP_NAME"
 
# Step 5: Prompt for PID after exiting SSH
read -p $'\n🔢 Enter the Node.js PID you noted earlier: ' pid
 
if [[ "$pid" =~ ^[0-9]+$ ]]; then
    echo -e "\n📡 Sending SIGUSR1 to PID $pid to activate debugger..."
    cf ssh "$APP_NAME" -c "kill -USR1 $pid"
    echo -e "\e[1;32m✅ Debugger activated on PID $pid.\e[0m"
else
    echo -e "\e[1;31m❌ Invalid PID entered. Exiting.\e[0m"
    exit 1
fi
 
# Step 6: Final Instructions
echo -e "\n🧠 \e[1;35mNow open a \e[1;36mNEW terminal window\e[0m and run:\n"
echo -e "  \e[1;36mcf ssh -N -L 9229:127.0.0.1:9229 $APP_NAME\e[0m\n"
echo -e "🧪 Then in Chrome, go to: \e[1;36mchrome://inspect\e[0m"
echo -e "Click 'Configure' and ensure \e[1;36mlocalhost:9229\e[0m is listed.\n"