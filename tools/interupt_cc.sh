#!/bin/bash

## -- if interrupt
# if exit or interrupt, copy logs and delete all things
function interupt_cc {
	copy_self || echo "pass"
	delete_self || echo "pass"
	exit 2
}
