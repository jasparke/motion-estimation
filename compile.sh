git pull
gcc -o unopt motion-unopt.c -lpng -marm -mfpu=neon
gcc -o motion motion.c -lpng -marm -mfpu=neon
