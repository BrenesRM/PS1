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
           Set-ADGroup -Identity ($line.Name) -ManagedBy ($line.Managedby) -Passthru #Check if the user exist.
           }
        catch
           {
           write-host "User is not in AD, is not posible update atributo Manageby, ($line.Managedby)"
           Add-Content E:\Scripts\Error.txt ("Updating attribute ManagedBy is failed, in the group name:",$line.Name,$line.Managedby,$_)
           }
        #Set-ADGroup -Identity ($line.Name) -Replace @{edsvaSecondaryOwners=($line.'Co-Dueño')} -Passthru # edsvaSecondaryOwners this attibute is only for ActiveRoles Server.
        Set-ADGroup -Identity ($line.Name) -Replace @{info=($line.Info)} -Passthru
        Start-Sleep -s 1
        }
    Catch
        {
        # Catch any error
        Write-Host "Group updated failed, ($line.Name)"
        Add-Content E:\Scripts\Error.txt ("Update group in AD is failed, in the group name:",$line.Name,$_)
        #New-ADGroup -Name ($line.Name) -SamAccountName ($line.Name) -GroupCategory Security -GroupScope Global -DisplayName ($line.Name) -Path "OU=Usuarios por Eliminar,DC=pruebas,DC=local" -Description ($line.Description)
        }
}