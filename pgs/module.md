~~~powershell
    Install-Module Chewbacca-Says 'Hrrrghghh Graaannngg'
~~~

[|Módulo|](https://educacao.uol.com.br/disciplinas/matematica/modulo-ou-valor-absoluto-calculando-o-modulo.htm) no mundo Posh é um conjunto de funcionalidades agrupadas numa unidade que lhe convém. Agrupando uma boa quantia de scripts, assemblies, recursos e afins, você consegue compartilhar e reutilizar seu código com muito mais facilidade que em muitas outras linguagens ou frameworks.

A principal função dos módulos é permitir modularização (Leia a fraze anterior de novo caso deseje que seu QI baixe alguns pontos) e abstação de código Posh.

Para criar um módulo PS, basta salvar seu arquivo com a extensão ".psm1".

>Só?

Sim...

Fazendo isso, você ganha controle sobre escopo (publico, privado, etc) sobre as funções e variáveis que estão em seu código. E a partir daqui você pode importar o módulo utilizando o comando que está no topo desta página, fazendo de seu módulo um dos tijolos de uma grande solução.

Uma breve introdução aos módulos ja foi feita no texto de apresentação do Powershell. Lembrando, eles se dividem em:
[Script Module](https://msdn.microsoft.com/en-us/library/dd878340(v=vs.85).aspx).
[Binary Module](https://msdn.microsoft.com/en-us/library/dd878342(v=vs.85).aspx).
[Module Manifest](https://msdn.microsoft.com/en-us/library/dd878337(v=vs.85).aspx). 

Seremos um pouco mais incisivos sobre o que compreende um Script Module, pois ele quem se encaixa em nossa POC. Transformaremos a função `Export-PrintScreen` num módulo e a importaremos em nossa solução de automação.

Falando um pouco mais sobre oque será nosso módulo e oque pode ser um módulo, normalmente nos preocupamos com as seguintes premissas:
1. Um módulo é um conjunto de código e/ou um conjunto de controladores para assemblies.
2. Tudo que o código acima necessite, tais como assemblies adicionais, arquivos de ajuda ou outros scripts.
3. Um manifesto que descreva o módulo
4. Um diretório que contenha todo oque foi listado acima e está localizado num local onde o Posh pode encontrá-lo.

>Note que na verdade, nenhum dos item acima é obrigatório. Por exemplo, você pode desejar ter um script simples que foi armazenado como um .psm1 ou um manifesto que está utilizando como ferramenta de organização, você pode também ter um módulo que cria suas dependencias dinamicamente, sem ter a necesidade de um diretório que as guarde...

Bom...vamos lá.

O primeiro passo é externar o código de nossa função para um arquivo apartado e salvar este arquivo com a extensão ".psm1". No caso uso o nome "Print-Screen.psm1" para nossa brincadeira.

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

Como esse módulo só contem uma função, a mesma poderia estar exposta, entretanto por padrão, expomos exatamente os pontos que desejamos expor no final do código.

~~~powershell
    export-modulemember -function Export-PrintScreen
~~~

>Você também pode restringir os acessos usando [manifestos](https://msdn.microsoft.com/en-us/library/dd878337(v=vs.85).aspx). Se houver alguma dependencia nesse módulo, ela deve ser declarada no início com uma linha semelhante a que temos no topo desta página: `Import-Module Lord-Vader -MinimumVersion 'RogueOne'`, por fim, se ainda houver alguma dependencia (Ex: Arquivo XML), está também pode ser controlada usando um manifesto.

Para usarmos o módulo, devemos posicioná-lo em um dos caminhos default que o PS pode ver. Você pode obter um desses valores com este comando: `$env:PSModulePath`. Por convençao podemos usar: `%SystemRoot%\users\<user>\Documents\WindowsPowerShell\Modules\<moduleName>`.

Agora basta importarmos o módulo com o comando: `Import-Module Print-Screen` no inicio de nosso código original, e usar sua função normalmente.

>Você também pode fazer isso por meio de dotSourcing `.\Print-Screen`, mas essa não é uma boa opção quando se pensa em escalabilidade ou usabilidade...afinal, se o módulo não estiver no exato diretório que esperava, isso não vai funcionar.

Com o módulo importado, basta chamar suas funções normalmente como se fossem nativas ao sistema.
Existem situações que você tem dois módulos com funções de mesmo nome, para mitigar isso costumamos "Tipar" a chamada com o nome do módulo, em nosso caso fica `Print-Screen\Export-PrintScreen -sSavePath $HOME -sFileName "print.png"` ou seja, isso é um "From<MODULE>\Call<Function> [-Args-]"

>Lembre de sempre remover o módulo ao final de seu uso para não deixar [sujeira na memoria](https://img1.ibxk.com.br/2012/3/materias/52348152015113625.jpg?w=700)

Em nossa proxima brincadeira vamos fazer algumas funções com recursos avançados [MODULO 4 - AVANÇADO](./adv.md)