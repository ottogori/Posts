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
