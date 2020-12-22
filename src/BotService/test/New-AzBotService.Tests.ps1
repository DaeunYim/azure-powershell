$loadEnvPath = Join-Path $PSScriptRoot 'loadEnv.ps1'
if (-Not (Test-Path -Path $loadEnvPath)) {
    $loadEnvPath = Join-Path $PSScriptRoot '..\loadEnv.ps1'
}
. ($loadEnvPath)
$TestRecordingFile = Join-Path $PSScriptRoot 'New-AzBotService.Recording.json'
$currentPath = $PSScriptRoot
while(-not $mockingPath) {
    $mockingPath = Get-ChildItem -Path $currentPath -Recurse -Include 'HttpPipelineMocking.ps1' -File
    $currentPath = Split-Path -Path $currentPath -Parent
}
. ($mockingPath | Select-Object -First 1).FullName

Describe 'New-AzBotService' {
    It 'Registration' {
        $NewApplication = New-AzApplicationInsights -ResourceGroupName $env.ResourceGroupName -Name $env.WebApplicationName1 -Location $env.Location
        $NewAzBot = New-AzBotService -ResourceGroupName $env.ResourceGroupName -Name $env.NewBotService1 -ApplicationId $NewApplication.AppId -Location $env.Location -Sku F0 -Description "description" -Registration
        $NewAzBot.Name | Should -Be $env.NewBotService1
    }

    #this case use the cmdlet 'New-AzResourceGroupDeployment' and it is can not be recorded.
    It 'WebApp' -Skip {
        $NewApplication = New-AzApplicationInsights -ResourceGroupName $env.ResourceGroupName -Name $env.WebApplicationName2 -Location $env.Location
        $ApplicationSecret = ConvertTo-SecureString -String $env.Secret -Force -AsPlainText
        write-host $ApplicationSecret
        $NewAzBot = New-AzBotService -ResourceGroupName $env.ResourceGroupName -Name $env.NewBotService2 -ApplicationId $NewApplication.AppId -Location $env.Location -Sku F0 -Description "description" -ApplicationSecret $ApplicationSecret -Webapp
        $NewAzBot.Name | Should -Be $env.NewBotService2
    }
}
