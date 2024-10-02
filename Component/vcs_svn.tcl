# $Id$
lappend components "Subversion" "Subversion Integration" "1.00" "VCS"

proc Subversion_info {} {
	regexp {[0-9]+\.[0-9]+\.[0-9]+} "[exec svn --version]" version
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

proc Subversion_repository {url ws} {
	if { [file exists "$ws"] } {
		if { [catch {exec svn up "$ws" >@stdout 2>@1}] } {
			return 1
		}
		return 0
	} else {
		if { [catch {exec svn co "$url" "$ws" >@stdout 2>@1}] } {
			return 1
		}
		return 0
	}
}
