<#
.SYNOPSIS
    Print Screen function
.DESCRIPTION
    Simples Powershell function to capture the screen
.PARAMETER sSavePath
    The directory in which you desire to save your file (will be verified using Test-Path)
.PARAMETER sFileName
    Specifies the file name you desire
.EXAMPLE
    Export-PrintScreen -sFileName "print.png"
.EXAMPLE
    Export-PrintScreen -sSavePath $HOME -sFileName "print.png"
.NOTES
    Author: Otto Gori
    Date:   03/2017    
#>
function Export-PrintScreen{
param(
    [Parameter(
        Position=0
    )]
    [ValidateScript(
        {Test-Path $_ -PathType Container}
    )][string]$sSavePath = $HOME,

    [Parameter(
        Mandatory=$True, 
        Position=1,
        HelpMessage="Chose your file name"
    )][string]$sFileName

)
    process{
        $infoMonitor =  [System.Windows.Forms.SystemInformation]::PrimaryMonitorSize

        $comBounds = [Drawing.Rectangle]::FromLTRB(0, 0, $infoMonitor.Width, $infoMonitor.Height)

        $bmpImage = New-Object Drawing.Bitmap $comBounds.width, $comBounds.height

        $comGraphics = [Drawing.Graphics]::FromImage($bmpImage)

        $comGraphics.CopyFromScreen($comBounds.Location, [Drawing.Point]::Empty, $comBounds.size)

        $bmpImage.Save($sSavePath+'\'+$sFileName)

        $comGraphics.Dispose()
        $bmpImage.Dispose()
    
    }
}

Export-ModuleMember -function Export-PrintScreen