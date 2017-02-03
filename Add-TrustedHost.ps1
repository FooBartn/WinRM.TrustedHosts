function Add-TrustedHost {
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
        $TrustedHosts = $CurTrustedHosts + ", $TrustedHost"
    } else {
        $TrustedHosts = $TrustedHost
    }

    $TrustedHostsValSet = @{
        ValueSet = @{
            TrustedHosts = $TrustedHosts
        }
    }

    Set-WSManInstance @TrustedHostParams @TrustedHostsValSet
}
