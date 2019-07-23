#/config-dns/v1/zones/devasos.com


function Get-AkamaiDNSZone{
    param(
        $domain
    )
    $zone =  Invoke-AkamaiRequest "/config-dns/v1/zones/$domain"
    $zone.zone
}

function Get-AkamaiDNSZoneSerial{
    param(
        $domain
    )
    $zone = Get-AkamaiDNSZone $domain
    $zone.soa.serial
}