# $Id$
package require http
package require base64
package require term::ansi::ctrl::unix

namespace eval rpc {
	proc require-auth {} {
		global RPC_URL
		set tok [::http::geturl "$RPC_URL"]
		set code [::http::ncode $tok]
		::http::cleanup $tok
		if { $code == 401 } {
			return 1
		} elseif { $code == 403 } {
			return -1
		} else {
			return 0
		}
	}
	set username ""
	set password ""
	proc ask-auth {} {
		upvar 1 username username
		upvar 1 password password
		puts -nonewline "Username: "
		flush stdout
		set username "[gets stdin]"
		puts -nonewline "Password: "
		flush stdout
		exec stty -echo
		set password "[gets stdin]"
		exec stty echo
		puts ""

		set headers ""
		lappend headers "Authorization"
		lappend headers "Basic [::base64::encode -wrapchar "" "$username:$password"]"

		global RPC_URL
		set tok [::http::geturl "$RPC_URL" -headers $headers]
		set code [::http::ncode $tok]
		::http::cleanup $tok

		if { $code == 200 } {
			return 1
		}
		return 0
	}
}
