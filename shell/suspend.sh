#!/bin/bash
########################################
# rebind usb ports and suspend system (sudo/root needed)
########################################
USB_DIR="/sys/bus/pci/drivers/xhci_hcd"
IDS=$(\ls -1 $USB_DIR|grep ':')
echo "rebinding all usb ports ..."
sudo echo -n "$IDS" > "$USB_DIR/unbind" && sudo echo -n "$IDS"> "$USB_DIR/bind" 
echo "Done."

while true; do
    read -p "Suspend system?" yn
    case $yn in
        [Yy]* ) systemctl suspend; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer y or n.";;
    esac
done
