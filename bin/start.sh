#!/bin/bash

# Check if the VNC service is active
if [[ $(sudo systemctl is-active vncserver-x11-serviced.service) != "active" ]]; then
    echo "VNC is not active. Enabling and starting VNC..."

    # Enable VNC non-interactively
    sudo raspi-config nonint do_vnc 0

    # Start the VNC service
    sudo systemctl start vncserver-x11-serviced.service

    echo "VNC has been enabled and started."
else
    echo "VNC is already active. Continuing..."
fi
# Set static ip 
echo "Starting static IP configuration..."
curl -sL https://raw.githubusercontent.com/rsgarciae/raspi-tailhole/main/bin/set_static_ip.sh | bash

# Enable ip forwarding 
echo "Enable ip forwarding"
curl -sL https://raw.githubusercontent.com/rsgarciae/raspi-tailhole/main/bin/enable_ip_forwarding.sh | bash

# Install docker
echo "Installing docker"
./install_docker.sh 
curl -sL https://raw.githubusercontent.com/rsgarciae/raspi-tailhole/main/bin/install_docker.sh | bash

