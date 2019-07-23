function Get-AkamaiRedirectorPolicies{
    param(
        [switch]$PrettyOutput = $false      
    )
    $pols = Invoke-AkamaiRequest "/cloudlets/api/v2/policies" 
    
    if($PrettyOutput){
        $prettyResults = @()
        foreach($pol in $pols){
            $latestversion = Get-AkamaiRedirectorPolicyLatestVersion -policyId $pol.policyId
            $newpol = [PSCustomObject]@{
                Name = $pol.name
                Description = $pol.Description
                PolicyID = $pol.policyId
                APIURI = $pol.location
                LatestVersion = $latestversion.version
            }
            $prettyResults += $newpol
        }
        return $prettyResults
    }
    return $pols
    
}

function Get-AkamaiRedirectorPolicyVersions{
    param(
        [Parameter(ValueFromPipelineByPropertyName=$true)]
        $policyId
    )
    Invoke-AkamaiRequest "/cloudlets/api/v2/policies/$policyId/versions"
}

function Get-AkamaiRedirectorPolicyLatestVersion{
    param(
        [Parameter(ValueFromPipelineByPropertyName=$true)]
        $policyId
    )
    $resp = Invoke-AkamaiRequest "/cloudlets/api/v2/policies/$policyId/versions"
    $resp | Sort-Object version -Descending | Select-Object version -First 1
}

function Get-AkamaiRedirectorPolicyCSV {
    param(
        $policyID,
        $version,
        $Path
    )
    $resp = Invoke-AkamaiRequest "/cloudlets/api/v2/policies/$policyID/versions/$version/download"
    $resp | Out-File $Path
}

function Get-AkamaiRedirectorPolicyDetails {
    param(
        $policyID,
        $version
    )
    $resp = Invoke-AkamaiRequest "/cloudlets/api/v2/policies/$policyID/versions/$version"
    return $resp
}

function Get-AkamaiRedirectorPolicyRules {
    param(
        $policyID,
        $version
    )
    if($version -eq $null){
        $version = (Get-AkamaiRedirectorPolicyLatestVersion -policyId $policyID).Version
    }
    $resp = Invoke-AkamaiRequest "/cloudlets/api/v2/policies/$policyID/versions/$version"
    return $resp.matchRules
}

function Copy-AkamaiRedirectorPolicy {
    param(
        $policyID,
        $version
    )
    if($version -eq $null){
        $version = (Get-AkamaiRedirectorPolicyLatestVersion -policyId $policyID).Version
    }
    $resp = Invoke-AkamaiRequest "/cloudlets/api/v2/policies/$policyID/versions?cloneVersion=$version" -Method "POST"

    return $resp
}

function Update-AkamaiRedirectorPolicyRules {
    param(
        $policyID,
        $version,
        [string]$content
    )
    $resp = Invoke-AkamaiRequest "/cloudlets/api/v2/policies/$policyID/versions/$version" -Method "PUT" -Body $content
    return $resp
}

function New-AkamaiRedirectorPolicyVersion {
    param(
        $policyID
    )
    $resp = Invoke-AkamaiRequest "/cloudlets/api/v2/policies/$policyID/versions" -Method POST
    return $resp
}