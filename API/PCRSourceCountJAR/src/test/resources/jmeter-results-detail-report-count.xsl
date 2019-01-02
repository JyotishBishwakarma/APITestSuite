<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0">

	<!-- Licensed to the Apache Software Foundation (ASF) under one or more 
		contributor license agreements. See the NOTICE file distributed with this 
		work for additional information regarding copyright ownership. The ASF licenses 
		this file to You under the Apache License, Version 2.0 (the "License"); you 
		may not use this file except in compliance with the License. You may obtain 
		a copy of the License at http://www.apache.org/licenses/LICENSE-2.0 Unless 
		required by applicable law or agreed to in writing, software distributed 
		under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES 
		OR CONDITIONS OF ANY KIND, either express or implied. See the License for 
		the specific language governing permissions and limitations under the License. -->

	<!-- Stylesheet for processing 2.1 output format test result files To uses 
		this directly in a browser, add the following to the JTL file as line 2: 
		<?xml-stylesheet type="text/xsl" href="../extras/jmeter-results-detail-report_21.xsl"?> 
		and you can then view the JTL in a browser -->

	<xsl:output method="html" indent="yes" encoding="UTF-8"
		doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN" />

	<!-- Defined parameters (overrideable) -->
	<!--<xsl:param name="showData" select="'n'" /> -->
	<xsl:param name="titleReport" select="'PCR Test Results'" />
	<xsl:param name="dateReport" select="'date not defined'" />
	<xsl:param name="Nil" select="'Null'" />

	<xsl:template match="testResults">
		<html>
			<head>
				<title>
					<xsl:value-of select="$titleReport" />
				</title>
				<style type="text/css">
					body {
					font:normal 68% verdana,arial,helvetica;
					color:#000000;
					}
					table tr td, table tr th {
					font-size: 68%;
					}
					table.details tr th{
					color: #ffffff;
					font-weight: bold;
					text-align:center;
					background:#2674a6;
					white-space: nowrap;
					}
					table.details tr td{
					background:#eeeee0;
					white-space: nowrap;
					}
					h1 {
					margin: 0px 0px 5px; font: 165% verdana,arial,helvetica
					}
					h2 {
					margin-top: 1em; margin-bottom: 0.5em; font: bold 125%
					verdana,arial,helvetica
					}
					h3 {
					margin-bottom: 0.5em; font: bold 115% verdana,arial,helvetica
					}
					.Failure {
					font-weight:bold; color:red;
					}
					
					


					img
					{
					border-width: 0px;
					}

					.expand_link
					{
					position=absolute;
					right: 0px;
					width: 27px;
					top: 1px;
					height: 27px;
					}

					.page_details
					{
					display: none;
					}

					.page_details_expanded
					{
					display: block;
					display/* hide this definition from IE5/6 */: table-row;
					}
					
					


				</style>
				<script language="JavaScript"><![CDATA[
                           function expand(details_id)
			   {
			      
			      document.getElementById(details_id).className = "page_details_expanded";
			   }
			   
			   function collapse(details_id)
			   {
			      
			      document.getElementById(details_id).className = "page_details";
			   }
			   
			   function change(details_id)
			   {
			      if(document.getElementById(details_id+"_image").src.match("expand"))
			      {
			         document.getElementById(details_id+"_image").src = "collapse.png";
			         expand(details_id);
			      }
			      else
			      {
			         document.getElementById(details_id+"_image").src = "expand.png";
			         collapse(details_id);
			      } 
                           }
			]]></script>
			</head>
			<body>

				<xsl:call-template name="pageHeader" />

				<xsl:call-template name="summary" />
				<hr size="1" width="95%" align="center" />

				

				<xsl:call-template name="detail" />

			</body>
		</html>
	</xsl:template>

	<xsl:template name="pageHeader">
		<h1>
			<xsl:value-of select="$titleReport" />
		</h1>
		<table width="100%">
			<tr>
				<td align="left">
					Date report:
					<xsl:value-of select="$dateReport" />
				</td>
				<td align="right">
				<!-- 	Designed for use with
					<a href="http://jmeter.apache.org/">JMeter</a>
					and
					<a href="http://ant.apache.org">Ant</a>
					. -->
				</td>
			</tr>
		</table>
		<hr size="1" />
	</xsl:template>

	<xsl:template name="summary">
		<h2>Summary</h2>
		<table align="center" class="details" border="0" cellpadding="5"
			cellspacing="2" width="95%">
			<tr valign="top">
				<th># Samples</th>
				<th>Failures</th>
				<th>Success Rate</th>
				<th>Average Time</th>
				<th>Min Time</th>
				<th>Max Time</th>
			</tr>
			<tr valign="top">
				<xsl:variable name="allCount" select="count(/testResults/*)" />
				<xsl:variable name="allFailureCount"
					select="count(/testResults/*[attribute::s='false'])" />
				<xsl:variable name="allSuccessCount"
					select="count(/testResults/*[attribute::s='true'])" />
				<xsl:variable name="allSuccessPercent" select="$allSuccessCount div $allCount" />
				<xsl:variable name="allTotalTime" select="sum(/testResults/*/@t)" />
				<xsl:variable name="allAverageTime" select="$allTotalTime div $allCount" />
				<xsl:variable name="allMinTime">
					<xsl:call-template name="min">
						<xsl:with-param name="nodes" select="/testResults/*/@t" />
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="allMaxTime">
					<xsl:call-template name="max">
						<xsl:with-param name="nodes" select="/testResults/*/@t" />
					</xsl:call-template>
				</xsl:variable>
				<xsl:attribute name="class">
				<xsl:choose>
					<xsl:when test="$allFailureCount &gt; 0">Failure</xsl:when>
				</xsl:choose>
			</xsl:attribute>
				<td align="center">
					<xsl:value-of select="$allCount" />
				</td>
				<td align="center">
					<xsl:value-of select="$allFailureCount" />
				</td>
				<td align="center">
					<xsl:call-template name="display-percent">
						<xsl:with-param name="value" select="$allSuccessPercent" />
					</xsl:call-template>
				</td>
				<td align="center">
					<xsl:call-template name="display-time">
						<xsl:with-param name="value" select="$allAverageTime" />
					</xsl:call-template>
				</td>
				<td align="center">
					<xsl:call-template name="display-time">
						<xsl:with-param name="value" select="$allMinTime" />
					</xsl:call-template>
				</td>
				<td align="center">
					<xsl:call-template name="display-time">
						<xsl:with-param name="value" select="$allMaxTime" />
					</xsl:call-template>
				</td>
			</tr>
		</table>
	</xsl:template>



	<xsl:template name="detail">
		<xsl:variable name="allFailureCount"
			select="count(/testResults/*[attribute::s='false'])" />



		<!-- <xsl:if test="$allFailureCount > 0"> -->
		<h2>Response Detail</h2>

		<!--<xsl:for-each select="/testResults/*[not(@lb = preceding::*/@lb)]">

			<xsl:variable name="failureCount"
				select="count(../*[@lb = current()/@lb][attribute::s='false'])" />

			
			<h3>
				<xsl:value-of select="@lb" />
				<a>
					<xsl:attribute name="name"><xsl:value-of
						select="@lb" /></xsl:attribute>
				</a>
			</h3>-->

			<table align="center" class="details" border="0" cellpadding="5"
				cellspacing="2" width="100%" style="table-layout:fixed">
				<tr valign="top">
					<th>contentType</th>
					<th>Mongodb Count</th>
					<th>Solr-Parent Count</th>
					<th>API Count</th>
					<th>solrChild count</th>
					<th>Mongdb Appl Count</th>
					<!--<xsl:if test="$showData = 'y'">
						<th>Response Data</th>
					</xsl:if> -->
				</tr>
				
				




					<tr>
					<td> </td>
					<td></td>
					<td> </td>
					<td> </td>
					<td> </td>
					<td> </td>
					
					


						<!--<td
							style="white-space:pre-wrap;white-space:-moz-pre-wrap;white-space:-pre-wrap;white-space:-o-pre-wrap;word-wrap:break-word">
							<xsl:value-of select="java.net.URL" />
						</td>
						
						<td
							style="white-space:pre-wrap;white-space:-moz-pre-wrap;white-space:-pre-wrap;white-space:-o-pre-wrap;word-wrap:break-word">
							<xsl:value-of select="queryString" />
						</td>
						
						<td
							style="white-space:pre-wrap;white-space:-moz-pre-wrap;white-space:-pre-wrap;white-space:-o-pre-wrap;word-wrap:break-word">
							<xsl:value-of select="responseData" />
						</td>
						
 					<xsl:variable name="message">
						
						<xsl:for-each select="assertionResult">
							<xsl:choose>
								<xsl:when test="failure= 'true'">
									<xsl:value-of select="failureMessage" />
								</xsl:when>
								
								<xsl:when test="error= 'true'">
									<xsl:value-of select="failureMessage" />
								</xsl:when>

								<xsl:otherwise>
									<xsl:value-of select="''" />
								</xsl:otherwise>
							</xsl:choose>
							
						</xsl:for-each>
						
						</xsl:variable>
						<td
								style="white-space:pre-wrap;white-space:-moz-pre-wrap;white-space:-pre-wrap;white-space:-o-pre-wrap;word-wrap:break-word;font-weight:bold; color:red;font-size:100%">
								<xsl:value-of select="$message" />
							</td>
						 <xsl:for-each select="assertionResult"> <xsl:if test="failure= 
							'true'"> <td style="white-space:pre-wrap;white-space:-moz-pre-wrap;white-space:-pre-wrap;white-space:-o-pre-wrap;word-wrap:break-word"><xsl:value-of 
							select="$message" /></td>
					 </xsl:if> </xsl:for-each> 
						<xsl:if test="$showData = 'y'">
							<td
								style="white-space:pre-wrap;white-space:-moz-pre-wrap;white-space:-pre-wrap;white-space:-o-pre-wrap;word-wrap:break-word">
								<xsl:value-of select="./binary" />
								<xsl:value-of select="responseData" />
							</td>
						</xsl:if> -->
						
					</tr>
				

			</table>
			<!-- </xsl:if> -->

		<!--</xsl:for-each>-->
		<!-- </xsl:if> -->
	</xsl:template>

	<xsl:template name="min">
		<xsl:param name="nodes" select="/.." />
		<xsl:choose>
			<xsl:when test="not($nodes)">
				NaN
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="$nodes">
					<xsl:sort data-type="number" />
					<xsl:if test="position() = 1">
						<xsl:value-of select="number(.)" />
					</xsl:if>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="max">
		<xsl:param name="nodes" select="/.." />
		<xsl:choose>
			<xsl:when test="not($nodes)">
				NaN
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="$nodes">
					<xsl:sort data-type="number" order="descending" />
					<xsl:if test="position() = 1">
						<xsl:value-of select="number(.)" />
					</xsl:if>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="display-percent">
		<xsl:param name="value" />
		<xsl:value-of select="format-number($value,'0.00%')" />
	</xsl:template>

	<xsl:template name="display-time">
		<xsl:param name="value" />
		<xsl:value-of select="format-number($value,'0 ms')" />
	</xsl:template>

</xsl:stylesheet>
