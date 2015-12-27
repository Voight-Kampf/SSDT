		Scope (IMEI)
		{
			Method (_DSM, 4)
			{
				If (Arg2 == Zero) { Return (Buffer () { 0x03 }) }
				// 6 Series IGPUs on a 7 Series chipset require IMEI device ID faking in order to get the IGPU kexts to load
				If ((\_SB.PCI0.IGPU.DID0 == 0x102) || (\_SB.PCI0.IGPU.DID0 == 0x112) || (\_SB.PCI0.IGPU.DID0 == 0x122) | (\_SB.PCI0.IGPU.DID0 == 0x10A))
				{
					Return (Package () { "device-id", Buffer () { 0x3A, 0x1C, 0x00, 0x00 } })
				}

				Return (Package () { Zero })
			}
		}

		Scope (IGPU)
		{
			OperationRegion (IGPH, PCI_Config, Zero, 0x40)
			Field (IGPH, ByteAcc, NoLock, Preserve)
			{
				VID0,	16,
				DID0,	16
			}

			Method (_DSM, 4)
			{
				If (Arg2 == Zero) { Return (Buffer () { 0x03 }) }
				// If the device ID of PEG0.GFX0.VID0 is 8086, the IGPU is the primary graphics adapter
				// We will inject the normal platform ID and fake device ID (if needed) to use the IGPU for display output
				If (\_SB.PCI0.PEG0.GFX0.VID0 == 0x8086)
				{
					Store (Package ()
					{
						0x0112,
						0x0122,
						0x010A,
						Package ()
						{
							"AAPL,snb-platform-id", Buffer () { 0x10, 0x00, 0x03, 0x00 },
							"device-id", Buffer () { 0x26, 0x01, 0x00, 0x00 }
						},

						0x0162,
						0x016A,
						Package ()
						{
							"AAPL,ig-platform-id", Buffer () { 0x0A, 0x00, 0x66, 0x01 },
							"device-id", Buffer () { 0x62, 0x01, 0x00, 0x00 }
						}
					}, Local4)
				}
				// If the device ID of PEG0.GFX0.VID0 isn't 8086, a PCIe GPU is the primary graphics adapter
				// Therefore, we can use the IGPU for AirPlay Mirroring/QuickSync (like a real iMac) by injecting a platform ID with 0 connectors
				Else
				{
					Store (Package ()
					{
						0x0102,
						Package () { "AAPL,snb-platform-id", Buffer (0x04) { 0x01, 0x00, 0x03, 0x00 } },

						0x0112,
						0x0112,
						0x010A,
						Package ()
						{
							"AAPL,snb-platform-id", Buffer () { 0x01, 0x00, 0x03, 0x00 },
							"device-id", Buffer () { 0x26, 0x01, 0x00, 0x00 }
						},

						0x0152,
						Package ()
						{
							"AAPL,ig-platform-id", Buffer () { 0x07, 0x00, 0x62, 0x01 }
						},

						0x0162,
						0x016A,
						Package ()
						{
							"AAPL,ig-platform-id", Buffer () { 0x07, 0x00, 0x62, 0x01 },
							"device-id", Buffer (0x04) { 0x62, 0x01, 0x00, 0x00 }
						}
					}, Local4)
				}

				// Credit: RehabMan
				Store (DID0, Local3)
				Store (Zero, Local0)
				Store (SizeOf (Local4), Local1)
				While (LLess (Local0, Local1))
				{
					Store (DerefOf (Index (Local4, Local0)), Local2)
					If (LEqual (One, ObjectType (Local2)))
					{
						If (LEqual (Local2, Local3))
						{
							Increment (Local0)
							While (LLess (Local0, Local1))
							{
								Store (DerefOf (Index (Local4, Local0)), Local2)
								If (LEqual (0x04, ObjectType (Local2)))
								{
									Return (Local2)
								}

								Increment (Local0)
							}
						}
					}

					Increment (Local0)
				}

				Return (Package () { Zero })
			}
		}

		Scope (PEG0)
		{
			Scope (GFX0)
			{
				OperationRegion (GFXH, PCI_Config, Zero, 0x40)
				Field (GFXH, ByteAcc, NoLock, Preserve)
				{
					VID0,	16,
					DID0,	16
				}

				Method (_DSM, 4)
				{
					If (Arg2 == Zero) { Return (Buffer () { 0x03 }) }
					Return (Package () { "AAPL,slot-name", Buffer() { "Slot-1" } })
				}
			}

			Device (HDAU)
			{
				Name (_ADR, One)
				Method (_DSM, 4)
				{
					If (Arg2 == Zero) { Return (Buffer () { 0x03 }) }
					If (\_SB.PCI0.PEG0.GFX0.VID0 != 0xFFFF)
					{
						If (\_SB.PCI0.PEG0.GFX0.VID0 == 0x8086)
						{
							Return (Package () { "hda-gfx", Buffer() { "onboard-2" } })
						}
						Else
						{
							Return (Package () { "hda-gfx", Buffer() { "onboard-1" } })
						}
					}

					Return (Package () { Zero })
				}
			}
		}

		Scope (HDEF)
		{
			Method (_DSM, 4)
			{
				If (Arg2 == Zero) { Return (Buffer () { 0x03 }) }
				If (\_SB.PCI0.PEG0.GFX0.VID0 == 0x8086)
				{
					Return (Package () { "hda-gfx", Buffer() { "onboard-1" } })
				}

				Return (Package () { Zero })
			}
		}
