
try {
    
    Get-MgSubscribedSku -ErrorAction Stop
}
catch {
    Connect-MgGraph -Scopes User.ReadWrite.All, Organization.Read.All
}

$EmsArray = (Get-MgSubscribedSku)

$users = Get-MgUser

foreach($item in $users)
{
    
    $LicensesAssigned = (Get-MgUserLicenseDetail -UserId $item.Id)
    if($LicensesAssigned)
    {
        foreach($License in $EmsArray)
        {
            if($LicensesAssigned.SkuId -contains $License.SkuId)
            {
                Set-MgUserLicense -UserId $item.id -RemoveLicenses @($License.SkuId) -AddLicenses @{}
            }
            else 
            {
                Write-Verbose -Message "$($item.UserPrincipalName) does not have license $($License.skupartnumber) " -Verbose
            
            }
        
        }
    }
    else 
    {
        Write-Verbose -Message "$($item.UserPrincipalName) does not have any licenses to take away" -Verbose
    }
    
}
