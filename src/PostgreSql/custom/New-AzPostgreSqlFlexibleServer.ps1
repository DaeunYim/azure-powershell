
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
<#
.Synopsis
Creates a new PostgreSQL flexible server.
.Description
Creates a new PostgreSQL flexible server.
#>

$DELEGATION_SERVICE_NAME = "Microsoft.DBforPostgreSQL/flexibleServers"
$DEFAULT_VNET_PREFIX = '10.0.0.0/16'
$DEFAULT_SUBNET_PREFIX = '10.0.0.0/24'
$AZURE_ARMNAME = '^[^<>%&:\\?/]{1,260}$'

function New-AzPostgreSqlFlexibleServer {
    [OutputType([Microsoft.Azure.PowerShell.Cmdlets.PostgreSql.Models.Api20200214Preview.IServerAutoGenerated])]
    [CmdletBinding(DefaultParameterSetName='CreateExpanded', PositionalBinding=$false, SupportsShouldProcess, ConfirmImpact='Medium')]
    [Microsoft.Azure.PowerShell.Cmdlets.PostgreSql.Description('Creates a new server.')]
    param(
        [Parameter(HelpMessage = 'The name of the server.')]
        [Alias('ServerName')]
        [Microsoft.Azure.PowerShell.Cmdlets.PostgreSql.Category('Path')]
        [System.String]
        ${Name},

        [Parameter(HelpMessage = 'The name of the resource group that contains the resource, You can obtain this value from the Azure Resource Manager API or the portal.')]
        [Microsoft.Azure.PowerShell.Cmdlets.PostgreSql.Category('Path')]
        [System.String]
        ${ResourceGroupName},

        [Parameter(HelpMessage='The subscription ID that identifies an Azure subscription.')]
        [Microsoft.Azure.PowerShell.Cmdlets.PostgreSql.Category('Path')]
        [Microsoft.Azure.PowerShell.Cmdlets.PostgreSql.Runtime.DefaultInfo(Script='(Get-AzContext).Subscription.Id')]
        [System.String]
        ${SubscriptionId},

        [Parameter(HelpMessage = 'The location the resource resides in.')]
        [Microsoft.Azure.PowerShell.Cmdlets.PostgreSql.Category('Body')]
        [System.String]
        ${Location},

        [Parameter(HelpMessage = 'Administrator username for the server. Once set, it cannot be changed.')]
        [Microsoft.Azure.PowerShell.Cmdlets.PostgreSql.Category('Body')]
        [System.String]
        ${AdministratorUserName},

        [Parameter(HelpMessage = 'The password of the administrator. Minimum 8 characters and maximum 128 characters. Password must contain characters from three of the following categories: English uppercase letters, English lowercase letters, numbers, and non-alphanumeric characters.')]
        [Microsoft.Azure.PowerShell.Cmdlets.PostgreSql.Category('Body')]
        [System.Security.SecureString]
        [ValidateNotNullOrEmpty()]
        ${AdministratorLoginPassword},

        [Parameter(HelpMessage = 'The name of the sku, typically, tier + family + cores, e.g. Standard_B1ms, Standard_D2ds_v4.')]
        [Microsoft.Azure.PowerShell.Cmdlets.PostgreSql.Category('Body')]
        [System.String]
        ${Sku},

        [Parameter(HelpMessage = 'Compute tier of the server. Accepted values: Burstable, GeneralPurpose, Memory Optimized. Default: Burstable.')]
        [Microsoft.Azure.PowerShell.Cmdlets.PostgreSql.Category('Body')]
        [System.String]
        ${SkuTier},

        [Parameter(HelpMessage = "Backup retention days for the server. Day count is between 7 and 35.")]
        [Microsoft.Azure.PowerShell.Cmdlets.PostgreSql.Category('Body')]
        [System.Int32]
        ${BackupRetentionDay},

        [Parameter(HelpMessage = 'Max storage allowed for a server.')]
        [Microsoft.Azure.PowerShell.Cmdlets.PostgreSql.Category('Body')]
        [System.Int32]
        ${StorageInMb},

        [Parameter(HelpMessage = 'Application-specific metadata in the form of key-value pairs.')]
        [Microsoft.Azure.PowerShell.Cmdlets.PostgreSql.Category('Body')]
        [Microsoft.Azure.PowerShell.Cmdlets.PostgreSql.Runtime.Info(PossibleTypes=([Microsoft.Azure.PowerShell.Cmdlets.PostgreSql.Models.Api20171201.IServerForCreateTags]))]
        [System.Collections.Hashtable]
        ${Tag},

        [Parameter(HelpMessage = 'Server version.')]
        [ArgumentCompleter([Microsoft.Azure.PowerShell.Cmdlets.PostgreSql.Support.ServerVersion])]
        [Microsoft.Azure.PowerShell.Cmdlets.PostgreSql.Category('Body')]
        [Microsoft.Azure.PowerShell.Cmdlets.PostgreSql.Support.ServerVersion]
        ${Version},

        # [Parameter(ParameterSetName='CreateWithPrivateAccess')]
        [Parameter(HelpMessage = 'The subnet IP address prefix to use when creating a new vnet in CIDR format. Default value is 10.0.0.0/24.')]
        [System.String]
        ${SubnetPrefix},

        # [Parameter(ParameterSetName='CreateWithPrivateAccess')]
        [Parameter(HelpMessage = 'The Name or Id of an existing Subnet or name of a new one to create. Please note that the subnet will be delegated to Microsoft.DBforPostgreSQL/flexibleServers. After delegation, this subnet cannot be used for any other type of Azure resources.')]
        [System.String]
        ${Subnet},

        # [Parameter(ParameterSetName='CreateWithPrivateAccess')]
        [Parameter(HelpMessage = 'The IP address prefix to use when creating a new vnet in CIDR format. Default value is 10.0.0.0/16.')]
        [System.String]
        ${VnetPrefix},

        # [Parameter(ParameterSetName='CreateWithPrivateAccess')]
        [Parameter(HelpMessage = 'The Name or Id of an existing virtual network or name of a new one to create. The name must be between 2 to 64 characters. The name must begin with a letter or number, end with a letter, number or underscore, and may contain only letters, numbers, underscores, periods, or hyphens.')]
        [System.String]
        ${Vnet},

        # [Parameter(ParameterSetName='CreateWithPublicAccess')]
        [Parameter(HelpMessage = "
            Determines the public access. Enter single or range of IP addresses to be 
            included in the allowed list of IPs. IP address ranges must be dash-
            separated and not contain any spaces. Specifying 0.0.0.0 allows public
            access from any resources deployed within Azure to access your server.
            Specifying no IP address sets the server in public access mode but does
            not create a firewall rule.")]
        [System.String]
        ${PublicAccess},

        [Parameter(HelpMessage = 'The credentials, account, tenant, and subscription used for communication with Azure.')]
        [Alias('AzureRMContext', 'AzureCredential')]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.PostgreSql.Category('Azure')]
        [System.Management.Automation.PSObject]
        ${DefaultProfile},

        [Parameter(HelpMessage = 'Run the command as a job.')]
        [Microsoft.Azure.PowerShell.Cmdlets.PostgreSql.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        ${AsJob},

        [Parameter(DontShow, HelpMessage = 'Wait for .NET debugger to attach.')]
        [Microsoft.Azure.PowerShell.Cmdlets.PostgreSql.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        ${Break},

        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.PostgreSql.Category('Runtime')]
        [Microsoft.Azure.PowerShell.Cmdlets.PostgreSql.Runtime.SendAsyncStep[]]
        # SendAsync Pipeline Steps to be appended to the front of the pipeline.
        ${HttpPipelineAppend},

        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.PostgreSql.Category('Runtime')]
        [Microsoft.Azure.PowerShell.Cmdlets.PostgreSql.Runtime.SendAsyncStep[]]
        # SendAsync Pipeline Steps to be prepended to the front of the pipeline.
        ${HttpPipelinePrepend},

        [Parameter(HelpMessage = 'Run the command asynchronously.')]
        [Microsoft.Azure.PowerShell.Cmdlets.PostgreSql.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        ${NoWait},

        [Parameter(DontShow)]
        [Microsoft.Azure.PowerShell.Cmdlets.PostgreSql.Category('Runtime')]
        [System.Uri]
        # The URI for the proxy server to use.
        ${Proxy},

        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.PostgreSql.Category('Runtime')]
        [System.Management.Automation.PSCredential]
        # Credentials for a proxy server to use for the remote call.
        ${ProxyCredential},

        [Parameter(DontShow)]
        [Microsoft.Azure.PowerShell.Cmdlets.PostgreSql.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        # Use the default credentials for the proxy.
        ${ProxyUseDefaultCredentials}
    )

    process {
        try {

            if (!$PSBoundParameters.ContainsKey('Location')) {
                $PSBoundParameters.Location = 'eastus'
            }

            if (!$PSBoundParameters.ContainsKey('AdministratorLoginPassword')) {
                $Password = Get-GeneratePassword
                $PSBoundParameters.AdministratorLoginPassword = $Password | ConvertTo-SecureString -AsPlainText -Force
            }

            Import-Module -Name Az.Resources
            
            if(!$PSBoundParameters.ContainsKey('ResourceGroupName')) {
                $PSBoundParameters.ResourceGroupName = Get-RandomNumbers -Prefix 'group' -Length 10
                $Msg = "Creating Resource Group {0}..." -f $PSBoundParameters.ResourceGroupName
                Write-Host $Msg
                
                if($PSCmdlet.ShouldProcess($PSBoundParameters.ResourceGroupName)) {
                    $null = New-AzResourceGroup -Name $PSBoundParameters.ResourceGroupName -Location $PSBoundParameters.Location -Force
                }
            }
            else {
                $Msg = 'Checking the existence of the resource group {0} ...' -f $PSBoundParameters.ResourceGroupName
                Write-Host $Msg
                try {
                    $null = Get-AzResourceGroup -Name $PSBoundParameters.ResourceGroupName -ErrorAction Stop
                    $Msg = 'Resource group {0} exists ? : True' -f $PSBoundParameters.ResourceGroupName
                    Write-Host $Msg
                }
                catch {
                    $Msg = 'Resource group {0} exists ? : False' -f $PSBoundParameters.ResourceGroupName
                    Write-Host $Msg
                    $Msg = "Creating Resource Group {0}..." -f $PSBoundParameters.ResourceGroupName
                    Write-Host $Msg
                    if($PSCmdlet.ShouldProcess($PSBoundParameters.ResourceGroupName)) {
                        $null = New-AzResourceGroup -Name $PSBoundParameters.ResourceGroupName -Location $PSBoundParameters.Location -Force
                    }

                }
            }

            if (!$PSBoundParameters.ContainsKey('Name')) {
                $PSBoundParameters.Name = Get-RandomNumbers -Prefix 'server' -Length 10
            }

            if ($PSBoundParameters.ContainsKey('Sku')) {
                $PSBoundParameters.SkuName = $PSBoundParameters['Sku']
                $null = $PSBoundParameters.Remove('Sku')
            }
            else {
                $PSBoundParameters.SkuName = 'Standard_D2s_v3'
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
                $PSBoundParameters.StorageProfileStorageMb = 128*1024
            }

            if (!$PSBoundParameters.ContainsKey('Version')) {
                $PSBoundParameters.Version = '12'
            }

            if (!$PSBoundParameters.ContainsKey('SkuTier')) {
                $PSBoundParameters.SkuTier = 'GeneralPurpose'
            }            

            if ($PSBoundParameters.ContainsKey('AdministratorUserName')) {
                $PSBoundParameters.AdministratorLogin = $PSBoundParameters['AdministratorUserName']
                $null = $PSBoundParameters.Remove('AdministratorUserName')
            }
            else {
                $PSBoundParameters.AdministratorLogin = Get-RandomName
            }

            $PSBoundParameters.CreateMode = [Microsoft.Azure.PowerShell.Cmdlets.PostgreSql.Support.CreateMode]::Default

            # Handling Vnet & Subnet
            $NetworkKeys = 'PublicAccess', 'Subnet', 'Vnet', 'SubnetPrefix', 'VnetPrefix'
            $NetworkParameters = @{}
            foreach($Key in $NetworkKeys){
                if ($PSBoundParameters.ContainsKey($Key)){ 
                    $NetworkParameters[$Key] = $PSBoundParameters[$Key]
                    $null = $PSBoundParameters.Remove($Key)
                }
            }
            $RequiredKeys = 'SubscriptionId', 'ResourceGroupName', 'Name', 'Location'
            foreach($Key in $RequiredKeys){ $NetworkParameters[$Key] = $PSBoundParameters[$Key] }

            if(!$NetworkParameters.ContainsKey('PublicAccess')){
                $VnetSubnetParameters = CreateNetworkResource $NetworkParameters
                $SubnetId = GetSubnetId $VnetSubnetParameters.ResourceGroupName $VnetSubnetParameters.VnetName $VnetSubnetParameters.SubnetName
                $PSBoundParameters.DelegatedSubnetArgumentSubnetArmResourceId = $SubnetId
                if ([string]::IsNullOrEmpty($PSBoundParameters.DelegatedSubnetArgumentSubnetArmResourceId)) {
                    $null = $PSBoundParameters.Remove('DelegatedSubnetArgumentSubnetArmResourceId')
                }
            }
            
            $Msg = 'Creating PostgreSQL server {0} in group {1}...' -f $PSBoundParameters.Name, $PSBoundParameters.resourceGroupName
            Write-Host $Msg
            $Msg = 'Your server {0} is using sku {1} (Paid Tier). Please refer to https://aka.ms/postgresql-pricing for pricing details' -f $PSBoundParameters.Name, $PSBoundParameters.SkuName
            Write-Host $Msg
            $Server = Az.PostgreSql.internal\New-AzPostgreSqlFlexibleServer @PSBoundParameters

            # Create Firewallrules
            $FirewallRuleName = CreateFirewallRule $NetworkParameters

            if (![string]::IsNullOrEmpty($FirewallRuleName)) {
                $Server.FirewallRuleName = $FirewallRuleName
            }
            $Server.SecuredPassword =  $PSBoundParameters.AdministratorLoginPassword

            return $Server
        } catch {
            throw
        }
    }
}

function CreateNetworkResource($NetworkParameters) {
    [OutputType([hashtable])]
    $WarningPreference = 'silentlycontinue'
    
    if (!(Get-Module -ListAvailable -Name Az.Network)) {
        throw 'Please install Az.Network module by entering "Install-Module -Name Az.Network"'
    }
    else {
        Import-Module -Name Az.Network
    }

    # 1. Error Handling
    # Raise error when user passes values for both parameters
    if ($NetworkParameters.Containskey('Subnet') -And $NetworkParameters.ContainsKey('PublicAccess')) {
        throw "Incorrect usage : A combination of the parameters -Subnet and -PublicAccess is invalid. Use either one of them."
    }

    # When address space parameters are passed, the only valid combination is : -Vnet -Subnet -VnetPrefix -SubnetPrefix
    if ($NetworkParameters.ContainsKey('Vnet') -Or $NetworkParameters.ContainsKey('Subnet')) {
        if (($NetworkParameters.ContainsKey('VnetPrefix') -And !$NetworkParameters.ContainsKey('SubnetPrefix')) -Or
            (!$NetworkParameters.ContainsKey('VnetPrefix') -And $NetworkParameters.ContainsKey('SubnetPrefix')) -Or 
            ($NetworkParameters.ContainsKey('VnetPrefix') -And $NetworkParameters.ContainsKey('SubnetPrefix') -And (!$NetworkParameters.ContainsKey('Vnet') -Or !$NetworkParameters.ContainsKey('Subnet')))){
                throw "Incorrect usage : -Vnet -Subnet -VnetPrefix -SubnetPrefix must be supplied together."
        }
    }
    
    #Handle Vnet, Subnet scenario
    if ($NetworkParameters.ContainsKey('Vnet') -Or $NetworkParameters.ContainsKey('Subnet')) {
        # Only the Subnet ID provided.. 
        if (!$NetworkParameters.ContainsKey('Vnet') -And $NetworkParameters.ContainsKey('Subnet')) {
            if (IsValidSubnetId $NetworkParameters.Subnet) {
                Write-Host "You have supplied a subnet Id. Verifying its existence..."
                $ParsedResult = ParseResourceId $NetworkParameters.Subnet 
                $NetworkParameters.VnetName = $ParsedResult.VnetName
                $NetworkParameters.SubnetName = $ParsedResult.SubnetName
                $NetworkParameters.ResourceGroupName = $ParsedResult.ResourceGroupName
                $SubnetFlag = $true
                try { # Valid Subnet ID is provided
                    $Subnet = Get-AzVirtualNetworkSubnetConfig -ResourceId $NetworkParameters.Subnet -ErrorAction Stop
                }
                catch { # Invalid subnet ID is provided, creating a new one.
                    $SubnetFlag = $false
                    Write-Host "The subnet doesn't exist. Creating the subnet"
                    $Subnet = CreateVnetSubnet $NetworkParameters
                }

                if ($SubnetFlag){
                    $Delegations = Get-AzDelegation -Subnet $Subnet
                    if ($null -ne $Delegations){ # Valid but incorrect delegation
                        $Delegations | ForEach-Object {if ($PSItem.ServiceName -ne $DELEGATION_SERVICE_NAME) {
                            $Msg = "Can not use subnet with existing delegations other than {0}" -f $DELEGATION_SERVICE_NAME
                            throw $Msg
                        }}
                    }
                    else { # Valid but no delegation
                        $Vnet = Get-AzVirtualNetwork -ResourceGroupName $NetworkParameters.ResourceGroupName -Name $NetworkParameters.VnetName
                        $Subnet = Get-AzVirtualNetworkSubnetConfig -Name $NetworkParameters.SubnetName -VirtualNetwork $Vnet
                        $Subnet = Add-AzDelegation -Name $DELEGATION_SERVICE_NAME -ServiceName $DELEGATION_SERVICE_NAME -Subnet $Subnet
                        $Vnet | Set-AzVirtualNetwork
                    }
                }
            }
            else {
                throw "The Subnet ID is not a valid form of resource id."
            }
        }
        elseif ($NetworkParameters.ContainsKey('Vnet') -And !$NetworkParameters.ContainsKey('Subnet')) {
            if (IsValidVnetId $NetworkParameters.Vnet){
                Write-Host "You have supplied a vnet Id. Verifying its existence..."
                IsValidRgLocation $NetworkParameters.Vnet $NetworkParameters
                $ParsedResult = ParseResourceId $NetworkParameters.Vnet 
                $NetworkParameters.VnetName = $ParsedResult.VnetName
                $NetworkParameters.SubnetName = 'Subnet' + $NetworkParameters.Name
                $Subnet = CreateVnetSubnet $NetworkParameters
            }
            elseif ($NetworkParameters.Vnet -Match $AZURE_ARMNAME) {
                Write-Host "You have supplied a vnet Name. Verifying its existence..."
                $NetworkParameters.VnetName = $NetworkParameters.Vnet
                $NetworkParameters.SubnetName = 'Subnet' + $NetworkParameters.Name
                $Subnet = CreateVnetSubnet $NetworkParameters
                IsValidRgLocation $Subnet.Id $NetworkParameters 
            }
            else {
                throw "Incorrectly formed Vnet id or Vnet name"
            }
        }
        else { # Both Vnet and Subnet provided
            if ($NetworkParameters.Vnet -Match $AZURE_ARMNAME -And $NetworkParameters.Subnet -Match $AZURE_ARMNAME) {
                $NetworkParameters.VnetName = $NetworkParameters.Vnet
                $NetworkParameters.SubnetName = $NetworkParameters.Subnet
                $Subnet = CreateVnetSubnet $NetworkParameters
            }
            else {
                if ($NetworkParameters.ContainsKey('SubnetPrefix') -And $NetworkParameters.ContainsKey('VnetPrefix')) {
                    $Msg = "If you pass an address prefix, please consider passing a name (instead of Id) for a subnet or vnet."
                }
                else { $Msg = "If you pass both --vnet and --subnet, consider passing names instead of ids." }
                throw $Msg
            }
        }
    }
    # Handling create command without arguments
    elseif (!$NetworkParameters.ContainsKey('PublicAccess') -And !$NetworkParameters.ContainsKey('Subnet') -And !$NetworkParameters.ContainsKey('Vnet')) {
        $NetworkParameters.VnetName = 'VNET' + $NetworkParameters.Name
        $NetworkParameters.SubnetName = 'Subnet' + $NetworkParameters.Name
        $NetworkParameters.VnetPrefix = $DEFAULT_VNET_PREFIX
        $NetworkParameters.SubnetPrefix = $DEFAULT_SUBNET_PREFIX

        $Subnet = CreateVnetSubnet $NetworkParameters
    }
    return $NetworkParameters
}


function GetSubnetId($ResourceGroupName, $VnetName, $SubnetName){
    if (!($ResourceGroupName -is [String])){ $ResourceGroupName = $ResourceGroupName[0]}
    $Vnet = Get-AzVirtualNetwork -Name $VnetName -ResourceGroupName $ResourceGroupName
    $Subnet = Get-AzVirtualNetworkSubnetConfig -Name $SubnetName -VirtualNetwork $Vnet
    return $Subnet.Id 
}

function CreateVnetSubnet($Parameters){
    if (!$Parameters.ContainsKey('SubnetPrefix')){$Parameters.SubnetPrefix = $DEFAULT_SUBNET_PREFIX}
    if (!$Parameters.ContainsKey('VnetPrefix')){$Parameters.VnetPrefix = $DEFAULT_VNET_PREFIX}

    try {
        Get-AzVirtualNetwork -Name $Parameters.VnetName -ResourceGroupName $Parameters.ResourceGroupName -ErrorAction Stop
        $Msg = "The provided vnet does exist."
        Write-Host $Msg
    }
    catch {
        $Msg = "Creating new vnet {0} in resource group {1}" -f $Parameters.VnetName, $Parameters.ResourceGroupName
        Write-Host $Msg
        if($PSCmdlet.ShouldProcess($Parameters.VnetName)) {
            New-AzVirtualNetwork -Name $Parameters.VnetName -ResourceGroupName $Parameters.ResourceGroupName -Location $Parameters.Location -AddressPrefix $Parameters.VnetPrefix -Force
        }
    }

    $Subnet = CreateAndDelegateSubnet $Parameters
    
    return $Subnet
}

function CreateAndDelegateSubnet($Parameters) {
    $SubnetFlag = $true
    $Vnet = Get-AzVirtualNetwork -Name $Parameters.VnetName -ResourceGroupName $Parameters.ResourceGroupName -ErrorAction Stop
    try {
        $Subnet = Get-AzVirtualNetworkSubnetConfig -VirtualNetwork $Vnet -Name $Parameters.SubnetName -ErrorAction Stop
        $Msg = "The provided subnet does exist."
        Write-Host $Msg
    }
    catch {
        $SubnetFlag = $false
        $Msg = 'Creating new subnet {0} in resource group {1} and delegating it to {2}' -f $Parameters.SubnetName, $Parameters.ResourceGroupName, $DELEGATION_SERVICE_NAME
        Write-Host $Msg
    }

    if (!$SubnetFlag) {
        $Delegation = New-AzDelegation -Name $DELEGATION_SERVICE_NAME -ServiceName $DELEGATION_SERVICE_NAME
        Add-AzVirtualNetworkSubnetConfig -Name $Parameters.SubnetName -VirtualNetwork $Vnet -AddressPrefix $Parameters.SubnetPrefix -Delegation $Delegation | Set-AzVirtualNetwork
    }
    else { # check if existing subnet is delegated
        $Delegations = Get-AzDelegation -Subnet $Subnet
        if ($null -ne $Delegations){
            $Delegations | ForEach-Object {If ($PSItem.ServiceName -ne $DELEGATION_SERVICE_NAME) {
                $Msg = "Can not use subnet with existing delegations other than {0}" -f $DELEGATION_SERVICE_NAME
                throw $Msg
            }}
        }
        else { # Valid but no delegation
            $Subnet = Add-AzDelegation -Name $DELEGATION_SERVICE_NAME -ServiceName $DELEGATION_SERVICE_NAME -Subnet $Subnet
            $Vnet | Set-AzVirtualNetwork
        }
    }

    return $Subnet
}

function CreateFirewallRule($FirewallRuleParameters) {
     if ($FirewallRuleParameters.ContainsKey('PublicAccess') -And $FirewallRuleParameters.PublicAccess.ToLower() -ne 'none') {
        $Date = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
        if ($FirewallRuleParameters.PublicAccess.ToLower() -eq 'all'){
            $StartIp = '0.0.0.0' 
            $EndIp = '255.255.255.255'
            $RuleName = "AllowAll_" + $Date 
            $FirewallRule = New-AzPostgreSqlFlexibleServerFirewallRule -Name $RuleName -ResourceGroupName $FirewallRuleParameters.ResourceGroupName -ServerName $FirewallRuleParameters.Name -EndIPAddress $EndIp -StartIPAddress $StartIp
        }
        else {
            $Parsed = $FirewallRuleParameters.PublicAccess -split "-"
            if ($Parsed.length -eq 1) {
                $StartIp = $Parsed[0]
                $EndIp = $Parsed[0]
            }
            elseif ($Parsed.length -eq 2) {
                $StartIp = $Parsed[0]
                $EndIp = $Parsed[1]
            }
            else { throw "Incorrect usage: --public-access. Acceptable values are \'all\', \'none\',\'<startIP>\' and \'<startIP>-<destinationIP>\' where startIP and destinationIP ranges from 0.0.0.0 to 255.255.255.255" }
            if ($StartIp -eq '0.0.0.0' -And $EndIp -eq '0.0.0.0') {
                $RuleName = "AllowAllAzureServicesAndResourcesWithinAzureIps_" + $Date
                $Msg = 'Configuring server firewall rule to accept connections from all Azure resources...'
            }
            elseif ($StartIP -eq $EndIP) {
                $Msg = 'Configuring server firewall rule to accept connections from ' + $StartIP 
            } 
            else {
                $Msg = 'Configuring server firewall rule to accept connections from {0} to {1}' -f $StartIP, $EndIp
                $RuleName = "FirewallIPAddress_" + $Date
            }
            Write-Host $Msg
            $FirewallRule = New-AzPostgreSqlFlexibleServerFirewallRule -Name $RuleName -ResourceGroupName $FirewallRuleParameters.ResourceGroupName -ServerName $FirewallRuleParameters.Name -EndIPAddress $EndIp -StartIPAddress $StartIp
        }
        return $FirewallRule.Name
    }
    elseif ($FirewallRuleParameters.ContainsKey('PublicAccess') -And $FirewallRuleParameters.PublicAccess.ToLower() -eq 'none') {
        Write-Host "No firewall rule was set"
    }
    
}
function IsValidVnetId($Rid){
    $VnetFormat = "\/subscriptions\/[0-9A-Fa-f]{8}-([0-9A-Fa-f]{4}-){3}[0-9A-Fa-f]{12}\/resourceGroups\/[-\w\._\(\)]+\/providers\/Microsoft.Network\/virtualNetworks\/[^<>%&:\\?/]{1,260}$"
    if ( $Rid -match $VnetFormat ) {
        return $True
    }
    return $False
}
function IsValidSubnetId($Rid){
    $SubnetFormat = "\/subscriptions\/[0-9A-Fa-f]{8}-([0-9A-Fa-f]{4}-){3}[0-9A-Fa-f]{12}\/resourceGroups/[-\w\._\(\)]+\/providers\/Microsoft.Network\/virtualNetworks\/[^<>%&:\\?/]{1,260}\/subnets\/[^<>%&:\\?/]{1,260}$"
    if ( $Rid -match $SubnetFormat ) {
        return $True
    }
    return $False
}
function ParseResourceId($Rid){
    $Splits = $Rid -split "/"
    $ParsedResults = @{}
    if ($Splits.length -gt 1){
        $ParsedResults["SubscriptionId"] = $Splits[2]
        $ParsedResults["ResourceGroupName"] = $Splits[4]
        $ParsedResults["VnetName"] = $Splits[8]
        if ($Splits.length -eq 11) {
            $ParsedResults["SubnetName"] = $Splits[10]
        }
    }
    return $ParsedResults
}
function IsValidRgLocation($ResourceId, $Parameters){
    $ParsedResults = ParseResourceId $ResourceId
    $Group = Get-AzResourceGroup -Name $ParsedResults["ResourceGroupName"]
    $ParsedResults["Location"] = $Group.Location

    if ($Parameters.SubscriptionId -eq $ParsedResults.SubscriptionId -And $Parameters.Location -eq $ParsedResults.Location) {
        return $True
    }
    throw "Incorrect Usage : The location and subscription of the server, Vnet and Subnet should be same."
}

function Get-RandomNumbers($Prefix, $Length) {
    $Generated = ""
    for($i = 0; $i -lt $Length; $i++){ $Generated += Get-Random -Maximum 10 }
    return $Prefix + $Generated
}

function Get-RandomName() {
    $Noun = Get-Content -Path (Join-Path $PSScriptRoot ".\nouns.txt") | Get-Random
    $Adjective = Get-Content -Path (Join-Path $PSScriptRoot ".\adjectives.txt") | Get-Random
    $Number = Get-Random -Maximum 10
    $RandomName =  $Adjective + (Get-Culture).TextInfo.ToTitleCase($Noun) + $Number
    return $RandomName

}

function Get-GeneratePassword() {
    $Password = ''
    $Chars = 'abcdefghiklmnoprstuvwxyzABCDEFGHKLMNOPRSTUVWXYZ1234567890'
    $SpecialChars = '!$%&/()=?}][{@#*+'
    for ($i = 0; $i -lt 10; $i++ ) { $Password += $Chars[(Get-Random -Minimum 0 -Maximum $Chars.Length)] }
    for ($i = 0; $i -lt 6; $i++ ) { $Password += $SpecialChars[(Get-Random -Minimum 0 -Maximum $SpecialChars.Length)] }
    $Password = ($Password -split '' | Sort-Object {Get-Random}) -join ''
    return $Password
}
