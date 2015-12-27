#define DISABLE_USBX		1

DefinitionBlock ("SSDT-GA-H77N-WIFI.aml", "SSDT", 2, "APPLE ", "General", 0x20151227)
{
	External (_SB.PCI0, DeviceObj)

	External (_SB.PCI0.RP05, DeviceObj)
	External (_SB.PCI0.RP06, DeviceObj)

	External (_SB.PCI0.RP05.PXSX, DeviceObj)
	External (_SB.PCI0.RP06.PXSX, DeviceObj)

	#include "../include/7-Series.asl"

	Scope (\_SB.PCI0)
	{
		Name (PW94, Package () { 0x09, 0x04 })

		Scope (RP05)
		{
			// Disabling the PXSX device
			Scope (PXSX) { Name (_STA, Zero) }
			// Adding a new ETH0 device
			Device (ETH0)
			{
				Name (_ADR, Zero)
				Alias (PW94, _PRW)
				// Adding location device property to first NIC (Realtek RTL8168E-VL/8111E-VL)
				Method (_DSM, 4)
				{
					If (Arg2 == Zero) { Return (Buffer () { 0x03 }) }
					Return (Package () { "location", Buffer() { "1" } })
				}
			}
		}

		Scope (RP06)
		{
			// Disabling the PXSX device
			Scope (PXSX) { Name (_STA, Zero) }
			// Adding a new ETH1 device
			Device (ETH1)
			{
				Name (_ADR, Zero)
				Alias (PW94, _PRW)
				// Adding location device property to second NIC (Realtek RTL8168E-VL/8111E-VL)
				Method (_DSM, 4)
				{
					If (Arg2 == Zero) { Return (Buffer () { 0x03 }) }
					Return (Package () { "location", Buffer() { "2" } })
				}
			}
		}
	}
}
