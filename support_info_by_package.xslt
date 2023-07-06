<?xml version="1.0"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:key name="statement_id" match="statement" use="@id"/>
<xsl:key name="note_id" match="note" use="@id"/>

<xsl:template match="/">
  <html>
  <head>
    <link rel="stylesheet" type="text/css" href="support_info.css" />
  </head>
  <body>
    <h1>Package Support Status (by package)</h1>
    <p>This is current as of <xsl:value-of select="/package_support/@current_as"/></p>
    <p>The following colors are displayed to indicate the remaining support life of packages from today's date, which is <span id="thetime">Enable JavaScript for this calculation</span> :</p>
    <table>
      <thead>
	<tr>
	  <th>Background Color</th>
	  <th>Meaning</th>
	</tr>
      </thead>
      <tbody>
	<tr class="supported">
	  <td>Green</td>
	  <td>More than 180 days of support remaining</td>
	</tr>
	<tr class="unsupported">
	  <td>Red</td>
	  <td>This package is currently End of Life</td>
	</tr>
	<tr class="unsupportedin60">
	  <td>Orange</td>
	  <td>Fewer than 60 days of support remaining</td>
	</tr>
	<tr class="unsupportedin180">
	  <td>Yellow</td>
	  <td>Fewer than 180 days of support remaining</td>
	</tr>
      </tbody>
    </table>
    
    <h2>Packages</h2>
    <table cellspacing="0" id="pkglist">
      <tr>
        <th>Package</th>
	<th>EoL Date</th>
	<th>Days Remaining</th>
	<th>Support Statement</th>
	<th>Note</th>
      </tr>
      <xsl:for-each select="/package_support/statements/statement/packages/package">
	<xsl:sort select="@name"/>
	<xsl:sort select="../../@start_date"/>
	<xsl:sort select="../../@end_date"/>
        <tr class="{../../@marker}">
          <td><a name="pkg-{@name}"><xsl:value-of select="@name"/></a></td>
	  <td><xsl:value-of select="../../@start_date"/></td>
	  <td></td>
	  <td><a href="#{../../@id}"><xsl:value-of select="../../summary"/></a></td>
	  <td><xsl:value-of select="key('note_id', @note )"/></td>
        </tr>
      </xsl:for-each>
    </table>

    <h2>Support Statements</h2>
    <ul>
      <xsl:for-each select="/package_support/statements/statement">
	<li><a href="#{@id}"><xsl:value-of select="summary"/></a> (<xsl:value-of select="@marker"/>)</li>
      </xsl:for-each>
    </ul>
    <xsl:for-each select="/package_support/statements/statement">
      <h2><a name="{@id}"><xsl:value-of select="summary"/></a></h2>
      <ul>
	<li>Start Date: <xsl:value-of select="@start_date"/></li>
	<li>End Date: <xsl:value-of select="@end_date"/></li>
	<li><a href="support_info_by_support_statement.html#{@id}">Full list of packages</a></li>
      </ul>
      <p><a href="{link}"><xsl:value-of select="link"/></a></p>
      <p><xsl:value-of select="text"/></p>
    </xsl:for-each>
    <script lang="JavaScript">
var thetime = new Date(Date());
document.getElementById("thetime").innerHTML = thetime.toISOString();

rows = document.getElementById("pkglist").getElementsByTagName("tr")
for (i=1; i &lt; rows.length; i++) {
  newclass = rows[i].getElementsByTagName("td")[1].getAttribute("class");
  start_date = rows[i].getElementsByTagName("td")[1].innerHTML;
  sd = new Date(start_date);
  if (sd == undefined || start_date == "" || sd == NaN)
    continue;

  var days_remaining = ((sd.getTime() - thetime.getTime()) / (1 * 24 * 60 * 60 * 1000)).toFixed();
  if (days_remaining &lt; 0) {
    newclass = "unsupported";
  } else if (days_remaining &gt; 180) {
    newclass = "supported";
  } else if (days_remaining &gt; 60) {
    newclass = "unsupportedin180";
  } else {
    newclass = "unsupportedin60";
  }
  rows[i].setAttribute("class", newclass);
  rows[i].getElementsByTagName("td")[2].innerHTML = days_remaining;
}
    </script>    
  </body>
  </html>
</xsl:template>

</xsl:stylesheet> 
