#!/bin/bash

# please read "RCF" documents fo email name rules

# bad examples
# ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$
# ^[A-Za-z0-9._%+-]+<b>@</b>[A-Za-z0-9.-]+<b>\.</b>[A-Za-z]{2,4}$
# @https://www.networkworld.com/article/2693361/operating-systems/unix-tip-using-bash-s-regular-expressions.html
# ^(?!\.)("([^"\r\\]|\\["\r\\])*"|([-a-z0-9!#$%&'*+/=?^_`{|}~] |(?@[a-z0-9][\w\.-]*[a-z0-9]\.[a-z][a-z\.]*[a-z]$
# @https://haacked.com/archive/2007/08/21/i-knew-how-to-validate-an-email-address-until-i.aspx/

function email_validator {
	# @https://gist.github.com/guessi/82a73ee7eb2b1216eb9db17bb8d65dd1
  	[[ "$1" =~ ^[a-z0-9_\+-]+(\.[a-z0-9_\+-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*\.([a-z]{2,4})$ ]] && printf "[yes]" || printf "[no]"
}
