$category = (Get-NetConnectionProfile).NetworkCategory

if ($category -eq "DomainAuthenticated") {
    Write-Output "0 Network_Profile - OK: Network profile is DOMAIN"
}
elseif ($category -eq "Private") {
    Write-Output "1 Network_Profile - WARNING: Network profile is PRIVATE"
}
elseif ($category -eq "Public") {
    Write-Output "2 Network_Profile - CRITICAL: Network profile is PUBLIC"
}
else {
    Write-Output "3 Network_Profile - UNKNOWN: Unable to determine network profile"
}
