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
    $AppServicePlanName
){

    $ApiVersion = '2014-04-01'
    $ResourceType = 'Microsoft.Web/sites'

    # build up property Hashtable from parameters
    $Properties = @{serverFarm=$AppServicePlanName}

    # Azure uniquely identifies an App Service WebApp by 'ResourceType', 'Name'.
    # If there's a resource with properties matching these then the resource requested
    # to be set already exists.
    $ExistingAzureAppServiceWebApp = AzureResourceManager\Get-AzureResource -ResourceType $ResourceType | ?{$_.Name -eq $Name}

    # handle new
    If($ExistingAzureAppServiceWebApp){
        AzureResourceManager\New-AzureResource `
        -Location $Location `
        -Name $Name `
        -ResourceGroupName $ResourceGroupName `
        -ResourceType $ResourceType `
        -ApiVersion $ApiVersion `
        -PropertyObject $Properties
    }
    # handle existing
    Else{

        # Azure returns location strings with whitespace stripped
        $WhitespaceStrippedLocation = $Location -replace '\s', ''
        if($ExistingAzureAppServiceWebApp.Location -ne $WhitespaceStrippedLocation){            
            throw "Changing an App Service WebApp location is (currently) unsupported"
        }

        # handle resource group
        If($ExistingAzureAppServiceWebApp.ResourceGroupName -ne $ResourceGroupName){
            
            throw "Changing an App Service WebApp resource group is (currently) unsupported"

            # @TODO: 
            # according to: http://azure.microsoft.com/en-us/documentation/articles/powershell-azure-resource-manager/
            # the following should work but Move-AzureResource is not present in the 0.8.8 sdk.. 
            # AzureResourceManager\Move-AzureResource -DestinationResourceGroupName $ResourceGroupName -ResourceId 
        }
        
        AzureResourceManager\Set-AzureResource `
        -Name $Name `
        -ResourceGroupName $ResourceGroupName `
        -ResourceType $ResourceType `
        -ApiVersion $ApiVersion `
        -PropertyObject $Properties
    }
}

Export-ModuleMember -Function Invoke
