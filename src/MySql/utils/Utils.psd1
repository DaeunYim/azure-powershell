@{

# Script module or binary module file associated with this manifest.
RootModule = 'Utils.psm1'

# Assemblies that must be loaded prior to importing this module
RequiredAssemblies = 'Microsoft.Azure.PowerShell.Clients.Network.dll', 
               'Microsoft.Azure.PowerShell.Clients.ResourceManager.dll'

CmdletsToExport = 'New-AzResourceGroup'
               
}