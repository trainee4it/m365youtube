function Show-AvailableLicenses

{
    'choose which licenses you want to assign 1 -' + $EmsArray.Count + ' -1 to stop'
    $EmsArray = (Get-MgSubscribedSku).SkuPartNumber
    write-host $EmsArray
    
    [int]$Number = Read-Host
    while($Number -ne -1)
    {
        
        $ChosenArray += $EmsArray[$Number -1]
        'choose which licenses you want to assign 1 -' + $EmsArray.Count + ' -1 to stop'
        [int]$Number = Read-Host

    }

    $ChosenArray

}


try {
    
    Get-MgSubscribedSku -ErrorAction Stop
}
catch {
    Connect-MgGraph -Scopes User.ReadWrite.All, Organization.Read.All
}



$users = Get-MgUser

foreach($item in $users)
{
    
    foreach($License in $EmsArray)
    {
        #$e5Sku = Get-MgSubscribedSku -All | Where SkuPartNumber -eq 'SPE_E5'
        #Set-MgUserLicense -UserId "belindan@litwareinc.com" -AddLicenses @{SkuId = $e5Sku.SkuId} -RemoveLicenses @()
        if($license -ne 'c7df2760-2c81-4ef7-b578-5b5392b571df')
        {
            Set-MgUserLicense -UserId $item.id -RemoveLicenses @() -AddLicenses @{SkuId = $License}

        }
        sleep -Milliseconds 20
    }

    sleep -Milliseconds 20
}
