# Just Some Kernel

A microkernel that I'm messing around with. In its incredibly early stages.

## TODO List

The first thing I want to do is to get a working scheduler that can run further programs such as a file system and other drivers.

To get a scheduler I also need the following higher level concepts (I may be forgetting some):

* Physical memory allocator
* System clock
* IPC
* System calls

To get these high level concepts working, I also need to implement the following (and probably much more) low level details:

### All Architectures

* Paging
* Interrupts
* Early serial output

### x86_64

* GDT
