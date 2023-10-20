## 0.3.3 - 
* Add `ServerHost` parameter to `Connect-MIAServer`
* Add support for -SkipCertificateCheck
* Format RestApi error details rather than the raw json (still want to add a try/catch before release.)
* Add `-Force` parameter to `Stop-MIATask`
## 0.3.2 - June 2022
* Refactor calls to Invoke-RestMethod to Invoke-MIARequest
* Consolidate .Format.ps1xml file
* Add `*-MIATaskScheduler` functions
* Add `Stop-MIATask` function
## 0.3.1 - March 2022
* Fixed issue in Wait-MIATask on Windows PowerShell 5.1
* Add Get-MIACustomScript command
* Add ToString() methods to MIATask, MIAHost, MIACustomScript
* Add Remove-MIATask command
* Add GetSteps() method to MIATask to make it easier to work with the steps in a task object.  *Note: used a method rather than a property so not to interfere with converting back to JSON*  
## 0.3.0 - April 2021
* Add Invoke-MIAWebRequest
## 0.2.1-preview - April 2021
* Add support for multiple contexts
## 0.2.0 - March 2021
* Initial Release