# DAX
Driver and eXecutable Format

# What is DAX?
Dax is a very very lightweight executable format specifically made for Real Mode (for bootloaders and kernels) and also for drivers (I Guess?).

It has two main programs the DAX convertor and the dax parser/executer. The DAX converter converts any .bin/.o file into a .dax file, the dax parser parses and executes a .dax file.

## DAX Convertor
Dax convertor is a program to convert .o/.bin to .dax files. It can only work in a OS environment unlike DAX parser.

DAX convertor and parser are written fully in assembly and due to this fact they are **very** **VERY** **VERY** **FAST!**

# How to install DAX?
## DAX Convertor
Navigate to the github repository DAX [https://github.com/AkshuDev/DAX] then go into the dax-assembler folder and then into the build. Choose a build file that matches your OS and Architecture for example - **dax-asm_linux_amd64**

Now you have downloaded the DAX Assembler which is required to convert files into dax formats as this assembler builds DAX specific binary and object files.

Now you would need the convertor itself so inside the repository navigate to the dax-convertor folder and go into the folder that matches your OS for example - **linux**, then choose and go into the folder that matches your cpu architecture for example - **amd64**. you can then either download the source and the build together and build it from scratch via MakeFile or whatever build format is available in the chosen folder, or you can just download the pre-built convertor by navigating into the build / bin folder.
