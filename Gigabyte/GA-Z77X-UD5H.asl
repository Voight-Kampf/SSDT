#define DISABLE_PEG2_IDE	1
#define DISABLE_PS2_PORT	1
#define DISABLE_USBX		1
#define INTEL_GBE_DEVICE	\_SB.PCI0.ETH1

DefinitionBlock ("SSDT-GA-Z77X-UD5H.aml", "SSDT", 2, "APPLE ", "General", 0x20151227)
{
	External (_SB.PCI0, DeviceObj)

	External (_SB.PCI0.RP02, DeviceObj)
	External (_SB.PCI0.RP05, DeviceObj)
	External (_SB.PCI0.RP06, DeviceObj)
	External (_SB.PCI0.RP07, DeviceObj)
	External (_SB.PCI0.RP08, DeviceObj)

	External (_SB.PCI0.RP02.PXSX, DeviceObj)
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

		Scope (INTEL_GBE_DEVICE)
		{
			// Adding location device property to second NIC (Intel 82579V)
			Method (_DSM, 4)
			{
				If (Arg2 == Zero) { Return (Buffer () { 0x03 }) }
				Return (Package () { "location", Buffer() { "2" } })
			}
		}

		Scope (RP02)
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

		Scope (RP05)
		{
			// Disabling the MVLx (IDE) devices
			Scope (MVL1) { Name (_STA, Zero) }
			Scope (MVL2) { Name (_STA, Zero) }
			// Disabling the PXSX device
			Scope (PXSX) { Name (_STA, Zero) }
			// Adding a new ARPT device
			Device (ARPT)
			{
				Name (_ADR, Zero)
				Alias (PW94, _PRW)
			}
		}

		Scope (RP06)
		{
			// Disabling the PXSX device
			Scope (PXSX) { Name (_STA, Zero) }
			// Adding a new FWBR device
			Device (FWBR)
			{
				Name (_ADR, Zero)
				Alias (PW94, _PRW)
				Device (FRWR)
				{
					Name (_ADR, 0x06010000)
					Name (_GPE, 0x1A)
					Method (_DSM, 4)
					{
						If (Arg2 == Zero) { Return (Buffer () { 0x03 }) }
						Return (Package ()
						{
							"fwports", Unicode("\x02"),
							"fws0", Unicode("\x01"),
							"fwswappedbib", Unicode("\x01")
						})
					}
				}
			}

			// Adding a new GPE to fix FireWire power management
			Method (\_SB._GPE._L1A, 0)
			{
				Notify (\_SB.PCI0.RP06.FWBR.FRWR, 0x02)
			}
		}

		Scope (RP07)
		{
			// Disabling the PXSX device
			Scope (PXSX) { Name (_STA, Zero) }
			// Adding a new ETH0 device
			Device (ETH0)
			{
				Name (_ADR, Zero)
				Alias (PW94, _PRW)
				// Adding location device property to first NIC (Atheros AR8151/8161)
				Method (_DSM, 4)
				{
					If (Arg2 == Zero) { Return (Buffer () { 0x03 }) }
					Return (Package () { "location", Buffer() { "1" } })
				}
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
