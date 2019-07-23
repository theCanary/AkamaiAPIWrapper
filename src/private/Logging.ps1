function Format-LoggingDates{
    param(
        $datetime
    )
    Get-Date -date $datetime -Format yyyy-MM-dd

}

function Set-LoggingDates{
    param(
        $startdate = $((Get-Date).AddDays(1)),
        $days = $null
    )
    $startdate = Format-LoggingDates $startdate
    if($days){
        $enddate = (Get-Date).AddDays($days+1)
        $enddate = Format-LoggingDates $enddate 
    }
    else{
        $enddate = $null
    }
    $dates = [PSCustomObject]@{
        startDate = $startdate
        endDate = $enddate
    }
    return $dates

}

function Test-LogConfigurationExists{
    param(
        $LogSource
    )
    if(Get-AkamaiLDConfigurationByType -logSources $LogSource){
        return $true
    }
    else{
        return $false
    }
}

function Get-FTPSettings{
    param(
        [Parameter(Mandatory=$false)]
        [Alias("Path")]
        $ftpPath = "$PSScriptRoot\..\..\conf\ftp"
    )
    begin{
        $ftp = Get-Content $ftpPath
        $ftpObject = [PSCustomObject]@{
            machine = ""
            login =""
            directory = ""
            password = ""
        }
    }
    process{
        foreach($line in $ftp){
            switch -Wildcard ($line){
                "machine*"{$ftpObject.machine = $line.Replace("machine = ", "")}
                "login*"{$ftpObject.login = $line.Replace("login = ", "")}
                "directory*"{$ftpObject.directory = $line.Replace("directory = ", "")}
                "password*"{$ftpObject.password = $line.Replace("password = ", "")}
            }
        }
    }
    end{
        return $ftpObject
    }
    

}

function Format-AkamaiLDConfig{
    param(
        $logConfig,
        $startdate = $((Get-Date).AddDays(1)),
        $days = $null
    )
    $LogFormat = 86 #"Extended + Host Header"
    $formattedDates = Set-LoggingDates -startdate $startdate -days $days
    $logConfig.startdate = $formattedDates.startDate
    if($formattedDates.endDate){
        if(-not($logConfig.enddate)){
            $logConfig | Add-Member -MemberType NoteProperty -Name enddate -Value $formattedDates.endDate
        }
        else{
            $logConfig.enddate = $formattedDates.endDate
        }
    }
    else{
        $logConfig = $logConfig | Select-Object * -ExcludeProperty enddate
    }
    $logConfig = $logConfig | Select-Object * -ExcludeProperty status
    
    $ftpDetails = Get-FTPSettings

    $logConfig.deliveryDetails | Add-Member -MemberType NoteProperty -Name password -Value $ftpDetails.password -Force
    $logConfig.deliveryDetails.machine = $ftpDetails.machine
    $logConfig.deliveryDetails.login = $ftpDetails.login
    $logConfig.deliveryDetails.directory = $ftpDetails.directory
    $logConfig.logFormatDetails.logformat.id = $LogFormat

    $out = $logConfig | ConvertTo-JSon
    $out
}