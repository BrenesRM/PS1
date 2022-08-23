#Allways do the process Verified Validated, if remediation is needed, then run this PS1.
#VerifiedValidatedGruposUpdate.ps1

# Import active directory module for running AD cmdlets
Import-Module ActiveDirectory
  
# Store the data from .csv in the $File variable
$File = Import-Csv E:\Scripts\GruposUpdate.csv -Delimiter ","

# Loop through each row containing user details in the CSV file
foreach ($line in $File) {

    Try
        {
    # Try to add / Descriptio, ManagedBy, Co - dueno (active roles), info (Notas, info)
        Set-ADGroup -Identity ($line.Name) -Description ($line.Description) -Passthru
        
        try
           {
           #Check if the user exist.
           Set-ADGroup -Identity ($line.Name) -ManagedBy ($line.Managedby) -Passthru 
           }
        catch
           {
           write-host "User is not in AD, is not posible update atributo Manageby, ($line.Managedby)"
           $Errortry = ($line.Name + "," + $line.Managedby + "," + $_ + ",Fecha: " + (Get-Date))
           Add-Content E:\Scripts\Error.txt -value ($Errortry)
           }
        #Set-ADGroup -Identity ($line.Name) -Replace @{extensionAttribute10=($line.'Co-Dueño')} -Passthru # Attribute in AD.
        #Set-ADGroup -Identity ($line.Name) -Replace @{edsvaSecondaryOwners=($line.'Co-Dueño')} -Passthru # edsvaSecondaryOwners this attibute is only for ActiveRoles Server.
        Set-ADGroup -Identity ($line.Name) -Replace @{info=($line.Info)} -Passthru
        Start-Sleep -s 1
        }
    Catch
        {
        # Catch any error
        Write-Host "Group updated failed, ($line.Name)"
        $Errortry = ($line.Name + "," + $_ + ",Fecha: " + (Get-Date))
        Add-Content E:\Scripts\Error.txt -value ($Errortry)
        #New-ADGroup -Name ($line.Name) -SamAccountName ($line.Name) -GroupCategory Security -GroupScope Global -DisplayName ($line.Name) -Path "OU=Usuarios por Eliminar,DC=pruebas,DC=local" -Description ($line.Description)
        }
}
