# Import active directory module for running AD cmdlets
Import-Module ActiveDirectory
  
# Store the data from .csv in the $File variable
$File = Import-Csv E:\Scripts\ActualizarAttibutesGroups\XXXX.csv -Delimiter ","
$ErrorPath = "E:\Scripts\ActualizarAttibutesGroups\ErrorXXXX.txt"
"Name" + ";" +  "Description"  + ";" + "ManageBy" + ";" + "Info" + ";" + "error" + ";" +  "Fecha" | Set-Content $ErrorPath

# Loop through each row containing user details in the CSV file
foreach ($line in $File) {

    Try
        {
    # Try to add / Descriptio, ManagedBy, Co - dueno (active roles), info (Notas, info)
        
        try 
        {
            Set-ADGroup -Identity ($line.Name) -Description ($line.Description) -Passthru
        }
        catch 
        {
           write-host "Description is in blank, is not posible update atributo description, ($line.Description)"
           $Errortry = ($line.Name + ";" + ($line.Description) + ";" + ($line.Managedby) + ";" + ($line.Info) + ";" + $_ + ";Fecha: " + (Get-Date))
           Add-Content ($ErrorPath) -value ($Errortry)

        }
        
        
        try
           {
           #Check if the user exist.
           
           if (($line.Managedby.Length) -gt 1) {
                Set-ADGroup -Identity ($line.Name) -ManagedBy ($line.Managedby) -Passthru
           }else {
                $Errortry = ($line.Name + ";" + ($line.Description) + ";" + "Sin Manager" + ";" + ($line.Info) + ";" + "Falta Definir el Manager" + ";Fecha: " + (Get-Date))
                Add-Content ($ErrorPath) -value ($Errortry)
           }
           }
        catch
           {
           write-host "User is not in AD, is not posible update atributo Manageby, ($line.Managedby)"
           $Errortry = ($line.Name + ";" + ($line.Description) + ";" + ($line.Managedby) + ";" + ($line.Info) + ";" + $_ + ";Fecha: " + (Get-Date))
           Add-Content ($ErrorPath) -value ($Errortry)
           }

        try 
        {
            Set-ADGroup -Identity ($line.Name) -Replace @{info=($line.Info)} -Passthru
        }
        catch 
        {
           write-host "info is in blank, is not posible update atributo info, ($line.Info)"
           $Errortry = ($line.Name + ";" + ($line.Description) + ";" + ($line.Managedby) + ";" + ($line.Info) + ";" + $_ + ";Fecha: " + (Get-Date))
           Add-Content ($ErrorPath) -value ($Errortry)

        }

        }
    Catch
        {
        # Catch any error
        Write-Host "Group updated failed, ($line.Name)"
        $Errortry = ($line.Name + ";" + ($line.Description) + ";" + ($line.Managedby) + ";" + ($line.Info) + ";" + $_ + ";Fecha: " + (Get-Date))
        Add-Content ($ErrorPath) -value ($Errortry)
        }
}
