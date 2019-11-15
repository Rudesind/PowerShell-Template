<#
.Synopsis
    <synopsis>

.Description
    <description>

.Parameter Debugging
    (Optional) Turn on local console debugging when running this script.

.Notes
    Script : <scriptName>
    Updated: <updated>
    Author : <author>
    Version: <version>

.Link
    For information on advanced parameters, see: 
        https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-6

.Link
    More information on variable types at: 
        https://docs.microsoft.com/en-us/powershell/developer/cmdlet/strongly-encouraged-development-guidelines

.Link
    Details on debug options: 
        https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_preference_variables?view=powershell-6

.Example
    <example>

#>

Param (

    [ValidateNotNullOrEmpty()]
    [Parameter(Mandatory = $False)]
    [System.Management.Automation.SwitchParameter] $Debugging

)

# Used for logging only
#
New-Variable SCRIPT -option Constant -value "<scriptName>"
New-Variable UPDATED -option Constant -value "<updated>"
New-Variable AUTHOR -option Constant -value "<author>"
New-Variable VERSION -option Constant -value "<version>"

# Error\Exit Codes
#
New-Variable INITIALIZATION_FAILED -option Constant -value 4000
New-Variable MODULE_LOAD_FAILED -option Constant -value 4001
New-Variable LOG_LOAD_FAILED -option Constant -value 4002
New-Variable FAILED_TO_EXIT -option Constant -value 4003

# Debugging
#
try {

    if ($Debugging) {

        $DebugPreference = "Continue"

        Write-Debug "Debug logging has been enabled"
    }

} catch {
    exit -1
}

# Initialize Variables
#
try {

    Write-Debug "Initializing variables"

    # Friendly error message for the script
    #
    [string] $errorMsg = [string]::Empty

} catch {
    $errorMsg = "Error, could not initialize the script: " + $Error[0]
    Write-Debug $errorMsg
    exit $INITIALIZATION_FAILED
}

# Load Modules
#
try {
    
    Write-Debug "Loading custom modules"

    Import-Module ".\LOG_Legacy.psm1"

} catch {
    $errorMsg = "Error, failed to load custom modules: " + $Error[0]
    Write-Debug $errorMsg
    exit $MODULE_LOAD_FAILED
}

# Initialize Log File
#
try {

    Write-Debug "Initializing log file"

    Initialize-Log ".\" $SCRIPT  > $null
    
    Write-Log "---" > $null
    Write-Log $SCRIPT > $null
    Write-Log $UPDATED > $null
    Write-Log $AUTHOR > $null
    Write-Log $VERSION > $null
    Write-Log "---" > $null

} catch {
    $errorMsg = "Error, could not initialize log: " + $Error[0]
    Write-Debug $errorMsg
    exit $LOG_LOAD_FAILED
}

# Sample Block
#
try  {

    # Code

} catch {
    $errorMsg = "Error" + $Error[0]
    Write-Debug $errorMsg
    Write-Log $errorMsg > $null
    Write-Log "Exiting with error code: $SAMPLEBLOCK" > $null
    exit $SAMPLEBLOCK
}

# Exit actions
#
try {

    Write-Debug "Script has completed with no errors"

    Write-Log "Exiting script with error code: 0" > $null

    exit 0

} catch {
    $errorMsg = "Error, code not exit: " + $Error[0]
    Write-Debug $errorMsg
    Write-Log $errorMsg > $null
    Write-Log "Exiting with error code: $FAILED_TO_EXIT" > $null
    exit $FAILED_TO_EXIT
}
