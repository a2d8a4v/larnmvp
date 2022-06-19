#!/bin/bash

function preload_trap {
	trap "interupt_cc" SIGINT INT TERM SIGTERM EXIT
	check_point
}
