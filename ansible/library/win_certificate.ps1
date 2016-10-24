#!powershell
# This file is part of Ansible
#
# Copyright 2016, Michael Perzel <michaelperzel@gmail.com>
#
# Ansible is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Ansible is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Ansible.  If not, see <http://www.gnu.org/licenses/>.

# WANT_JSON
# POWERSHELL_COMMON

$params = Parse-Args $args;

$result = New-Object psobject @{
    changed = $false
    msg = ""
};

$state = Get-AnsibleParam -obj $params -name "state" -ValidateSet "present","absent" -resultobj $result -failifempty $true
$file_path = Get-Attr $params "file_path" -failifempty $true
$pfx_pass = Get-Attr $params "pfx_pass" -failifempty $true
$thumbprint = Get-Attr $params "thumbprint" -failifempty $true
$friendly_name = Get-Attr $params "friendly_name" -failifempty $true
$exportable = Get-Attr $params "exportable" -failifempty $true | ConvertTo-Bool
$iis_permissions = Get-Attr $params "iis_permissions" -failifempty $true | ConvertTo-Bool

# state not currently used, would be used for deleting certificates

if (Test-Path Cert:\LocalMachine\my\$thumbprint ) {
    $result.msg = "Certificate is already installed"
    Exit-Json $result
}
else {
    $pfx = new-object System.Security.Cryptography.X509Certificates.X509Certificate2

    if (!(Test-Path $file_path)) {
        Fail-Json $result "Unable to locate certificate $file_path"
    }

    $securePass = ConvertTo-SecureString -AsPlainText -Force $pfx_pass
    if ($exportable) {
        $pfx.import($file_path,$securePass,"exportable,PersistKeySet,MachineKeySet")
    } else {
        $pfx.import($file_path,$securePass,"PersistKeySet,MachineKeySet")
    }

    if ($friendly_name) {
        $pfx.FriendlyName = $friendly_name
    }

    $store = new-object System.Security.Cryptography.X509Certificates.X509Store("My","LocalMachine")
    $store.open("MaxAllowed")
    $store.add($pfx)
    $store.close()
    $result.changed=$true

    if ( $iis_permissions ){
        $cert = get-item Cert:\LocalMachine\my\$thumbprint
        $rsaName = $cert.PrivateKey.CspKeyContainerInfo.UniqueKeyContainerName
        if(!$rsaname){
            Fail-Json $result "Rsa name is undefined, unable to set IIS user permissions"
        }

        $keyPath = "C:\ProgramData\Microsoft\Crypto\RSA\MachineKeys\" + $rsaName
        $acl = (Get-Item $keyPath).GetAccessControl('Access')
        # Create new acl rule
        $accessRule=new-object System.Security.AccessControl.FileSystemAccessRule "IIS_IUSRS", "FullControl", "Allow"
        $acl.AddAccessRule($accessRule)

        try
        {
            Set-Acl $keyPath $acl
        }
        catch
        {
            Fail-Json $result "Error: unable to set ACL on certificate."
        }
    }
    
$result.msg = "Certificate installed"
Exit-Json $result
}
