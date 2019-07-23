
. "$PSScriptRoot\src\private\Get-AkamaiAuth.ps1"
. "$PSScriptRoot\src\private\Akamai-Requests.ps1"
. "$PSScriptRoot\src\private\Logging.ps1"
. "$PSScriptRoot\src\public\Akamai-Properties.ps1"
. "$PSScriptRoot\src\public\Akamai-Redirectors.ps1"
. "$PSScriptRoot\src\public\Akamai-Diagnostics.ps1"
. "$PSScriptRoot\src\public\Akamai-FastDNS.ps1"
. "$PSScriptRoot\src\public\Akamai-LogDelivery.ps1"
. "$PSScriptRoot\src\public\Akamai-CPCodes.ps1"
$authPath = "$PSScriptRoot\conf\auth.edgerc"




function Update-AkamaiAuth{
    if(Test-Path $authPath){
        Get-AkamaiAuthToken -authPath $authPAth

    }
    else{
        Write-Error -Message "Auth File does not exist. Run 'Initialize-AkamaiCredentialsFile'" -RecommendedAction "Run 'Initialize-AkamaiAuth'"
    }
}

$authtoken = Update-AkamaiAuth

function Get-AkamaiProducts{
    param(
        [Parameter(ValueFromPipelineByPropertyName=$true,Mandatory=$true)]
        [Alias("contractId")]
        $contractIds
    )
    begin{
        if($contractIds.Length -gt 0){
            $contractIds = $contractIds[0]
        }
    }
    process{
        $products =  Invoke-AkamaiRequest "/papi/v1/products/?contractId=$contractIds"
        $products.products.items
    }

}
function Get-AkamaiSiteShieldMaps{
    param(
        [Parameter(Mandatory=$false)]
        [switch]$OnlyNetworks = $false
    )
    $map =  Invoke-AkamaiRequest "/siteshield/v1/maps"
    if($OnlyNetworks){
        return $map.siteShieldMaps.currentCidrs
    }
    return $map.siteShieldMaps
}








function Export-JSON{
    param(
        $APIResponse,
        $Path
    )
    begin{}
    process{
        $APIResponse | ConvertTo-Json | Out-File $Path -Force
    }
    end{}

    
}

function Search-AkamaiRules{
    param(
        $PolicyDetails,
        $FilterQuery,
        [switch]
        $PrepareforUpload = $false
    )

    $result = @()

    foreach($rule in $PolicyDetails){
        if (($rule.matchURL -like "*$FilterQuery*") -or ($rule.matches.matchValue -like "*$FilterQuery*")){
            $result += $rule
        }
    }

    if($PrepareforUpload){
        return Set-AkamaiRulestoJSON $result
    }
    else{
        return $result
    }
}

function Convert-AkamaiRules{
    param(
        $rulesJSON,
        $match,
        $replace
    )

    $data = $rulesJSON -replace ($match,$replace)
    return $data
}

function Set-AkamaiRulestoJSON{
    param(
        $rules
    )

    $rules =  $rules | Select-Object * -ExcludeProperty location | ConvertTo-Json -Depth 5
    $rules = '{"description": "updated via AS API", "matchRuleFormat":"1.0", "matchRules":' + $rules + '}'


    return $rules
}