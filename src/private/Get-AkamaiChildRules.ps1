function Get-ChildRules{
    [CMDletBinding()]
    param(
        $ruleset
    )
    $childrules = @()
    foreach($prop in $ruleset.rules){
        if($prop.children -ne $null){
            $childrules +=$prop.children
                $childrules += Get-ChildRules $prop.children
                
        }
    }
    $childrules
}
function Get-Origin{
    param(
        $rules,
        $originsearchtext = "origin*.asos.com"
    )

    foreach($rule in $rules){
        if($rule.behaviors -match "origin"){
            if($rule.behaviors.options.hostname -like $originsearchtext){
                #if($rule.criteria -match "path"){
                    $rule
                #}
            }
        }
    }
}

function Get-RulebyName{
    param(
        $rules
    )
    foreach($rule in $rules){
        if($rule.name -like "*favicon*"){
            $rule
        }
    }
}


#$rules = Import-Clixml .\wwwrules.xml
#$rules = Import-Clixml .\apirules.xml
#$rules = $rules.rules
#Get-Origin $rules
#Get-Origin $(Get-ChildRules $rules)