<cfquery name="csvquery" datasource="soniswebp">

  <!--- Example query --->
  SELECT top 1 1 from name

</cfquery>

<cfinvoke component="CFC.query_to_csv" method="query_to_csv">
  <!--- name of the query above --->
  <cfinvokeargument name = "Query" value = #csvquery#>

  <!--- The columns being selected; format: "column1, column2, column3, columnX, columnY, columnZ"
  <cfinvokeargument name = "Fields" value = "column1, column2, column3, columnX, columnY, columnZ">

  <!--- This value helps to write the report name to the file that is streamed to browser --->
  <cfinvokeargument name = "report_name" value = 'FHC_Example_Query'>
</cfinvoke>
