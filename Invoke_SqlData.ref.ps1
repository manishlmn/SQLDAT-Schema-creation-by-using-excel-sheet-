
Param(					 
		[Parameter(Mandatory=$true, Position=1)] [String] $PackageRoot
	 )

Begin
{
    #File paths
    $ConfigPath="$PackageRoot\Configfiles\SQLDATAConfig.xml"
    $OutputFilePath="$PackageRoot\SourceQueries\Ref_Scripts"
    $logFilePath = "$PackageRoot\EventLogs"

}
Process
{ 
  try
  {  

    
      $serverName="HD02ASMSQLDB\INSTANCE_4"
      $dbName="AfmsDWH"

        $TableScripts="YES"
        $ForeignKeyScripts="YES"
        $PrimaryKeyScripts="YES"
        $DefaultsConstraintsScripts="YES"

        $SelectedDBs="AdventureWorksDW2012"
        $SelectedSchemas="dbo"


      Get-ChildItem -Path "$PackageRoot\OutSqlScripts" -Recurse | Remove-Item -Force -Recurse 

       Get-ChildItem -Path "$PackageRoot\ConfigFiles\TempFiles" -Include *.txt* -File -Recurse | foreach { $_.Delete()}

       Get-ChildItem -Path "$logFilePath" -Include *.* -File -Recurse | foreach { $_.Delete()}



      $inputFiles=   Get-ChildItem -path "$PackageRoot\SourceQueries\MainScripts"  
      foreach($inputFile in $inputFiles){

             $InputFilePath=$inputFile.FullName
             $fileName=$inputFile.BaseName
       
              $localizationResult = & "$PackageRoot\ConfigFiles\TxtPreProcess.exe" /i "$InputFilePath" /x "$ConfigPath" /e "SQLDATA" /o "$OutputFilePath\$fileName.ref.sql"
                write-host  " ref file generated for $fileName "

           }

        $ExcelImportFile= "$OutputFilePath\ExcelImport.ref.sql"

        $Create_Function_FilePath= "$OutputFilePath\Create_fn_FunctionSplit.ref.sql"

         $NoOfTotalDBS_EachRun = "$OutputFilePath\NoOfTotalDBS_EachRun.ref.sql"

         

        Write-host  "--------------------------------------------------------------------------"
        Write-Output "--------------------------------------------------------------------------" >> "$logFilePath\Export.log"
        
        write-host  " Excel Imports STARTS HERE." 
        write-output  " Excel Imports STARTS HERE." >> "$logFilePath\Export.log" 
        
        write-host   "--------------------------------------------------------------------------" 
        write-output   "--------------------------------------------------------------------------" >> "$logFilePath\Export.log"

            Invoke-sqlcmd -ServerInstance $serverName -Database $dbName -InputFile $ExcelImportFile |Out-File "$logFilePath\Export.log"

            Invoke-sqlcmd -ServerInstance $serverName -Database $dbName -InputFile $Create_Function_FilePath |Out-File "$logFilePath\Export.log"




         $DBslist= $SelectedDBs -split ','

       foreach ($DB in $DBslist)
         {

              $inputRefFiles=   Get-ChildItem -path "$OutputFilePath"  | Where-Object {$_.Name -match ".ref"}
          
          foreach($inputRefFile in $inputRefFiles){

               $inputRefFilePath=$inputRefFile.FullName
           
           
              $inputRefFileName=$inputRefFile.BaseName

              (gc "$inputRefFilePath" ) -replace "$SelectedDBs","$DB" | out-file "$OutputFilePath\Temp\$inputRefFileName.sql"
               write-host  " ref $inputRefFileName content has modified with this DB name  $DB "

            }




            $RecordsCount=(Invoke-sqlcmd -ServerInstance $serverName -Database $dbName -InputFile "$OutputFilePath\Temp\ValidationQuery.ref.sql")

            write-output  $RecordsCount >> "$logFilePath\Export.log"

            if($RecordsCount.Count -eq $null -or $RecordsCount.Count -eq "0" )
            {

             Get-ChildItem -Path "$PackageRoot\ConfigFiles\TempFiles" -Include *.txt* -File -Recurse | foreach { $_.Delete()}

                 write-host   "----------------Validation passed--------------------------"
                 write-output   "----------------Validation passed--------------------------" >> "$logFilePath\Export.log" 

                 IF ($DefaultsConstraintsScripts -eq "YES")
                 {
                    Invoke-sqlcmd -ServerInstance $serverName -Database $dbName -InputFile "$OutputFilePath\Temp\DFQuery.ref.sql"|out-file "$PackageRoot\ConfigFiles\TempFiles\Constraints.txt" -width 8192
                    (get-content "$PackageRoot\ConfigFiles\TempFiles\Constraints.txt")  -notmatch "Column1" -notmatch "-------" |out-file "$PackageRoot\ConfigFiles\TempFiles\Constraints.txt"
                 }
                  IF ($ForeignKeyScripts -eq "YES")
                 {
                    Invoke-sqlcmd -ServerInstance $serverName -Database $dbName -InputFile "$OutputFilePath\Temp\ForeignKeyQuery.ref.sql"|out-file "$PackageRoot\ConfigFiles\TempFiles\ForeignKeyScripts.txt"  -width 8192
                    (get-content "$PackageRoot\ConfigFiles\TempFiles\ForeignKeyScripts.txt")  -notmatch "Column1" -notmatch "-------" |out-file "$PackageRoot\ConfigFiles\TempFiles\ForeignKeyScripts.txt"
                 }

                 IF ($PrimaryKeyScripts -eq "YES")
                 {
                    Invoke-sqlcmd -ServerInstance $serverName -Database $dbName -InputFile "$OutputFilePath\Temp\PrimaryKeyQuery.ref.sql"|out-file "$PackageRoot\ConfigFiles\TempFiles\PrimaryKeyScripts.txt"  -width 8192
                    (get-content "$PackageRoot\ConfigFiles\TempFiles\PrimaryKeyScripts.txt")  -notmatch "Column1" -notmatch "-------" |out-file "$PackageRoot\ConfigFiles\TempFiles\PrimaryKeyScripts.txt"
                 }

                 IF ($TableScripts -eq "YES")
                 {
                    Invoke-sqlcmd -ServerInstance $serverName -Database $dbName -InputFile "$OutputFilePath\Temp\NewTableQuery.ref.sql"|out-file "$PackageRoot\ConfigFiles\TempFiles\Tables.txt"  -width 8192
                    (get-content "$PackageRoot\ConfigFiles\TempFiles\Tables.txt")  -notmatch "Column1" -notmatch "-------" |out-file "$PackageRoot\ConfigFiles\TempFiles\Tables.txt"
                 }


            }

              else
              {
                $DeleteExcelImportFile= "$OutputFilePath\DeleteExcelImport.ref.sql"
     
               Invoke-sqlcmd -ServerInstance $serverName -Database $dbName -InputFile $DeleteExcelImportFile 


                 write-host  "----------------------------Validation failed---------------------------------" 
                 write-output  "----------------------------Validation failed---------------------------------"  >> "$logFilePath\Error.log"
                    
                 Write-host "Validation failed.  For additional information refer to logs at - `"...\logfile\Export.log " 
                 Write-output "Validation failed.  For additional information refer to logs at - `"...\logfile\Export.log "  >> "$logFilePath\Error.log" 
                  write-output  $RecordsCount >> "$logFilePath\Error.log"

                Exit 1
              }


  $files= gci "$PackageRoot\ConfigFiles\TempFiles"


      foreach($file in $files){

             $inputfile=$file.FullName
             (gc $inputfile) | ? {$_.trim() -ne "" } | set-content $inputfile

             $dirName=$file.BaseName

              $NONEmptyLinesFile = Get-ChildItem -Path "$inputFile"

                (gc $NONEmptyLinesFile) | Foreach {$_.TrimEnd()} | where {$_ -ne ""} | Set-Content $NONEmptyLinesFile


              
                 if(!(test-path "$PackageRoot\OutSqlScripts\$DB\$dirName"))
                 {
                  
                      if ("$dirName" -eq "ForeignKeyScripts" -or "$dirName" -eq "PrimaryKeyScripts"   )
                      {
                         if(!(test-path "$PackageRoot\OutSqlScripts\$DB\key"))
                         {
                           New-Item -Path "$PackageRoot\OutSqlScripts\$DB\Key" -ItemType directory
                         }

                       }
                      Else
                      {
                       New-Item -Path "$PackageRoot\OutSqlScripts\$DB\$dirName" -ItemType directory
                       }
                 }
            $sourceFileNames = get-content $inputFile 
    
            foreach($sourceName in $sourceFileNames)
            {
              $fileName,$content = $sourceName -split ":::"

              write-host   "$fileName Object Scripts  Created...." 
              write-output   "$fileName Object Scripts  Created...." >> "$logFilePath\DBObjects.log" 
             


             

               if ("$dirName" -eq "ForeignKeyScripts" -or "$dirName" -eq "PrimaryKeyScripts"   )
                {
                         
                    New-Item -Path "$PackageRoot\OutSqlScripts\$DB\Key\$fileName.sql" -type file -Value $content  
                }
                Else
                {
                New-Item -path "$PackageRoot\OutSqlScripts\$DB\$dirName\$fileName.sql" -type file -Value $content


                    if ("$dirName" -eq "Tables") 
                    {
                       (gc "$PackageRoot\OutSqlScripts\$DB\$dirName\$fileName.sql" ) -replace "NULL,","NULL,`n" | out-file "$PackageRoot\OutSqlScripts\$DB\$dirName\$fileName.sql"

                    }

                }
      
            }

     }

     }
      Get-Process | Out-File  "$logFilePath\DBObjects_ProcessOutput.log"

      #$DeleteExcelImportFile= "$OutputFilePath\DeleteExcelImport.ref.sql"
     
    # Invoke-sqlcmd -ServerInstance $serverName -Database $dbName -InputFile $DeleteExcelImportFile 
      #Deleting Excel and function which has created for this tool to run successfully.
     
  }
  catch {
        #system exception error message

         write-host  "Exception Occurred in the main Invoke_SqlData.ps1 entry script file." 
          Write-Output  "Exception Occurred in the main Invoke_SqlData.ps1 entry script file."  >>"$logFilePath\Error.log" 


		 write-error  $_.Exception.Message  
         Write-Output  $_.Exception.Message  >> "$logFilePath\DBObjects.log" 

  }

   
}

  

