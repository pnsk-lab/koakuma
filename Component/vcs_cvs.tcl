# $Id$
lappend components "CVS" "CVS Integration" "1.00" "VCS"

proc CVS_info {} {
	regexp {[0-9]+\.[0-9]+\.[0-9]+} "[exec cvs --version]" version
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

proc CVS_repository {url ws} {
	set result [URL_parse "$url"]
	set path "[regsub {@[^@]+$} "[Get_KV $result "path"]" ""]"
	regexp {^.+@([^@]+)$} "[Get_KV $result "path"]" -> reponame

	if { "[Get_KV $result "scheme"]" == "pserver" } {
		if { [file exists "$ws"] } {
			set old "[pwd]"
			cd "$ws"
			if { [catch {exec cvs -d ":pserver:[Get_KV $result "userpass"]@[Get_KV $result "host"]:$path" up >@stdout 2>@1}] } {
				cd "$old"
				return 1
			}
			cd "$old"
		} else {
			if { [catch {exec cvs -d ":pserver:[Get_KV $result "userpass"]@[Get_KV $result "host"]:$path" co -d "$ws" "$reponame" >@stdout 2>@1}] } {
				return 1
			}
		}
		return 0
	} elseif { "[Get_KV $result "scheme"]" == "file" } {
		if { [file exists "$ws"] } {
			set old "[pwd]"
			cd "$ws"
			if { [catch {exec cvs -d "$path" up >@stdout 2>@1}] } {
				cd "$old"
				return 1
			}
			cd "$old"
		} else {
			if { [catch {exec cvs -d "$path" co -d "$ws" "$reponame" >@stdout 2>@1}] } {
				return 1
			}
		}
		return 0
	} else {
		return 1
	}
	return 0
}
