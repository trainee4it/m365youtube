
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
    $LicensesAssigned = (Get-MgUserLicenseDetail -UserId $item.Id)
    foreach($License in $EmsArray)
    {
        if($LicensesAssigned.SkuId -contains $License)
        {
            Set-MgUserLicense -UserId $item.id -RemoveLicenses @($License) -AddLicenses @{}
        }
        else 
        {
           Write-Verbose -Message "$($item.UserPrincipalName) does not have license " -Verbose
           
           #"$($item.UserPrincipalName) does not give"

        }
        sleep -Milliseconds 20

    }

    sleep -Milliseconds 20
}
