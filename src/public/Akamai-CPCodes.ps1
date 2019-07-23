function Get-AkamaiCPCodes{
    param(
        [Parameter(ValueFromPipelineByPropertyName=$true,Mandatory=$true)]
        [Alias("Group")]
        $groupId,
        [Parameter(ValueFromPipelineByPropertyName=$true,Mandatory=$true)]
        [Alias("Contracts")]
        [string[]]$contractIds
    )
    
    begin{
        $ErrorActionPreference = "SilentlyContinue"
        if($contractIds.Length -gt 0){
            $contractIds = $contractIds[0]
        }
    }
    process{
            $cpcode =  Invoke-AkamaiRequest "/papi/v1/cpcodes?contractId=$contractIds&groupId=$groupId"
            $cpcode.cpcodes.items
    }
    end{

    }
}