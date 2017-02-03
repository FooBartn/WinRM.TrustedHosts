function Remove-TrustedHost {
    [CmdletBinding()]
    param (
        # Trusted Host IP
        [Parameter(Mandatory)]
        [string]
        $TrustedHost,

        # ComputerName
        [Parameter()]
        [string]
        $ComputerName = 'localhost'
    )

    $TrustedHostParams = @{
        ResourceURI = 'winrm/config/client'
        ComputerName = $ComputerName
    }

    $CurTrustedHosts = Get-WSManInstance @TrustedHostParams |
    Select-Object -ExpandProperty TrustedHosts

    if ($CurTrustedHosts) {
        $TrustedHostsArray = {$CurTrustedHosts.Split(',').Trim()}.Invoke()
        $TrustedHostsArray.Remove($TrustedHost)
        $NewTrustedHosts = $TrustedHostsArray -join ', '
        $TrustedHostsValSet = @{
            ValueSet = @{
                TrustedHosts = $NewTrustedHosts
            }
        }
        Set-WSManInstance @TrustedHostParams @TrustedHostsValSet
    } else {
        Write-Warning -Message 'TrustedHosts list is empty'
    }
}
