
try {
    
    Get-MgSubscribedSku -ErrorAction Stop
}
catch {
    Connect-MgGraph -Scopes User.ReadWrite.All, Organization.Read.All
}

$EmsArray = (Get-MgSubscribedSku).SkuId

$users = Get-MgUser

foreach($item in $users)
{
    $LicensesAssigned = (Get-MgUserLicenseDetail -UserId $item.Id).SkuId
    foreach($License in $EmsArray)
    {
        if($LicensesAssigned -contains $License)
        {
            Set-MgUserLicense -UserId $item.id -RemoveLicenses @($License) -AddLicenses @{}
        }
        else 
        {
           Write-Verbose -Message $item.UserPrincipalName does not have this license -Verbose
        }
        sleep -Milliseconds 20
    }

    sleep -Milliseconds 20
}
