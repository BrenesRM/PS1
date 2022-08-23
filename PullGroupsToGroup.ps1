# Import active directory module for running AD cmdlets
Import-Module ActiveDirectory
  
# Store the data from .csv in the $File variable
$File = Import-Csv E:\Scripts\GruposUpdate.csv -Delimiter ","

# Loop through each row containing user details in the CSV file
foreach ($line in $File) {

    Try
        {
    # Try to add / Descriptio, ManagedBy, Co - dueno (active roles), info (Notas, info)
        Add-ADGroupMember -Identity GruposADesprovicionar -Members ($line.Name)
        Start-Sleep -s 1
        }
    Catch
        {
        # Catch any error
        Write-Host "Adding Group failed, ($line.Name)"
        $Errortry = ($line.Name + "," + $_ + ",Fecha: " + (Get-Date))
        Add-Content E:\Scripts\Error.txt -value ($Errortry)
        }
}