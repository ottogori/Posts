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
Mais a frente aprofundarei seus módulos, funcionalidades e darei alguns exemplos reais, por hora somente um overview.

Esse post tem diversos links, recomendo que acesse eles ao longo da leitura para melhor entendimento... Entretanto, esse post é dividido em quatro modulos - sendo o total deste post o primeiro módulo que compreende a introdução da ferramenta numa forma mais "leve" e com um pouco de história (minha e do powershell) embutida. E outros três módulos (serão destacados por links mais abaixo) que descrevem mais profundamente o como escrever código em powershell, sendo que a ordem destes segue uma metodologia que normalmente eu sigo ao codificar alguma solução/ferramenta em powershell ou em quaquer outra linguagem.

Tudo isso será melhor explicado ao longo deste primeiro post.

Para aqueles que já tem alguma (mesmo que breve) experiencia em powershell ou na plataforma .NET, ler separadamente os módulos é uma opção. Cada um dos módulos abrange o seu "nicho" e somente ele. Ainda assim, recomendo para quem nunca teve contato com a plataforma que leia este módulo acessando os links ao decorrer do mesmo, desta forma o entendimento será mais claro para você leitor que nunca teve contato com a ferramenta.

>Ha também o fato de que eu gosto de distribuir alguns "easter eggs" pelo caminho, assim a experiência de leitura fica mais divertida. 

Primeiro um pequeno trecho de História... Que seria de um Ferreiro lvl 13 (Str 12; Sta 6; Int 10; Res 9; Cha 12; Wis 10; Wil 5; Ft 7) se ele não contasse as historias de suas Quests e experiencias além das magias que aprendeu a realizar com powershell desde muitas luas atrás? 

>Por "um pouco de história", eu gostaria de brevemente mostrar o que senti ao ter contato com powershell e o porque este desempenhou uma função importante em minha carreira, e também mostrar brevemente o PS e o que pode fazer por você.

Powershell sem dúvida é hoje minha escolha clara para resolver quaisquer problemas que eu encontro pelo caminho (ando tendo um affair com python, mas é recente)....Mas porque?...Bom...O powershell (A partir daqui chamado carinhosamente pelo seu nick ["**Posh**"](http://www.drogariaminasbrasil.com.br/media/catalog/product/cache/5/image/0dc2d03fe217f8c83829496872af24a0/c/h/chicletes_poosh_arcor_tutti_frutti_7g_40660.jpg)) é uma linguagem extremamente flexível, inteligível e modular, ainda assim sem deixar de ser simples e rápida/leve...Sem dúvida uma das ferramentas mais fortes que a filha do titiu Gates (Binomial Microsoft CORP ou MS ou Master Race {o choro é livre}) criou ate hoje e uma das que mais cresceu desde seu lançamento.

Voltada para a montagem de scripts poderosos e com os recursos da plataforma .NET, permite que o desenvolvedor rapidamente entregue soluções complexas com poucas linhas de código e inclusive abrangendo soluções que necessitem  resolver paradigmas de orientação. Abaixo um exemplo de CtrlJ de classe simples.

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

Todo e qualquer procedimento, função e aproach feito em powershell segue padrões de nomenclatura (Titiu Gates e seus padrões...) e parametrização descritos [**aqui**](https://msdn.microsoft.com/en-us/library/ms714428(v=vs.85).aspx) ... Funciona basicamente assim: Você precisa de uma função que copia um item? o nome dela é simples: `Copy-Item`. Quer uma que apaga um item? : `Remove-Item`. Quer uma que importe um arquivo CSV? `Import-CSV`... e assim vai... Essa estrutura "Verb-Noun" faz com que qualquer pessoa, até mesmo as com conhecimento muito breve em programação esteja prontamente apta a interpretar um código/script escrito em Posh e compreenda facilmente oque ele faz.

A comunidade adere fortemente a estes conceitos, estão temos um crescimento muito solido e controlado.

Lembra daquela pesquisa no [ss64](https://ss64.com/bash/) sobre qual o significado/função do comando [Lorem_ipsum](https://pt.wikipedia.org/wiki/Lorem_ipsum)? Lembra aquela duvida na sequencia dos atributos? se é com hífem simples ou duplo, se é maiúsculo ou minusculo, se está na ordem certa ou combinação correta...

Ou chamadas de funções escritas desta forma: `:(){:|:&};:`

![](./imgs/wut.png)

...lembra aquela vez que você executou um comando e ele fez uma coisa que você NÃO queria, erro justamente causado por uma ou a combinação das duvidas listadas acima? 

![](./imgs/feel.jpg)

... aqui [não!](https://www.youtube.com/watch?v=JncgoPKklVE)... leia o comando e você saberá oque ele faz!

>Isso faz com que a curva de aprendizado em Posh seja muito acelerada! Rapidamente o jovem guerreiro viking está apto a desfrutar as batalhas acompanhado de seu fiel machado ... digo ... rapidamente o desenvolvedor consegue aproveitar amplamente as funcionalidades e facilidades que o powershell pode lhe entregar. 

Com uma base solida nas libs .NET, o Posh vem ao ecossistema MS para ser a ferramenta base para **automação e gestão de configuração** da plataforma Microsoft. 
>Notou algum ressalte ao nosso mundo de DevOps pelo texto hachurado acima? 
Hoje ela ja é muito mais que isso.

Sendo ele um framework para automação de tarefas e gerenciamento de configuração, o Posh fornece total controle aos: [COM](https://msdn.microsoft.com/en-us/library/windows/desktop/ms690343(v=vs.85).aspx), [WMI](https://msdn.microsoft.com/en-us/library/aa394582(v=vs.85).aspx) e [CIMs](https://en.wikipedia.org/wiki/Common_Information_Model_(computing)) Para os Linux Peasants. 

>Uma diferença legal do posh para com as demais "command-line interfaces" é que o posh foi feito para manusear objetos. Toda informação é um encapsulamento de propriedades/metodos/etc que você pode usar, não é somente texto sendo exibido na tela.

Temos também o recente [DSC](https://msdn.microsoft.com/pt-br/powershell/dsc/overview) Para realizar o "Desired State Configuration". 

Com uma forte base nas estruturas: [Script Module](https://msdn.microsoft.com/en-us/library/dd878340(v=vs.85).aspx), [Binary Module](https://msdn.microsoft.com/en-us/library/dd878342(v=vs.85).aspx) e [Module Manifest](https://msdn.microsoft.com/en-us/library/dd878337(v=vs.85).aspx). 

Temos também notorias contribuições da comunidade [Posh-Ssh](https://github.com/darkoperator/Posh-SSH) 

E um amplo material disponivel numa linguagem facil de entender e escrita numa forma muito amigavel [techNet](https://technet.microsoft.com/pt-br/) pelo meu querido [Ed](https://social.technet.microsoft.com/wiki/contents/articles/33421.rsa-with-powershell-powerrsa.aspx) ... 

Como o Powershell é uma linguagem extremamente bem descrita, fica muito facil encontrar ajuda em sites especializados [Copy-Item](https://msdn.microsoft.com/en-us/powershell/reference/5.1/microsoft.powershell.management/copy-item) com exemplos de todos os casos de uso, e ainda contando cum uma comunidade forte [Developer Network](https://msdn.microsoft.com/en-us/powershell) ... 

Meios os quais até hoje nunca deixaram de sanar qualquer duvida que eu tive, e olha que ja foram muitas.

Pouco tempo atrás o Posh se tornou-se multiplataforma e open source (ago/2016) e juntamente as parcerias entre a Microsoft e a RedHat 

[Windows Love Linux](httPosh://blogs.technet.microsoft.com/windowsserver/2015/05/06/microsoft-loves-linux/) - - -

[RedHat Love Azure](httPosh://azure.microsoft.com/pt-br/campaigns/redhat/) - - -

[RedHat Strategic Alliance](httPosh://www.redhat.com/pt-br/partners/strategic-alliance/microsoft) ---

Posh torna-se (com certeza) uma coisa a se prestar atenção e dedicar um tempo de aprendizado.

Hoje (03/2017) em sua versão do [wmf 5.1](https://blogs.msdn.microsoft.com/powershell/2017/01/19/windows-management-framework-wmf-5-1-released/) o Powershell traz cada vez mais funcionalidade e mais poder ao seu leque de ferramentas

Funciona muito bem como ferramenta de gestão para [Azure](https://docs.microsoft.com/en-us/powershell/azureps-cmdlets-docs/) e [Server Cores](https://msdn.microsoft.com/pt-br/library/jj574205(v=ws.11).aspx) e tem suporte nativo a ferramentas uteis como [Docker](https://github.com/Microsoft/Docker-PowerShell) e outras.

Para trabalhar com powershell, basicamente oque você precisa ter é seu windows atualizado (Ou [Linux](https://github.com/PowerShell/PowerShell)), pois todas suas dependencias ja estão nativas no SO. Você vai se deparar com a [ISE](https://msdn.microsoft.com/pt-br/powershell/scripting/core-powershell/ise/introducing-the-windows-powershell-ise) ou com a Console. Caso tenha curiosidade, esses são os [system-requirements](https://msdn.microsoft.com/en-us/powershell/scripting/setup/windows-powershell-system-requirements) 

Eventualmente também gosto de usar o [Visual Studio Code](https://github.com/Microsoft/vscode) para meus scripts, porém sempre dou preferencia para trabalhar com ferramentas nativas e sem dependências (não gosto de depender/baixar/configurar alguma coisa para poder trabalhar - isso tem muito a ver com agilidade), por isso me mantendo na ISE e Console somente. Até porque, elas sinceramente funcionam muito bem...A Intellisense é rápida e clara e não ha inconsistências de funcionamento. Importar modulos é bem facil (Te dou 5 segundos para pensar qual será o conjunto de "Verb-Noun" que IMPORTA um MODULO no powershell - E aposto o ultimo pedaço da pizza que você acerta). 

Por fim, após editar um script na ISE, sua execução e dupuração é bem rapida e facilitada.

>Aqui termina o "Um pouco de hitória", vamos agora sujar um pouco as mãos

Bom...vamos então aos aprofundamentos seguindo a metodologia que citei laaaaa em cima. Existem "dois grandes mundos" em que o Posh te ajuda muito, o primeiro é como uma ferramenta de gestão de seu sistema, e o segundo é como uma ferramenta de automação, vou discorrer um pouco aqui sobre o segundo. 

Primeiro: Vamos pensar numa POC de automação?...Digamos que após um deployment eu precise atestar uma funcionalidade basica da aplicação "deployada", então vamos supor que eu precise somente abrir uma pagina web e logar na aplicação.

Vamos la.

A primeira coisa a se pensar é o caminho "straightforward" ou "direto" dessa execução, então digamos um script que crie um COM do Explorer, navegue até a pagina, identifique os objetos de login e senha, complete-os e aperte o botão "login". Esse Script é descrito neste módulo: [MODULO 1 - SCRIPT](script/sc.md) - Neste módulo, vou descrever brevemente a sintaxe do powershell, seu set-up e realizar essa POC citada acima.

A segunda coisa é fazer com que esse código seja mais reutilizável, então deixaremos de ter um script "travado" que só execute aquilo para ter um conjunto de funções que eu possa chamar a meu bel sabor. Isso será abordado neste módulo [MODULO 2 - FUNÇÕES](function/fnc.md)

A terceira ação é fazer com que esse código possa ser carregado por outro, transformando-o em um "powershell module" e também trazendo algum usos de funções avançada, modularização e criando uma estrutura que permite que esse código seja mais portavel ainda, podendo então ser utilizado em qualquer necessidade de nossa POC. Isso será abordado em nosso [MODULO 3 - AVANÇADO](advFunction/adv.md) 

![](./imgs/masterraceApproved.gif)

~~~Powershell
Write-Host "po-po-po-po-power!"
~~~


    



