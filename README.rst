=================================
Projet innovant RICM4 : Easy-eLua
=================================

Description
===========

Le but du projet est de simplifier la programation sur les cartes 
microcontroler STM32F4-DISCOVERY, en proposant une approche Arduino sur le 
projet opensource eLua,  qui implementant Lua sur de nombreuses autres cartes.
Notre projet consiste à porter en Lua les principales fonctions Arduino, pour 
que n'importe qui venant du monde Arduino, puisse trouver ses reperes assez 
rapidement. 

Couplé à la puissance d'eLua, Easy-eLua permet : 

- Portabilité : Le code Lua produit est compatible avec diferrentes 
 architectures supportant elua.

- le RAD pour l'embarqué: Prototyper et expérimenter des applications rapidement.
 Testez vos idées directement sans besoin de simulations ou de futures modifications.

Récupérer les sources
=====================

Le code source du projet est disponible sur github avec une license BSD :)

::
    
    $ git clone git@github.com:SalemHarrache/ricm4-Easy-Elua.git


Instalation
===========


Une fois téléchargé, il faut lancer le script d’installation (debian/ubuntu) 
qui met en place l'environnement, à savoir Sourcery toolchain et l'utilitaire 
de flash de stlink:

::

    $ cd ricm4-Easy-Elua.git
    $ ./debian_install.sh
    -------------------------------------------------------------------------------
    Install prerequisites
    -------------------------------------------------------------------------------
          [OK] Install development tools
    -------------------------------------------------------------------------------
    Install Sourcery ARM toolchain version 2011.03-42
    -------------------------------------------------------------------------------
          [OK] Donwload Sourcery G++ Lite 2011.03-42 for ARM EABI
          [OK] Unpack Sourcery G++ Lite 2011.03-42 for ARM EABI
    -------------------------------------------------------------------------------
    Install ST-FLASH from stlink
    -------------------------------------------------------------------------------
          [OK] Git clone stlink
          [OK] Compiling st-flash
    -------------------------------------------------------------------------------
    Install elua
    -------------------------------------------------------------------------------
          [OK] Git clone elua
          [OK] Compiling elua for STM32F4DSCY
          [OK] Clean

    Installation succeed !
    -------------------------------------------------------------------------------
    Sourcery toolchain folder:        /home/salem/project/projet-ricm4/env/CodeSourcery/arm-2011.03
    stlink flash utils floder:        /home/salem/project/projet-ricm4/env/utils/
    Elua floder:                      /home/salem/project/projet-ricm4/elua
    Activate env:                     /home/salem/project/projet-ricm4/activate_env.sh
    -------------------------------------------------------------------------------
    $

Utilisation
===========

Le script activate_env.sh permet simplement d'activer à la demande l'environnement pour ne pas polluer le PATH de votre machine. Pour l'utiliser :

::

    $ source activate_env.sh

ou

::

    $ . activate_env.sh


Pour lancer des programmes sur la carte, il faut utiliser le script flash.sh 
suivi du nom de votre fichier. La carte doit etre branchée sur les deux ports 
usb (alimentation + com).

Vous devez importer le fichier arduino_wraper.lua en début du programme avec 
l'instruction require("arduino_wraper")

::

    -- blink.lua example

    require("arduino_wraper")

    function App:setup()
        self.ledpin = getPin("PD_13") -- Pin PD_13 has a LED connected
        pinMode(self.ledpin, OUTPUT) -- Initialize the digital pin as an output.
    end

    function App:loop()
        digitalWrite(self.ledpin, HIGH)    -- set the LED on
        delay(1000)                      -- wait for a second
        digitalWrite(self.ledpin, LOW)     -- set the LED off
        delay(1000)                      -- wait for a second
    end

    app = App:new("Blink led")
    app:run()

::

    $ ./flash.sh examples/blink.lua

Le script s'occupe d'ajoute le fichier arduino_wraper, de compiler elua, de 
flasher la carte avec l'image générée. Le programme (ici blink.lua) se lance 
automatiquement. (parfois il faut appuyer sur reset ou débrancher puis 
rebrancher l'alimentation)

Lancement d'un programme a partir du shell Elua
===============================================

Le Shell Elua
~~~~~~~~~~~~~

Elua propose un shell embarqué dans lequel vous pouvez tester votre programme 
sans devoir reflasher la carte. Pour cela vous avez besoin d'une liason série.

* PB6 <-> TX
* PB7 <-> RX
* GND <-> Ground

On se connecte avec screen :

::

    $ screen /dev/ttyUSB0 115200 8n1
    eLua dev-1b3d785  Copyright (C) 2007-2011 www.eluaproject.net
    eLua# help
    Shell commands:
    exit        - exit from this shell
    help        - print this help
    ls or dir   - lists filesystems files and sizes
    cat or type - lists file contents
    lua [args]  - run Lua with the given arguments
    recv [path] - receive a file via XMODEM, if there is a path, save                there, otherwise run it.  cp <src> <dst> - copy source file 'src' to 'dst'
    ver         - print eLua version
    eLua# ls

    /rom
    arduino_wraper.lua             1976 bytes
    autorun.lua                    679 bytes

    Total on /rom: 2655 bytes

    eLua# lua /rom/autorun.lua
    Press CTRL+Z to exit Lua
    Run : Blink led

On peut également lancement l'interprète lua pour composer des programmes
dynamiquement !

::

    eLua# lua
    Press CTRL+Z to exit Lua
    Lua 5.1.4  Copyright (C) 1994-2011 Lua.org, PUC-Rio
    > require("arduino_wraper")
    > app = App:new("Hello Word!")
    > app:run()
    Run : Hello Word!

Envoyer les scripts via xmodem
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Pour pouvez envoyer votre script Lua par xmodem sur la carte à l'aide de la 
commande recv.

::

    screen /dev/ttyUSB0 115200 8n1
    eLua# recv

sur screen faites 'CTRL+A :', puis

::

    exec !! sx -Xb /path/to/script.lua

Remarque : Le script se lance automatiquement. Il serait possible normalement 
de  sauvegarder le script directement sur la carte en spécifiant à recv le 
chemin, mais pour l'instant cela ne semble pas marcher avec la STMF4DISCOVERY.

