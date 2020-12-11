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
Get the connection string according to client connection provider.
.Description
Get the connection string according to client connection provider.
#>
function Get-AzPostgreSqlFlexibleServerConnectionString {
    [OutputType([System.String])]
    [CmdletBinding(DefaultParameterSetName='Get', PositionalBinding=$false)]
    [Microsoft.Azure.PowerShell.Cmdlets.PostgreSql.Description('Get the connection string according to client connection provider.')]
    param(
        [Parameter(ParameterSetName='Get', Mandatory, HelpMessage = 'The name of the server.')]
        [Alias('ServerName')]
        [Microsoft.Azure.PowerShell.Cmdlets.PostgreSql.Category('Path')]
        [System.String]
        ${Name},

        [Parameter(ParameterSetName='Get', Mandatory,  HelpMessage = 'The name of the resource group that contains the resource, You can obtain this value from the Azure Resource Manager API or the portal.')]
        [Microsoft.Azure.PowerShell.Cmdlets.PostgreSql.Category('Path')]
        [System.String]
        ${ResourceGroupName},

        [Parameter(ParameterSetName='Get', HelpMessage='The subscription ID that identifies an Azure subscription.')]
        [Microsoft.Azure.PowerShell.Cmdlets.PostgreSql.Category('Path')]
        [Microsoft.Azure.PowerShell.Cmdlets.PostgreSql.Runtime.DefaultInfo(Script='(Get-AzContext).Subscription.Id')]
        [System.String]
        ${SubscriptionId},

        [Parameter(Mandatory, HelpMessage = 'Client connection provider.')]
        [Microsoft.Azure.PowerShell.Cmdlets.PostgreSql.Category('Path')]
        [Validateset('ADO.NET', 'C++', 'JDBC', 'Node.js', 'PHP', 'psql', 'Python', 'Ruby')]
        [System.String]
        ${Client},

        [Parameter(HelpMessage = 'The credentials, account, tenant, and subscription used for communication with Azure.')]
        [Alias('AzureRMContext', 'AzureCredential')]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.PostgreSql.Category('Azure')]
        [System.Management.Automation.PSObject]
        ${DefaultProfile},

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
        $null = $PSBoundParameters.Remove('Client')
        $postgreSql = Az.PostgreSql\Get-AzPostgreSqlFlexibleServer @PSBoundParameters
        $DBHost = $postgreSql.FullyQualifiedDomainName
        $DBPort = 5432
        $adminName = $postgreSql.AdministratorLogin
        
        $ConnectionStringMap = @{
            'ADO.NET' = "Server=${DBHost};Database={your_database};Port=${DBPort};User Id=${adminName};Password={your_password};"
            'C++' = "host=${DBHost} port=${DBPort} dbname={your_database} user=${adminName} password={your_password}"
            'JDBC' = "jdbc:postgresql://${DBHost}:${DBPort}/{your_database}?user=${adminName}&password={your_password}&"
            'Node.js' = "host=${DBHost} port=${DBPort} dbname={your_database} user=${adminName} password={your_password}"
            'PHP' = "host=${DBHost} port=${DBPort} dbname={your_database} user=${adminName} password={your_password}"
            'psql' = "psql ""host=${DBHost} port=${DBPort} dbname={your_database} user=${adminName} password={your_password}"""
            'Python' = "dbname='{your_database}' user='${adminName}' host='${DBHost}' password='{your_password}' port='${DBPort}'"
            'Ruby' = "host=${DBHost}; dbname={your_database} user=${adminName} password={your_password} port=${DBPort}"
        }
        return $ConnectionStringMap[$Client]
    }
}

