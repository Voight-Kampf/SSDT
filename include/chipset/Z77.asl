	External (_SB.LNKA._STA, IntObj)
	External (_SB.LNKB._STA, IntObj)
	External (_SB.LNKC._STA, IntObj)
	External (_SB.LNKD._STA, IntObj)
	External (_SB.LNKE._STA, IntObj)
	External (_SB.LNKF._STA, IntObj)
	External (_SB.LNKG._STA, IntObj)
	External (_SB.LNKH._STA, IntObj)

	External (_SB.PCI0.B0D4, DeviceObj)
	External (_SB.PCI0.EH01, DeviceObj)
	External (_SB.PCI0.EH02, DeviceObj)
#ifdef INTEL_GBE_DEVICE
	External (INTEL_GBE_DEVICE, DeviceObj)
#else
	External (_SB.PCI0.GIGE, DeviceObj)
#endif
	External (_SB.PCI0.HDEF, DeviceObj)
	External (_SB.PCI0.IGPU, DeviceObj)
	External (_SB.PCI0.IMEI, DeviceObj)
	External (_SB.PCI0.LPCB, DeviceObj)
	External (_SB.PCI0.PEG0, DeviceObj)
#if DISABLE_PEG2_IDE == 1
	External (_SB.PCI0.PEG2, DeviceObj)
#endif

	External (_SB.PCI0.SAT1, DeviceObj)
	External (_SB.PCI0.SBUS, DeviceObj)
	External (_SB.PCI0.WMI1, DeviceObj)
	External (_SB.PCI0.XH01, DeviceObj)

	External (_SB.PCI0.LPCB.RMSC, DeviceObj)
#if DISABLE_PS2_PORT == 1
	External (_SB.PCI0.LPCB.SIO1, DeviceObj)
#endif
#if FIX_SHUTDOWN == 1
	External (_SB.PCI0.LPCB.SPTS, MethodObj)
#endif
	External (_SB.PCI0.PEG0.GFX0, DeviceObj)
#if DISABLE_PEG2_IDE == 1
	External (_SB.PCI0.PEG2.MVL3, DeviceObj)
	External (_SB.PCI0.PEG2.MVL4, DeviceObj)
#endif
	External (_SB.PCI0.TPMX._STA, IntObj)
	External (_SB.PCI0.XH01.RHUB, DeviceObj)

	External (_SB.PCI0.LPCB.CWDT._STA, IntObj)
	External (_SB.PCI0.XH01.RHUB.HSP1, DeviceObj)
	External (_SB.PCI0.XH01.RHUB.HSP2, DeviceObj)
	External (_SB.PCI0.XH01.RHUB.HSP3, DeviceObj)
	External (_SB.PCI0.XH01.RHUB.HSP4, DeviceObj)

	External (_TZ.FAN0, DeviceObj)
	External (_TZ.FAN1, DeviceObj)
	External (_TZ.FAN2, DeviceObj)
	External (_TZ.FAN3, DeviceObj)
	External (_TZ.FAN4, DeviceObj)
	External (_TZ.TZ00, PkgObj)
	External (_TZ.TZ01, PkgObj)

	// Calls to XOSI in the DSDT are routed here
	Method (XOSI, 1, Serialized)
	{
		// Simulates Windows 2012 (Windows 8)
		Name (WINV, Package ()
		{
			"Windows",			// Generic Windows query
			"Windows 2001",		// Windows XP
			"Windows 2001 SP2",	// Windows XP SP2
			"Windows 2006",		// Windows Vista
			"Windows 2006 SP1",	// Windows Vista SP1
			"Windows 2009",		// Windows 7/Windows Server 2008 R2
			"Windows 2012",		// Windows 8/Windows Server 2012
		})

		// _OSI must return true for all previous versions of Windows
		Return (Match (WINV, MEQ, Arg0, MTR, Zero, Zero) != Ones)
	}

	Method (\_SB._INI)
	{
		// These devices already have _STA objects, we set them to 0 to disable them

		// Disabling the TPMX device
		\_SB.PCI0.TPMX._STA = Zero

		// Disabling the CWDT device
		\_SB.PCI0.LPCB.CWDT._STA = Zero

		// Disabling the ThermalZones
		\_TZ.TZ00 = Zero
		\_TZ.TZ01 = Zero
	}

	Scope (\_SB.PCI0)
	{
		// Disabling the B0D4 device
		Scope (B0D4) { Name (_STA, Zero) }

		#include "../include/gfx/7-Series.asl"

		// Adding device properties to EH01
		Scope (EH01)
		{
			Name (PROP, Package ()
			{
				"AAPL,current-available", 0x0834,
				"AAPL,current-extra", 0x0A8C,
				"AAPL,current-extra-in-sleep", 0x0A8C,
				"AAPL,device-internal", 0x02,
				"AAPL,max-port-current-in-sleep", 0x0834
			})

			Method (_DSM, 4)
			{
				If (Arg2 == Zero) { Return (Buffer () { 0x03 }) }
				Return (PROP)
			}
		}

		// Adding device properties to EH02
		Scope (EH02)
		{
			Method (_DSM, 4)
			{
				If (Arg2 == Zero) { Return (Buffer () { 0x03 }) }
				Return (\_SB.PCI0.EH01.PROP)
			}
		}

		// Adding device properties to XH01
		Scope (XH01)
		{
			// Let AppleUSBODD know that USB SuperDrive is supported on this Mac (credit: Pike R. Alpha)
			Name (MBSD, One)
			Method (_DSM, 4)
			{
				If (Arg2 == Zero) { Return (Buffer () { 0x03 }) }
				Store (0x00, Index (\_SB.PCI0.EH01.PROP, 0x07))
				Return (\_SB.PCI0.EH01.PROP)
			}

			Scope (RHUB)
			{
				// Disabling unneeded USB 2.0 ports
				Scope (HSP1) { Name (_STA, Zero) }
				Scope (HSP2) { Name (_STA, Zero) }
				Scope (HSP3) { Name (_STA, Zero) }
				Scope (HSP4) { Name (_STA, Zero) }
			}
		}

#if DISABLE_PEG2_IDE == 1
		Scope (PEG2)
		{
			// Disabling the MVLx (IDE) devices
			Scope (MVL3) { Name (_STA, Zero) }
			Scope (MVL4) { Name (_STA, Zero) }
		}
#endif

#ifndef INTEL_GBE_DEVICE
		// Disabling the GIGE device
		Scope (GIGE) { Name (_STA, Zero) }
#endif

		Scope (LPCB)
		{
			// Disabling the RMSC device
			Scope (RMSC) { Name (_STA, Zero) }
#if DISABLE_PS2_PORT == 1
			// Disabling the SIO1 device
			Scope (SIO1) { Name (_STA, Zero) }
#endif
		}

		// Disabling the SAT1 device
		Scope (SAT1) { Name (_STA, Zero) }

		Scope (SBUS)
		{
			// Adding a new BUS0 device
			Device (BUS0)
			{
				Name (_ADR, Zero)
				Name (_CID, "smbus")
				Device (BLC0)
				{
					Name (_ADR, Zero)
					Name (_CID, "smbus-blc")
				}
			}
		}

		// Disabling the WMI1 device
		Scope (WMI1) { Name (_STA, Zero) }
	}

	Scope (\_TZ)
	{
		// Disabling the FANx devices
		Scope (FAN0) { Name (_STA, Zero) }
		Scope (FAN1) { Name (_STA, Zero) }
		Scope (FAN2) { Name (_STA, Zero) }
		Scope (FAN3) { Name (_STA, Zero) }
		Scope (FAN4) { Name (_STA, Zero) }
	}

#if FIX_SHUTDOWN == 1
	Method (_PTS, 1)
	{
		If ((Arg0) && (Arg0 != 0x05))
		{
			\_SB.PCI0.LPCB.SPTS (Arg0)
		}
	}
#endif
