$loadEnvPath = Join-Path $PSScriptRoot 'loadEnv.ps1'
if (-Not (Test-Path -Path $loadEnvPath)) {
    $loadEnvPath = Join-Path $PSScriptRoot '..\loadEnv.ps1'
}
. ($loadEnvPath)
$TestRecordingFile = Join-Path $PSScriptRoot 'New-AzPostgreSqlFlexibleServer.Recording.json'
$currentPath = $PSScriptRoot
while(-not $mockingPath) {
    $mockingPath = Get-ChildItem -Path $currentPath -Recurse -Include 'HttpPipelineMocking.ps1' -File
    $currentPath = Split-Path -Path $currentPath -Parent
}
. ($mockingPath | Select-Object -First 1).FullName
$DELEGATION_SERVICE_NAME = "Microsoft.DBforPostgreSQL/flexibleServers"
$DEFAULT_VNET_PREFIX = '10.0.0.0/16'
$DEFAULT_SUBNET_PREFIX = '10.0.0.0/24'
If ($TestMode -eq 'live' -or $TestMode -eq 'record') {
    If (!(Get-Module -ListAvailable -Name Az.Network)) { Install-Module -Name Az.Network }
    Import-Module -Name Az.Network
}

Describe 'New-AzPostgreSqlFlexibleServer' {
    function WaitServerDelete(){
        If ($TestMode -eq 'live' -or $TestMode -eq 'record') {
            Start-Sleep -Seconds 450
        }
    }
    function ValidateSubnetVnet($Server, $VnetName, $SubnetName){
        $Vnet = Get-AzVirtualNetwork -Name $VNetName -ResourceGroupName $env.resourceGroup
        $Subnet = Get-AzVirtualNetworkSubnetConfig -Name $SubnetName -VirtualNetwork $Vnet
            
        $Server.DelegatedSubnetArgumentSubnetArmResourceId | Should -Be $Subnet.Id
        $Delegation = Get-AzDelegation -Name $DELEGATION_SERVICE_NAME -Subnet $Subnet
        $Delegation.ServiceName | Should -Be $DELEGATION_SERVICE_NAME
    }
    
    function RemoveServerVnet($ServerName, $VnetName, $SubnetName){
        $Vnet = Get-AzVirtualNetwork -Name $VNetName -ResourceGroupName $env.resourceGroup
        $Subnet = Get-AzVirtualNetworkSubnetConfig -Name $SubnetName -VirtualNetwork $Vnet

        Remove-AzPostgreSqlFlexibleServer -ResourceGroupName $env.resourceGroup -Name $ServerName
        WaitServerDelete
        $Subnet = Remove-AzDelegation -Name $DELEGATION_SERVICE_NAME -Subnet $Subnet
        Set-AzVirtualNetwork -VirtualNetwork $Vnet
        Remove-AzVirtualNetwork -Name $Vnet.Name -ResourceGroupName $env.resourceGroup -Force
    }

    It 'NoArgumentsScenario' {
        If ($TestMode -eq 'live' -or $TestMode -eq 'record') {
            {
                $Server = New-AzPostgreSqlFlexibleServer
                $Splits = $Server.Id -Split "/" 
                $ResourceGroupName = $Splits[4]
                $SubnetName = 'Subnet' + $Server.Name
                $VnetName = 'VNET' + $Server.Name
                $Vnet = Get-AzVirtualNetwork -Name $VnetName -ResourceGroupName $ResourceGroupName
                $Subnet = Get-AzVirtualNetworkSubnetConfig -Name $SubnetName -VirtualNetwork $Vnet

                $Server.SkuName | Should -Be "Standard_D2s_v3"
                $Server.SkuTier | Should -Be "GeneralPurpose"
                $Server.StorageProfileStorageMb | Should -Be 131072
                $Server.StorageProfileBackupRetentionDay | Should -Be 7
                $Server.Location | Should -Be "East US"

                $Vnet = Get-AzVirtualNetwork -Name $VNetName -ResourceGroupName $ResourceGroupName
                $Subnet = Get-AzVirtualNetworkSubnetConfig -Name $SubnetName -VirtualNetwork $Vnet
                    
                $Server.DelegatedSubnetArgumentSubnetArmResourceId | Should -Be $Subnet.Id
                $Delegation = Get-AzDelegation -Name $DELEGATION_SERVICE_NAME -Subnet $Subnet
                $Delegation.ServiceName | Should -Be $DELEGATION_SERVICE_NAME
                Remove-AzPostgreSqlFlexibleServer -ResourceGroupName $ResourceGroupName -Name $Server.Name
                WaitServerDelete
                Remove-AzVirtualNetwork -Name $Vnet.Name -ResourceGroupName $ResourceGroupName -Force
                Remove-AzResourceGroup -Name $ResourceGroupName -Force
            } | Should -Not -Throw
        }
    }
}
