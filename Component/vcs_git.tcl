# $Id$
lappend components "Git" "Git Integration" "1.00" "VCS"

proc Git_info {} {
	regexp {[0-9]+\.[0-9]+\.[0-9]+} "[exec git --version]" version
	tputs	"<table border=\"0\">"
	tputs	"	<tr>"
	tputs	"		<th>"
	tputs	"			Version"
	tputs	"		</th>"
	tputs	"		<td>"
	tputs	"			$version"
	tputs	"		</td>"
	tputs	"	</tr>"
	tputs	"</table>"
}

proc Git_repository {url ws} {
	if { [file exists "$ws"] } {
		set old "[pwd]"
		cd "$ws"
		if { [catch {exec git pull >@stdout 2>@1}] } {
			cd "$old"
			return 1
		}
		cd "$old"
		return 0
	} else {
		if { [catch {exec git clone --recursive "$url" "$ws" >@stdout 2>@1}] } {
			return 1
		}
		return 0
	}
}
