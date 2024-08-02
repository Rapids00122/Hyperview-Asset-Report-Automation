#Generates Hyperview Access Token
$headers = @{
    "Content-Type" = "application/x-www-form-urlencoded"
}

$body = @{
    client_id = "8dcaf879-9077-42b1-a7b3-05dbce43c5b0"
    client_secret = "08c1b6ec-9800-42d6-ada1-be2244e76e38"
    Grant_Type = "client_credentials"
}

$response = Invoke-WebRequest -Uri 'https://msu.hyperviewhq.com/connect/token' -Method POST -Headers $headers -ContentType 'application/x-www-form-urlencoded' -Body $body

$content = ConvertFrom-Json $response.Content

$token = $content.access_token

#Sends API request to Hyperview to send over JSON list
$headers=@{}
$headers.Add("accept", "application/json, text/plain, */*")
$headers.Add("accept-language", "en-US,en;q=0.9")
$headers.Add("content-type", "application/json")
$headers.Add("origin", "https://msu.hyperviewhq.com")
$headers.Add("priority", "u=1, i")
$headers.Add("referer", "https://msu.hyperviewhq.com/search/(searchContentArea:advancedSearch)?s=%257B%2522c%2522%253A%255B%2522displayName%2522%252C%2522assetType%2522%252C%2522locationDisplayValue%2522%252C%2522manufacturerName%2522%252C%2522productName%2522%252C%2522serialNumber%2522%252C%2522PO%2520Number%2522%252C%2522Asset%2520Tag%2522%255D%252C%2522f%2522%253A%255B%255D%252C%2522m%2522%253A%255B%255D%252C%2522q%2522%253A%2522%2522%252C%2522l%2522%253A%252211223344-5566-7788-99aa-bbccddeeff00%2522%252C%2522p%2522%253A%2522All%2522%252C%2522i%2522%253A%2522faba89dc-89f8-d27a-5207-326a7b17459f%2522%257D")
$headers.Add("Authorization", "Bearer $token")
$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$cookie = New-Object System.Net.Cookie
$cookie.Name = 'REALTIMESERVERID'
$cookie.Value = '1710799780.752.13289.869472|f894e6ceb4de65607e7cbc0a3410ce96'
$cookie.Domain = 'msu.hyperviewhq.com'
$session.Cookies.Add($cookie)
$ProgressPreference = 'SilentlyContinue'
$response = Invoke-WebRequest -Uri 'https://msu.hyperviewhq.com/api/asset/search' -Method POST -Headers $headers -WebSession $session -ContentType 'application/json' -Body '{"size":10000,"from":0,"query":{"bool":{"filter":{"wildcard":{"tabDelimitedPath":"All\t*"}}}},"searchComplexDataFields":[{"contextId":"Asset Tag","propertyName":"Value","complexDataFieldCategory":"stringCustomProperties"},{"contextId":"PO Number","propertyName":"Value","complexDataFieldCategory":"stringCustomProperties"}],"selectedFields":["stringCustomProperties","DisplayName","AssetType","LocationDisplayValue","ManufacturerName","ProductName","SerialNumber"]}' -OutFile "Mallory_Search.json"