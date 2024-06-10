<?xml version='1.0' encoding='utf-8'?>
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
      <title>Statistics Summary Report</title>
      
      <head>
        <!--<h1 align="center">
          <font face="Courier New">Statistics Summary Report</font>
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
    
    <!-- Products -->
    <xsl:if test="$ObjectType = 'Product'">
      <xsl:apply-templates select="Products">
        <xsl:with-param name="run_no" select="$run_no"/>
      </xsl:apply-templates>
    </xsl:if>

    <!-- Processes -->
    <xsl:if test="$ObjectType = 'Process'">
      <xsl:apply-templates select="Processes">
        <xsl:with-param name="run_no" select="$run_no"/>
      </xsl:apply-templates>
    </xsl:if>

    <!-- Resources -->
    <xsl:if test="$ObjectType = 'Resource'">
      <xsl:apply-templates select="Resources">
        <xsl:with-param name="run_no" select="$run_no"/>
      </xsl:apply-templates>
    </xsl:if>

  </xsl:template>

  <!-- Start Product Statistics -->
  <xsl:template match="Products">
    <xsl:param name="run_no"/>

    <xsl:for-each select="Product">
      <xsl:if test="@Name = $ObjectName">
        <h2 align="center">
          <font face="Courier New">
            Statistics of Product - <xsl:value-of select="@Name"/>
          </font>
        </h2>
        <table border="1" bordercolor="#C0C0C0" cellPadding="2" cellSpacing="0" width="100%" bgcolor="#CCFFFF" style="border-collapse: collapse">
          <tr>
            <th align="center" rowspan="2" colspan="1" bgcolor="#808080">Name</th>
            <th align="center" rowspan="1" colspan="3" bgcolor="#808080">Waiting Time</th>
            <th align="center" rowspan="2" colspan="1" bgcolor="#808080">Arrived</th>
            <th align="center" rowspan="2" colspan="1" bgcolor="#808080">Consumed</th>
            <th align="center" rowspan="2" colspan="1" bgcolor="#808080">Produced</th>
            <th align="center" rowspan="2" colspan="1" bgcolor="#808080">Dispatched</th>
          </tr>
          <tr>
            <th align = "center" bgcolor="#808080">Min</th>
            <th align = "center" bgcolor="#808080">Max</th>
            <th align = "center" bgcolor="#808080">Avg</th>
          </tr>
          <tr>
            <td align="center">
              <xsl:value-of select="@Name"/>
            </td>
            <td align="center">
              <xsl:value-of select="format-number(Statistics/ResidenceTime/Minimum,'0.000')"/>
            </td>
            <td align="center">
              <xsl:value-of select="format-number(Statistics/ResidenceTime/Maximum,'0.000')"/>
            </td>
            <td align="center">
              <xsl:value-of select="format-number(Statistics/ResidenceTime/Average,'0.000')"/>
            </td>
            <td align="center">
              <xsl:value-of select="Statistics/NumCreated"/>
            </td>
            <td align="center">
              <xsl:value-of select="Statistics/NumConsumed"/>
            </td>
            <td align="center">
              <xsl:value-of select="Statistics/NumProduced"/>
            </td>
            <td align="center">
              <xsl:value-of select="Statistics/NumDestroyed"/>
            </td>
          </tr>
        </table>
      </xsl:if>
    </xsl:for-each>
    <br/>
    <hr/>
  </xsl:template>
  <!-- End Product Statistics -->

  <!-- Start Process Statistics -->
  <xsl:template match="Processes">
    <xsl:for-each select="*">
      <xsl:for-each select="Process">
        <xsl:if test="@Name = $ObjectName">
          <h2 align="center">
            <font face="Courier New">
              Statistics of Process - <xsl:value-of select="@Name"/>
            </font>
          </h2>
          <table border="1" bordercolor="#C0C0C0" cellPadding="2" cellSpacing="0" width="100%" bgcolor="#CCFFFF" style="border-collapse: collapse">
            <tr>
              <th align="center" bgcolor="#808080">Name</th>
              <th align="center" bgcolor="#808080">Execution Count</th>
              <th align="center" bgcolor="#808080">Avg. Working Time</th>
              <th align="center" bgcolor="#808080">Avg. Reqmt. Time</th>
              <th align="center" bgcolor="#808080">Avg. Activity Time</th>
            </tr>
            <tr>
              <td align="center">
                <xsl:value-of select="@Name"/>
              </td>
              <td align="center">
                <xsl:value-of select="ProcessTime/Count"/>
              </td>
              <td align="center">
                <xsl:if test="CycleTime/Count = 0">
                  0.000
                </xsl:if>
                <xsl:if test="CycleTime/Count != 0">
                  <xsl:value-of select="format-number(CycleTime/Sum div CycleTime/Count,'0.000')"/>
                </xsl:if>
              </td>
              <td align="center">
                <xsl:if test="ReqmtTime/Count = 0">
                  0.000
                </xsl:if>
                <xsl:if test="ReqmtTime/Count != 0">
                  <xsl:value-of select="format-number(ReqmtTime/Sum div ReqmtTime/Count,'0.000')"/>
                </xsl:if>
              </td>
              <td align="center">
                <xsl:if test="ProcessTime/Count = 0">
                  0.000
                </xsl:if>
                <xsl:if test="ProcessTime/Count != 0">
                  <xsl:value-of select="format-number(ProcessTime/Sum div ProcessTime/Count,'0.000')"/>
                </xsl:if>
              </td>
            </tr>
          </table>
        </xsl:if>
      </xsl:for-each>
    </xsl:for-each>
    <hr color="black" size="3"/>
    <br></br>
  </xsl:template>
  <!-- End Process Statistics -->

  <!-- Start Resource Statistics -->
  <xsl:template match="Resources">
    <xsl:for-each select="*"	>
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
      <xsl:call-template name="agv_template"/>
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
    <xsl:for-each select="*">
      <xsl:if test="@Name = $ObjectName">
        <h2 align="center">
          <font face="Courier New">
            Statistics of Source (Resource) - <xsl:value-of select="@Name"/>
          </font>
        </h2>

        <table border="1" bordercolor="#C0C0C0" cellPadding="2" cellSpacing="0" width="40%" bgcolor="#CCFFFF" style="border-collapse: collapse">
          <tr>
            <th align="center" rowspan="1" colspan="1" bgcolor="#808080">Name</th>
            <th	align="center" rowspan="1" colspan="1" bgcolor="#808080">Products Arrived</th>
          </tr>
          <tr>
            <td align="center">
              <xsl:value-of select="@Name"/>
            </td>
            <td align="center">
              <xsl:value-of select="ProductStatistics/AllProducts/NumCreated"/>
            </td>
          </tr>
        </table>
        <hr size="2" color="black"></hr>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="sink_template">
    <xsl:for-each select="*">
      <xsl:if test="@Name = $ObjectName">
        <h2 align="center">
          <font face="Courier New">
            Statistics of Sink (Resource) - <xsl:value-of select="@Name"/>
          </font>
        </h2>

        <table border="1" bordercolor="#C0C0C0" cellPadding="2" cellSpacing="0" width="40%" bgcolor="#CCFFFF" style="border-collapse: collapse">
          <tr>
            <th align="center" rowspan="1" colspan="1" bgcolor="#808080">Name</th>
            <th align="center" rowspan="1" colspan="1" bgcolor="#808080">Products Dispatched</th>
          </tr>
          <tr>
            <td	align="center">
              <xsl:value-of select="@Name"/>
            </td>
            <td align="center">
              <xsl:value-of select="ProductStatistics/AllProducts/NumDestroyed"/>
            </td>
          </tr>
        </table>
        <hr size="2" color="black"></hr>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="buffer_template">
    <xsl:for-each select="*">
      <xsl:if test="@Name = $ObjectName">
        <h2 align="center">
          <font face="Courier New">
            Statistics of Buffer (Resource) - <xsl:value-of select="@Name"/>
          </font>
        </h2>

        <xsl:variable name="StatetimesCount" select="count(StateTimes/*)"/>

        <table border="1" bordercolor="#C0C0C0" cellPadding="2" cellSpacing="0" width="100%" bgcolor="#CCFFFF" style="border-collapse: collapse">
          <tr>
            <th align="center" rowspan="2" colspan="1" bgcolor="#808080">Name</th>
            <th align="center" rowspan="1" colspan="2" bgcolor="#808080">Products</th>
            <th align="center" rowspan="1" colspan="2" bgcolor="#808080">Content</th>
            <th align="center" rowspan="1" colspan="3" bgcolor="#808080">Waiting Time</th>
            <th align="center" rowspan="1" colspan="{$StatetimesCount}" bgcolor="#808080">State Times</th>
            <th align="center" rowspan="2" colspan="1" bgcolor="#808080">Utilisation (%)</th>
          </tr>
          <tr>
            <th align = "center" bgcolor="#808080">Input</th>
            <th align = "center" bgcolor="#808080">Output</th>
            <th align = "center" bgcolor="#808080">Max</th>
            <th align = "center" bgcolor="#808080">Avg</th>
            <th align = "center" bgcolor="#808080">Min</th>
            <th align = "center" bgcolor="#808080">Max</th>
            <th align = "center" bgcolor="#808080">Avg</th>
            <xsl:apply-templates select="StateTimes/*"/>
          </tr>
          <tr>
            <td align="center">
              <xsl:value-of select="@Name"/>
            </td>
            <td align="center">
              <xsl:value-of select="ProductStatistics/AllProducts/TotalIn"/>
            </td>
            <td align="center">
              <xsl:value-of select="ProductStatistics/AllProducts/TotalOut"/>
            </td>
            <td align="center">
              <xsl:value-of select="format-number(ProductStatistics/AllProducts/Content/Maximum,'0.000')"/>
            </td>
            <td align="center">
              <xsl:value-of select="format-number(ProductStatistics/AllProducts/Content/Average,'0.000')"/>
            </td>
            <td align="center">
              <xsl:value-of select="format-number(ProductStatistics/AllProducts/ResidenceTime/Minimum,'0.000')"/>
            </td>
            <td align="center">
              <xsl:value-of select="format-number(ProductStatistics/AllProducts/ResidenceTime/Maximum,'0.000')"/>
            </td>
            <td align="center">
              <xsl:value-of select="format-number(ProductStatistics/AllProducts/ResidenceTime/Average,'0.000')"/>
            </td>
            <xsl:for-each select="StateTimes/*">
				<td align="center">
					<xsl:value-of select="format-number( text(), '###.###')"/>
				</td>
            </xsl:for-each>
            <td align="center">
              <xsl:value-of select="format-number(AvgUtilization*100,'###.##')"/>
            </td>
          </tr>
        </table>
        <hr size="2" color="black"></hr>
      </xsl:if>
    </xsl:for-each>
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
    <xsl:for-each select="*">
      <xsl:if test="@Name = $ObjectName">
        <h2 align="center">
          <font face="Courier New">
            Statistics of Station (Resource) - <xsl:value-of select="@Name"/>
          </font>
        </h2>
        
        <xsl:variable name="StatetimesCount" select="count(StateTimes/*)"/>

        <table border="1" bordercolor="#C0C0C0" cellPadding="2" cellSpacing="0" width="100%" bgcolor="#CCFFFF" style="border-collapse: collapse">
          <tr>
            <th align="center" rowspan="2" colspan="1" bgcolor="#808080">Name</th>
            <th align="center" rowspan="1" colspan="4" bgcolor="#808080">Products</th>
            <!--<th align="center" rowspan="2" colspan="1">Avg. Activity Time</th>
            <th align="center" rowspan="2" colspan="1">Avg. Working Time</th>-->
            <th align="center" rowspan="2" colspan="1" bgcolor="#808080">Avg. Behaviour Time</th>
            <th align="center" rowspan="1" colspan="{$StatetimesCount}" bgcolor="#808080">State Times</th>
            <th align="center" rowspan="2" colspan="1" bgcolor="#808080">Utilization (%)</th>
          </tr>
          <tr>
            <th align = "center" bgcolor="#808080">Input</th>
            <th align = "center" bgcolor="#808080">Produced</th>
            <th align = "center" bgcolor="#808080">Consumed</th>
            <th align = "center" bgcolor="#808080">Output</th>
            <xsl:apply-templates select="StateTimes/*"/>
          </tr>
          <tr>
            <td align="center">
              <xsl:value-of select="@Name"/>
            </td>
            <td align="center">
              <xsl:value-of select="ProductStatistics/AllProducts/TotalIn"/>
            </td>
            <td align="center">
              <xsl:value-of select="ProductStatistics/AllProducts/NumProduced"/>
            </td>
            <td align="center">
              <xsl:value-of select="ProductStatistics/AllProducts/NumConsumed"/>
            </td>
            <td align="center">
              <xsl:value-of select="ProductStatistics/AllProducts/TotalOut"/>
            </td>
            <!--<td align="center">
              <xsl:call-template name="get_process_time"/>
            </td>
            <td align="center">
              <xsl:call-template name="get_cycle_time"/>
            </td>-->
            <td align="center">
              <xsl:value-of select="format-number(Processes/Process[1]/ProcessTime/Average, '0.000')"/>
            </td>
            <xsl:for-each select="StateTimes/*">
              <td align="center">
                <xsl:value-of select="format-number( text(), '###.###')"/>
              </td>
            </xsl:for-each>
            <td align="center">
              <xsl:value-of select="format-number(AvgUtilization*100,'###.##')"/>
            </td>
          </tr>
        </table>
        <hr size="2" color="black"></hr>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="conveyor_template">
    <xsl:for-each select="*">
      <xsl:if test="@Name = $ObjectName">
        <h2 align="center">
          <font face="Courier New">
            Statistics of Conveyor (Resource) - <xsl:value-of select="@Name"/>
          </font>
        </h2>
        <table border="1" bordercolor="#C0C0C0" cellPadding="2" cellSpacing="0" width="100%" bgcolor="#CCFFFF" style="border-collapse: collapse">
          <tr>
            <th align="center" rowspan="1" colspan="1" bgcolor="#808080">Name</th>
            <th align="center" rowspan="1" colspan="1" bgcolor="#808080">Products Entered</th>
            <th align="center" rowspan="1" colspan="1" bgcolor="#808080">Avg. Load</th>
            <th align="center" rowspan="1" colspan="1" bgcolor="#808080">Transportation Rate</th>
            <th align="center" rowspan="1" colspan="1" bgcolor="#808080">Avg. Residence Time</th>
            <th align="center" rowspan="1" colspan="1" bgcolor="#808080">Utilization (%)</th>
          </tr>
          <tr>
            <td align="center">
              <xsl:value-of select="@Name"/>
            </td>
            <td align="center">
              <xsl:value-of select="PartsEntered"/>
            </td>
            <td align="center">
              <xsl:value-of select="format-number(Load/Average,'0.000')"/>
            </td>
            <td align="center">
              <xsl:value-of select="format-number(TransportationRate,'0.000')"/>
            </td>
            <td align="center">
              <xsl:value-of select="format-number(PartResidenceTime/Average,'0.000')"/>
            </td>
            <td align="center">
              <xsl:value-of select="format-number(AvgUtilization*100,'###.##')"/>
            </td>
          </tr>
        </table>
        <hr size="2" color="black"></hr>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="agv_template">
    <xsl:for-each select="*">
      <xsl:if test="@Name = $ObjectName">

        <h2 align="center">
          <font face="Courier New">
            Statistics of Worker/AGV (Resource) - <xsl:value-of select="@Name"/>
          </font>
        </h2>

        <xsl:variable name="StatetimesCount" select="count(StateTimes/*)"/>

        <table border="1" bordercolor="#C0C0C0" cellPadding="2" cellSpacing="0" width="100%" bgcolor="#CCFFFF" style="border-collapse: collapse">
          <tr>
            <th align="center" rowspan="2" colspan="1" bgcolor="#808080">Name</th>
            <th align="center" rowspan="2" colspan="1" bgcolor="#808080">Distance Travelled</th>
            <th align="center" rowspan="1" colspan="{$StatetimesCount}" bgcolor="#808080">State Times</th>
            <th align="center" rowspan="2" colspan="1" bgcolor="#808080">Utilization (%)</th>
          </tr>
          <tr>
            <xsl:apply-templates select="StateTimes/*"/>
          </tr>
          <tr>
            <td align="center">
              <xsl:value-of select="@Name"/>
            </td>
            <td align="center">
              <xsl:value-of select="format-number(DistanceTravelled,'0.000')"/>
            </td>
            <xsl:for-each select="StateTimes/*">
              <td align="center">
                <xsl:value-of select="format-number( text(), '###.###')"/>
              </td>
            </xsl:for-each>
            <td align="center">
              <xsl:value-of select="format-number(AvgUtilization*100,'###.##')"/>
            </td>
          </tr>
        </table>
        <hr size="2" color="black"></hr>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="carrier_template">
    <xsl:for-each select="*">
      <xsl:if test="@Name = $ObjectName">
        <table border="1" bordercolor="#C0C0C0" cellPadding="2" cellSpacing="0" width="100%" bgcolor="#CCFFFF" style="border-collapse: collapse">
          <tr>
            <th align="center" bgcolor="#808080">Name</th>
            <th align="center" bgcolor="#808080">Number of Trips</th>
            <th align="center" bgcolor="#808080">Products Entered</th>
            <th align="center" bgcolor="#808080">Loaded Travel Time</th>
            <th align="center" bgcolor="#808080">Empty Travel Time</th>
            <th align="center" bgcolor="#808080">Stop Time</th>
            <th align="center" bgcolor="#808080">Dog Time</th>
            <th align="center" bgcolor="#808080">Avg. Product Residence Time</th>
            <th align="center" bgcolor="#808080">Avg. Contents</th>
          </tr>
          <tr>
            <td align="center">
              <xsl:value-of select="@Name"/>
            </td>
            <td align="center">
              <xsl:value-of select="NumTrips"/>
            </td>
            <td align="center">
              <xsl:value-of select="PartsEntered"/>
            </td>
            <td align="center">
              <xsl:value-of select="format-number(LoadedTravelTime,'0.000')"/>
            </td>
            <td align="center">
              <xsl:value-of select="format-number(EmptyTravelTime,'0.000')"/>
            </td>
            <td align="center">
              <xsl:value-of select="format-number(TravelBlockTime,'0.000')"/>
            </td>
            <td align="center">
              <xsl:value-of select="format-number(DogTime,'0.000')"/>
            </td>
            <td align="center">
              <xsl:value-of select="format-number(PartResidenceTime/Average,'0.000')"/>
            </td>
            <td align="center">
              <xsl:value-of select="format-number(Content/Average,'0.000')"/>
            </td>
          </tr>
        </table>
        <hr size="2" color="black"></hr>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="dec_template">
    <xsl:for-each select="*">
      <xsl:if test="@Name = $ObjectName">
        <table border="1" bordercolor="#C0C0C0" cellPadding="2" cellSpacing="0" width="100%" bgcolor="#CCFFFF" style="border-collapse: collapse">
          <tr>
            <th align="center" rowspan="1" colspan="1" bgcolor="#808080">Name</th>
            <th align="center" rowspan="1" colspan="1" bgcolor="#808080">Utilization</th>

            <xsl:if test="name(.)!='Cnv_Dec_Pt'">
              <th align="center" rowspan="1" colspan="1" bgcolor="#808080">No. of Vehicles Crossed</th>
              <th align="center" rowspan="1" colspan="1" bgcolor="#808080">Avg. Vehicle Time</th>
            </xsl:if>

            <xsl:if test="name(.)='Cnv_Dec_Pt'">
              <!-- 
					All Cnv Dec Process stats here
				-->
              <th align="center" rowspan="1" colspan="1" bgcolor="#808080">No. of Products Crossed</th>
              <th align="center" rowspan="1" colspan="1" bgcolor="#808080">Avg. Product Time</th>
              <th align="center" rowspan="1" colspan="1" bgcolor="#808080">Avg. Activity Time</th>
              <th align="center" rowspan="1" colspan="1" bgcolor="#808080">Avg. Working Time</th>
              <th align="center" rowspan="1" colspan="1" bgcolor="#808080">No. of Products</th>
              <th align="center" rowspan="1" colspan="1" bgcolor="#808080">Production Rate</th>
              <th align="center" rowspan="1" colspan="1" bgcolor="#808080">Final Content</th>
            </xsl:if>

            <xsl:if test="name(.)='Agv_Dec_Pt'">
              <!--
					All AGV Dec Stats here
				-->
              <th align="center" rowspan="1" colspan="1" bgcolor="#808080">Claim Busy Time</th>
              <th align="center" rowspan="1" colspan="1" bgcolor="#808080">Claim Utilization</th>
              <th align="center" rowspan="1" colspan="1" bgcolor="#808080">Total AGVs Claimed</th>
              <th align="center" rowspan="1" colspan="1" bgcolor="#808080">Avg. Claim Wait Time</th>
              <th align="center" rowspan="1" colspan="1" bgcolor="#808080">AGV Claim Wait Content</th>
              <th align="center" rowspan="1" colspan="1" bgcolor="#808080">Num AGVs Waited to Claim</th>
              <th align="center" rowspan="1" colspan="1" bgcolor="#808080">Num AGVs Claimed with No Wait</th>
            </xsl:if>
          </tr>
          <tr>
            <td align="center">
              <xsl:value-of select="@Name"/>
            </td>
            <td align="center">
              <xsl:value-of select="format-number(AvgUtilization,'0.000')"/>
            </td>
            <xsl:if test="name(.)='Cnv_Dec_PtElement'">
              <td align="center">
                <xsl:value-of select="PartsCrossed"/>
              </td>
            </xsl:if>
            <xsl:if test="name(.)!='Cnv_Dec_PtElement'">
              <td align="center" rowspan="1" colspan="1">
                <xsl:value-of select="VehiclesVisited"/>
              </td>
            </xsl:if>
            <xsl:if test="name(.)='Agv_Dec_PtElement'">
              <td align="center">
                <xsl:value-of select="format-number(VehicleTime/Average,'0.000')"/>
              </td>
            </xsl:if>
            <xsl:if test="name(.)!='Agv_Dec_PtElement'">
              <td align="center">
                <xsl:value-of select="format-number(PartResidenceTime/Average,'0.000')"/>
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
                <xsl:value-of select="PartsProduced"/>
              </td>
              <td align="center">
                <xsl:value-of select="format-number(ProductionRate,'0.000')"/>
              </td>
              <td align="center">
                <xsl:value-of select="FinalContent"/>
              </td>
            </xsl:if>

            <xsl:if test="name(.)='Agv_Dec_PtElement'">
              <td align="center">
                <xsl:value-of select="format-number(ClaimBusyTime,'0.000')"/>
              </td>
              <td align="center">
                <xsl:value-of select="format-number(ClaimBusyTime div //QuestStatistics/Run[@RunNumber=$run_no]/RunParameters/StatsCollectionTime, '0.000')"/>
              </td>
              <td align="center">
                <xsl:value-of select="TotalAGVsClaimed"/>
              </td>
              <td align="center">
                <xsl:value-of select="format-number(AvgClaimWaitTime,'0.000')"/>
              </td>
              <td align="center">
                <xsl:value-of select="format-number(ClaimContent/Average,'0.000')"/>
              </td>
              <td align="center">
                <xsl:value-of select="AGVsWaitedToClaim"/>
              </td>
              <td align="center">
                <xsl:value-of select="TotalAGVsClaimed - AGVsWaitedToClaim"/>
              </td>
            </xsl:if>
          </tr>
        </table>
        <hr size="2" color="black"></hr>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="sr_template">
    <xsl:for-each select="*">
      <xsl:if test="@Name = $ObjectName">

        <xsl:variable name="StatetimesCount" select="count(StateTimes/*)"/>

        <table border="1" bordercolor="#C0C0C0" cellPadding="2" cellSpacing="0" width="100%" bgcolor="#CCFFFF" style="border-collapse: collapse">
          <tr>
            <th align="center" rowspan="2" colspan="1" bgcolor="#808080">Name</th>
            <th align="center" rowspan="1" colspan="{$StatetimesCount}" bgcolor="#808080">State Times</th>
          </tr>
          <tr>
            <xsl:apply-templates select="StateTimes/*"/>
          </tr>
          <tr>
            <td align="center">
              <xsl:value-of select="@Name"/>
            </td>
            <xsl:for-each select="StateTimes/*">
				<td align="center">
					<xsl:value-of select="format-number( text(), '###.###')"/>
				</td>
            </xsl:for-each>
          </tr>
        </table>
        <hr size="2" color="black"></hr>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template match="IDLE">
	<th align = "center" bgcolor="#808080">Idle</th>
</xsl:template>

<xsl:template match="IDLE_PARKED">
  <th align = "center" bgcolor="#808080">Idle Parked</th>
  </xsl:template>
  
  <xsl:template match="BUSY_PROCESSING">
	<th align = "center" bgcolor="#808080">Busy Processing</th>
</xsl:template>

<xsl:template match="BUSY_LOADING">
  <th align = "center" bgcolor="#808080">Busy Loading</th>
  </xsl:template>
  
  <xsl:template match="BUSY_UNLOADING">
	  <th align = "center" bgcolor="#808080">Busy Loading</th>
  </xsl:template>

  <xsl:template match="BUSY_SETUP">
    <th align = "center" bgcolor="#808080">Busy Setup</th>
  </xsl:template>

  <xsl:template match="BUSY_REPAIR">
    <th align = "center" bgcolor="#808080">Busy Repair</th>
  </xsl:template>
  
  <xsl:template match="LOADED_TRAVEL">
	  <th align = "center" bgcolor="#808080">Loaded Travel</th>
  </xsl:template>
  
  <xsl:template match="EMPTY_TRAVEL">
	  <th align = "center" bgcolor="#808080">Empty Travel</th>
  </xsl:template>

  <xsl:template match="TRAVEL_BLOCK">
    <th align = "center" bgcolor="#808080">Travel Block</th>
  </xsl:template>
  
  <xsl:template match="UNLOAD_BLOCK">
	  <th align = "center" bgcolor="#808080">Unload Block</th>
  </xsl:template>

  <xsl:template match="REQMT_BLOCK">
    <th align = "center" bgcolor="#808080">Requirement Block</th>
  </xsl:template>
  
  <xsl:template match="DEPART_REQMT_BLOCK">
	  <th align = "center" bgcolor="#808080">Depart Reqmt. Block</th>
  </xsl:template>

  <xsl:template match="CLAIM_BLOCK">
    <th align = "center" bgcolor="#808080">Claim Block</th>
  </xsl:template>
  
  <xsl:template match="REQMT_PREEMPTED">
	  <th align = "center" bgcolor="#808080">Reqmt. Preempted</th>
  </xsl:template>
  
  <xsl:template match="WAIT_BLOCK">
	  <th align = "center" bgcolor="#808080">Wait Block</th>
  </xsl:template>

  <xsl:template match="SHIFT_OUT">
    <th align = "center" bgcolor="#808080">Shift Out</th>
  </xsl:template>
  
  <xsl:template match="SHIFT_BRK">
	  <th align = "center" bgcolor="#808080">Shift Break</th>
  </xsl:template>

  <xsl:template match="FAILED">
    <th align = "center" bgcolor="#808080">Failed</th>
  </xsl:template>
  
  <xsl:template match="BUSY_XFERING">
	  <th align = "center" bgcolor="#808080">Busy Transfering</th>
  </xsl:template>

  <xsl:template match="NOT_CONSIDERED">
    <th align = "center" bgcolor="#808080">Not Considered</th>
  </xsl:template>
  
</xsl:stylesheet>
