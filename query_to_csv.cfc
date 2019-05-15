<cfcomponent>
  <!--- Credits to Ben Nadel: http://www.bennadel.com/blog/1231-converting-a-coldfusion-query-to-csv-using-querytocsv.htm --->
  <cffunction name="query_to_csv" output="yes" returntype="Any">
    <!---Function Arguments--->
    <cfargument name="Query" required="yes" type="query" default="" hint="The query you want output as a spreadsheet"/>
    <cfargument name="Fields" type="string" required="true" hint="The list of query fields to be used when creating the CSV"/>
    <cfargument name="CreateHeaderRow" type="boolean" required="false" default="true" hint="I flag whether or not to create a row of header values."/>
    <cfargument name="Delimiter" type="string" required="false" default="," hint="I am the field delimiter in the CSV value."/>
    <cfargument name="report_name" required="yes" type="string" default="" hint="The name of this report">
    <cfset variables.report_name = arguments.report_name>

    <cfset var LOCAL = {} />
    <cfset LOCAL.ColumnNames = {} />
    <cfloop
      index="LOCAL.ColumnName"
      list="#ARGUMENTS.Fields#"
      delimiters=",">

      <!--- Store the current column name. --->
      <cfset LOCAL.ColumnNames[ StructCount( LOCAL.ColumnNames ) + 1 ] = Trim( LOCAL.ColumnName ) />
    </cfloop>

     <cfset LOCAL.ColumnCount = StructCount( LOCAL.ColumnNames ) />

    <cfquery name="batch_dir_query" datasource="soniswebp" maxrows="1">
      select batch_dir from webopts
    </cfquery>
    <CFIF right(trim(batch_dir_query.batch_dir),1) EQ '/' OR  right(trim(batch_dir_query.batch_dir),1) EQ '\'>
        <CFSET batch_dir = '#trim(batch_dir_query.batch_dir)#'>
    <CFELSE>
        <CFSET batch_dir = '#trim(batch_dir_query.batch_dir)#\'>
    </CFIF>
    <cfset login_id = trim(#session.login_id#)>
    <cfset LOCAL.Buffer = CreateObject( "java", "java.lang.StringBuffer" ).Init() />
    <cfset LOCAL.NewLine = (Chr( 13 ) & Chr( 10 )) />
    <cfif ARGUMENTS.CreateHeaderRow>

        <!--- Loop over the column names. --->
        <cfloop
            index="LOCAL.ColumnIndex"
            from="1"
            to="#LOCAL.ColumnCount#"
            step="1">
            <!--- Append the field name. --->
            <cfset LOCAL.Buffer.Append(
                JavaCast(
                    "string",
                    """#LOCAL.ColumnNames[ LOCAL.ColumnIndex ]#"""
                    )
                ) />
            <cfif (LOCAL.ColumnIndex LT LOCAL.ColumnCount)>
                <!--- Field delimiter. --->
                <cfset LOCAL.Buffer.Append(
                    JavaCast( "string", ARGUMENTS.Delimiter )
                    ) />
            <cfelse>
                <cfset LOCAL.Buffer.Append(
                    JavaCast( "string", LOCAL.NewLine )
                    ) />
            </cfif>
        </cfloop>
    </cfif>
        <!--- Loop over the query. --->
    <cfloop query="ARGUMENTS.Query">

        <!--- Loop over the columns. --->
        <cfloop
            index="LOCAL.ColumnIndex"
            from="1"
            to="#LOCAL.ColumnCount#"
            step="1">

            <!--- Append the field value. --->
            <cfset LOCAL.Buffer.Append(
                JavaCast(
                    "string",
                    """#ARGUMENTS.Query[ LOCAL.ColumnNames[ LOCAL.ColumnIndex ] ][ ARGUMENTS.Query.CurrentRow ]#"""
                    )
                ) />

            <!---
                Check to see which delimiter we need to add:
                field or line.
            --->
            <cfif (LOCAL.ColumnIndex LT LOCAL.ColumnCount)>

                <!--- Field delimiter. --->
                <cfset LOCAL.Buffer.Append(
                    JavaCast( "string", ARGUMENTS.Delimiter )
                    ) />

            <cfelse>
                <!--- Line delimiter. --->
                <cfset LOCAL.Buffer.Append(
                    JavaCast( "string", LOCAL.NewLine )
                    ) />
            </cfif>
        </cfloop>
    </cfloop>

    <!--- Write the CSV value to a file and prevent race conditions. --->
    <cfquery name="batch_dir_query" datasource="soniswebp" maxrows="1">
      select batch_dir from webopts
    </cfquery>

    <cfset batch_dir = trim(#batch_dir_query.batch_dir#) & "\">
    <cfset login_id = trim(#session.login_id#)>
    <cfset file_name = #login_id# & "_" & #ReReplace(report_name, "[[:space:]]","","ALL")# & ".csv">
    <cfset save_path = #batch_dir# & #login_id# & "_" & #ReReplace(report_name, "[[:space:]]","","ALL")# & ".csv">
    <cffile action = "write" file = #save_path# output = #LOCAL.Buffer.ToString()#>
    <!--- Stream the file to browser/delete it                                                        --->
        <cfheader name="Content-Disposition" value="attachment;filename=#file_name#">
        <cfcontent type="application/octet-stream" file="#save_path#" deletefile="Yes">

  </cffunction>
</cfcomponent>
