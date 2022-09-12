#Transforma la jpg a Base64
[Convert]::ToBase64String((Get-Content -Path D:\1.jpg -Encoding Byte)) >> capture.txt

#La pasa a jpg
$Base64 = Get-Content -Raw -Path D:\capture.txt
$Image = [Drawing.Bitmap]::FromStream([IO.MemoryStream][Convert]::FromBase64String($Base64))
$Image.Save("D:\capture.jpg")