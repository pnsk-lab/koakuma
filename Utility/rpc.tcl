# $Id$
package require http
package require base64
package require term::ansi::ctrl::unix

catch {
	package require tls
	::http::register https 443 ::tls::socket
	puts "HTTPs is usable."
}

set RPC_URL "http://127.0.0.1/koakuma/rpc"
if { [info exists "env(KOAKUMA_RPC)"] } {
	set RPC_URL "$env(KOAKUMA_RPC)"
}
set RPC_URL "[regsub {/+$} "$RPC_URL" ""]"

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
		global username
		global password
		puts -nonewline "Username: "
		flush stdout
		set ::rpc::username "[gets stdin]"
		puts -nonewline "Password: "
		flush stdout
		exec stty -echo
		set ::rpc::password "[gets stdin]"
		exec stty echo
		puts ""

		set headers ""
		lappend headers "Authorization"
		lappend headers "Basic [::base64::encode -wrapchar "" "$::rpc::username:$::rpc::password"]"

		global RPC_URL
		set tok [::http::geturl "$RPC_URL" -headers $headers]
		set code [::http::ncode $tok]
		::http::cleanup $tok

		if { $code == 200 } {
			return 1
		}
		return 0
	}
	proc send {path content} {
		set headers ""
		global RPC_URL
		if { "$::rpc::username" != "" } {
			lappend headers "Authorization"
			lappend headers "Basic [::base64::encode -wrapchar "" "$::rpc::username:$::rpc::password"]"
		}
		set tok [::http::geturl "$RPC_URL$path" -headers $headers -type "application/json" -query "$content"]
		set code [::http::ncode $tok]
		set body "[::http::data $tok]"
		::http::cleanup $tok
		lappend result "$code"
		lappend result "$body"
		return $result
	}
	proc init {} {
		puts -nonewline "Authentication: "
		set status [::rpc::require-auth]
		if { $status == 1 } {
			puts "Required"
			if { ![::rpc::ask-auth] } {
				puts "Authentication failure"
				exit 1
			}
		} elseif { $status < 0 } {
			puts "Got forbidden, cannot continue"
			exit 1
		} else {
			puts "Not required"
		}
	}
}
