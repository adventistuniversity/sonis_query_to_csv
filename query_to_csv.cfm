<cfquery name="csvquery" datasource="#sonis.ds#">

  <!--- Example query --->
  SELECT TOP 10 first_name, last_name, camp_cod FROM name

</cfquery>

<cfinvoke component="CFC.query_to_csv" method="query_to_csv">
  <!--- name of the query above --->
  <cfinvokeargument name = "Query" value = #csvquery#>

  <!--- The columns being selected; format: "column1, column2, column3, columnX, columnY, columnZ" --->
  <cfinvokeargument name = "Fields" value = "first_name, last_name, camp_cod">

  <!--- This value becomes part of the report name to the file that is streamed to browser --->
  <cfinvokeargument name = "report_name" value = 'AHU_Example_Query'>


  <!--- OPTIONAL: You can specify a delimiter, if you do not, the default is a comma --->
  <!--- This example is a tab --->
  <cfinvokeargument name = "Delimiter" value = "#chr(9)#">

  <!--- OPTIONAL: You can choose to add a header row or not. The default is to include the header. --->
  <cfinvokeargument name = "CreateHeaderRow" value = "false">

  <!--- OPTIONAL: Choose if fields are surrounded by quotes or not. The default is to include quotes. --->
  <cfinvokeargument name = "QuoteFields" value = "false">

  <!--- OPTIONAL: Specify the file extension. The default is csv. --->
  <cfinvokeargument name = "Extension" value = "tab">
</cfinvoke>
