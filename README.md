# win-acme-powerdns

Custom script that you can use with [win-acme](https://www.win-acme.com/) to validate domains with a DNS challenge on a PowerDNS server using the PowerDNS API.

## Before using
* Create a new API key in PowerDNS and make sure it has correct access to the zone you want to validate. It has to be able to add and remove TXT records.

* You will need to edit the script to point to the correct PowerDNS server and to use the correct API key.

## To use:
1. Download the script somewhere convenient and note the path
2. Start win-acme and create a new certificate. Enter the domain name
3. Choose the following challenge: `[dns-01] Create verification records with your own script`
4. Enter the path you noted in step 1
5. Choose to use the same script for both creation and deletion.
6. For `DnsCreateScriptArguments` enter the following
```
-Action create -ZoneName {ZoneName} -RecordName {RecordName} -Token {Token}
```
7. For `DnsDeleteScriptArguments` enter the following
```
-Action delete  -ZoneName {ZoneName} -RecordName {RecordName}
```
8. Choose `Run everything one by one`
9. Follow the rest of the steps according to your own use-case / preference

