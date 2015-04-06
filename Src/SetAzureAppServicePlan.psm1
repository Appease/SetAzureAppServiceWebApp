# halt immediately on any errors which occur in this module
$ErrorActionPreference = 'Stop'
Import-Module 'C:\Program Files (x86)\Microsoft SDKs\Azure\PowerShell\ResourceManager\AzureResourceManager' -Force -RequiredVersion '0.8.8'

function Invoke(

    [string]
    [ValidateNotNullOrEmpty()]
    [Parameter(
        Mandatory=$true,
        ValueFromPipelineByPropertyName=$true)]
    $Name,

    [string]
    [ValidateNotNullOrEmpty()]
    [Parameter(
        Mandatory=$true,
        ValueFromPipelineByPropertyName=$true)]
    $ResourceGroupName,

    [string]
    [ValidateNotNullOrEmpty()]
    [Parameter(
        Mandatory=$true,
        ValueFromPipelineByPropertyName=$true)]
    $Location,

    [string]
    [ValidateNotNullOrEmpty()]
    [Parameter(
        Mandatory=$true,
        ValueFromPipelineByPropertyName=$true)]
    $AppServicePlanName,

    [PSCustomObject[]]
    [Parameter(
        ValueFromPipelineByPropertyName=$true)]
    $Tag
){

    $ApiVersion = '2014-04-01'
    $ResourceType = 'Microsoft.Web/sites'
    # azure returns location strings with whitespace stripped
    $WhitespaceStrippedLocation = $Location -replace '\s', ''

    # build up property Hashtable from parameters
    $Properties = @{'serverFarm'=$AppServicePlanName}

    # build up tag Hashtable from tag PSCustomObject
    $TagHashtable = @{}
    if($Tag){
        $Tag.PSObject.Properties | %{$TagHashtable[$_.Name]=$_.Value}
    }

    If(!(AzureResourceManager\Get-AzureResource | ?{($_.Name -eq $Name) -and ($_.ResourceGroupName -eq $ResourceGroupName) -and ($_.Location -eq $WhitespaceStrippedLocation)})){
        AzureResourceManager\New-AzureResource `
        -Location $Location `
        -Name $Name `
        -ResourceGroupName $ResourceGroupName `
        -ResourceType $ResourceType `
        -Tag $TagHashtable `
        -ApiVersion $ApiVersion `
        -PropertyObject $Properties
    }
    Else{
        AzureResourceManager\Set-AzureResource `
        -Name $Name `
        -ResourceGroupName $ResourceGroupName `
        -ResourceType $ResourceType `
        -Tag $TagHashtable `
        -ApiVersion $ApiVersion `
        -PropertyObject $Properties
    }
}

Export-ModuleMember -Function Invoke