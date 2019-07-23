$akamaiwrapper = "$($MyInvocation.PSScriptRoot)\lib\AkamaiOPEN-edgegrid-powershell\Invoke-AkamaiOPEN.ps1"
function  Set-AkamaiRequest {
    param(
        [Parameter(Mandatory=$true)]
        [pscustomobject]$authtokens,
        [Parameter(Mandatory=$true)]
        [ValidateSet("GET", "PUT", "POST", "DELETE")]
        [string]$Method,
        [Parameter(Mandatory=$true)]
        [string]$ApiUrl,
        [Parameter(Mandatory=$false)]
        [string]$Body
    )
    begin{
    }
    process{
        $args = @{
            Method = $Method
            ClientToken = $authtokens.ClientToken
            ClientAccessToken = $authtokens.ClientAccessToken
            ClientSecret = $authtokens.ClientSecret
            ReqURL = "https://$($authtokens.APIHOST)$ApiUrl"
            Body = $Body
        }
    }
    end{
        return $args
    }
    
}

function Invoke-AkamaiRequest{
    param(
        $ApiUrl,
        $Method = "GET",
        $Body = $null
    )
    begin{

    }
    process{
        $splatting = Set-AkamaiRequest -auth $authtoken -Method $Method -ApiUrl $ApiUrl -Body $Body
        $response = & $akamaiwrapper @splatting
        
    }
    end{
        return $response
    }
}