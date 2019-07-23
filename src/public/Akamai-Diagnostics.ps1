function Get-AkamaiTranslatedURL {
    param(
        $url
    )
    $encodedurl = [System.Web.HttpUtility]::UrlEncode($url) 
    $resp = Invoke-AkamaiRequest "/diagnostic-tools/v2/translated-url?url=$encodedurl"
    return $resp.translatedUrl
}


function Get-AkamaiTranslatedError {
    param(
        $errorCode
    )
    $resp = Invoke-AkamaiRequest "/diagnostic-tools/v2/errors/$errorCode/translated-error"
    return $resp.translatedError
}