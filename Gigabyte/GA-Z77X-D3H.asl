#define DISABLE_USBX		1

DefinitionBlock ("SSDT-GA-Z77X-D3H.aml", "SSDT", 2, "APPLE ", "General", 0x20151227)
{
	External (_SB.PCI0, DeviceObj)

	External (_SB.PCI0.RP05, DeviceObj)
	External (_SB.PCI0.RP06, DeviceObj)
	External (_SB.PCI0.RP07, DeviceObj)
	External (_SB.PCI0.RP08, DeviceObj)

	External (_SB.PCI0.RP05.MVL1, DeviceObj)
	External (_SB.PCI0.RP05.MVL2, DeviceObj)
	External (_SB.PCI0.RP05.PXSX, DeviceObj)
	External (_SB.PCI0.RP06.PXSX, DeviceObj)
	External (_SB.PCI0.RP07.PXSX, DeviceObj)
	External (_SB.PCI0.RP08.PXSX, DeviceObj)

	#include "../include/7-Series.asl"

	Scope (\_SB.PCI0)
	{
		Name (PW94, Package () { 0x09, 0x04 })

		Scope (RP05)
		{
			// Disabling the MVLx (IDE) devices
			Scope (MVL1) { Name (_STA, Zero) }
			Scope (MVL2) { Name (_STA, Zero) }
			// Disabling the PXSX device
			Scope (PXSX) { Name (_STA, Zero) }
			// Adding a new XH02 device
			Device (XH02)
			{
				Name (_ADR, Zero)
				Alias (PW94, _PRW)
				// Let AppleUSBODD know that USB SuperDrive is supported on this Mac (credit: Pike R. Alpha)
				Name (MBSD, One)
				Method (_DSM, 4)
				{
					If (Arg2 == Zero) { Return (Buffer() { 0x03 }) }
					Store (0x00, Index (\_SB.PCI0.EH01.PROP, 0x07))
					Return (\_SB.PCI0.EH01.PROP)
				}
			}
		}

		Scope (RP06)
		{
			// Disabling the PXSX device
			Scope (PXSX) { Name (_STA, Zero) }
			// Adding a new ARPT device
			Device (ARPT)
			{
				Name (_ADR, Zero)
				Alias (PW94, _PRW)
			}
		}

		Scope (RP07)
		{
			// Disabling the PXSX device
			Scope (PXSX) { Name (_STA, Zero) }
			// Adding a new GIGE device
			Device (GIGE)
			{
				Name (_ADR, Zero)
				Alias (PW94, _PRW)
			}
		}

		Scope (RP08)
		{
			// Disabling the PXSX device
			Scope (PXSX) { Name (_STA, Zero) }
			// Adding a new SATA device
			Device (SATA)
			{
				Name (_ADR, Zero)
				Alias (PW94, _PRW)
			}
		}
	}
}
