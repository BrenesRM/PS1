Function GeneratePassword {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline=$false)]
            [ValidateRange(1,256)]
            [int]$PWLength = 16,
        [Parameter(ValueFromPipeline=$false)]
            [char[]]$CharSet1 = 'abcdefghiklmnoprstuvwxyz'.ToCharArray(),
        [Parameter(ValueFromPipeline=$false)]
            [char[]]$CharSet2 = 'ABCDEFGHKLMNOPRSTUVWXYZ'.ToCharArray(),
        [Parameter(ValueFromPipeline=$false)]
            [char[]]$CharSet3 = '1234567890'.ToCharArray(),
        [Parameter(ValueFromPipeline=$false)]
            [char[]]$CharSet4 = '!"$%&/()=?}][{@#*+'.ToCharArray(),
        [Parameter(ValueFromPipeline=$false)]
            [ValidateRange(0,256)]
            [int]$Set1Num = 8,
        [Parameter(ValueFromPipeline=$false)]
            [ValidateRange(0,256)]
            [int]$Set2Num = 3,
        [Parameter(ValueFromPipeline=$false)]
            [ValidateRange(0,256)]
            [int]$Set3Num = 2,
        [Parameter(ValueFromPipeline=$false)]
            [ValidateRange(0,256)]
            [int]$Set4Num = 3
    )

        $password =  $CharSet1 | Get-Random -Count $Set1Num
        $password += $CharSet2 | Get-Random -Count $Set2Num
        $password += $CharSet3 | Get-Random -Count $Set3Num
        $password += $CharSet4 | Get-Random -Count $Set4Num

        Write-Verbose "Initial password: $(-join $password)"

        $Password = -join ($password | Get-Random -Count $PWLength)

        Write-Verbose "Final   password: $Password"

        Write-Output $password
}


$LcAlpha = 'abcdefghiklmnoprstuvwxyz'.ToCharArray()
$UcAlpha = 'ABCDEFGHKLMNOPRSTUVWXYZ'.ToCharArray()
$Numbers = '1234567890'.ToCharArray()
$NonAlphaNum = '!"$%&/()=?}][{@#*+'.ToCharArray()

# 8 character password, 5 lower-case, 1 upper-case, 1 digit, 1 punctuation
#GeneratePassword -Verbose 8 $LcAlpha $UcAlpha $Numbers $NonAlphaNum 5 1 1 1

# 16 character password, 8 lower-case, 3 upper-case, 2 digit, 3 punctuation
GeneratePassword -Verbose
