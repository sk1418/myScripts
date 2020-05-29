 #!/bin/bash
 # Disable device on USB to wake up system from suspend
 echo "XHC" > /proc/acpi/wakeup
 echo "EHC1" > /proc/acpi/wakeup
 echo "EHC2" > /proc/acpi/wakeup
