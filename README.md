# ACPI

[Tiny SSDTs](https://github.com/Piker-Alpha/RevoBoot/wiki/ACPI-patching,-done-the-easy-way) for various motherboards running OS X.

### Usage

Build the SSDT for your board using the `mkSSDT.sh` script. For example:

```
~/G/SSDT ❯❯❯ ./mkSSDT.sh GA-Z77X-UD5H
Compiling GA-Z77X-UD5H.asl

Intel ACPI Component Architecture
ASL+ Optimizing Compiler version 20150717-64
Copyright (c) 2000 - 2015 Intel Corporation

ASL Input:     /Users/alexjames/GitHub/SSDT/Gigabyte/GA-Z77X-UD5H.asl - 148 lines, 3407 bytes, 237 keywords
AML Output:    /Users/alexjames/GitHub/SSDT/Gigabyte/SSDT-GA-Z77X-UD5H.aml - 2331 bytes, 130 named objects, 107 executable opcodes

Compilation complete. 0 Errors, 0 Warnings, 0 Remarks, 16 Optimizations
```

The script will output the compiled SSDT-HACK.aml to the root of the repo folder.

Note that these SSDTs require some DSDT edits (usually device/method renaming), which can be accomplished with Clover DSDT binpatches, which will vary depending on your motherboard.
