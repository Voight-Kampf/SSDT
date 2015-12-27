#!/bin/bash
# mkSSDT.sh

# Initialize global variables

## The script version
gScriptVersion="0.1"

## The folder containing the repo
gRepo=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

## The motherboard
gMotherboard="$1"

## Styling stuff
STYLE_RESET="\e[0m"
STYLE_BOLD="\e[1m"

## Color stuff
COLOR_RED="\e[1;31m"

if [ -z $gMotherboard ]; then
	echo "Usage: ./mkSSDT.sh <motherboard>, where <motherboard> is one of the following:"
	# printf "     "
	# find . -name "*.asl" -not -path "./include*" | cut -d "/" -f 3 | tr -d '.asl'
	tree -I 'include|README.md|iasl|mkSSDT.sh' --noreport
	echo
else
	if [ ! -f $gRepo/*/$gMotherboard.asl ]; then
		printf "${COLOR_RED}${STYLE_BOLD}ERROR: ${STYLE_RESET}${STYLE_BOLD}$gMotherboard is not supported by this script!${STYLE_RESET} Exiting...\n"
	else
		printf "${STYLE_BOLD}Compiling $gMotherboard.asl${STYLE_RESET}:\n"
		"$gRepo/iasl" $gRepo/*/$gMotherboard.asl
		mv $gRepo/*/*.aml $gRepo/SSDT-HACK.aml
	fi
fi
