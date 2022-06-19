#!/bin/bash

function lower_case {
	# @https://stackoverflow.com/questions/2264428/how-to-convert-a-string-to-lower-case-in-bash
	printf "$1" | tr '[:upper:]' '[:lower:]'
}
