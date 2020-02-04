# Quick and Dirty Dev Workstations in Azure

It's quick and dirty by design. Lots of flexibility, and not a lot of dependencies :) 

[![Deploy](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fjeremytbrun%2Fdev-workstation%2Fmaster%2Fazuredeploy.json)

Post-Deployment Config Script: [bit.ly/2Upy908](https://bit.ly/2Upy908)


Then run `iex "$((iwr https://bit.ly/2Upy908 -usebasicparsing).Content) | out-file c:\Initialize.ps1; c:\initialize.ps1"` from an administrative PowerShell console.