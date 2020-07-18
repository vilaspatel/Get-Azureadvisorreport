<#
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
    (C) Copyright 2020 - Vilas Patel
.LINK
.EXAMPLE
    Azureadvisorreport.ps1
#>

Import-Module Az.Advisor

Login-AzAccount 

# define veriables 
$jsonString =@()
$jsonTable = New-Object system.Data.DataTable
        [void]$jsonTable.Columns.Add("ResourceId")
        [void]$jsonTable.Columns.Add("Impact") 
        [void]$jsonTable.Columns.Add("Category")
        [void]$jsonTable.Columns.Add("ShortDescription")
        [void]$jsonTable.Columns.Add("ImpactedField") 
        [void]$jsonTable.Columns.Add("ImpactedValue") 
        [void]$jsonTable.Columns.Add("LastUpdated") 
        [void]$jsonTable.Columns.Add("Subscription")
        [void]$jsonTable.Columns.Add("SubscriptionId")
 
        
# Get all subscriptions        
$Subscriptions = Get-azsubscription        
foreach ( $Subscription in $Subscriptions ) 
{
Set-AzContext $Subscription.name

$advisory = Get-AzAdvisorRecommendation  # Can include "-Category <CategoryName>" like Security, Cost, Reliability etc. to get specific Category .

if ($advisory.Impact -ne "null" ) 
    {

 for($i = 0; $i -lt $advisory.Count; $i++)
                    {
   
                    $jsonRow = $jsonTable.NewRow()
                                    $jsonRow.ResourceId = $advisory.ResourceId[$i]
                                    $jsonRow.Impact = $advisory.Impact[$i]
                                    $jsonRow.Category = $advisory.Category[$i]
                                    $jsonRow.ShortDescription = $advisory.ShortDescription[$i]
                                    $jsonRow.ImpactedField = $advisory.ImpactedField[$i]		
                                    $jsonRow.ImpactedValue =  $advisory.ImpactedValue[$i]
                                    $jsonRow.LastUpdated =  $advisory.LastUpdated[$i]
                                    $jsonRow.Subscription =  $Subscription.name
                                    $jsonRow.SubscriptionId =  $Subscription.Id
                    $jsonTable.Rows.Add($jsonRow)    
                        
                    }
                

    }

}

# creating csv file 
$jsonString = ($jsonTable | select $jsonTable.Columns.ColumnName) | ConvertTo-csv  > AdvisoryReport.csv

# creating json file 
$jsonString = ($jsonTable | select $jsonTable.Columns.ColumnName) | ConvertTo-json  > AdvisoryReport.json
