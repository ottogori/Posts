Digamos que você se depara com o seguinte script:

~~~powershell
    $ie = New-Object -ComObject InternetExplorer.Application
    $ie.Visible = $True

    $ie.Navigate('https://github.com/login')

    While($ie.Busy -eq $True){
        Start-Sleep -Milliseconds 100
    }

    ($ie.Document.getElementsByName("login") | Select-Object -Unique).Value = "otto.gori@concrete.com.br"

    ($ie.Document.getElementsByName("commit") | Select-Object -Unique).Click()

    While($ie.Busy -eq $True){
        Start-Sleep -Milliseconds 100
    }

    $monitor =  [System.Windows.Forms.SystemInformation]::PrimaryMonitorSize

    $bounds = [Drawing.Rectangle]::FromLTRB(0, 0, $monitor.Width, $monitor.Height)

    $bmp = New-Object Drawing.Bitmap $bounds.width, $bounds.height

    $graphics = [Drawing.Graphics]::FromImage($bmp)

    $graphics.CopyFromScreen($bounds.Location, [Drawing.Point]::Empty, $bounds.size)

    $bmp.Save("$HOME\print.png")

    $graphics.Dispose()
    $bmp.Dispose()

    Invoke-Item "$HOME\print.png"

    $ie.Quit()
~~~

Notoriamente ha oque melhorar, certo? Vamos então listar os pontos de melhoria para guiar nosso "code refactor":

1. Ha trechos de chamadas repetidas, esses podem ser transformados em funções.
2. Esse script executa SOMENTE isso...não ha reutilização para nenhum dos pedaços contidos nele.
3. Ha hardcoding em alguns pontos
4. Não ha um padrão claro de nomenclatura para as variáveis

Vamos resolver por etapas? 

Etapa 1 : criar funções para remover a repetição de chamadas dentro do código.

A primeira que me vem em mente é a mais simples:

~~~powershell
    While($ie.Busy -eq $True){
        Start-Sleep -Milliseconds 100
    }
~~~

Existem varias formas de escrever - corretamente - funções no Posh, basicamente gosto de dividir em 3 grupos ("simples", "funções" e "funções avançadas"). Explico-as:

1. "Funções simples" são funções que julgo não ter a necessidade de um emprego enorme de esforço, não queremos matar um formiga com um um lana chamas né Hanz? 
2. "Funções" são trechos de código que julgo necessitarem de um pouco mais de cuidado, por exemplo: Validar o tipo de um parametro antes de iniciar a execução, validar se esse parametro está dentro de oque eu espero; Tratar possiveis erros de execução; Verificar se alguma dependencia está previamente carregada antes de começar a execução; Etc....
3. "Funções avançadas" além de uma estrutura do Posh é também aquilo que eu chamo de uma ferramenta extremamente polida e não passivel de falha. Essas funções demandam um esforço e conhecimento bem maior tanto de codificação quanto de boas praticas e também da estrutura de funcionamento do Powershell

Lembro, tu, leitor que é importante seguir as convenções de nomenclatura que podem ser encontradas aqui:[Verb-Noun](https://msdn.microsoft.com/en-us/library/ms714428(v=vs.85).aspx)

Como essa nossa megera funçãozinha só executa um sleep, vou mante-la como algo simples e acreditar que a pessoa que a invocar sabe oque está fazendo.

>Nota do diabinho sentado ombro esquerdo do Editor: Sempre acredite na capacidade humana de fazer coisas boas, mas sempre tenha em mente a capacidade humana de fazer caquinha.

Temos então:

~~~powershell
    function Wait-ComIE ([__ComObject]$comIExplorer){
        While($comIExplorer.Busy -eq $True){
            Start-Sleep -Milliseconds 100
        }
    }
~~~

Outro trecho que pode ser escrito numa função simples é a ação de criar o Objeto Internet Explorer. Incluí um "try/catch" aqui imaginando a possibilidade de o IE não estar habilitado no SO executor, e porque assim ja apresento essa estrutura a vocês. Fica assim:

~~~powershell
    Function New-IExplorer{
        Try{
            Return New-Object -ComObject InternetExplorer.Application            
        } catch [System.__ComObject]{
            Return $_.Exeption.Message            
        }
    }
~~~

O ultimo trecho nessa iteração de nosso refactor que será transformado em função é a execução do "Print Screen", esse vou brincar um pouco mais com a função para mostrar algumas coisas para vocês. Ela ficou assim:

~~~powershell
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
~~~

A primeira coisa a reparar é o bloco de comentário no inicio. Na verdade não são comentarios e sim epecificações desta função. Isso faz com que quem for usar essa função possa executar um `Get-Help Export-PrintScreen` e receba essa descrição

~~~powershell
    PS C:\Users\ottog> Get-Help Export-PrintScreen

    NAME
        Export-PrintScreen
        
    SYNOPSIS
        Print Screen function
         
    SYNTAX
        Export-PrintScreen [[-sSavePath] <String>] [-sFileName] <String> [<CommonParameters>]
        
    DESCRIPTION
        Simples Powershell function to capture the screen
        

    RELATED LINKS

    REMARKS
        To see the examples, type: "get-help Export-PrintScreen -examples".
        For more information, type: "get-help Export-PrintScreen -detailed".
        For technical information, type: "get-help Export-PrintScreen -full".
~~~

Ou `Get-Help Export-PrintScreen -Exeples`

~~~powershell
    PS C:\Users\ottog> Get-Help Export-PrintScreen -Examples

    NAME
        Export-PrintScreen
        
    SYNOPSIS
        Print Screen function    
        
        -------------------------- EXAMPLE 1 --------------------------
        
        PS C:\>Export-PrintScreen -sFileName "print.png"
        
        -------------------------- EXAMPLE 2 --------------------------
        
        PS C:\>Export-PrintScreen -sSavePath $HOME -sFileName "print.png"
~~~

A segunda coisa a reparar é o bloco de validação de parametros. Observe que o parametro `$sSavePath` [de posição Zero] é validado como um diretório que existe e "setado" para $HOME como default caso o usuário não espessifique nenhum outro. O parametro `$sFileName` [de posição 1] é o único obrigatório e tem uma mensagem de ajuda. que pode ser obtida com o comando `Get-Help Export-PrintScreen -Parameter sFileName`

~~~powershell
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
~~~

Por fim o bloco de execução em si, que recebeu padrão na nomenclatura (seguindo as recomendações oficiais), não está mais Hard Coded e foi incluído num bloco `process` que é um "início" do ciclo de vida avançado de uma função Posh.

~~~powershell
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
~~~

>Ufa...ja fizemos bastante coisa, tem só mais um pouquinho, prometo.

O proximo passo é criar uma função para encontrar os elementos dentro do Internet Explorer. Mapeei dois comportamentos de nossas ações na pagina, o primeiro é preencher um valor e o segundo é clicar num botão.

>Vou aproveitar e montar uma estrutura de case/switch, aqui, para exemplificar seu uso.

~~~powershell

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

~~~

Observe um novo tipo de validação de parametro chamado "Validate Set" - Isso faz com que ao chamar essa função por linha de comando, um comboBox SOMENTE com essas opções seja exibido, qualquer outro valor não será aceito.

>ACABOU - É TRETRAAAA

Esse é o resultado do código:

~~~powershell
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
[Alias()]
[OutputType([int])]
Param(
    # Param1 help description
    [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]$ieObj,

    # Param2 help description
    [ValidateSet("Txt","Btn")][string]$sObjType,
    [string]$sObjName,
    [ValidateSet("FillValue","Click")][string]$sObjAction,
    [string]$sFillValue

)
    Process{
        Switch($sObjType){
            Txt{
                ($ieObj.Document.getElementsByName($sObjName) | Select-Object -Unique).Value = $sFillValue
            } Btn{
                ($ieObj.Document.getElementsByName($sObjName) | Select-Object -Unique).Click()
            }
        }
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
~~~

E sua chamada pode ser feita pela linha de comando

~~~powershell
    $ie = New-IExplorer
    $ie.Visible = $True
    $ie.Navigate('https://github.com/login')

    Wait-ComIE $ie

    Handle-IeObj -ieObj $ie -sObjType Txt -sObjName 'login' -sFillValue "otto.gori@concrete.com.br"
    Handle-IeObj -ieObj $ie -sObjType Btn -sObjName 'commit'

    Export-PrintScreen -sFileName 'screen.png'

    $ie.Quit()
~~~

Muito Bem! Temos agora um script mais flexível e reutilizável. Claro, ele ainda pode ser melhorado! Vamos brincar um pouco com essas melhorias aqui: [MODULO 3 - AVANÇADO](../advFunction/adv.md)