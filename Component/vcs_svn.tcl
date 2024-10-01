# $Id$
lappend components "Subversion" "Subversion Integration" "1.00"

proc Subversion_info {} {
	regexp {[0-9]+\.[0-9]+\.[0-9]+} "[exec svn --version]" version
	add_toc2 "Subversion"
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
