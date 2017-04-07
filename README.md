[Power](https://www.youtube.com/watch?v=XLmMh4DYQC4)shell
============


~~~powershell
<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>
function Verb-Noun{
[CmdletBinding()]
[Alias()]
[OutputType([int])]
Param(
    # Param1 help description
    [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true, Position=0)]$Param1,

    # Param2 help description
    [int]$Param2
)
    Begin{
            #Make parameters Valid
    }
    Process{
            #Forge Knives and stuff
    }
    End{
            #Go home and have a beer
    }
}

~~~

Isto acima é o powershell, pra quem nunca viu =)

Decidi fazer deste, um post de introdução ao framework Powershell e um pouco de seu ecossistema.
Mais a frente aprofundarei seus módulos, funcionalidades e darei alguns exemplos reais. Por hora somente um overview.

Esse post tem diversos links, recomendo que acesse eles ao longo da leitura para melhor entendimento...(Inclusive acho que você ja deixou passar um que está escondido no título deste post)...Entretanto, esse post é dividido em quatro módulos - sendo o total deste post o primeiro "módulo" que compreende a introdução da ferramenta numa forma mais "leve" e com um pouco de história (minha e do powershell) embutida. E outros três módulos (serão destacados por links mais abaixo) que descrevem mais profundamente o como escrever código em powershell, sendo que a ordem destes segue uma metodologia que normalmente eu sigo ao codificar alguma solução/ferramenta em powershell ou em quaquer outra linguagem.

Tudo isso será melhor explicado ao longo deste primeiro post.

Para aqueles que já tem alguma (mesmo que breve) experiência em powershell ou na plataforma .NET, ler separadamente os módulos é uma opção palpável. Cada um dos módulos abrange o seu "nicho" e somente ele!. Ainda assim, recomendo para quem nunca teve contato com a plataforma que leia todo este módulo acessando os links ao decorrer da leitura do mesmo, desta forma o entendimento será mais claro para você leitor que nunca teve contato com a ferramenta.

>Ha também o fato de que eu gosto de distribuir alguns "easter eggs" pelo caminho, assim a experiência de leitura fica mais divertida. 

Primeiro um pequeno trecho de História... O que seria de um Ferreiro lvl 13 (Str 12; Sta 6; Int 10; Res 9; Cha 12; Wis 10; Wil 5; Ft 7) se ele não contasse as historias de suas Quests e experiencias além das magias que aprendeu a realizar com powershell desde muitas luas atrás? 

>Por "um pouco de história", eu gostaria de brevemente mostrar o que senti ao ter contato com powershell, o porquê este desempenhou uma função importante em minha carreira, e também mostrar brevemente o PS e o que ele pode fazer por você.

Powershell sem dúvida é hoje minha escolha clara para resolver quaisquer problemas que eu encontro pelo caminho (ando tendo um affair com python, mas é recente). Mas por que?...Bom...O powershell (a partir daqui chamado carinhosamente pelo seu nick ["**Posh**"](http://www.drogariaminasbrasil.com.br/media/catalog/product/cache/5/image/0dc2d03fe217f8c83829496872af24a0/c/h/chicletes_poosh_arcor_tutti_frutti_7g_40660.jpg), ou pela sigla ["**PS**"](https://pt.wikipedia.org/wiki/PS), que na definição do wikipedia pode ser "O Script que você escreve depois"{Post scriptum}, "PostScript", "O código TLD (ccTLD) na Internet para a Palestina" ou o objeto favorito do [Yudi](http://i.imgur.com/SyDl08m.jpg)).É uma linguagem extremamente flexível, inteligível e modular, ainda assim sem deixar de ser simples e rápida/leve...Sem dúvida uma das ferramentas mais fortes que a filha do titiu Gates (Binomial Microsoft CORP ou Master Race {o choro é livre}) criou ate hoje e uma das que mais cresceu desde seu lançamento.

Voltada para a montagem de scripts poderosos e com os recursos da plataforma .NET e ainda, permite que o desenvolvedor rapidamente entregue soluções complexas com poucas linhas de código e inclusive abrangendo soluções que necessitem resolver paradigmas de orientação. Abaixo um exemplo CtrlJ de "classe simples".

~~~powershell
class TypeName{
   # Property with validate set
   [ValidateSet("val1", "Val2")][string] $P1

   # Static property
   static [hashtable] $P2

   # Hidden property does not show as result of Get-Member
   hidden [int] $P3

   # Constructor
   TypeName ([string] $s){
       $this.P1 = $s       
   }

   # Static method
   static [void] MemberMethod1([hashtable] $h){
       [TypeName]::P2 = $h
   }

   # Instance method
   [int] MemberMethod2([int] $i){
       $this.P3 = $i
       return $this.P3
   }
}

~~~ 

Todo e qualquer procedimento, função e aproach feito em powershell segue padrões de nomenclatura (titio Gates e seus padrões...) e parametrização descritos [**aqui**](https://msdn.microsoft.com/en-us/library/ms714428(v=vs.85).aspx). Funciona basicamente assim: Você precisa de uma função que copia um item? O nome dela é simples: `Copy-Item`. Quer uma que apaga um item? : `Remove-Item`. Quer uma que importe um arquivo CSV? `Import-CSV`... E assim vai... Essa estrutura "Verb-Noun" faz com que qualquer pessoa, até mesmo as com conhecimento muito breve em programação, esteja prontamente apta a interpretar um código/script escrito em Posh e compreenda facilmente o que ele faz.

A comunidade adere fortemente a estes conceitos, então temos um crescimento muito sólido e controlado.

Lembra daquela pesquisa no [ss64](https://ss64.com/bash/) sobre qual o significado/função do comando [Lorem_ipsum](https://pt.wikipedia.org/wiki/Lorem_ipsum)? Lembra aquela dúvida na sequência dos atributos? Se é com hífen simples ou duplo, se é maiúsculo ou minúsculo, se está na ordem certa ou combinação correta?

Ou chamadas de funções escritas desta forma: `:(){:|:&};:`

![](./imgs/wut.png)

... Lembra aquela vez que você executou um comando e ele fez uma coisa que você NÃO queria, erro justamente causado por uma ou a combinação das dúvidas listadas acima? 

![](./imgs/feel.jpg)

... Aqui [não!](https://www.youtube.com/watch?v=JncgoPKklVE)... leia o comando e você saberá o que ele faz!

>Isso faz com que a curva de aprendizado em Posh seja muito acelerada! Rapidamente o jovem guerreiro viking está apto a desfrutar as batalhas acompanhado de seu fiel machado ... Digo ... Rapidamente o desenvolvedor consegue aproveitar amplamente as funcionalidades e facilidades que o powershell pode lhe entregar. 

Com uma base sólida nas libs .NET, o Posh vem ao ecossistema MS para ser a ferramenta base para **automação e gestão de configuração** da plataforma Microsoft. 
>Notou algum ressalte ao nosso mundo de DevOps pelo texto hachurado acima? 

Sendo o posh um framework para automação de tarefas e gerenciamento de configuração, que fornece total controle aos: [COM](https://msdn.microsoft.com/en-us/library/windows/desktop/ms690343(v=vs.85).aspx), [WMI](https://msdn.microsoft.com/en-us/library/aa394582(v=vs.85).aspx) e [CIMs](https://en.wikipedia.org/wiki/Common_Information_Model_(computing)) para os Linux Peasants. 

>Uma diferença legal do Posh para com as demais "command-line interfaces" é que o Posh foi feito para manusear objetos. Toda informação é um encapsulamento de propriedades/métodos/etc que você pode usar, não é somente texto sendo exibido na tela.

Temos também o recente [DSC](https://msdn.microsoft.com/pt-br/powershell/dsc/overview) para realizar o "Desired State Configuration". 

Com uma forte base nas estruturas: [Script Module](https://msdn.microsoft.com/en-us/library/dd878340(v=vs.85).aspx), [Binary Module](https://msdn.microsoft.com/en-us/library/dd878342(v=vs.85).aspx) e [Module Manifest](https://msdn.microsoft.com/en-us/library/dd878337(v=vs.85).aspx). 

Temos também notorias contribuições da comunidade [Posh-Ssh](https://github.com/darkoperator/Posh-SSH). E um amplo material disponível numa linguagem fácil de entender e escrita numa forma muito amigável [techNet](https://technet.microsoft.com/pt-br/) pelo meu querido [Ed](https://social.technet.microsoft.com/wiki/contents/articles/33421.rsa-with-powershell-powerrsa.aspx) ... 

Como o Powershell é uma linguagem extremamente bem descrita, fica muito fácil encontrar ajuda em sites especializados [Copy-Item](https://msdn.microsoft.com/en-us/powershell/reference/5.1/microsoft.powershell.management/copy-item) com exemplos de todos os casos de uso, e ainda contando cum uma comunidade forte [Developer Network](https://msdn.microsoft.com/en-us/powershell). Meios os quais até hoje nunca deixaram de sanar qualquer dúvida que eu tive, e olha que já foram muitas.

Pouco tempo atrás, o Posh tornou-se multiplataforma e Open Source (Ago/2016) e juntamente as parcerias entre a Microsoft e a RedHat.

[Windows Love Linux](http://blogs.technet.microsoft.com/windowsserver/2015/05/06/microsoft-loves-linux/)

[RedHat Love Azure](http://azure.microsoft.com/pt-br/campaigns/redhat/)

[RedHat Strategic Alliance](http://www.redhat.com/pt-br/partners/strategic-alliance/microsoft)

Posh torna-se (com certeza) uma coisa a se prestar atenção e dedicar um tempo de aprendizado.

Hoje (03/2017) em sua versão do [wmf 5.1](https://blogs.msdn.microsoft.com/powershell/2017/01/19/windows-management-framework-wmf-5-1-released/) o Powershell traz cada vez mais funcionalidade e mais poder ao seu leque de ferramentas

Funciona muito bem como ferramenta de gestão para [Azure](https://docs.microsoft.com/en-us/powershell/azureps-cmdlets-docs/) e [Server Cores](https://msdn.microsoft.com/pt-br/library/jj574205(v=ws.11).aspx) e tem suporte nativo a ferramentas uteis como [Docker](https://github.com/Microsoft/Docker-PowerShell) e outras.

Para trabalhar com powershell, basicamente o que você precisa ter é seu Windows atualizado (ou [Linux](https://github.com/PowerShell/PowerShell)), pois todas suas dependências já estão nativas no SO. Você vai se deparar com a [ISE](https://msdn.microsoft.com/pt-br/powershell/scripting/core-powershell/ise/introducing-the-windows-powershell-ise) ou com a Console. Caso tenha curiosidade, esses são os [system-requirements](https://msdn.microsoft.com/en-us/powershell/scripting/setup/windows-powershell-system-requirements) 

Eventualmente também gosto de usar o [Visual Studio Code](https://github.com/Microsoft/vscode) para meus scripts, porém sempre dou preferência a trabalhar com ferramentas nativas e sem dependências (não gosto de depender/baixar/configurar alguma coisa para poder trabalhar, isso tem muito a ver com agilidade), por isso me mantendo na ISE e Console somente. Até porque, elas sinceramente funcionam muito bem. A Intellisense é rápida, clara e não há inconsistências de funcionamento. Importar (e criar) módulos é bem fácil (te dou 5 segundos para pensar qual será o conjunto de "Verb-Noun" que IMPORTA um MÓDULO no powershell - E aposto o último pedaço da pizza que você acerta). 

Por fim, após editar um script na ISE, sua execução e dupuração é bem rápida e facilitada.

>Aqui termina o "Um pouco de história", vamos agora sujar um pouco as mãos!

Bom... Vamos então aos aprofundamentos seguindo a metodologia que citei laaaaa em cima. Existem "dois grandes mundos" em que o Posh te ajuda muito, o primeiro é como uma ferramenta de gestão de seu sistema, e o segundo é como uma ferramenta de automação, vou discorrer um pouco aqui sobre o segundo. 

Primeiro: Vamos pensar numa POC de automação?...Digamos que após um deployment eu precise atestar uma funcionalidade básica da aplicação que acabou de ser instalada, então vamos supor que eu precise somente abrir uma página web e logar na aplicação.

Vamos lá.

A primeira coisa a se pensar é o caminho "straightforward" ou "direto" dessa execução. Então digamos um script que crie um COM do Explorer, navegue até a página "X", identifique os objetos de login e senha, complete-os e aperte o botão "login". Esse Script é descrito neste módulo: [MODULO 1 - SCRIPT](pgs/sc.md). Neste módulo, vou descrever brevemente a sintaxe do powershell, seu set-up e realizar essa POC citada acima.

A segunda coisa é fazer com que esse código seja mais reutilizável, então deixaremos de ter um script "travado" que só execute aquilo para ter um conjunto de funções que eu possa chamar a meu bel sabor. Isso será abordado neste módulo [MODULO 2 - FUNÇÕES](pgs/fnc.md)

A terceira ação é modularizar nosso código, para atingirmos uma maior escalabilidade, controle, abstração e aumentando ainda mais o reúso de nosso código [MODULO 3 - MÓDULOS](pgs/module.md)

A quarta ação é fazer com que esse código possa ser carregado por outro, transformando-o em um "powershell module" e também trazendo algum usos de funções avançada, modularização e criando uma estrutura que permite que esse código seja mais portável ainda, podendo então ser utilizado em qualquer necessidade de nossa POC. Isso será abordado em nosso [MODULO 4 - AVANÇADO](pgs/adv.md) 

![](./imgs/masterraceApproved.gif)

~~~Powershell
Write-Host "po-po-po-po-power!"
~~~


    



