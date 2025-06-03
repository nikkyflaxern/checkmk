# check_software_center_updates.ps1

function Get-SoftwareCenterUpdates {
    $updates = @()
    
    Import-Module -Name 'CimCmdlets'

    $requiredUpdates = Get-CimInstance -Namespace 'root\ccm\clientSDK' -ClassName 'CCM_SoftwareUpdate'
    foreach ($update in $requiredUpdates) {
        $updates += [PSCustomObject]@{
            UpdateID = $update.CI_UniqueID
            Title    = $update.CI_Title
            Status   = 'Required'
        }
    }
    
    $availableUpdates = Get-CimInstance -Namespace 'root\ccm\clientSDK' -ClassName 'CCM_SoftwareUpdate'
    foreach ($update in $availableUpdates) {
        if ($update.Status -eq 'Available') {
            $updates += [PSCustomObject]@{
                UpdateID = $update.CI_UniqueID
                Title    = $update.CI_Title
                Status   = 'Available'
            }
        }
    }
    
    return $updates
}

$updates = Get-SoftwareCenterUpdates

$output = @()

if ($updates.Count -eq 0) {
    $output += "0 Software_Center_Updates count=0;0;0 No updates available"
} else {
    $requiredCount = $updates | Where-Object { $_.Status -eq 'Required' } | Measure-Object | Select-Object -ExpandProperty Count
    $availableCount = $updates | Where-Object { $_.Status -eq 'Available' } | Measure-Object | Select-Object -ExpandProperty Count
    $totalCount = $requiredCount + $availableCount
    $output += "1 Software_Center_Updates count=$totalCount;0;0 Updates available: $requiredCount required, $availableCount available"
}

$output
