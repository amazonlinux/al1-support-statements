<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:key name="statement_id" match="statement" use="@id"/>
<xsl:key name="note_id" match="note" use="@id"/>

<xsl:template match="/">
  <html>
  <head>
    <link rel="stylesheet" type="text/css" href="support_info.css" />
  </head>
  <body>
    <h1>Package Support Status</h1>
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
    <ul>
      <xsl:for-each select="/package_support/statements/statement">
	<li><a href="#{@id}"><xsl:value-of select="summary"/></a></li>
      </xsl:for-each>
    </ul>
    <xsl:for-each select="/package_support/statements/statement">
      <h2><a name="{@id}"><xsl:value-of select="summary"/></a></h2>
      <p><a href="{link}"><xsl:value-of select="link"/></a></p>
      <p><xsl:value-of select="text"/></p>

      <h3>Package List</h3>
      <table cellspacing="0" id="pkglist-{@id}">
	<tr>
          <th>Package</th>
	  <th>Days Remaining</th>
	  <th>Note</th>
	</tr>
	<xsl:for-each select="packages/package">
        <tr class="{../../@marker}">
          <td><xsl:value-of select="@name"/></td>
	  <td></td>
	  <td><xsl:value-of select="key('note_id', @note )"/></td>
          </tr>
	</xsl:for-each>
      </table>
    </xsl:for-each>
    <script lang="JavaScript">
      var thetime = new Date(Date());
      document.getElementById("thetime").innerHTML = thetime.toISOString();

      var support_dates = {
    <xsl:for-each select="/package_support/statements/statement">"pkglist-<xsl:value-of select="@id"/>" : "<xsl:value-of select="@start_date"/>",</xsl:for-each>
    };
    for (const [s_id, start_date] of Object.entries(support_dates)) {
      rows = document.getElementById(s_id).getElementsByTagName("tr")
      if (rows.length &lt; 2) {
            continue; // Maybe no packages
      }
      newclass = rows[1].getAttribute("class");

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
      for (i=1; i &lt; rows.length; i++) {
        rows[i].setAttribute("class", newclass);
        rows[i].getElementsByTagName("td")[1].innerHTML = days_remaining;
      }
    }
    </script>
  </body>
  </html>
</xsl:template>

</xsl:stylesheet> 
