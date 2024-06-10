<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet version='1.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform' xmlns:fo='http://www.w3.org/1999/XSL/Format'>
  <xsl:param name="ObjectType"/>
  <xsl:param name="ObjectName"/>

        <xsl:variable name="run_no">
          <xsl:for-each select="SystemStatistics/Run">
            <xsl:sort order="descending" data-type="number" select="@RunNumber"/>
            <xsl:if test="position() = 1">
              <xsl:value-of select="@RunNumber"/>
            </xsl:if>
          </xsl:for-each>
        </xsl:variable>


  <xsl:template match = '/'>
    <html>
      <title>Production System Statistics Summary Report</title>

      <head>
        <!--<h1 align="center">
          <font face="Courier New">Production System Statistics Summary Report</font>
        </h1>-->
      </head>

      <body bgcolor="#FFFFCC" text="#000000">
        <xsl:apply-templates select="SystemStatistics">
          <xsl:with-param name="run_no" select="$run_no"/>
        </xsl:apply-templates>

        <xsl:apply-templates select="SystemStatistics/Run[@RunNumber=$run_no]">
          <xsl:with-param name="run_no" select="$run_no"/>
        </xsl:apply-templates>
      </body>
    </html>
  </xsl:template>

  <!-- Print File Header -->
  <xsl:template match="SystemStatistics">
    <xsl:param name="run_no"/>

    <table border="0" width="85%" id="table1" style="border-collapse: collapse" cellpadding="5">
      <tr>
        <!--<td width="12%" rowspan="3" align="left" valign="top">
          <img border="0" src="DELMIAlogo.GIF" width="94" height="69"></img>
        </td>-->
        <td valign="top" colspan="3" align="right">
          <font face="Arial" size="6">
            Production System Simulation Statistics
          </font>
        </td>
      </tr>
      <tr>
        <td width="33%" valign="top" align="right">
          <b>
            <font face="Arial" size="2">
              Run # <xsl:value-of select="$run_no"/>
            </font>
          </b>
        </td>
        <td valign="top" width="26%" align="right">
          <b>
            <font face="Arial" size="2">
              Simulation Time: <xsl:value-of select="Run[@RunNumber=$run_no]/RunParameters/SimulationTime"/>
            </font>
          </b>
        </td>
        <td valign="top" width="21%" align="right">
          <b>
            <font face="Arial" size="2">
              Warm up Time: <xsl:value-of select="Run[@RunNumber=$run_no]/RunParameters/WarmupTime"/> 
            </font>
          </b>
        </td>
      </tr>
      <tr>
        <td width="33%" valign="top" align="right">
          <p align="left">
            <i>
              <font face="Times New Roman" size="2">
                Length in <xsl:value-of select="Units/Length"/>; Time in <xsl:value-of select="Units/Time"/>
              </font>
            </i>
          </p>
        </td>
        <td valign="top" width="26%" align="right">&#160;</td>
        <td valign="top" width="21%" align="right">
          <font face="Arial" size="2">
            <xsl:value-of select="Model/Date"/> (<xsl:value-of select="Model/Time"/>)
          </font>
        </td>
      </tr>
    </table>
    <!--<hr  size="2"/>
    <pre>
      Date (DD-MM-YY)   : <xsl:value-of select="Model/Date"/>
      Time              : <xsl:value-of select="Model/Time"/>

      Length Units        : <xsl:value-of select="Units/Length"/>
      Time Units          : <xsl:value-of select="Units/Time"/>

      Run Number          : <xsl:value-of select="$run_no"/>
      Simulation Time     : <xsl:value-of select="Run[@RunNumber=$run_no]/RunParameters/SimulationTime"/>
      Warmup Time         : <xsl:value-of select="Run[@RunNumber=$run_no]/RunParameters/WarmupTime"/>
      Statistics Collection Time    : <xsl:value-of select="Run[@RunNumber=$run_no]/RunParameters/StatsCollectionTime"/>
    </pre>
    <hr  size="2"/>-->
  </xsl:template>
  <!-- End File Header -->

  <xsl:template match="SystemStatistics/Run">
    <xsl:param name="run_no"/>

	<!-- Resources -->
    <xsl:apply-templates select="Resources">
      <xsl:with-param name="run_no" select="$run_no"/>
    </xsl:apply-templates>
    
    <!-- Products -->
    <xsl:apply-templates select="Products">
      <xsl:with-param name="run_no" select="$run_no"/>
    </xsl:apply-templates>

    <!-- Processes -->
    <xsl:apply-templates select="Processes">
      <xsl:with-param name="run_no" select="$run_no"/>
    </xsl:apply-templates>

  </xsl:template>

  <!-- Start Part Class Statistics -->
  <xsl:template match="Products">
    <xsl:param name="run_no"/>

    <h2 align="left" style="margin-bottom: 0">
      <font face="Arial">Products</font>
    </h2>
    
    <table border="1" bordercolor="#C0C0C0" cellPadding="2" cellSpacing="0" width="100%" bgcolor="#FFCCCC" style="border-collapse: collapse">
      <tr>
        <th align="center" bgcolor="#808080" rowspan="2" colspan="1">
          <font face="Arial" size="2" color="#000000">Name</font>
        </th>
        <th align="center" bgcolor="#808080" rowspan="1" colspan="3">
          <font face="Arial" size="2" color="#000000">Waiting Time</font>
        </th>
        <th align="center" bgcolor="#808080" rowspan="2" colspan="1">
          <font face="Arial" size="2" color="#000000">Arrived</font>
        </th>
        <th align="center" bgcolor="#808080" rowspan="2" colspan="1">
          <font face="Arial" size="2" color="#000000">Consumed</font>
        </th>
        <th align="center" bgcolor="#808080" rowspan="2" colspan="1">
          <font face="Arial" size="2" color="#000000">Produced</font>
        </th>
        <th align="center" bgcolor="#808080" rowspan="2" colspan="1">
          <font face="Arial" size="2" color="#000000">Dispatched</font>
        </th>
      </tr>
      <tr>
        <th align = "center" bgcolor="#808080">
          <font face="Arial" size="2" color="#000000">Min</font>
        </th>
        <th align = "center" bgcolor="#808080">
          <font face="Arial" size="2" color="#000000">Max</font>
        </th>
        <th align = "center" bgcolor="#808080">
          <font face="Arial" size="2" color="#000000">Avg</font>
        </th>
      </tr>
      <xsl:for-each select="Product">
        <tr>
          <td align="center">
            <font face="Arial" size="2" color="#000000">
              <xsl:value-of select="@Name"/>
            </font>
          </td>
          <td align="center">
            <font face="Arial" size="2" color="#000000">
              <xsl:value-of select="format-number(Statistics/ResidenceTime/Minimum,'0.000')"/>
            </font>
          </td>
          <td align="center">
            <font face="Arial" size="2" color="#000000">
              <xsl:value-of select="format-number(Statistics/ResidenceTime/Maximum,'0.000')"/>
            </font>
          </td>
          <td align="center">
            <font face="Arial" size="2" color="#000000">
              <xsl:value-of select="format-number(Statistics/ResidenceTime/Average,'0.000')"/>
            </font>
          </td>
          <td align="center">
            <font face="Arial" size="2" color="#000000">
              <xsl:value-of select="Statistics/NumCreated"/>
            </font>
          </td>
          <td align="center">
            <font face="Arial" size="2" color="#000000">
              <xsl:value-of select="Statistics/NumConsumed"/>
            </font>
          </td>
          <td align="center">
            <font face="Arial" size="2" color="#000000">
              <xsl:value-of select="Statistics/NumProduced"/>
            </font>
          </td>
          <td align="center">
            <font face="Arial" size="2" color="#000000">
              <xsl:value-of select="Statistics/NumDestroyed"/>
            </font>
          </td>
        </tr>
      </xsl:for-each>
    </table>
    <hr color="black" size="3"/>
    <br></br>
  </xsl:template>
  <!-- End Part Class Statistics -->

  <!-- Start Process Statistics -->
  <xsl:template match="Processes">
    <h2 align="left" style="margin-bottom: 0">
      <font face="Arial">Processes</font>
    </h2>
    
    <table border="1" bordercolor="#CCCCFF" cellPadding="2" cellSpacing="0" width="100%" bgcolor="#CCCCFF" style="border-collapse: collapse">
      <tr>
        <th align="center" bgcolor="#808080">
          <font face="Arial" size="2" color="#000000">Name</font>
        </th>
        <th align="center" bgcolor="#808080">
          <font face="Arial" size="2" color="#000000">Execution Count</font>
        </th>
        <th align="center" bgcolor="#808080">
          <font face="Arial" size="2" color="#000000">Avg. Working Time</font>
        </th>
        <th align="center" bgcolor="#808080">
          <font face="Arial" size="2" color="#000000">Avg. Reqmt. Time</font>
        </th>
        <th align="center" bgcolor="#808080">
          <font face="Arial" size="2" color="#000000">Avg. Activity Time</font>
        </th>
      </tr>
      <xsl:for-each select="*/Process">
          <tr>
            <td align="center">
              <font face="Arial" size="2" color="#000000">
                <xsl:value-of select="@Name"/>
              </font>
            </td>
            <td align="center">
              <font face="Arial" size="2" color="#000000">
                <xsl:value-of select="ProcessTime/Count"/>
              </font>
            </td>
            <td align="center">
              <xsl:if test="CycleTime/Count = 0">
                <font face="Arial" size="2" color="#000000">
                  0.000
                </font>
              </xsl:if>
              <xsl:if test="CycleTime/Count != 0">
                <font face="Arial" size="2" color="#000000">
                  <xsl:value-of select="format-number(CycleTime/Sum div CycleTime/Count,'0.000')"/>
                </font>
              </xsl:if>
            </td>
            <td align="center">
              <xsl:if test="ReqmtTime/Count = 0">
                <font face="Arial" size="2" color="#000000">
                  0.000
                </font>
              </xsl:if>
              <xsl:if test="ReqmtTime/Count != 0">
                <font face="Arial" size="2" color="#000000">
                  <xsl:value-of select="format-number(ReqmtTime/Sum div ReqmtTime/Count,'0.000')"/>
                </font>
              </xsl:if>
            </td>
            <td align="center">
              <xsl:if test="ProcessTime/Count = 0">
                <font face="Arial" size="2" color="#000000">
                  0.000
                </font>
              </xsl:if>
              <xsl:if test="ProcessTime/Count != 0">
                <font face="Arial" size="2" color="#000000">
                  <xsl:value-of select="format-number(ProcessTime/Sum div ProcessTime/Count,'0.000')"/>
                </font>
              </xsl:if>
            </td>
          </tr>
      </xsl:for-each>
    </table>
    <hr color="black" size="3"/>
    <br></br>
  </xsl:template>
  <!-- End Process Statistics -->

  <!-- Start Resource Statistics -->
  <xsl:template match="Resources">
    <!--<h2 align="center">
      <font face="Courier New">Resources</font>
    </h2>-->
    <xsl:for-each select="*">
      <xsl:call-template name="resource_template"/>
    </xsl:for-each>
  </xsl:template>
  <!-- End Resource Statistics -->

  <xsl:template name="href_template">
    <font face="Arial" color="blue" size="2">
      <a>
        <xsl:attribute name="href">
          #<xsl:value-of select="name(.)"/>
        </xsl:attribute>
        <b>
          <xsl:value-of select="name(.)"/>
        </b>
      </a>
    </font>
  </xsl:template>

  <xsl:template name="resource_template">
    <xsl:if test="name(.)='Sources'">
      <xsl:call-template name="source_template"/>
    </xsl:if>
    <xsl:if test="name(.)='Sinks'">
      <xsl:call-template name="sink_template"/>
    </xsl:if>
    <xsl:if test="name(.)='Buffers'">
      <xsl:call-template name="buffer_template"/>
    </xsl:if>
    <xsl:if test="name(.)='Machines'">
      <xsl:call-template name="machine_template"/>
    </xsl:if>
    <xsl:if test="name(.)='Conveyors'">
      <xsl:call-template name="conveyor_template"/>
    </xsl:if>
    <xsl:if test="name(.)='AGVs'">
      <xsl:call-template name="agv_template"/>
    </xsl:if>
    <xsl:if test="name(.)='Labors'">
      <xsl:call-template name="labor_template"/>
    </xsl:if>
    <xsl:if test="name(.)='Carriers'">
      <xsl:call-template name="carrier_template"/>
    </xsl:if>
    <!--
    Commenting code for Dec points as statistics is not supported yet
    <xsl:if test="name(.)='Cnv_Dec_Pts'">
      <xsl:call-template name="dec_template"/>
    </xsl:if>
    <xsl:if test="name(.)='Pnf_Dec_Pts'">
      <xsl:call-template name="dec_template"/>
    </xsl:if>
    <xsl:if test="name(.)='AGV_Dec_Pts'">
      <xsl:call-template name="dec_template"/>
    </xsl:if>
    <xsl:if test="name(.)='Labor_Dec_Pts'">
      <xsl:call-template name="dec_template"/>
    </xsl:if>
    -->
    <xsl:if test="name(.)='Extr_Conveyors'">
      <xsl:call-template name="conveyor_template"/>
    </xsl:if>
    <xsl:if test="name(.)='Resources'">
      <xsl:call-template name="sr_template"/>
    </xsl:if>
  </xsl:template>

  <xsl:template name="source_template">
    <h3 align="left" style="margin-bottom: 0">
      <font face="Arial">Arrivals</font>
    </h3>

    <table border="1" bordercolor="#C0C0C0" cellPadding="2" cellSpacing="0" width="40%" bgcolor="#CCFFFF" style="border-collapse: collapse">
      <tr>
        <!--<th align="center" rowspan="1" colspan="1">Source</th>
        <th	align="center" rowspan="1" colspan="1">Products Arrived</th>-->
        <th bordercolor="#C0C0C0" bgcolor="#808080">
          <p align="center">
            <font face="Arial" size="2" color="#000000">Source</font>
          </p>
        </th>
        <th bordercolor="#C0C0C0" bgcolor="#808080">
          <font face="Arial" size="2" color="#000000">Products Arrived</font>
        </th>
      </tr>
      <xsl:for-each select="*">
        <tr>
          <!--<td align="center">
            <xsl:value-of select="@Name"/>
          </td>
          <td align="center">
            <xsl:value-of select="ProductStatistics/AllProducts/NumCreated"/>
          </td>-->
          <td align="left">
            <font face="Arial" size="2" color="#000000">
              <xsl:value-of select="@Name"/>
            </font>
          </td>
          <td align="right">
            <font face="Arial" size="2" color="#000000">
              <xsl:value-of select="ProductStatistics/AllProducts/NumCreated"/>
            </font>
          </td>
        </tr>
      </xsl:for-each>
    </table>
    <hr size="2" color="black"></hr>
    <br></br>
  </xsl:template>

  <xsl:template name="sink_template">
    <h3 align="left" style="margin-bottom: 0">
      <font face="Arial">Dispatches</font>
    </h3>
    
    <table border="1" bordercolor="#C0C0C0" cellPadding="2" cellSpacing="0" width="40%" bgcolor="#CCFFFF" style="border-collapse: collapse">
      <tr>
        <th bordercolor="#C0C0C0" bgcolor="#808080">
          <p align="center">
            <font face="Arial" size="2" color="#000000">Sink</font>
          </p>
        </th>
        <th bordercolor="#C0C0C0" bgcolor="#808080">
          <font face="Arial" size="2" color="#000000">Products Dispatched</font>
        </th>
        <!--<th align="center" rowspan="1" colspan="1">Name</th>
        <th align="center" rowspan="1" colspan="1">Products Dispatched</th>-->
      </tr>
      <xsl:for-each select="*">
        <tr>
          <!--<td	align="center">
            <xsl:value-of select="@Name"/>
          </td>
          <td align="center">
            <xsl:value-of select="ProductStatistics/AllProducts/NumDestroyed"/>
          </td>-->
          <td align="left">
            <font face="Arial" size="2" color="#000000">
              <xsl:value-of select="@Name"/>
            </font>
          </td>
          <td align="right">
            <font face="Arial" size="2" color="#000000">
              <xsl:value-of select="ProductStatistics/AllProducts/NumDestroyed"/>
            </font>
          </td>
        </tr>
      </xsl:for-each>
    </table>
    <hr size="2" color="black"></hr>
    <br></br>
  </xsl:template>

  <xsl:template name="buffer_template">
    <h3 align="left" style="margin-bottom: 0">
      <font face="Arial">Storage</font>
    </h3>
    
    <xsl:variable name="StatetimesCount" select="count(Buffer[1]/StateTimes/*)"/>

    <table border="1" bordercolor="#C0C0C0" cellPadding="2" cellSpacing="0" width="100%" bgcolor="#CCFFFF" style="border-collapse: collapse">
      <tr>
        <th align="center" rowspan="2" colspan="1" bgcolor="#808080">
          <font face="Arial" size="2" color="#000000">Buffer</font>
        </th>
        <th align="center" rowspan="1" colspan="2" bgcolor="#808080">
          <font face="Arial" size="2" color="#000000">Products</font>
        </th>
        <th align="center" rowspan="1" colspan="2" bgcolor="#808080">
          <font face="Arial" size="2" color="#000000">Content</font>
        </th>
        <th align="center" rowspan="1" colspan="3" bgcolor="#808080">
          <font face="Arial" size="2" color="#000000">Waiting Time</font>
        </th>
        <th align="center" rowspan="1" colspan="{$StatetimesCount}" bgcolor="#808080">
          <font face="Arial" size="2" color="#000000">State Times</font>
        </th>
        <th align="center" rowspan="2" colspan="1" bgcolor="#808080">
          <font face="Arial" size="2" color="#000000">Utilisation (%)</font>
        </th>
      </tr>
      <tr>
        <th align = "center" bgcolor="#808080">
          <font face="Arial" size="2" color="#000000">Input</font>
        </th>
        <th align = "center" bgcolor="#808080">
          <font face="Arial" size="2" color="#000000">Output</font>
        </th>
        <th align = "center" bgcolor="#808080">
          <font face="Arial" size="2" color="#000000">Max</font>
        </th>
        <th align = "center" bgcolor="#808080">
          <font face="Arial" size="2" color="#000000">Avg</font>
        </th>
        <th align = "center" bgcolor="#808080">
          <font face="Arial" size="2" color="#000000">Min</font>
        </th>
        <th align = "center" bgcolor="#808080">
          <font face="Arial" size="2" color="#000000">Max</font>
        </th>
        <th align = "center" bgcolor="#808080">
          <font face="Arial" size="2" color="#000000">Avg</font>
        </th>
        <xsl:apply-templates select="Buffer[1]/StateTimes/*"/>
      </tr>
      <xsl:for-each select="*">
        <tr>
          <td align="center">
            <font face="Arial" size="2" color="#000000">
              <xsl:value-of select="@Name"/>
            </font>
          </td>
          <td align="center">
            <font face="Arial" size="2" color="#000000">
              <xsl:value-of select="ProductStatistics/AllProducts/TotalIn"/>
            </font>
          </td>
          <td align="center">
            <font face="Arial" size="2" color="#000000">
              <xsl:value-of select="ProductStatistics/AllProducts/TotalOut"/>
            </font>
          </td>
          <td align="center">
            <font face="Arial" size="2" color="#000000">
              <xsl:value-of select="format-number(ProductStatistics/AllProducts/Content/Maximum,'0.000')"/>
            </font>
          </td>
          <td align="center">
            <font face="Arial" size="2" color="#000000">
              <xsl:value-of select="format-number(ProductStatistics/AllProducts/Content/Average,'0.000')"/>
            </font>
          </td>
          <td align="center">
            <font face="Arial" size="2" color="#000000">
              <xsl:value-of select="format-number(ProductStatistics/AllProducts/ResidenceTime/Minimum,'0.000')"/>
            </font>
          </td>
          <td align="center">
            <font face="Arial" size="2" color="#000000">
              <xsl:value-of select="format-number(ProductStatistics/AllProducts/ResidenceTime/Maximum,'0.000')"/>
            </font>
          </td>
          <td align="center">
            <font face="Arial" size="2" color="#000000">
              <xsl:value-of select="format-number(ProductStatistics/AllProducts/ResidenceTime/Average,'0.000')"/>
            </font>
          </td>
          <xsl:for-each select="StateTimes/*">
		    <td align="center">
          <font face="Arial" size="2" color="#000000">
            <xsl:value-of select="format-number( text(), '###.###')"/>
          </font>
			</td>
          </xsl:for-each>
          <td align="center">
            <font face="Arial" size="2" color="#000000">
              <xsl:value-of select="format-number(AvgUtilization*100,'###.##')"/>
            </font>
          </td>
        </tr>
      </xsl:for-each>
    </table>
    <hr size="2" color="black"></hr>
    <br></br>
  </xsl:template>

  <xsl:template name="get_process_time">
    <script language="javascript">
      var process_time = 0.0;
      var process_count = 0.0;
      <![CDATA[
				function avg_process_time( t1, c1 )
				{
					var avg_time = 0.0;
					if( c1 != 0.0 )
					{
						avg_time = t1/c1;
            avg_time = Math.round(avg_time*1000)/1000;
					}
					
 					document.write( avg_time );
				}
				function sum_process_count( c1 )
				{
					process_count = process_count + c1;
				}
				function sum_process_time( t1 )
				{
					process_time = process_time + t1;
				}
			]]>

      <xsl:for-each select="Processes/Process">
        <xsl:if test="@Type='CycleProcess'">
          sum_process_count( <xsl:value-of select="ProcessTime/Count"/> );
          sum_process_time( <xsl:value-of select="ProcessTime/Sum"/> );
        </xsl:if>
        <xsl:if test="@Type='FluidCycleProcess'">
          sum_process_count( <xsl:value-of select="ProcessTime/Count"/> );
          sum_process_time( <xsl:value-of select="ProcessTime/Sum"/> );
        </xsl:if>
      </xsl:for-each>
      avg_process_time( process_time, process_count );
    </script>
  </xsl:template>

  <xsl:template name="get_cycle_time">
    <script language="javascript">
      var cycle_time = 0.0;
      var cycle_count = 0.0;

      <![CDATA[
				function avg_cycle_time( t1, c1 )
				{
					var avg_time = 0.0;
					if( c1 != 0.0 )
					{
						avg_time = t1/c1;
            avg_time = Math.round(avg_time*1000)/1000;
						document.write( avg_time );
					}
				}
				function sum_cycle_count( c1 )
				{
					cycle_count = cycle_count + c1;
				}
				function sum_cycle_time( t1 )
				{
					cycle_time = cycle_time + t1;
				}
			]]>

      <xsl:for-each select="Processes/Process">
        <xsl:if test="@Type='CycleProcess'">
          sum_cycle_count( <xsl:value-of select="CycleTime/Count"/> );
          sum_cycle_time( <xsl:value-of select="CycleTime/Sum"/> );
        </xsl:if>
        <xsl:if test="@Type='FluidCycleProcess'">
          sum_cycle_count( <xsl:value-of select="CycleTime/Count"/> );
          sum_cycle_time( <xsl:value-of select="CycleTime/Sum"/> );
        </xsl:if>
      </xsl:for-each>
      avg_cycle_time( cycle_time, cycle_count );
    </script>
  </xsl:template>

  <xsl:template name="machine_template">
    <h3 align="left" style="margin-bottom: 0">
      <font face="Arial">Production</font>
    </h3>
       
    <xsl:variable name="StatetimesCount" select="count(Machine[1]/StateTimes/*)"/>

    <table border="1" bordercolor="#C0C0C0" cellPadding="2" cellSpacing="0" width="100%" bgcolor="#CCFFFF" style="border-collapse: collapse">
      <tr>
        <th align="center" rowspan="2" colspan="1" bgcolor="#808080">
          <font face="Arial" size="2" color="#000000">Station</font>
        </th>
        <th align="center" rowspan="1" colspan="4" bgcolor="#808080">
          <font face="Arial" size="2" color="#000000">Products</font>
        </th>
        <!--<th align="center" rowspan="2" colspan="1" bgcolor="#808080">Avg. Activity Time</th>
        <th align="center" rowspan="2" colspan="1" bgcolor="#808080">Avg. Working Time</th>-->
        <th align="center" rowspan="2" colspan="1" bgcolor="#808080">
          <font face="Arial" size="2" color="#000000">Avg. Behaviour Time</font>
        </th>
        <th align="center" rowspan="1" colspan="{$StatetimesCount}" bgcolor="#808080">
          <font face="Arial" size="2" color="#000000">State Times</font>
        </th>
        <th align="center" rowspan="2" colspan="1" bgcolor="#808080">
          <font face="Arial" size="2" color="#000000">Utilization (%)</font>
        </th>
      </tr>
      <tr>
        <th align = "center" bgcolor="#808080">
          <font face="Arial" size="2" color="#000000">Input</font>
        </th>
        <th align = "center" bgcolor="#808080">
          <font face="Arial" size="2" color="#000000">Produced</font>
        </th>
        <th align = "center" bgcolor="#808080">
          <font face="Arial" size="2" color="#000000">Consumed</font>
        </th>
        <th align = "center" bgcolor="#808080">
          <font face="Arial" size="2" color="#000000">Output</font>
        </th>
        <xsl:apply-templates select="Machine[1]/StateTimes/*"/>
      </tr>
      <xsl:for-each select="*">
        <tr>
          <td align="center">
            <font face="Arial" size="2" color="#000000">
              <xsl:value-of select="@Name"/>
            </font>
          </td>
          <td align="center">
            <font face="Arial" size="2" color="#000000">
              <xsl:value-of select="ProductStatistics/AllProducts/TotalIn"/>
            </font>
          </td>
          <td align="center">
            <font face="Arial" size="2" color="#000000">
              <xsl:value-of select="ProductStatistics/AllProducts/NumProduced"/>
            </font>
          </td>
          <td align="center">
            <font face="Arial" size="2" color="#000000">
              <xsl:value-of select="ProductStatistics/AllProducts/NumConsumed"/>
            </font>
          </td>
          <td align="center">
            <font face="Arial" size="2" color="#000000">
              <xsl:value-of select="ProductStatistics/AllProducts/TotalOut"/>
            </font>
          </td>
          <!--<td align="center">
            <xsl:call-template name="get_process_time"/>
          </td>
          <td align="center">
            <xsl:call-template name="get_cycle_time"/>
          </td>-->
          <td align="center">
            <font face="Arial" size="2" color="#000000">
              <xsl:value-of select="format-number(Processes/Process[1]/ProcessTime/Average, '0.000')"/>
            </font>
          </td>
          <xsl:for-each select="StateTimes/*">
		    <td align="center">
          <font face="Arial" size="2" color="#000000">
            <xsl:value-of select="format-number( text(), '###.###')"/>
          </font>
			</td>
          </xsl:for-each>
          <td align="center">
            <font face="Arial" size="2" color="#000000">
              <xsl:value-of select="format-number(AvgUtilization*100,'###.##')"/>
            </font>
          </td>
        </tr>
      </xsl:for-each>
    </table>
    <hr size="2" color="black"></hr>
    <br></br>
  </xsl:template>
  
  <xsl:template name="conveyor_template">
    <h3 align="left" style="margin-bottom: 0">
      <font face="Arial">Conveyors</font>
    </h3>
    
    <table border="1" bordercolor="#C0C0C0" cellPadding="2" cellSpacing="0" width="100%" bgcolor="#CCFFFF" style="border-collapse: collapse">
      <tr>
        <th align="center" rowspan="1" colspan="1" bgcolor="#808080">
          <font face="Arial" size="2" color="#000000">Conveyor</font>
        </th>
        <th align="center" rowspan="1" colspan="1" bgcolor="#808080">
          <font face="Arial" size="2" color="#000000">Products Entered</font>
        </th>
        <th align="center" rowspan="1" colspan="1" bgcolor="#808080">
          <font face="Arial" size="2" color="#000000">Avg. Load</font>
        </th>
        <th align="center" rowspan="1" colspan="1" bgcolor="#808080">
          <font face="Arial" size="2" color="#000000">Transportation Rate</font>
        </th>
        <th align="center" rowspan="1" colspan="1" bgcolor="#808080">
          <font face="Arial" size="2" color="#000000">Avg. Residence Time</font>
        </th>
        <th align="center" rowspan="1" colspan="1" bgcolor="#808080">
          <font face="Arial" size="2" color="#000000">Utilization (%)</font>
        </th>
      </tr>
      <xsl:for-each select="*">
        <tr>
          <td align="center">
            <font face="Arial" size="2" color="#000000">
              <xsl:value-of select="@Name"/>
            </font>
          </td>
          <td align="center">
            <font face="Arial" size="2" color="#000000">
              <xsl:value-of select="PartsEntered"/>
            </font>
          </td>
          <td align="center">
            <font face="Arial" size="2" color="#000000">
              <xsl:value-of select="format-number(Load/Average,'0.000')"/>
            </font>
          </td>
          <td align="center">
            <font face="Arial" size="2" color="#000000">
              <xsl:value-of select="format-number(TransportationRate,'0.000')"/>
            </font>
          </td>
          <td align="center">
            <font face="Arial" size="2" color="#000000">
              <xsl:value-of select="format-number(PartResidenceTime/Average,'0.000')"/>
            </font>
          </td>
          <td align="center">
            <font face="Arial" size="2" color="#000000">
              <xsl:value-of select="format-number(AvgUtilization*100,'###.##')"/>
            </font>
          </td>
        </tr>
      </xsl:for-each>
    </table>
    <hr size="2" color="black"></hr>
    <br></br>
  </xsl:template>

  <xsl:template name="agv_template">
    <h3 align="left" style="margin-bottom: 0">
      <font face="Arial">AGVs</font>
    </h3>
    
    <xsl:variable name="StatetimesCount" select="count(AGV[1]/StateTimes/*)"/>

    <table border="1" bordercolor="#C0C0C0" cellPadding="2" cellSpacing="0" width="100%" bgcolor="#CCFFFF" style="border-collapse: collapse">
      <tr>
        <th align="center" rowspan="2" colspan="1" bgcolor="#808080">
          <font face="Arial" size="2" color="#000000">AGV</font>
        </th>
        <th align="center" rowspan="2" colspan="1" bgcolor="#808080">
          <font face="Arial" size="2" color="#000000">Distance Travelled</font>
        </th>
        <th align="center" rowspan="1" colspan="{$StatetimesCount}" bgcolor="#808080">
          <font face="Arial" size="2" color="#000000">State Times</font>
        </th>
        <th align="center" rowspan="2" colspan="1" bgcolor="#808080">
          <font face="Arial" size="2" color="#000000">Utilization (%)</font>
        </th>
      </tr>
      <tr>
		<xsl:apply-templates select="AGV[1]/StateTimes/*"/>
      </tr>
      <xsl:for-each select="*">
        <tr>
          <td align="center">
            <font face="Arial" size="2" color="#000000">
              <xsl:value-of select="@Name"/>
            </font>
          </td>
          <td align="center">
            <font face="Arial" size="2" color="#000000">
              <xsl:value-of select="format-number(DistanceTravelled,'0.000')"/>
            </font>
          </td>
          <xsl:for-each select="StateTimes/*">
		    <td align="center">
          <font face="Arial" size="2" color="#000000">
            <xsl:value-of select="format-number( text(), '###.###')"/>
          </font>
			</td>
          </xsl:for-each>
          <td align="center">
            <font face="Arial" size="2" color="#000000">
              <xsl:value-of select="format-number(AvgUtilization*100,'###.##')"/>
            </font>
          </td>
        </tr>
      </xsl:for-each>
    </table>
    <hr size="2" color="black"></hr>
    <br></br>
  </xsl:template>

  <xsl:template name="labor_template">
    <h3 align="left" style="margin-bottom: 0">
      <font face="Arial">Workers</font>
    </h3>

    <xsl:variable name="StatetimesCount" select="count(Labor[1]/StateTimes/*)"/>

    <table border="1" bordercolor="#C0C0C0" cellPadding="2" cellSpacing="0" width="100%" bgcolor="#CCFFFF" style="border-collapse: collapse">
      <tr>
        <th align="center" rowspan="2" colspan="1" bgcolor="#808080">
          <font face="Arial" size="2" color="#000000">Worker</font>
        </th>
        <th align="center" rowspan="2" colspan="1" bgcolor="#808080">
          <font face="Arial" size="2" color="#000000">Distance Travelled</font>
        </th>
        <th align="center" rowspan="1" colspan="{$StatetimesCount}" bgcolor="#808080">
          <font face="Arial" size="2" color="#000000">State Times</font>
        </th>
        <th align="center" rowspan="2" colspan="1" bgcolor="#808080">
          <font face="Arial" size="2" color="#000000">Utilization (%)</font>
        </th>
      </tr>
      <tr>
        <xsl:apply-templates select="Labor[1]/StateTimes/*"/>
      </tr>
      <xsl:for-each select="*">
        <tr>
          <td align="center">
            <font face="Arial" size="2" color="#000000">
              <xsl:value-of select="@Name"/>
            </font>
          </td>
          <td align="center">
            <font face="Arial" size="2" color="#000000">
              <xsl:value-of select="format-number(DistanceTravelled,'0.000')"/>
            </font>
          </td>
          <xsl:for-each select="StateTimes/*">
            <td align="center">
              <font face="Arial" size="2" color="#000000">
                <xsl:value-of select="format-number( text(), '###.###')"/>
              </font>
            </td>
          </xsl:for-each>
          <td align="center">
            <font face="Arial" size="2" color="#000000">
              <xsl:value-of select="format-number(AvgUtilization*100,'###.##')"/>
            </font>
          </td>
        </tr>
      </xsl:for-each>
    </table>
    <hr size="2" color="black"></hr>
    <br></br>
  </xsl:template>

  <xsl:template name="carrier_template">
    <table border="1" bordercolor="#C0C0C0" cellPadding="2" cellSpacing="0" width="100%" bgcolor="#CCFFFF" style="border-collapse: collapse">
      <tr>
        <th align="center" bgcolor="#808080">
          <font face="Arial" size="2" color="#000000">Carrier</font>
        </th>
        <th align="center" bgcolor="#808080">
          <font face="Arial" size="2" color="#000000">Number of Trips</font>
        </th>
        <th align="center" bgcolor="#808080">
          <font face="Arial" size="2" color="#000000">Products Entered</font>
        </th>
        <th align="center" bgcolor="#808080">
          <font face="Arial" size="2" color="#000000">Loaded Travel Time</font>
        </th>
        <th align="center" bgcolor="#808080">
          <font face="Arial" size="2" color="#000000">Empty Travel Time</font>
        </th>
        <th align="center" bgcolor="#808080">
          <font face="Arial" size="2" color="#000000">Stop Time</font>
        </th>
        <th align="center" bgcolor="#808080">
          <font face="Arial" size="2" color="#000000">Dog Time</font>
        </th>
        <th align="center" bgcolor="#808080">
          <font face="Arial" size="2" color="#000000">Avg. Product Residence Time</font>
        </th>
        <th align="center" bgcolor="#808080">
          <font face="Arial" size="2" color="#000000">Avg. Contents</font>
        </th>
      </tr>
      <xsl:for-each select="*">
        <tr>
          <td align="center">
            <font face="Arial" size="2" color="#000000">
              <xsl:value-of select="@Name"/>
            </font>
          </td>
          <td align="center">
            <font face="Arial" size="2" color="#000000">
              <xsl:value-of select="NumTrips"/>
            </font>
          </td>
          <td align="center">
            <font face="Arial" size="2" color="#000000">
              <xsl:value-of select="PartsEntered"/>
            </font>
          </td>
          <td align="center">
            <font face="Arial" size="2" color="#000000">
              <xsl:value-of select="format-number(LoadedTravelTime,'0.000')"/>
            </font>
          </td>
          <td align="center">
            <font face="Arial" size="2" color="#000000">
              <xsl:value-of select="format-number(EmptyTravelTime,'0.000')"/>
            </font>
          </td>
          <td align="center">
            <font face="Arial" size="2" color="#000000">
              <xsl:value-of select="format-number(TravelBlockTime,'0.000')"/>
            </font>
          </td>
          <td align="center">
            <font face="Arial" size="2" color="#000000">
              <xsl:value-of select="format-number(DogTime,'0.000')"/>
            </font>
          </td>
          <td align="center">
            <font face="Arial" size="2" color="#000000">
              <xsl:value-of select="format-number(PartResidenceTime/Average,'0.000')"/>
            </font>
          </td>
          <td align="center">
            <font face="Arial" size="2" color="#000000">
              <xsl:value-of select="format-number(Content/Average,'0.000')"/>
            </font>
          </td>
        </tr>
      </xsl:for-each>
    </table>
    <hr size="2" color="black"></hr>
    <br></br>
  </xsl:template>

  <xsl:template name="dec_template">
    <h3 align="left" style="margin-bottom: 0">
      <font face="Arial">Decision Points</font>
    </h3>
    <table border="1" bordercolor="#C0C0C0" cellPadding="2" cellSpacing="0" width="100%" bgcolor="#CCFFFF" style="border-collapse: collapse">
      <tr>
        <th align="center" rowspan="1" colspan="1" bgcolor="#808080">
          <font face="Arial" size="2" color="#000000">Name</font>
        </th>
        <th align="center" rowspan="1" colspan="1" bgcolor="#808080">
          <font face="Arial" size="2" color="#000000">Utilization</font>
        </th>

        <xsl:if test="name(.)!='Cnv_Dec_Pt'">
          <th align="center" rowspan="1" colspan="1" bgcolor="#808080">
            <font face="Arial" size="2" color="#000000">No. of Vehicles Crossed</font>
          </th>
          <th align="center" rowspan="1" colspan="1" bgcolor="#808080">
            <font face="Arial" size="2" color="#000000">Avg. Vehicle Time</font>
          </th>
        </xsl:if>

        <xsl:if test="name(.)='Cnv_Dec_Pt'">
          <!-- All Cnv Dec Process stats here	-->
          <th align="center" rowspan="1" colspan="1" bgcolor="#808080">
            <font face="Arial" size="2" color="#000000">No. of Products Crossed</font>
          </th>
          <th align="center" rowspan="1" colspan="1" bgcolor="#808080">
            <font face="Arial" size="2" color="#000000">Avg. Product Time</font>
          </th>
          <th align="center" rowspan="1" colspan="1" bgcolor="#808080">
            <font face="Arial" size="2" color="#000000">Avg. Activity Time</font>
          </th>
          <th align="center" rowspan="1" colspan="1" bgcolor="#808080">
            <font face="Arial" size="2" color="#000000">Avg. Working Time</font>
          </th>
          <th align="center" rowspan="1" colspan="1" bgcolor="#808080">
            <font face="Arial" size="2" color="#000000">No. of Products</font>
          </th>
          <th align="center" rowspan="1" colspan="1" bgcolor="#808080">
            <font face="Arial" size="2" color="#000000">Production Rate</font>
          </th>
          <th align="center" rowspan="1" colspan="1" bgcolor="#808080">
            <font face="Arial" size="2" color="#000000">Final Content</font>
          </th>
        </xsl:if>

        <xsl:if test="name(.)='Agv_Dec_Pt'">
          <!-- All AGV Dec Stats here	-->
          <th align="center" rowspan="1" colspan="1" bgcolor="#808080">
            <font face="Arial" size="2" color="#000000">Claim Busy Time</font>
          </th>
          <th align="center" rowspan="1" colspan="1" bgcolor="#808080">
            <font face="Arial" size="2" color="#000000">Claim Utilization</font>
          </th>
          <th align="center" rowspan="1" colspan="1" bgcolor="#808080">
            <font face="Arial" size="2" color="#000000">Total AGVs Claimed</font>
          </th>
          <th align="center" rowspan="1" colspan="1" bgcolor="#808080">
            <font face="Arial" size="2" color="#000000">Avg. Claim Wait Time</font>
          </th>
          <th align="center" rowspan="1" colspan="1" bgcolor="#808080">
            <font face="Arial" size="2" color="#000000">AGV Claim Wait Content</font>
          </th>
          <th align="center" rowspan="1" colspan="1" bgcolor="#808080">
            <font face="Arial" size="2" color="#000000">Num AGVs Waited to Claim</font>
          </th>
          <th align="center" rowspan="1" colspan="1" bgcolor="#808080">
            <font face="Arial" size="2" color="#000000">Num AGVs Claimed with No Wait</font>
          </th>
        </xsl:if>
      </tr>
      <xsl:for-each select="*">
        <tr>
          <td align="center">
            <font face="Arial" size="2" color="#000000">
              <xsl:value-of select="@Name"/>
            </font>
          </td>
          <td align="center">
            <font face="Arial" size="2" color="#000000">
              <xsl:value-of select="format-number(AvgUtilization,'0.000')"/>
            </font>
          </td>
          <xsl:if test="name(.)='Cnv_Dec_PtElement'">
            <td align="center">
              <font face="Arial" size="2" color="#000000">
                <xsl:value-of select="PartsCrossed"/>
              </font>
            </td>
          </xsl:if>
          <xsl:if test="name(.)!='Cnv_Dec_PtElement'">
            <td align="center" rowspan="1" colspan="1">
              <font face="Arial" size="2" color="#000000">
                <xsl:value-of select="VehiclesVisited"/>
              </font>
            </td>
          </xsl:if>
          <xsl:if test="name(.)='Agv_Dec_PtElement'">
            <td align="center">
              <font face="Arial" size="2" color="#000000">
                <xsl:value-of select="format-number(VehicleTime/Average,'0.000')"/>
              </font>
            </td>
          </xsl:if>
          <xsl:if test="name(.)!='Agv_Dec_PtElement'">
            <td align="center">
              <font face="Arial" size="2" color="#000000">
                <xsl:value-of select="format-number(PartResidenceTime/Average,'0.000')"/>
              </font>
            </td>
          </xsl:if>

          <xsl:if test="name(.)='Cnv_Dec_PtElement'">
            <td align="center">
              <xsl:call-template name="get_process_time"/>
            </td>
            <td align="center">
              <xsl:call-template name="get_cycle_time"/>
            </td>
            <td align="center">
              <font face="Arial" size="2" color="#000000">
                <xsl:value-of select="PartsProduced"/>
              </font>
            </td>
            <td align="center">
              <font face="Arial" size="2" color="#000000">
                <xsl:value-of select="format-number(ProductionRate,'0.000')"/>
              </font>
            </td>
            <td align="center">
              <font face="Arial" size="2" color="#000000">
                <xsl:value-of select="FinalContent"/>
              </font>
            </td>
          </xsl:if>

          <xsl:if test="name(.)='Agv_Dec_PtElement'">
            <td align="center">
              <font face="Arial" size="2" color="#000000">
                <xsl:value-of select="format-number(ClaimBusyTime,'0.000')"/>
              </font>
            </td>
            <td align="center">
              <font face="Arial" size="2" color="#000000">
                <xsl:value-of select="format-number(ClaimBusyTime div //SystemStatistics/Run[@RunNumber=$run_no]/RunParameters/StatsCollectionTime, '0.000')"/>
              </font>
            </td>
            <td align="center">
              <font face="Arial" size="2" color="#000000">
                <xsl:value-of select="TotalAGVsClaimed"/>
              </font>
            </td>
            <td align="center">
              <font face="Arial" size="2" color="#000000">
                <xsl:value-of select="format-number(AvgClaimWaitTime,'0.000')"/>
              </font>
            </td>
            <td align="center">
              <font face="Arial" size="2" color="#000000">
                <xsl:value-of select="format-number(ClaimContent/Average,'0.000')"/>
              </font>
            </td>
            <td align="center">
              <font face="Arial" size="2" color="#000000">
                <xsl:value-of select="AGVsWaitedToClaim"/>
              </font>
            </td>
            <td align="center">
              <font face="Arial" size="2" color="#000000">
                <xsl:value-of select="TotalAGVsClaimed - AGVsWaitedToClaim"/>
              </font>
            </td>
          </xsl:if>
        </tr>
      </xsl:for-each>
    </table>
    <hr size="2" color="black"></hr>
    <br></br>
  </xsl:template>

  <xsl:template name="sr_template">

    <xsl:variable name="StatetimesCount" select="count(Resource[1]/StateTimes/*)"/>

    <table border="1" bordercolor="#C0C0C0" cellPadding="2" cellSpacing="0" width="100%" bgcolor="#CCFFFF" style="border-collapse: collapse">
      <tr>
        <th align="center" rowspan="2" colspan="1" bgcolor="#808080">
          <font face="Arial" size="2" color="#000000">Name</font>
        </th>
		    <th align="center" rowspan="1" colspan="{$StatetimesCount}" bgcolor="#808080">
          <font face="Arial" size="2" color="#000000">State Times</font>
        </th>
      </tr>
      <tr>
		  <xsl:apply-templates select="Resource[1]/StateTimes/*"/>
      </tr>
      <xsl:for-each select="*">
        <tr>
          <td align="center">
            <font face="Arial" size="2" color="#000000">
              <xsl:value-of select="@Name"/>
            </font>
          </td>
          <xsl:for-each select="StateTimes/*">
			  <td align="center">
          <font face="Arial" size="2" color="#000000">
            <xsl:value-of select="format-number( text(), '###.###')"/>
          </font>
			  </td>
          </xsl:for-each>
        </tr>
      </xsl:for-each>
    </table>
    <hr size="2" color="black"></hr>
    <br></br>
  </xsl:template>
  
  <xsl:template match="IDLE">
	<th align = "center" bgcolor="#808080">
    <font face="Arial" size="2" color="#000000">Idle</font>
  </th>
  </xsl:template>
  
  <xsl:template match="IDLE_PARKED">
	<th align = "center" bgcolor="#808080">
    <font face="Arial" size="2" color="#000000">Idle Parked</font>
  </th>
  </xsl:template>
  
  <xsl:template match="BUSY_PROCESSING">
	<th align = "center" bgcolor="#808080">
    <font face="Arial" size="2" color="#000000">Busy Processing</font>
  </th>
  </xsl:template>

  <xsl:template match="BUSY_LOADING">
    <th align = "center" bgcolor="#808080">
      <font face="Arial" size="2" color="#000000">Busy Loading</font>
    </th>
  </xsl:template>

  <xsl:template match="BUSY_UNLOADING">
    <th align = "center" bgcolor="#808080">
      <font face="Arial" size="2" color="#000000">Busy Loading</font>
    </th>
  </xsl:template>

  <xsl:template match="BUSY_SETUP">
    <th align = "center" bgcolor="#808080">
      <font face="Arial" size="2" color="#000000">Busy Setup</font>
    </th>
  </xsl:template>
  
  <xsl:template match="BUSY_REPAIR">
	  <th align = "center" bgcolor="#808080">
      <font face="Arial" size="2" color="#000000">Busy Repair</font>
    </th>
  </xsl:template>

  <xsl:template match="LOADED_TRAVEL">
    <th align = "center" bgcolor="#808080">
      <font face="Arial" size="2" color="#000000">Loaded Travel</font>
    </th>
  </xsl:template>
  
  <xsl:template match="EMPTY_TRAVEL">
	  <th align = "center" bgcolor="#808080">
      <font face="Arial" size="2" color="#000000">Empty Travel</font>
    </th>
  </xsl:template>
  
  <xsl:template match="TRAVEL_BLOCK">
	  <th align = "center" bgcolor="#808080">
      <font face="Arial" size="2" color="#000000">Travel Block</font>
    </th>
  </xsl:template>

  <xsl:template match="UNLOAD_BLOCK">
    <th align = "center" bgcolor="#808080">
      <font face="Arial" size="2" color="#000000">Unload Block</font>
    </th>
  </xsl:template>
  
  <xsl:template match="REQMT_BLOCK">
	  <th align = "center" bgcolor="#808080">
      <font face="Arial" size="2" color="#000000">Requirement Block</font>
    </th>
  </xsl:template>

  <xsl:template match="DEPART_REQMT_BLOCK">
    <th align = "center" bgcolor="#808080">
      <font face="Arial" size="2" color="#000000">Depart Reqmt. Block</font>
    </th>
  </xsl:template>
  
  <xsl:template match="CLAIM_BLOCK">
	  <th align = "center" bgcolor="#808080">
      <font face="Arial" size="2" color="#000000">Claim Block</font>
    </th>
  </xsl:template>

  <xsl:template match="REQMT_PREEMPTED">
    <th align = "center" bgcolor="#808080">
      <font face="Arial" size="2" color="#000000">Reqmt. Preempted</font>
    </th>
  </xsl:template>
  
  <xsl:template match="WAIT_BLOCK">
	  <th align = "center" bgcolor="#808080">
      <font face="Arial" size="2" color="#000000">Wait Block</font>
    </th>
  </xsl:template>

  <xsl:template match="SHIFT_OUT">
    <th align = "center" bgcolor="#808080">
      <font face="Arial" size="2" color="#000000">Shift Out</font>
    </th>
  </xsl:template>
  
  <xsl:template match="SHIFT_BRK">
	  <th align = "center" bgcolor="#808080">
      <font face="Arial" size="2" color="#000000">Shift Break</font>
    </th>
  </xsl:template>

  <xsl:template match="FAILED">
    <th align = "center" bgcolor="#808080">
      <font face="Arial" size="2" color="#000000">Failed</font>
    </th>
  </xsl:template>
  
  <xsl:template match="BUSY_XFERING">
	  <th align = "center" bgcolor="#808080">
      <font face="Arial" size="2" color="#000000">Busy Transfering</font>
    </th>
  </xsl:template>
  
  <xsl:template match="NOT_CONSIDERED">
	  <th align = "center" bgcolor="#808080">
      <font face="Arial" size="2" color="#000000">Not Considered</font>
    </th>
  </xsl:template>

</xsl:stylesheet>
