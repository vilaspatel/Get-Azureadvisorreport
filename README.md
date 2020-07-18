# Get-Azureadvisorreport

.SYNOPSIS
    Script that collects Azure advisory report from all Subscriptions.
.DESCRIPTION
    The script collect all the Azure Advisor report from all the subscription which are permitted with your account.
    The following files will be created:
    AdvisoryReport.json
    AdvisoryReport.csv
.NOTES
    File Name      : Azureadvisorreport.ps1
    Author         : Vilas Patel
    Prerequisite   : PowerShell with Az module (Az.Advisor and Az.Accounts) 
.LINK
.EXAMPLE
    Azureadvisorreport.ps1
