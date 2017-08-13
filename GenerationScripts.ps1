<#Param(					 
		[Parameter(Mandatory=$true, Position=1)] [String] $PackageRoot
	 )#>

$PackageRoot=$PSScriptRoot

$ConfigPath="$PackageRoot\Configfiles\SQLDATAConfig.xml"

$localizationResult  = & "$PackageRoot\Configfiles\TxtPreProcess.exe" /i "$PackageRoot\Invoke_SqlData.ps1" /x "$ConfigPath" /e "SQLDATA" /o "$PackageRoot\Invoke_SqlData.ref.ps1"

& "$PackageRoot\Invoke_SqlData.ref.ps1" -PackageRoot $PackageRoot