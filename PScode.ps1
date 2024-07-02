Install-Module -Name AzureAD
Install-Module -Name ImportExcel
 

Connect-AzureAD

$excelFilePath = "C:\Users\KaylaNCedeno\Downloads\newCopy_offboarding.xlsx"
$excelData = Import-Excel -Path $excelFilePath
$endDateThreshold = Get-Date "8/11/23" -Format "MM/dd/yyyy"

foreach ($column in $excelData) {
       $name = $column.Account
       $endDateValue = $column.EndDate

       if ($endDateValue -as [DateTime]) {
           $endDate = [DateTime]$endDateValue
           if ($endDate -le $endDateThreshold) {
               try {

                   Remove-AzureADUser -ObjectId $name -Force
                   Write-Host "Deleted Azure AD user: $name."

               } 
               catch {
                   Write-Host "Error deleting user $name : $_"
               }
           } 

           else {
               Write-Host "End date not before the threshold for $name."
           }

       } 

      else {
           Write-Host "Invalid or empty EndDate value for $name."
       }
   }

   Disconnect-AzureAD
