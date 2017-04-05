function Wait-ComIE ([__ComObject]$comIExplorer){
    While($comIExplorer.Busy -eq $True){
        Start-Sleep -Milliseconds 100
    }
}

Function New-IExplorer{
    Try{
        Return New-Object -ComObject InternetExplorer.Application            
    } catch [System.__ComObject]{
        Return $_.Exeption.Message
            
    }
}

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

function Handle-IeObj{
[CmdletBinding()]
Param(
    # Essa é outra opção de Help Message
    [Parameter(Mandatory=$true,Position=0)]
    [__ComObject]$ieObj,

    # Descreve o tipo do objeto que quero encontrar
    [Parameter(Mandatory=$true)]
    [ValidateSet("Txt","Btn")]
    [string]$sObjType,

    [Parameter(Mandatory=$true)]
    [string]$sObjName,

    [string]$sFillValue

)

    Process{
        Switch($sObjType){
            Txt{
                ($ieObj.Document.getElementsByName($sObjName) | Select-Object -Unique).Value = $sFillValue
            } 
            Btn{
                ($ieObj.Document.getElementsByName($sObjName) | Select-Object -Unique).Click()
            }
        }
    }

}



$ie = New-IExplorer

$ie.Visible = $True
$ie.Navigate('https://github.com/login')

Wait-ComIE $ie

Handle-IeObj -ieObj $ie -sObjType Txt -sObjName 'login' -sFillValue "otto.gori@concrete.com.br"
Handle-IeObj -ieObj $ie -sObjType Btn -sObjName 'commit'

Export-PrintScreen -sFileName 'screen.png'

$ie.Quit()
