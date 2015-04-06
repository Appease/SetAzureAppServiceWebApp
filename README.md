![](https://ci.appveyor.com/api/projects/status/kqyfqb3ug8cdm96f?svg=true)

####What is it?

An [Appease](http://appease.io) task template that sets an [Azure App Service WebApp](http://azure.microsoft.com/en-us/documentation/articles/app-service-web-overview/).

####How do I install it?

```PowerShell
Add-AppeaseTask `
    -DevOpName YOUR-DEVOP-NAME `
    -TemplateId SetAzureAppServiceWebApp
```

####What parameters are required?

#####Name
description: a `string` representing the name of the App Service Web App.

#####ResourceGroupName
description: a `string` representing the name of the resource group this App Service Web App will be added to.

#####Location
description: a `string` representing the geographical location of the App Service Web App.  
known allowed values: `Brazil South`, `East Asia`, `East US`, `Japan East`, `Japan West`, `North Central US`, `North Europe`, `South Central US`, `West Europe`, `West US`, `Southeast Asia`, `Central US`, `East US 2`

#####AppServicePlanName
description: a `string` representing the name of the App Service plan this App Service Web App will be added to.
