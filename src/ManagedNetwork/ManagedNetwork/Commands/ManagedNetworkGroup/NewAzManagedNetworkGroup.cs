﻿using System.Management.Automation;
using Microsoft.Azure.Commands.ManagedNetwork.Common;
using Microsoft.Azure.Commands.ManagedNetwork.Helpers;
using Microsoft.Azure.Management.ManagedNetwork;
using System.Linq;
using Microsoft.Azure.Commands.ResourceManager.Common.ArgumentCompleters;
using Microsoft.Azure.Management.ManagedNetwork.Models;
using System.Collections.Generic;
using Microsoft.Azure.Commands.ManagedNetwork.Models;
using System.Resources;
using System.Collections;
using Microsoft.Azure.Management.Internal.Resources.Utilities.Models;

namespace Microsoft.Azure.Commands.ManagedNetwork
{
    /// <summary>
    /// New Azure InputObject Command-let
    /// </summary>
    [Cmdlet(VerbsCommon.New, "AzManagedNetworkGroup", SupportsShouldProcess = true, DefaultParameterSetName = Constants.NameParameterSet)]
    [OutputType(typeof(PSManagedNetwork))]
    public class NewAzManagedNetworkGroup : AzureManagedNetworkCmdletBase
    {
        /// <summary>
        /// Gets or sets The Resource Group name
        /// </summary>
        [Parameter(Position = 0, 
            Mandatory = true, 
            HelpMessage = Constants.ResourceGroupNameHelp,
            ParameterSetName = Constants.NameParameterSet)]
        [ValidateNotNullOrEmpty]
        [ResourceGroupCompleter]
        public string ResourceGroupName { get; set; }

        [Parameter(Position = 1, 
            Mandatory = true, 
            HelpMessage = Constants.ManagedNetworkNameHelp,
            ParameterSetName = Constants.NameParameterSet)]
        [ValidateNotNullOrEmpty]
        public string ManagedNetworkName { get; set; }

        [Parameter(Position = 2, 
            Mandatory = true, 
            HelpMessage = Constants.ManagedNetworkGroupNameHelp,
            ParameterSetName = Constants.NameParameterSet)]
        [Parameter(Mandatory = true,
            HelpMessage = Constants.ManagedNetworkGroupNameHelp,
            ParameterSetName = Constants.ManagedNetworkObjectParameterSet)]
        [ValidateNotNullOrEmpty]
        public string Name { get; set; }

        [Parameter(Mandatory = true,
            HelpMessage = Constants.ManagedNetworkObjectHelp,
            ValueFromPipeline = true,
            ParameterSetName = Constants.ManagedNetworkObjectParameterSet)]
        [ValidateNotNullOrEmpty]
        public PSManagedNetwork ManagedNetworkObject { get; set; }

        [Parameter(Mandatory = true, HelpMessage = Constants.ManagedNetworkLocationHelp)]
        [ValidateNotNullOrEmpty]
        [LocationCompleter("Microsoft.ManagedNetwork/managedNetworks")]
        public string Location { get; set; }

        [Parameter(Mandatory = false, HelpMessage = "Azure ManagedNetwork management group ids.")]
        public List<string> ManagementGroupIdList { get; set; }

        [Parameter(Mandatory = false, HelpMessage = "Azure ManagedNetwork subscription ids.")]
        public List<string> SubscriptionIdList { get; set; }

        [Parameter(Mandatory = false, HelpMessage = "Azure ManagedNetwork virtual network ids.")]
        public List<string> VirtualNetworkIdList { get; set; }

        [Parameter(Mandatory = false, HelpMessage = "Azure ManagedNetwork subnet ids.")]
        public List<string> SubnetIdList { get; set; }

        /// <summary>
        ///     The AsJob parameter to run in the background.
        /// </summary>
        [Parameter(Mandatory = false, HelpMessage = Constants.ForceHelp)]
        public SwitchParameter Force { get; set; }

        /// <summary>
        ///     The AsJob parameter to run in the background.
        /// </summary>
        [Parameter(Mandatory = false, HelpMessage = Constants.AsJobHelp)]
        public SwitchParameter AsJob { get; set; }

        public override void ExecuteCmdlet()
        {
            base.ExecuteCmdlet();

            if (string.Equals(
                    this.ParameterSetName,
                    Constants.ManagedNetworkObjectParameterSet))
            {
                var resourceIdentifier = new ResourceIdentifier(this.ManagedNetworkObject.Id);
                this.ResourceGroupName = resourceIdentifier.ResourceGroupName;
                this.ManagedNetworkName = resourceIdentifier.ResourceName;
            }

            var present = IsManagedNetworkGroupPresent(ResourceGroupName, ManagedNetworkName, Name);
            ConfirmAction(
                Force.IsPresent,
                string.Format(Constants.ConfirmOverwriteResource, Name),
                Constants.CreatingResource,
                Name,
                () =>
                {
                    PSManagedNetworkGroup managedNetworkGroup = CreateManagedNetworkGroup();
                    WriteObject(managedNetworkGroup);
                },
                () => present);
        }

        private PSManagedNetworkGroup CreateManagedNetworkGroup()
        {
            PSManagedNetworkGroup psManagedNetworkGroup = new PSManagedNetworkGroup();
            if (this.ManagementGroupIdList != null)
            {
                psManagedNetworkGroup.ManagementGroups = this.ManagementGroupIdList.Select(id => new PSResourceId() { Id = id }).ToList();
            }

            if (this.SubscriptionIdList != null)
            {
                psManagedNetworkGroup.Subscriptions = this.SubscriptionIdList.Select(id => new PSResourceId() { Id = id }).ToList();
            }

            if (this.VirtualNetworkIdList != null)
            {
                psManagedNetworkGroup.VirtualNetworks = this.VirtualNetworkIdList.Select(id => new PSResourceId() { Id = id }).ToList();
            }

            if (this.SubnetIdList != null)
            {
                psManagedNetworkGroup.Subnets = this.SubnetIdList.Select(id => new PSResourceId() { Id = id }).ToList();
            }

            var sdkManagedNetworkGroup = ManagedNetworkResourceManagerProfile.Mapper.Map<ManagedNetworkGroup>(psManagedNetworkGroup);
            sdkManagedNetworkGroup.Location = this.Location;
            var putSdkResponse = this.ManagedNetworkManagementClient.ManagedNetworkGroups.CreateOrUpdate(sdkManagedNetworkGroup, this.ResourceGroupName, this.ManagedNetworkName, this.Name);
            var putPSResponse = ManagedNetworkResourceManagerProfile.Mapper.Map<PSManagedNetworkGroup>(putSdkResponse);
            return putPSResponse;
        }
    }
}
