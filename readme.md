# SENG 440 - Motion Estimation

## Usage Instructions

The application must be compiled before use, and depends on libpng-devel and NEON.

```
    gcc -o motion motion.c -lpng -marm -mfpu=neon
```

After compilation, it can be run with:

```
    ./motion FIRST_FRAME.PNG SECOND_FRAME.PNG
```

For testing, several frames sample frames are provided:

```
    ./motion images/busy.png images/busy-shift.png
    ./motion images/block.png images/block-shift.png
    ./motion images/single.png images/single-r10.png
    ./motion images/single.png images/single-r10-d10.png
```
