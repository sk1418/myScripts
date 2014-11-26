#!/bin/bash
########################################
# rebind usb ports and suspend system (sudo/root needed)
########################################
USB_DIR="/sys/bus/pci/drivers/xhci_hcd"
IDS=$(\ls -1 $USB_DIR|grep ':')
echo "rebinding all usb ports ..."
echo -n "$IDS" > "$USB_DIR/unbind" && sudo echo -n "$IDS"> "$USB_DIR/bind"
echo "suspending system ..."
systemctl suspend

 
