#$authPath = "$PSScriptRoot\conf\auth.edgerc"

function Get-AkamaiAuthToken{
    param(
        [Parameter(Mandatory=$false)]
        [Alias("Path")]
        $authPath = "$PSScriptRoot\..\..\conf\auth.edgerc"
    )
    begin{
        $auth = Get-Content $authPath
        $authtoken = [PSCustomObject]@{
            ClientToken = ""
            ClientAccessToken =""
            ClientSecret = ""
            APIHOST = ""
        }
    }
    process{
        foreach($line in $auth){
            switch -Wildcard ($line){
                "client_token*"{$authtoken.ClientToken = $line.Replace("client_token = ", "")}
                "client_secret*"{$authtoken.ClientSecret = $line.Replace("client_secret = ", "")}
                "access_token*"{$authtoken.ClientAccessToken = $line.Replace("access_token = ", "")}
                "host*"{$authtoken.APIHOST = $line.Replace("host = ", "")}
            }
        }
    }
    end{
        return $authtoken
    }
    

}

function Initialize-AkamaiCredentialsFile{
    [CmdletBinding(DefaultParameterSetName="Manual")]
    param(
            [Parameter(ParameterSetName="Manual")]
            [string]$ClientSecret,
            [Parameter(ParameterSetName="Manual")]
            [alias("Host")]
            [string]$reqUrl,
            [Parameter(ParameterSetName="Manual")]
            [string]$AccessToken,
            [Parameter(ParameterSetName="Manual")]
            [string]$ClientToken,
            [Parameter(ParameterSetName="Manual")]
            [int]$MaxBody = 131072,
            [Parameter(ParameterSetName="File")]
            [string]$Path,
            [switch]$Force = $false
        )
        $overwrite = $Force
        if((Test-Path $authPath) -and ($overwrite -ne $true)){
            Write-Error "Auth File already exists, use -Force to overwrite" -RecommendedAction "Re-run using -Force parameter"
        }
        else{
            if((Test-Path $authPath) -and ($overwrite -eq $true)){
                Remove-Item $authPath -Force
            }
    
            if($Path -eq $null){
                New-Item $authPath -ItemType File -Value "[default]`n"
                $data = @{
                    client_secret = $ClientSecret
                    host = $reqUrl
                    access_token = $AccessToken
                    client_token = $ClientToken
                    'max-body' = $MaxBody
                }
                
                $formattedData = $null
                foreach($Key in $data.Keys){
                    $formattedData += '{0} = {1}' -f $Key, $data[$Key]
                    $formattedData += "`n"
                }
                Add-Content $authPath -Value $formattedData
            }
            else{
                Copy-Item $Path $authPath -Force
                Update-AkamaiAuth
            }
        }
}