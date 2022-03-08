# <h1 align="center">![logo](https://i.imgur.com/kpTFQOp.png)</h1>

<h1 align="center">IMPORTANT - READ EVERYTHING!</h1>
<h3 align="center">
  Este texto está disponível em português e inglês.
  Para ler em português, apenas continue.
</h3>
<h3 align="center">
  This text is available in portuguese and english.
  To read in english, scroll all the way down.
</h3>
<h1># PORTUGUÊS - PORTUGUESE</h1> 
Bem-vindo ao primeiro protótipo público do jogo de space shooter 2D, ou bullet hell, chamado "VIRUS HAVOC!".

Como foi dito, isto é apenas um PROTÓTIPO. Este jogo está muito, mas MUITO incompleto. Tanto em questões técnicas (programação, design, sistemas, etc.) e em questões conceituais e artísticas (níveis, inimigos, história, etc.), e ainda contém bugs.

Se esse jogo vai ser continuado ou não, depende bastante dos feedbacks, ideias e conceitos que tiver com o tempo.

A lore desse jogo é resumidamente, sobre um cobaia enviado pela NASA para salvar a internet de um ataque de vírus enorme de origem desconhecida.

Pode soar clichê ou meio maluco, mas a lore não está completa ainda.

(OBS: ESTE JOGO NÃO TEM ABSOLUTAMENTE NADA A VER COM COVID-19 E A PANDEMIA. TANTO QUE O JOGO FOI CRIADO ANTES DO VÍRUS SEQUER TER CHEGADO NO MEU PAÍS. FOI TUDO UMA COINCIDÊNCIA, EU JURO.)

Agora, vamos falar sobre as instruções do jogo, as mecânicas e o conteúdo que o jogo tem a oferecer:

MENU:
No canto esquerdo superior, tem a lista de níveis. Tem 2 níveis disponíveis pra jogar.
Também há 2 caixas para marcar: Uma de começar bossfight ao entrar em um nível, e outra de habilitar o idioma em inglês. O nível 2 não há nenhum boss, então se você marcar a primeira opção, nada vai acontecer.
No canto esquerdo inferior, tem a Gún-Dex. Isso vai ser explicado na próxima seção.
No canto direito inferior, tem o botão de mods, que é uma feature que pretendo implementar, mas não está implementado ainda.
GÚN-DEX:
A lista de armas que você pode usar no jogo. Tem 2 slots de armas disponíveis, então você só pode carregar até 2 armas ao mesmo tempo. E tem apenas 5 armas no jogo. Cada arma tem seu nome, descrição e danos únicos:

Arma Laser Comum: Dá 1 de dano
Arma Laser de Canhão Duplo: dá 1 de dano EM CADA BALA.
Arma Laser Dupla Diagonal: dá um dano aleatório entre 1, 1.5 e 2.
Arma Lançadora de Bombas: Dá um dano aleatório entre 2, 3 e 4.
Arma Laser Arco-Íris sem canhão: Dá 2 de dano em cada bala, porém é uma bala com cooldown.
Originalmente, era para todas as armas estarem bloqueadas exceto a Arma Laser Comum. As armas seriam desbloqueadas conforme você vai pegando as "Loot Boxes" nos níveis, que será explicado melhor em uma outra seção.

CONTROLES:
Mover jogador: WASD ou setinhas.
Atirar: Aperta Espaço ou Enter (pode ser o Enter da esquerda ou o da direita, tanto faz).
Trocar de arma: Aperta Q para mudar para o primeiro slot. Tecla E para mudar para o segundo slot.
NÍVEL 1:
O nível usa um sistema de ondas. O nível no total tem 10 ondas. Cada onda tem uma quantidade fixa de vírus, e a partir da onda número 7, os vírus começam a ficar indo e voltando do centro.
Na onda número 4, irá aparecer uma Loot Box (depois irei falar com mais detalhes o que é), e também irá aparecer na onda número 7 (somente se você não pegou a primeira loot box). Depois de passar das 10 ondas, irá começar a luta com o boss. Você irá vencer o nível se você derrotar o boss. As armas que forem pegas no nível 1 não serão salvas.
OBS: O nível 1 foi feito para jogar somente com as seguintes armas: Arma Laser Comum, Arma Laser de Canhão Duplo e Arma Laser Dupla Diagonal. Usar qualquer arma que não seja dessas, estará fora do balanceamento do nível 1.
NÍVEL 2:
Tem três inimigos: o avião de papel bombardeador, a pasta atiradora e a lixeira spammadora. Os dois primeiros tem 6 de vida. O avião atira uma .zip bomb, que pode dar entre 1-2 de dano no jogador e nos inimigos. Já a pasta atiradora, ela atira arquivos em sua direção. Dá apenas 1 de dano. A lixeira mira em você por um tempo e então atira um raio de papéis representando um spam, e depois some, e é imortal.

LOOT BOXES:
São caixas que contém uma arma aleatória, dependendo do nível que você for jogar. Tem 75% de chance de aparecer em uma fase, dependendo de em qual momento exatamente a loot box aparece. Se você já tiver pego a loot box antes em uma fase, ela não aparecerá novamente até que você renicie a fase.
No nível 1, as loot boxes geram duas armas que são escolhidas aleatoriamente: Arma Laser de Canhão Duplo, e Arma Laser Dupla Diagonal.
Originalmente, era para desbloquear a(s) arma(s) que você pegou logo quando você pega as loot boxes e consegue chegar até o fim do nível.
CORAÇÕES:
São pickups simples que recuperam entre 1 e 2 de HP ao coletar. Eles são dropados dos vírus (inimigos) com uma chance determinada por ele, que geralmente é 75% de chance.

Agora, vamos falar sobre o que realmente pretendo fazer com o jogo, a história do desenvolvimento, e esclarecer algumas coisas.
Este jogo está em desenvolvimento desde Abril de 2020. O jogo no início era pra ser bem simples, mas conforme o tempo foi passando, fui tendo mais e mais idéias para o jogo. Para você ter uma idéia de quão simples o jogo realmente era pra ser na época, veja o meu jogo Gilbreto e a Encomienda Roubada, que é outro jogo que eu fiz sem muito motivo, e é um exemplo de um jogo extremamente simples.

Durante esse meio tempo do desenvolvimento, a engine utilizada foi trocada algumas vezes, códigos foram reescritos muitas vezes. O jogo era pra ser feito no Unity quando o desenvolvimento começou. Mas na época, eu não sabia nada sobre essa engine e muito menos programação por texto. Naquela época eu tava acostumado a usar engines com scripting visual como Clickteam Fusion ou Construct 2. Foi com o Construct 2 que o jogo estava sendo desenvolvido, e teve uma época que havia trocado pro HaxeFlixel, mas odiei. E hoje em dia estou usando Godot Engine, que é na minha opinião, a melhor engine que existe.

Este jogo, na verdade, estava fechado para apenas as pessoas que eu quiser que possa testar, que era chamado de uma versão antecipada. Mas mudei de ideia, e decidi fazer o jogo, que agora virou um protótipo público, para poder ganhar mais feedback e ver se vale a pena continuar com esse jogo ou não, ou ter pelo menos um caminho mais claro em como continuar com este jogo.

Eu decidi deixar este jogo disponível ao público, pois o desenvolvimento infelizmente ficou "preso", devido a falta de ideias, e de que o jogo aparenta estar bagunçado em todos os sentidos, tanto conceituamente quanto tecnicamente. Então achei que seria uma boa ideia deixar o jogo disponível ao público.

Antes estava fazendo o jogo ser privado pra fazer meio que uma espécie de "surpresa" para todo mundo, mas essa ideia estava errada desde o ínicio.

Aliás, eu pretendo deixar o jogo ser gratuito e de código aberto. Fiz essa decisão para deixar o jogo acessível e poder contribuir junto com a comunidade. E você já está aqui! Você também pode visitar a página do itch.io aqui: https://pvini-games.itch.io/virus-havoc

Sobre a música utilizada neste jogo: TODAS AS MÚSICAS SÃO ORIGINAIS E FEITAS PARA ESTE JOGO. Não são músicas retiradas de sites tipo YouTube, Soundcloud ou sites de músicas copyright-free. ESTAS MÚSICAS NÃO EXISTEM EM LUGAR NENHUM EXCETO NESTE JOGO. Elas foram feitas por um amigo meu, chamado "²He", ou "Helium". Eu também fiz protótipos de músicas, mas ele fez todo o trabalho pra mim.

Você pode, é claro, usar as músicas desse jogo como quiser. Seja pra enviar no YouTube ou algo assim, ou usar em algum tipo de meme funny, você está livre pra isso, DESDE QUE DÊ CRÉDITOS. Se você usar as músicas desse jogo sem deixar nenhum tipo de crédito ou fonte, principalmente se usar as músicas como se ela fosse SUA, CRIADA POR VOCÊ, consequências podem emergir.

Agora, quero falar sobre as coisas que ainda pretendo implementar no jogo:
Todos os níveis deviam estar bloqueados exceto pelo primeiro, e o próximo nível só seria desbloqueado após completar o anterior.
Cada nível deve ter uma gameplay e temática diferente, para fazer o jogo ser mais diverso e não enjoar.
Adicionar uma loja de armas, e usar criptomoedas como a moeda do jogo para comprar as armas, sendo utilizado como uma outra forma de obter novas armas além de loot boxes. A forma de como obter essas criptomoedas ainda não está 100% definido. (NÃO SÃO CRIPTOMOEDAS DE VERDADE. PELO AMOR DE DEUS, ISSO NÃO É UM JOGO NFT. E NEM PRETENDO ADICIONAR MICROTRANSAÇÕES.)
Adicionar armas "tematizadas", ou seja, armas que fazem referência a algum jogo/série/livro existente. Exemplo: Adicionar a "arma do Pico do Newgrounds" no jogo. Provavelmente a única forma de obter elas seria pela loja, ou por easter eggs escondidos.
Adicionar suporte oficial a modding, ou seja, poder adicionar novos níveis, inimigos, armas, etc. Sem precisar obter e modificar a source code do jogo.
Enfim... É isso! Espero que você goste do jogo. Eu sei que o jogo está bem incompleto, mas saiba que esse é o melhor que pude fazer. O jogo foi feito com bastante dedicação e criatividade.

E é claro, seu feedback é MUITO IMPORTANTE! Estarei aguardando por todo feedback que esse jogo receber.

CRÉDITOS:
Game Design: pvini07BR Programação: pvini07BR (a maior parte), Charalian Música: ²He (todas as músicas), pvini07BR (apenas protótipos de música) Arte: dentinho, TKO, ²He e pvini07BR Engine: Godot Engine

# INGLÊS - ENGLISH 
Welcome to the first public prototype of the 2D space shooter, or bullet hell game, called "VIRUS HAVOC!".

As I said, this is just a PROTOTYPE. The game is still very, VERY INCOMPLETE. Both in technical terms (programming, design, systems, etc.) and in conceptual and artistic terms (stages, enemies, story, etc.), and it still contains bugs.

Whether this game will be continued or not, depends on the feedback, ideas and concepts the game will have over time.

The lore of this game is, in a nutshell, about a test subject sent by NASA to save the internet from a massive virus attack from an unknown origin.

It might sound cliché or a little crazy, but the lore isn't complete yet.

(NOTE: THIS GAME HAS ABSOLUTELY NOTHING TO DO WITH COVID-19 AND THE PANDEMIC SITUATION. THE GAME WAS CREATED EVEN BEFORE THE VIRUS ARRIVED ON MY COUNTRY. IT WAS ALL A COINCIDENCE, I SWEAR.)

Now, let's talk about the game's instructions, mechanics and the content that the game has to offer:

MENU:
In the upper left corner is the list of stages. There are two stages available to play.
There are also two checking boxes: One for starting a bossfight when starting a stage, and another one for enabling the english language (YOU MIGHT WANT TO ENABLE THIS IF YOU SPEAK ENGLISH!)
In the stage 2, there is no boss, so if you check the first option, nothing will happen. Really.
In the lower left corner, there is the Gún-Dex. This will be explained in further details in the next section.
In the lower right corner, there is the mods button, which is a feature that I intend to implement, but it's not yet.
GÚN-DEX:
It's the list of guns you can use in the game. You have two available gun slots, so you can only carry up to two guns at the same time.

And there is only 5 guns in the game. Each gun has its unique name, description and damage:

Common Laser Gun: 1 of damage.
Dual-Cannon Laser Gun: 1 of damage IN EACH BULLET.
Dual-Cannon Diagonal Laser Gun: Random value between 1, 1.5 and 2, of damage.
Bomb Launcher Gun: Random value between 2, 3 and 4, of damage.
Cannonless Rainbow Gun: 2 of damage in each bullet, but it has cooldown.
Originally, all guns were supposed to be locked except of the Common Laser Gun. Guns would be unlocked as you pick up the "Loot Boxes" on the stages, which will be explained further in another section.

CONTROLS:
Move player: WASD or arrow keys.
Shoot: Press Space or Enter (It can be the Enter on the left or the one on the right, it doesn't matter).
Switch Gun: Press Q to switch to the first slot. Press E to switch to the second slot.
STAGE 1:
This stage uses a "wave system". The total amount of waves is 10. Each wave has a fixed amount of viruses (enemies), and from wave number 7 onwards, the viruses will start moving back and forth from the center.
On wave number 4, a Loot Box will appear (I'll talk in further detail about it in another section), and it will also appear on wave number 7 (only if you didn't get the first loot box). After passing the 10 waves, the boss fight will begin. If you defeat the boss the stage ends. The guns picked on the first stage will not be saved.
NOTE: Stage 1 was made to play only with the following guns:

Common Laser Gun
Dual-Cannon Laser Gun
Dual-Cannon Diagonal Laser Gun
Using any gun other than these will be out of balance.

STAGE 2:
It has three enemies: The bomber paper plane, the shooting folder and the spamming trash bin. The first two have 6 of HP. The plane fires a .zip bomb, which can deal 1-2 of damage to the player AND to the enemies. As for the shooting folder, It shoots files towards the player. It only deals 1 of damage. The spamming trash bin targets the player for a while and then shoots a spamming beam, and then disappears. You cannot deal damage to it.

LOOT BOXES:
These boxes contains a random gun, depending on the stage you are playing. It has 75% of chance of appearing in a stage, depending on when exactly the loot box appears. If you have already picked the loot while playing on a stage, it will not appear again until you restart the stage.
At stage 1, loot boxes can have one of these two guns:
Dual-Cannon Laser Gun and the Dual-Cannon Diagonal Laser Gun.
Originally it was supposed to unlock the gun(s) you picked up when you pick up the gun from the loot box and then make it to the end of the stage.
HEALTH HEARTS:
These are simple pickups that recover between 1 and 2 HP when picked. They are dropped from viruses (enemies) with a chance determined by them, which is usually 75% of chance.

Now, let's talk about what I really intend to do with the game, the story of the development, and clear up a few things.
This game has been in development since April 2020. The game at first was supposed to be very simple, but as time went by, I got more and more ideas for the game. To give you an idea of how simple the game was really was at the time, check out my game Gilbreto e a Encomienda Roubada, which is another game I made for not too much of a reason, and it is an example of an extremely simple game.

During the development, the engine has been switched a couple times, and code has been rewritten many times. The game was supposed to be made in Unity when development started. But at the time, I didn't knew anything about this engine, and even programming in general. At that time I was used to using engines with visual scripting, like Clickteam Fusion or Construct 2. The game was being made in Construct 2 for some time, in a while ago. And there was a time when I switched development to HaxeFlixel, but I hated it. And nowadays I'm using Godot Engine, which is, in my opinion, the best engine available out there.

This game was actually closed for only a few people that I had choosed, which means, it was an closed early access version. But then, I changed my mind. And decided to make the game to be an public prototype, to gain more feedback and see if it's worth continuing this game or not, or at least have a clearer path on how to continue with this game.

I decided to make this game available to the public, because the development has unfortunately been "stuck", due to the lack of ideas, and the game appears to be kind of messed up in every way, both conceptually and technically. So I thought it would be a good idea to make the game available to the public.

Before, I was making the game private to make it sort of a "surprise" for everyone, but that idea was wrong from the start.

By the way, I intend to make the game free and open source. I made this decision to make the game accessible and to be able to contribute together with the community. And you're already here! You can also visit the itch.io page of the game here: https://pvini-games.itch.io/virus-havoc

About the music used in this game: ALL THE MUSIC ARE ORIGINAL AND MADE FOR THIS GAME. These are not songs taken from sites like YouTube, Soundcloud or these copyright-free sites that offers these songs. THE MUSIC OF THIS GAME DOES NOT EXIST ANYWHERE EXCEPT ON THIS GAME. They were made by a friend of mine called "²He", or "Helium". I also prototyped songs, but he did all the work for me.

You can, of course, use the songs in this game however you like. Whether it's to upload it on YouTube or something, or use it in some kind of funny meme, you're free to do so, AS LONG AS YOU GIVE CREDIT. If you use the music from this game without giving and sort of credit or source, especially if you use the music as if it were YOURS, CREATED BY YOU, consequences can happen.

Now I want to talk about the things I still plan to implement in the game:
All stages should be locked except for the first one. And the next stage would only be unlocked after completing the previous one.
Each stage must have a different gameplay and theme, to make the game more diverse and not boring.
Add some kind of gun shop, and use cryptocoins as the fictional in-game currency to buy guns, being used as another way of obtaining new guns besides loot boxes. The way to obtain these cryptocoins is yet 100% defined. (THIS ARE NOT REAL CRYPTOCOINS. FOR THE GOD'S SAKE, THIS ISN'T AN NFT GAME. AND I DON'T INTEND TO PUT IN-GAME MICROTRANSACTIONS.)
Add "themed" guns. That means, guns that has an reference to an existing game/series/book. Example: Adding the "Pico Gun from Newgrounds" to the game. Probably the only way to get them would be from the gun shop, or from hidden easter eggs.
Add official modding support, i.e. being able to add new stages, enemies, guns, etc. No need to get and modify the game's source code.
Anyways... That's it! I hope you enjoy the game. I know, this game is still very incomplete, but please know that this is the best I could do. The game was made with a lot of dedication and creativity.

And of course, your feedback is VERY IMPORTANT! I'll be waiting for all the feedback this game receives.

CREDITS:
Game Design: pvini07BR
Programming: pvini07BR (most of it), Charalian
Music: ²He (all songs), pvini07BR (song prototypes only_
Art & Design: dentinho, TKO, ²He and pvini07BR
Engine: Godot Engine
