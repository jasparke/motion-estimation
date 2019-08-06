git pull
gcc -o unopt motion-unopt.c -lpng -marm -mfpu=neon $1
gcc -o motion motion.c -lpng -marm -mfpu=neon $1
