# 00SChip8 #

Emulator that emulates Chip-8 and SuperChip completely. It can emulate all of the games, official and unofficial. MegaChip support has been left out due to lack of documentation on the subject.

[Official Website + Binaries](http://00laboratories.com/downloads/emulation/chip-8-emulator)

### Motivation ###

I have always been very interested in emulators and it was announced that Chip-8 is a great platform to learn the inner workings behind it. After creating this emulator I definitely learned a lot about how the CPU (registers, op-codes, state-flags, stack and program execution), RAM (overflowing, operations between CPU/RAM, dynamic ASM generation) and GPU (pixel plotting, collision feedback, sprites) work.

The emulator ships with a large game package. Our favorite game is: "Ant - In Search of Coke [Erin S. Catto]", an amazing sidescroller.

### Changes ###

**Version 2016**

Faster execution and no longer requires Ogre Engine.
No more external resource files, everything is embedded into the final executable.
Added a start-up "BIOS" game.
Now supports scaling the window to any size.

**Version 2011 - 2015**

Now utilizes various inline x86 assembly instead of manual carry flag detection and various speed improvements.
No longer resets game speed when the game is reset.
Fixed rendering artifacts and inaccurate collision detection.
Fixed SHL,1 (shift register left by 1) that set Register F to the least significant bit instead of the most significant bit.
Small GUI changes.

### Screenshots ###

![00SChip8A.png](https://bitbucket.org/repo/XpeXLg/images/3027919275-00SChip8A.png)
![00SChip8B.png](https://bitbucket.org/repo/XpeXLg/images/2352330980-00SChip8B.png)
![00SChip8C.png](https://bitbucket.org/repo/XpeXLg/images/3337427761-00SChip8C.png)