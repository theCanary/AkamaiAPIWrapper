function Get-AkamaiPropertiesGroups{
    $groups =  Invoke-AkamaiRequest "/papi/v1/groups"
    #$groups.PSObject.TypeNames.Insert(0,'scotta01.Akamai.Groups')
        $groups.groups.items

}

function Get-AkamaiContracts{
    $contracts = Invoke-AkamaiRequest "/papi/v1/contracts" 
    $contracts.contracts.items
}

function Get-AkamaiProperties{
    param(
        [Parameter(ValueFromPipelineByPropertyName=$true,Mandatory=$true)]
        [Alias("Group")]
        $groupId,
        [Parameter(ValueFromPipelineByPropertyName=$true,Mandatory=$true)]
        [Alias("Contracts")]
        [string[]]$contractIds,
        [Parameter(ParameterSetName="Manual",ValueFromPipelineByPropertyName=$true,Mandatory=$false)]
        [string]$propertyId = $null
    )
    
    begin{
        $ErrorActionPreference = "SilentlyContinue"
        $byproperty = $false
        if($contractIds.Length -gt 0){
            $contractIds = $contractIds[0]
        }
        if($propertyId){
            $byproperty = $true
        }
    }
    process{
        if($byproperty){
            $properties =  Invoke-AkamaiRequest "/papi/v1/properties/?propertyId=$propertyId&contractId=$contractIds&groupId=$groupId"
        }
        else{
            $properties =  Invoke-AkamaiRequest "/papi/v1/properties/?contractId=$contractIds&groupId=$groupId"
        
        }
        $properties.properties.items
    }
    end{

    }
}

function Get-AkamaiPropertyRules{
    param(
        [Parameter(ValueFromPipelineByPropertyName=$true,Mandatory=$true)]
        [string[]]$propertyId,
        [Parameter(ValueFromPipelineByPropertyName=$true,Mandatory=$true)]
        [Alias("latestVersion")]
        $version
    )
    begin{

    }
    process{
        $rules =  Invoke-AkamaiRequest "/papi/v1/properties/$propertyId/versions/$version/rules"
        if($rules.RedirectLink){
            $rules =  Invoke-AkamaiRequest $rules.RedirectLink
        }
        $rules
    }
    end{

    }
}



function Get-AkamaiPropertyHostnames{
    param(
        [Parameter(ValueFromPipelineByPropertyName=$true,Mandatory=$true)]
        [string[]]$propertyId,
        [Parameter(ValueFromPipelineByPropertyName=$true,Mandatory=$true)]
        [Alias("latestVersion")]
        $version
    )
    begin{

    }
    process{
        $hostnames =  Invoke-AkamaiRequest "/papi/v1/properties/$propertyId/versions/$version/hostnames"
        $hostnames
    }
    end{

    }
}