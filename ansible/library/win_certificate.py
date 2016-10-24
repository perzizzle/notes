#!/usr/bin/python
# -*- coding: utf-8 -*-
# This file is part of Ansible
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

# this is a windows documentation stub.  actual code lives in the .ps1
# file of the same name

DOCUMENTATION = '''
---
module: win_certificate
version_added: "2.0"
short_description: Manage windows certificates
description:
    - Manage windows certificates
options:
  state:
    description:
      - State that the certificate should become
    choices:
      - present
      - absent
  file_path:
    description:
      - Path to pfx file on local file system
    required: true
  pfx_pass:
    description:
      - Certificate password
    required: true
  thumbprint:
    description:
      - Thumb print of certificate, used to make module idempotent
    required: true
  friendly_name:
    description:
      - Friendly name for installed certificate
    required: true
  exportable:
    description:
      - Defines ability to export private key after installation
    required: true
  iis_permissions:
    description:
      - Give iis user permissions to the private key
    required: true
'''

EXAMPLES = '''
  - name: Install windows certificates
    win_certificate_store:
      state: present
      file_path: "C:\\temp\\{{ cert_name}}.pfx"
      pfx_pass: "{{ password }}"
      thumbprint: "{{ thumbprint }}"
      friendly_name: "{{ friendly_name }}"
      exportable: False
      iis_permissions: True
'''
