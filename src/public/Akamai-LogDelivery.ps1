
function Get-AkamaiLDSources {
    param(
        $CPCodeFilter
    )
    $resp = Invoke-AkamaiRequest "/lds-api/v3/log-sources"
    $cplogs = $resp | Where-Object{$_.type -eq "cpcode-products"}
    if($CPCodeFilter){
        $cplogs = $cplogs | Where-Object{$_.cpCode -like "*$CPCodeFilter*"}
    }
    return $cplogs
}

function Get-AkamaiLDConfigurationByType {
    param(
        $logSources
    )
    begin{}
    process{
        foreach($logSource in $logSources){
            
            $url = "/lds-api/v3/log-sources/cpcode-products/{0}/log-configurations" -f $logSource.id
            $resp = Invoke-AkamaiRequest $url
            $resp
        }
    }
    end{}
}

function Get-AkamaiLDConfiguration {
    param(
       $logConfigurationId
    )
    begin{}
    process{
        $resp = Invoke-AkamaiRequest "/lds-api/v3/log-configurations/$logConfigurationId"
        $resp
    }
    end{}
}

function Get-AkamaiLDFormats {
    param(
       $productType = "cpcode-products"
    )
    begin{}
    process{
        $resp = Invoke-AkamaiRequest "/lds-api/v3/log-sources/$productType/log-formats"
        $resp
    }
    end{}
}

function Update-AkamaiLDConfiguration{
    param(
        $logConfigurationId,
        [string]$content
    )
    $resp = Invoke-AkamaiRequest "/lds-api/v3/log-configurations/$logConfigurationId" -Method "PUT" -Body $content
    $resp
}

function New-AkamaiLDConfiguration{
    param(
        $logSourceId,
        [string]$content
    )
    $resp = Invoke-AkamaiRequest "/lds-api/v3/log-sources/cpcode-products/$logSourceId/log-configurations" -Method "POST" -Body $content
    $resp
}

function Start-AkamaiLDConfiguration {
    param(
       $logConfigurationId
    )
    begin{}
    process{
        $resp = Invoke-AkamaiRequest "/lds-api/v3/log-configurations/$logConfigurationId/resume" -Method POST
        $resp
    }
    end{}
}