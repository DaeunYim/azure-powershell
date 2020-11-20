
# ----------------------------------------------------------------------------------
#
# Copyright Microsoft Corporation
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ----------------------------------------------------------------------------------
. (Join-Path $PSScriptRoot "\..\utils\FlexibleServerUtils.ps1")
$DEFAULT_VNET_PREFIX = '10.0.0.0/16'
$DEFAULT_SUBNET_PREFIX = '10.0.0.0/24'
$DEFAULT_DB_NAME = 'flexibleserverdb'
$DELEGATION_SERVICE_NAME = "Microsoft.DBforMySQL/flexibleServers"
function New-AzMySqlFlexibleServer {
    [OutputType([Microsoft.Azure.PowerShell.Cmdlets.MySql.Models.Api20200701Preview.IServerAutoGenerated])]
    [CmdletBinding(DefaultParameterSetName='CreateExpanded', PositionalBinding=$false, SupportsShouldProcess, ConfirmImpact='Medium')]
    [Microsoft.Azure.PowerShell.Cmdlets.MySql.Description('Creates a new server.')]
    param(
        [Parameter(HelpMessage = 'The name of the server.')]
        [Alias('ServerName')]
        [Microsoft.Azure.PowerShell.Cmdlets.MySql.Category('Path')]
        [System.String]
        ${Name},

        [Parameter(HelpMessage = 'The name of the resource group that contains the resource, You can obtain this value from the Azure Resource Manager API or the portal.')]
        [Microsoft.Azure.PowerShell.Cmdlets.MySql.Category('Path')]
        [System.String]
        ${ResourceGroupName},

        [Parameter(HelpMessage='The subscription ID that identifies an Azure subscription.')]
        [Microsoft.Azure.PowerShell.Cmdlets.MySql.Category('Path')]
        [Microsoft.Azure.PowerShell.Cmdlets.MySql.Runtime.DefaultInfo(Script='(Get-AzContext).Subscription.Id')]
        [System.String]
        ${SubscriptionId},

        [Parameter(HelpMessage = 'The location the resource resides in.')]
        [Microsoft.Azure.PowerShell.Cmdlets.MySql.Category('Body')]
        [System.String]
        ${Location},

        [Parameter(HelpMessage = 'Administrator username for the server. Once set, it cannot be changed.')]
        [Microsoft.Azure.PowerShell.Cmdlets.MySql.Category('Body')]
        [System.String]
        ${AdministratorUserName},

        [Parameter(HelpMessage = 'The password of the administrator. Minimum 8 characters and maximum 128 characters. Password must contain characters from three of the following categories: English uppercase letters, English lowercase letters, numbers, and non-alphanumeric characters.')]
        [Microsoft.Azure.PowerShell.Cmdlets.MySql.Category('Body')]
        [System.Security.SecureString]
        [ValidateNotNullOrEmpty()]
        ${AdministratorLoginPassword},

        [Parameter(HelpMessage = 'The name of the sku, typically, tier + family + cores, e.g. Standard_B1ms, Standard_D2ds_v4.')]
        [Microsoft.Azure.PowerShell.Cmdlets.MySql.Category('Body')]
        [System.String]
        ${Sku},

        [Parameter(HelpMessage = 'Compute tier of the server. Accepted values: Burstable, GeneralPurpose, Memory Optimized. Default: Burstable.')]
        [Microsoft.Azure.PowerShell.Cmdlets.MySql.Category('Body')]
        [System.String]
        ${SkuTier},

        [Parameter(HelpMessage = "Backup retention days for the server. Day count is between 7 and 35.")]
        [Microsoft.Azure.PowerShell.Cmdlets.MySql.Category('Body')]
        [System.Int32]
        ${BackupRetentionDay},

        [Parameter(HelpMessage = 'Max storage allowed for a server.')]
        [Microsoft.Azure.PowerShell.Cmdlets.MySql.Category('Body')]
        [System.Int32]
        ${StorageInMb},

        [Parameter(HelpMessage = 'Application-specific metadata in the form of key-value pairs.')]
        [Microsoft.Azure.PowerShell.Cmdlets.MySql.Category('Body')]
        [Microsoft.Azure.PowerShell.Cmdlets.MySql.Runtime.Info(PossibleTypes=([Microsoft.Azure.PowerShell.Cmdlets.MySql.Models.Api20171201.IServerForCreateTags]))]
        [System.Collections.Hashtable]
        ${Tag},

        [Parameter(HelpMessage = 'Server version.')]
        [ArgumentCompleter([Microsoft.Azure.PowerShell.Cmdlets.MySql.Support.ServerVersion])]
        [Microsoft.Azure.PowerShell.Cmdlets.MySql.Category('Body')]
        [Microsoft.Azure.PowerShell.Cmdlets.MySql.Support.ServerVersion]
        ${Version},

        [Parameter(HelpMessage = 'The virtual network address prefix.')]
        [Microsoft.Azure.PowerShell.Cmdlets.MySql.Category('Body')]
        ${AddressPrefix},

        [Parameter(HelpMessage = 'The subnet IP address prefix to use when creating a new VNet in CIDR format. Default value is 10.0.0.0/24.')]
        [Microsoft.Azure.PowerShell.Cmdlets.MySql.Category('Body')]
        ${SubnetPrefix},

        [Parameter(HelpMessage = 'Resource ID of an existing subnet. Please note that the subnet will be delegated to Microsoft.DBforPostgreSQL/flexibleServers/Microsoft.DBforMySQL/flexibleServers.After delegation, this subnet cannot be used for any other type of Azure resources.')]
        [Microsoft.Azure.PowerShell.Cmdlets.MySql.Category('Body')]
        ${Subnet},

        [Parameter(HelpMessage = 'The IP address prefix to use when creating a new virtual network in CIDR format. Default value is 10.0.0.0/16.')]
        [Microsoft.Azure.PowerShell.Cmdlets.MySql.Category('Body')]
        ${VnetPrefix},

        [Parameter(HelpMessage = 'Name of an existing virtual network or name of a new one to create. The name must be between 2 to 64 characters. The name must begin with a letter or number, end with a letter, number or underscore, and may contain only letters, numbers, underscores, periods, or hyphens.')]
        [Microsoft.Azure.PowerShell.Cmdlets.MySql.Category('Body')]
        ${Vnet},

        [Parameter(HelpMessage = "
            Determines the public access. Enter single or range of IP addresses to be 
            included in the allowed list of IPs. IP address ranges must be dash-
            separated and not contain any spaces. Specifying 0.0.0.0 allows public
            access from any resources deployed within Azure to access your server.
            Specifying no IP address sets the server in public access mode but does
            not create a firewall rule.")]
        [Microsoft.Azure.PowerShell.Cmdlets.MySql.Category('Body')]
        ${PublicAccess},

        [Parameter(HelpMessage = 'Enable or disable high availability feature.  Default value is Disabled. Default: Disabled.')]
        [Microsoft.Azure.PowerShell.Cmdlets.MySql.Category('Body')]
        ${HighAvailability},

        [Parameter(HelpMessage = 'The credentials, account, tenant, and subscription used for communication with Azure.')]
        [Alias('AzureRMContext', 'AzureCredential')]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.MySql.Category('Azure')]
        [System.Management.Automation.PSObject]
        ${DefaultProfile},

        [Parameter(HelpMessage = 'Run the command as a job.')]
        [Microsoft.Azure.PowerShell.Cmdlets.MySql.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        ${AsJob},

        [Parameter(DontShow, HelpMessage = 'Wait for .NET debugger to attach.')]
        [Microsoft.Azure.PowerShell.Cmdlets.MySql.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        ${Break},

        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.MySql.Category('Runtime')]
        [Microsoft.Azure.PowerShell.Cmdlets.MySql.Runtime.SendAsyncStep[]]
        # SendAsync Pipeline Steps to be appended to the front of the pipeline.
        ${HttpPipelineAppend},

        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.MySql.Category('Runtime')]
        [Microsoft.Azure.PowerShell.Cmdlets.MySql.Runtime.SendAsyncStep[]]
        # SendAsync Pipeline Steps to be prepended to the front of the pipeline.
        ${HttpPipelinePrepend},

        [Parameter(HelpMessage = 'Run the command asynchronously.')]
        [Microsoft.Azure.PowerShell.Cmdlets.MySql.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        ${NoWait},

        [Parameter(DontShow)]
        [Microsoft.Azure.PowerShell.Cmdlets.MySql.Category('Runtime')]
        [System.Uri]
        # The URI for the proxy server to use.
        ${Proxy},

        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.MySql.Category('Runtime')]
        [System.Management.Automation.PSCredential]
        # Credentials for a proxy server to use for the remote call.
        ${ProxyCredential},

        [Parameter(DontShow)]
        [Microsoft.Azure.PowerShell.Cmdlets.MySql.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        # Use the default credentials for the proxy.
        ${ProxyUseDefaultCredentials}
    )

    process {
        try {
            if (!$PSBoundParameters.ContainsKey('Location')) {
                $PSBoundParameters.Location = 'westus2'
            }

            if (!$PSBoundParameters.ContainsKey('AdministratorLoginPassword')) {
                $Password = Get-GeneratePassword
                $PSBoundParameters.AdministratorLoginPassword = $Password | ConvertTo-SecureString -AsPlainText -Force
                Write-Output "G Password: " $Password
                Write-Output "Password: " $PSBoundParameters.AdministratorLoginPassword
            }
            $PSBoundParameters.AdministratorLoginPassword = . "$PSScriptRoot/../utils/Unprotect-SecureString.ps1" $PSBoundParameters['AdministratorLoginPassword']

            if(!$PSBoundParameters.ContainsKey('ResourceGroupName')) {
                $PSBoundParameters.ResourceGroupName = Get-RandomNumbers -Prefix 'group' -Length 10
                $Msg = "Creating Resource Group " + $PSBoundParameters.ResourceGroupName + "..."
                Write-Output $Msg
                If (!(Test-Path (Join-Path $PSScriptRoot '../generated/modules/Az.Resources'))){
                    Write-Output "No resources module here"
                    Find-Module -Name Az.Resources -RequiredVersion 2.0.1 -Repository 'PSGallery' | Save-Module -Path (Join-Path $PSScriptRoot '../generated/modules')
                }
                Else {
                    Write-Output "Yes resources module here"
                }
                Import-Module -Name Az.Resources -RequiredVersion 2.0.1
                New-AzResourceGroup -Name $PSBoundParameters.ResourceGroupName -Location $PSBoundParameters.Location
            }

            if ($PSBoundParameters.ContainsKey('Name')) {
                $Request = [Microsoft.Azure.PowerShell.Cmdlets.MySql.Models.Api20171201.NameAvailabilityRequest]::new()
                $Request.name = $PSBoundParameters['Name']
                $Request.type = 'Microsoft.DBforMySQL/flexibleServers'
                $AvailabilityResult = Test-AzMySqlFlexibleServerNameAvailability -NameAvailabilityRequest $Request
                if (!$AvailabilityResult.NameAvailable) {
                    $Msg = "The server name " + $PSBoundParameters['Name'] + " already exists. Please re-run command with some other server name."
                    Write-Error $Msg
                }
                $PSBoundParameters.ServerName = $PSBoundParameters['Name']
                $null = $PSBoundParameters.Remove('Name')
            }
            else {
                $PSBoundParameters.ServerName = Get-RandomNumbers -Prefix 'server' -Length 10
                $Msg = "Provisioning server " + $PSBoundParameters.ServerName
                Write-Output $Msg
            }

            if ($PSBoundParameters.ContainsKey('Sku')) {
                $PSBoundParameters.SkuName = $PSBoundParameters['Sku']
                $null = $PSBoundParameters.Remove('Sku')
            }
            else {
                $PSBoundParameters.SkuName = 'Standard_B1ms'
            }

            if ($PSBoundParameters.ContainsKey('BackupRetentionDay')) {
                $PSBoundParameters.StorageProfileBackupRetentionDay = $PSBoundParameters['BackupRetentionDay']
                $null = $PSBoundParameters.Remove('BackupRetentionDay')
            }
            else {
                $PSBoundParameters.StorageProfileBackupRetentionDay = 7
            }

            if ($PSBoundParameters.ContainsKey('StorageInMb')) {
                $PSBoundParameters.StorageProfileStorageMb = $PSBoundParameters['StorageInMb']
                $null = $PSBoundParameters.Remove('StorageInMb')
            }
            else {
                $PSBoundParameters.StorageProfileStorageMb = 10240
            }

            if (!$PSBoundParameters.ContainsKey('Version')) {
                $PSBoundParameters.Version = '5.7'
            }

            if (!$PSBoundParameters.ContainsKey('SkuTier')) {
                $PSBoundParameters.SkuTier = 'Burstable'
            }

            if ($PSBoundParameters.ContainsKey('AdministratorUserName')) {
                $PSBoundParameters.AdministratorLogin = $PSBoundParameters['AdministratorUserName']
                $null = $PSBoundParameters.Remove('AdministratorUserName')
            }
            else {
                $PSBoundParameters.AdministratorLogin = Get-RandomName
            }
            
            $PSBoundParameters.CreateMode = [Microsoft.Azure.PowerShell.Cmdlets.MySql.Support.CreateMode]::Default

            
            # ForEach($item in $PSBoundParameters) { Write-Output $item $PSBoundParameters[$item] }
            $NetworkKeys = 'PublicAccess', 'Subnet', 'Vnet', 'SubnetPrefix', 'VnetPrefix', 'ResourceGroupName', 'ServerName', 'Location'
            $NetworkParameters = @{}
            ForEach($Key in $NetworkKeys){If ($PSBoundParameters.ContainsKey($Key)){ $NetworkParameters[$Key] = $PSBoundParameters[$Key]}}
            foreach($item in $NetworkParameters) { Write-Output $item $NetworkParameters[$item] }

            $PSBoundParameters.DelegatedSubnetArgumentSubnetArmResourceId = CreateNetworkResource $NetworkParameters 
            # New-AzMySqlFlexibleServerDatabase -Name $DEFAULT_DB_NAME -ResourceGroupName $PSBoundParameters.ResourceGroupName -ServerName $PSBoundParameters.ServerName -Charset utf8
            
            # Az.MySql.internal\New-AzMySqlFlexibleServer @PSBoundParameters
        } catch {
            throw
        }
    }
}

function CreateNetworkResource($Parameters) {
    $SubnetId = $null
    Write-Output "Printing parameters.."
    foreach($item in $Parameters) { Write-Output $item $Parameters[$item] }
    # If (!(Test-Path (Join-Path $PSScriptRoot '../generated/modules/Az.Network'))){
    #     Write-Output "No network module here"
    #     Find-Module -Name Az.Network -RequiredVersion 3.0.0 -Repository 'PSGallery' | Save-Module -Path (Join-Path $PSScriptRoot '../generated/modules')
    # }
    # Else {
    #     Write-Output "Yes network module here"
    # }
    # Import-Module -Name Az.Network -RequiredVersion 3.0.0

    # # 1. Error Handling
    # # Raise error when user passes values for both parameters
    # if ($Parameters.ContainsKey('Subnet') -And $Parameters.ContainsKey('PublicAccess')) {
    #     Write-Error "Incorrect usage : A combination of the parameters --subnet and --public_access is invalid. Use either one of them."
    # }

    # # When address space parameters are passed, the only valid combination is : --vnet, --subnet, --vnet-address-prefix, --subnet-address-prefix
    # if ($Parameters.ContainsKey('Vnet') -Or $Parameters.ContainsKey('Subnet')) {
    #     if (!($Parameters.ContainsKey('VnetPrefix') -And $Parameters.ContainsKey('SubnetPrefix'))){
    #         Write-Error "Incorrect usage : --vnet, --subnet, --vnet-address-prefix, --subnet-address-prefix must be supplied together."
    #     }
    # }
    
    #Handle Vnet scenario
    If ($Parameters.ContainsKey('Vnet') -Or $Parameters.ContainsKey('Subnet')) {
        return $SubnetId
    }
    ElseIf (!$Parameters.ContainsKey('PublicAccess') -And !$Parameters.ContainsKey('Subnet') -And !$Parameters.ContainsKey('Vnet')) {
        $VnetName = 'VNET' + $Parameters.ServerName
        $SubnetName = 'Subnet' + $Parameters.ServerName
        $VnetAddrPrefix = $DEFAULT_VNET_PREFIX
        $SubnetAddrPrefix = $DEFAULT_SUBNET_PREFIX

        $Msg = 'Creating new vnet' + $VnetName + 'in resource group' + $Parameters.ResourceGroupName
        Write-Output $Msg
        Get-Help New-AzVirtualNetworkSubnetConfig
        Get-Help New-AzVirtualNetwork
        Get-Help Add-AzDelegation
        Get-Help Set-AzVirtualNetwork
        Get-Help Get-AzVirtualNetwork
        Get-Help Get-AzDelegation
        $Subnet = New-AzVirtualNetworkSubnetConfig -Name $SubnetName -AddressPrefix $SubnetAddrPrefix
        $Vnet = New-AzVirtualNetwork -Name $VnetName -ResourceGroupName $Parameters.ResourceGroupName -Location $Parameters.Location -AddressPrefix $VnetAddrPrefix -Subnet $Subnet
        $Subnet = Add-AzDelegation -Name "MySqlDelegation" -ServiceName $DELEGATION_SERVICE_NAME -Subnet $Subnet
        Set-AzVirtualNetwork -VirtualNetwork $Vnet
        
        # # Verify
        $Subnet = Get-AzVirtualNetwork -Name $VnetName -ResourceGroupName $Parameters.ResourceGroupName | Get-AzVirtualNetworkSubnetConfig -Name $SubnetName
        Get-AzDelegation -Name "MySqlDelegation" -Subnet $Subnet

        Write-Output 'Creating new subnet' $SubnetName 'in resource group ' $Parameters.ResourceGroupName 'and delegating it to ' $DELEGATION_SERVICE_NAME
        return $SubnetId = $Subnet.Id
    }


    # # Adding firewall rule
    # If ($Parameters.ContainsKey('PublicAccess') -And $Parameters.PublicAccess.ToLower() -ne 'none') {
    #     If ($Parameters.PublicAccess.ToLower() -eq 'all'){
    #         $StartIp = '0.0.0.0' 
    #         $EndIp = '255.255.255.255'
    #         $FirewallRule = New-AzMySqlFlexibleServerFirewallRule -ResourceGroupName $Parameters.ResourceGroupName -ServerName $Parameters.ServerName -EndIPAddress $EndIp -StartIPAddress $StartIp
    #     }
    #     Else {
    #         try{
    #             $Parsed = $Parameters.PublicAccess -split "-"
    #             If ($Parsed.length -eq 1) {
    #                 $StartIp = $Parsed[0]
    #                 $EndIp = $Parsed[0]
    #             }
    #             ElseIf ($Parsed.length -eq 2) {
    #                 $StartIp = $Parsed[0]
    #                 $EndIp = $Parsed[1]
    #             }
    #             Else { Write-Error "incorrect usage: --public-access. Acceptable values are \'all\', \'none\',\'<startIP>\' and \'<startIP>-<destinationIP>\' where startIP and destinationIP ranges from 0.0.0.0 to 255.255.255.255" }
                
    #             If ($StartIp -eq '0.0.0.0' -And $EndIp -eq '0.0.0.0') {
    #                 $RuleName = Get-Date -Format "AllowAllAzureServicesAndResourcesWithinAzureIps_yyyy-MM-dd_HH-mm-ss"
    #             }
    #             Else {
    #                 $RuleName = Get-Date -Format "FirewallIPAddress_yyyy-MM-dd_HH-mm-ss"
    #             }
    #             $FirewallRule = New-AzMySqlFlexibleServerFirewallRule -Name $RuleName -ResourceGroupName $Parameters.ResourceGroupName -ServerName $Parameters.ServerName -EndIPAddress $EndIp -StartIPAddress $StartIp
    #         } catch {
    #             Write-Error "incorrect usage: --public-access. Acceptable values are \'all\', \'none\',\'<startIP>\' and \'<startIP>-<destinationIP>\' where startIP and destinationIP ranges from 0.0.0.0 to 255.255.255.255"
    #         }
    #     }
    # }
    return $SubnetId
}
