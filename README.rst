===================================================
Easy-eLua : Innovating project by `RICM4 students`_
===================================================

Easy-Elua for ** `STM32F4-DISCOVERY`_ **

.. _`RICM4 students`: http://air.imag.fr/mediawiki/index.php/Main_Page
.. _`STM32F4-DISCOVERY`: http://www.st.com/internet/evalboard/product/252419.jsp

Description
===========

This project aims to make programming easier on microcontroller cards STM32F4-DISCOVERY by 
offering an Arduino interface of the opensource project eLua, which implements Lua on multiple other cards.
Our project consists in transcribing the mains functions of Arduino in Lua, so that everyone already using
Arduino can understand it. 

Combined with the powerful eLua, Easy-eLua offers:

* Source code portability: Like in Lua, you program in C, Lua or a mixture of both and your program runs in a wide varied of (sometimes radically different) platforms and architectures supported.

* Embedded RAD: Prototype and experiment on a Rapid Aplication Develop model. Test your ideas directly on the target platforms and cheap development kits. No need for simulators or future code adaptations.


Get the sources
===============

The source code of the project is available on github:

::

    $ git clone git@github.com:SalemHarrache/ricm4-Easy-Elua.git


Installation
============

Once you downloaded it, you need to launch the installation script (debian/fedora) which 
sets the environment, i.e. Sourcery toolchain and the stlink flash tool:

::

    $ cd ricm4-Easy-Elua.git
    $ ./install.sh
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

Use
===

The activate_env.sh script is used to easily activate on demand the environment so that the PATH of your machine doesn't become impaired. How to use it:

::

    $ source activate_env.sh

or

::

    $ . activate_env.sh

To launch programs on the card, you need to use the flash.sh script followed
by your file name. The card must be connected via USB on the mini-USB**A** port 
(power supply).

You need to import the arduino_wrapper.lua file when first launching 
the program with the instruction require ("arduino_wrapper").


::

    --  Blink
    --  Turns on an LED on for one second, then off for one second, repeatedly.
    require("arduino_wrapper")

    function App:setup()
        pinMode(ORANGE_LED, OUTPUT) -- Initialize the digital pin as an output.
    end

    function App:loop()
        digitalWrite(ORANGE_LED, HIGH)    -- set the LED on
        delay(1000)                       -- wait for a second
        digitalWrite(ORANGE_LED, LOW)     -- set the LED off
        delay(1000)                       -- wait for a second
    end

    app = App:new("Blink led")
    app:run()


::

    $ ./flash.sh examples/blink.lua

The script adds the file arduino_wrapper, compiles elua and flashes the card 
with the generated image. The program (here blink.lua) launches automatically 
(sometimes you have to press the reset button or unplug and then replug the 
power supply).


Launching a program from the Elua shell
=======================================

The Elua Shell
~~~~~~~~~~~~~~

Elua offers an embbed shell, which allows you to test your program without 
reflashing the card. To do so, you need a `serial link`_. 

.. _`serial link`: http://www.futureelectronics.com/fr/technologies/interconnect/usb-to-ttl-rs232-rs422-rs485-cables/Pages/4880316-TTL-232R-5V-WE.aspx?IM=0

* PB6 <-> TX
* PB7 <-> RX
* GND <-> Ground

We connect to the card with screen by launching the run_shell.sh script:

::

    $ ./run_shell.sh
    eLua dev-1b3d785  Copyright (C) 2007-2011 www.eluaproject.net
    eLua# help
    Shell commands:
    exit        - exit from this shell
    help        - print this help
    ls or dir   - lists filesystems files and sizes
    cat or type - lists file contents
    lua [args]  - run Lua with the given arguments
    recv [path] - receive a file via XMODEM, if there is a path, save there, otherwise run it.  cp <src> <dst> - copy source file 'src' to 'dst'
    ver         - print eLua version
    eLua# ls

    /rom
    arduino_wrapper.lua             1976 bytes
    autorun.lua                    679 bytes

    Total on /rom: 2655 bytes

    eLua# lua /rom/autorun.lua
    Press CTRL+Z to exit Lua
    Run : Blink led

We can also use the lua interpreter to write dynamic programs!

::

    eLua# lua
    Press CTRL+Z to exit Lua
    Lua 5.1.4  Copyright (C) 1994-2011 Lua.org, PUC-Rio
    > require("arduino_wrapper")
    > app = App:new("Hello Word!")
    > app:run()
    Run : Hello Word!

Send scripts via xmodem (without flash)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If the card is already flashed with elua, you can send your Lua script via 
xmodem (with screen) using the send.sh script


::

    $ ./send.sh examples/ascii_table.lua
    eLua# recv
    Waiting for file ... CSending examples/ascii_table.lua, 8 blocks: Give your local XMODEM receive command now.
    Bytes Sent:   1152   BPS:2984

    Transfer complete
    done, got 1097 bytes
    Run : ASCII Table ~ Character Map
    !, dec: 33, hex: 21, oct: 41, bin: 100001
    ", dec: 34, hex: 22, oct: 42, bin: 100010
    #, dec: 35, hex: 23, oct: 43, bin: 100011
    $, dec: 36, hex: 24, oct: 44, bin: 100100
    %, dec: 37, hex: 25, oct: 45, bin: 100101
    &, dec: 38, hex: 26, oct: 46, bin: 100110
    ', dec: 39, hex: 27, oct: 47, bin: 100111

To exit screen, press CTRL+A then K

Note: It is usually possible to save the script directly into the card by 
specifying to recv the path, but for now it is not supported for the 
STM32F4-DISCOVERY.