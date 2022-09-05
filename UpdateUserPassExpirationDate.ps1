# Import active directory module for running AD cmdlets
Import-Module ActiveDirectory
  
# Store the data from .csv in the $File variable
$File = Import-Csv E:\SCRIPTS\MultiAccion\usuariosAD.csv -Delimiter ","
$ErrorPath = "E:\SCRIPTS\MultiAccion\ErrorusuariosAD.csv"
"Name" + "," +  "Dominio"  + "," + "Accion" + "," + "Nota" + ","  + "Pass"+ ","  + "NuevaFecha"+ ","  + "Error" + "," + "Fecha" | Set-Content $ErrorPath

$domain = Get-ComputerInfo | select csdomain
$domain = $domain.csdomain

#Funtion for Set the objects in the AD
Function Set-Pass {
    
    try {
        Set-ADAccountPassword -Identity ($line.nombre) -Reset -NewPassword (ConvertTo-SecureString -AsPlainText ($line.Pass) -Force)
        Set-ADUser -Identity ($line.nombre) -ChangePasswordAtLogon $true
        $InfoAD = Get-ADUser -Identity ($line.nombre) -properties * | select info
        $InfoAD = $InfoAD.info += ","
        $InfoAD = $InfoAD + $line.nota
        Set-ADUser -Identity ($line.nombre) -Replace @{info=($InfoAD)} -Passthru

        $lineaArchivo = (($line.nombre) + "," + ($line.dominio) + "," + ($line.accion) + "," + ($line.nota) + "," + ($line.Pass) + "," + ($line.NueFecha) + ",SinErrores" + "," + (Get-Date)) 
        Add-Content $ErrorPath -value ($lineaArchivo)
        Write-Host $line.nombre, $line.accion

   }
   catch { 
        $lineaArchivo = (($line.nombre) + "," + ($line.dominio) + "," + ($line.accion) + "," + ($line.nota) + "," + ($line.Pass) + "," + ($line.NueFecha) + "," + $_ + "," + (Get-Date)) 
        Add-Content $ErrorPath -value ($lineaArchivo)
   }
}

Function Set-Expira {
    
    
    try {
        Set-ADAccountExpiration -Identity ($line.nombre) -DateTime ($line.NueFecha)
        $InfoAD = Get-ADUser -Identity ($line.nombre) -properties * | select info
        $InfoAD = $InfoAD.info += ","
        $InfoAD = $InfoAD + $line.nota
        Set-ADUser -Identity ($line.nombre) -Replace @{info=($InfoAD)} -Passthru

        $lineaArchivo = (($line.nombre) + "," + ($line.dominio) + "," + ($line.accion) + "," + ($line.nota) + "," + ($line.Pass) + "," + ($line.NueFecha) + ",SinErrores" + "," + (Get-Date)) 
        Add-Content $ErrorPath -value ($lineaArchivo)
        Write-Host $line.nombre, $line.accion

   }
   catch { 
        $lineaArchivo = (($line.nombre) + "," + ($line.dominio) + "," + ($line.accion) + "," + ($line.nota) + "," + ($line.Pass) + "," + ($line.NueFecha) + "," + $_ + "," + (Get-Date)) 
        Add-Content $ErrorPath -value ($lineaArchivo)
        Write-Host $line.nombre, $line.accion
   }
}

# Loop through each row containing user details in the CSV file
foreach ($line in $File) {


    Try
        {
        # Try to add / Descriptio, ManagedBy, Co - dueno (active roles), info (Notas, info)
        if ($line.dominio -eq $domain) {
            if ($line.accion -eq "caco"){
                Set-Pass ($line.Name, $line.nota, $line.Pass)
                Write-Host "Set-Pass"
            }
            else {
                Set-Expira ($line.Name, $line.NueFecha)
                Write-Host "Set-Expira"
            }
            
        }

        }
    Catch
        {
        # Catch any error
        $lineaArchivo = (($line.nombre) + "," + ($line.dominio) + "," + ($line.accion) + "," + ($line.nota) + "," + ($line.Pass) + "," + ($line.NueFecha) + "," + $_ + "," + (Get-Date)) 
        Add-Content $ErrorPath -value ($lineaArchivo)
        }
}