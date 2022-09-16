Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$PSDefaultParameterValues['*:ErrorAction'] = 'Stop'

Import-Module Microsoft.Graph 
Import-Module Microsoft.Graph.Applications
Import-Module Az.Accounts 

function Connect-B2cCli {
    <#
    .SYNOPSIS
    Logs the user in via the Microsoft Graph Powershell SDK.
    .DESCRIPTION
    A wrapper for the Connect-MgGraph cmdlet that logs the user in via the Microsoft Graph Powershell SDK. This command will launch a web browser to authenticate the user. Must be run with the tenant ID of the B2C tenant you'd like to manage. 
    .PARAMETER TenantId
    The tenant ID of the B2C tenant you'd like to manage.
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$TenantId
    )
    Get-MgGraphStatus
    Connect-MgGraph -TenantId $TenantId -Scopes "User.ReadWrite.All", "Application.ReadWrite.All", "Directory.AccessAsUser.All", "Directory.ReadWrite.All", "TrustFrameworkKeySet.ReadWrite.All, Policy.ReadWrite.TrustFramework"

}

function Get-MgGraphStatus {
    <#
    .SYNOPSIS
    Checks to see if the MgGraph modules are correctly installed
    .PARAMETER CheckLogin
    Boolean flag to enable checking the login status before doing anything else. 
    #>

    [CmdletBinding()]
    param(
        [switch] $CheckLogin
    )

    # if (!Get-Module -ListAvailable -Name Microsoft.Graph) {
    #     throw "Module Microsoft.Graph is not installed yet. Please install it first! Run 'Install-Module Microsoft.Graph'."
    # }
    # if (!Get-Module -ListAvailable -Name Microsoft.Graph.Applications) {
    #     throw "Module Microsoft.Graph.Applications is not installed yet. Please install it first! Run 'Install-Module Microsoft.Graph.Applications'."
    # }
    # if (!Get-Module -ListAvailable -Name Az.Accounts) {
    #     throw "Module Az.Accounts is not installed yet. Please install it first! Run 'Install-Module Az.Accounts'."
    # }

    if ((Get-MgProfile).Name -ne "beta"){
        Write-Warning "Your Microsoft Graph profile has been automatically swapped to using the BETA Graph API. The APIs in the beta Microsoft Graph build are subject to change at any time."
        Select-MgProfile -Name "beta"
    }

    if ($CheckLogin) {
        $context = Get-MgContext
        if ($null -eq $context){
            throw "You have not yet authenticated. Please run Connect-B2cCli."
        }
    }
}

Export-ModuleMember -Function Connect-B2cCli