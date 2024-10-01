# $Id$
lappend components "CVS" "CVS Integration" "1.00" "VCS"

proc CVS_info {} {
	regexp {[0-9]+\.[0-9]+\.[0-9]+} "[exec cvs --version]" version
	add_toc2 "CVS"
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
