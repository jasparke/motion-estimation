	.arch armv7-a
	.eabi_attribute 28, 1
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 2
	.eabi_attribute 30, 6
	.eabi_attribute 34, 1
	.eabi_attribute 18, 4
	.file	"motion.c"
	.text
	.align	2
	.arch armv7-a
	.syntax unified
	.arm
	.fpu neon
	.type	fatal_error, %function
fatal_error:
	@ args = 4, pretend = 16, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 1
	push	{r0, r1, r2, r3}
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #8
	add	r3, fp, #8
	str	r3, [fp, #-8]
	movw	r3, #:lower16:stderr
	movt	r3, #:upper16:stderr
	ldr	r3, [r3]
	ldr	r2, [fp, #-8]
	ldr	r1, [fp, #4]
	mov	r0, r3
	bl	vfprintf
	mov	r0, #1
	bl	exit
	.size	fatal_error, .-fatal_error
	.section	.rodata
	.align	2
.LC0:
	.ascii	"images/busy.png\000"
	.align	2
.LC1:
	.ascii	"images/busy-shift.png\000"
	.align	2
.LC2:
	.ascii	"ERROR: Expect equal sized frames as input.\000"
	.text
	.align	2
	.global	main
	.syntax unified
	.arm
	.fpu neon
	.type	main, %function
main:
	@ args = 0, pretend = 0, frame = 32
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #32
	str	r0, [fp, #-32]
	str	r1, [fp, #-36]
	sub	r2, fp, #16
	sub	r3, fp, #20
	mov	r1, r3
	movw	r0, #:lower16:.LC0
	movt	r0, #:upper16:.LC0
	bl	loadImageFromPNG
	str	r0, [fp, #-8]
	sub	r2, fp, #24
	sub	r3, fp, #28
	mov	r1, r3
	movw	r0, #:lower16:.LC1
	movt	r0, #:upper16:.LC1
	bl	loadImageFromPNG
	str	r0, [fp, #-12]
	ldr	r2, [fp, #-16]
	ldr	r3, [fp, #-24]
	cmp	r2, r3
	bne	.L3
	ldr	r2, [fp, #-20]
	ldr	r3, [fp, #-28]
	cmp	r2, r3
	beq	.L4
.L3:
	movw	r0, #:lower16:.LC2
	movt	r0, #:upper16:.LC2
	bl	fatal_error
.L4:
	ldr	r2, [fp, #-20]
	ldr	r3, [fp, #-16]
	ldr	r1, [fp, #-12]
	ldr	r0, [fp, #-8]
	bl	motion
	mov	r3, #0
	mov	r0, r3
	sub	sp, fp, #4
	@ sp needed
	pop	{fp, pc}
	.size	main, .-main
	.section	.rodata
	.align	2
.LC3:
	.ascii	"rb\000"
	.align	2
.LC4:
	.ascii	"ERROR: Unable to open file %s.\000"
	.align	2
.LC5:
	.ascii	"1.6.34\000"
	.align	2
.LC6:
	.ascii	"ERROR: Unable to open PNG: %s\000"
	.text
	.align	2
	.global	loadImageFromPNG
	.syntax unified
	.arm
	.fpu neon
	.type	loadImageFromPNG, %function
loadImageFromPNG:
	@ args = 0, pretend = 0, frame = 40
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r4, fp, lr}
	add	fp, sp, #8
	sub	sp, sp, #44
	str	r0, [fp, #-40]
	str	r1, [fp, #-44]
	str	r2, [fp, #-48]
	movw	r1, #:lower16:.LC3
	movt	r1, #:upper16:.LC3
	ldr	r0, [fp, #-40]
	bl	fopen
	str	r0, [fp, #-20]
	ldr	r3, [fp, #-20]
	cmp	r3, #0
	bne	.L7
	ldr	r1, [fp, #-40]
	movw	r0, #:lower16:.LC4
	movt	r0, #:upper16:.LC4
	bl	fatal_error
.L7:
	mov	r3, #0
	mov	r2, #0
	mov	r1, #0
	movw	r0, #:lower16:.LC5
	movt	r0, #:upper16:.LC5
	bl	png_create_read_struct
	mov	r3, r0
	str	r3, [fp, #-28]
	ldr	r3, [fp, #-28]
	cmp	r3, #0
	bne	.L8
	ldr	r1, [fp, #-40]
	movw	r0, #:lower16:.LC6
	movt	r0, #:upper16:.LC6
	bl	fatal_error
.L8:
	ldr	r3, [fp, #-28]
	mov	r0, r3
	bl	png_create_info_struct
	mov	r3, r0
	str	r3, [fp, #-32]
	ldr	r3, [fp, #-28]
	ldr	r1, [fp, #-20]
	mov	r0, r3
	bl	png_init_io
	ldr	r3, [fp, #-28]
	ldr	r2, [fp, #-32]
	mov	r1, r2
	mov	r0, r3
	bl	png_read_info
	ldr	r3, [fp, #-28]
	ldr	r2, [fp, #-32]
	mov	r1, r2
	mov	r0, r3
	bl	png_get_image_width
	mov	r3, r0
	mov	r2, r3
	ldr	r3, [fp, #-44]
	str	r2, [r3]
	ldr	r3, [fp, #-28]
	ldr	r2, [fp, #-32]
	mov	r1, r2
	mov	r0, r3
	bl	png_get_image_height
	mov	r3, r0
	mov	r2, r3
	ldr	r3, [fp, #-48]
	str	r2, [r3]
	ldr	r3, [fp, #-48]
	ldr	r3, [r3]
	lsl	r3, r3, #2
	mov	r0, r3
	bl	malloc
	mov	r3, r0
	str	r3, [fp, #-24]
	mov	r3, #0
	str	r3, [fp, #-16]
	b	.L9
.L10:
	ldr	r3, [fp, #-28]
	ldr	r2, [fp, #-32]
	mov	r1, r2
	mov	r0, r3
	bl	png_get_rowbytes
	mov	r1, r0
	ldr	r3, [fp, #-16]
	lsl	r3, r3, #2
	ldr	r2, [fp, #-24]
	add	r4, r2, r3
	mov	r0, r1
	bl	malloc
	mov	r3, r0
	str	r3, [r4]
	ldr	r3, [fp, #-16]
	add	r3, r3, #1
	str	r3, [fp, #-16]
.L9:
	ldr	r3, [fp, #-44]
	ldr	r3, [r3]
	ldr	r2, [fp, #-16]
	cmp	r2, r3
	blt	.L10
	ldr	r3, [fp, #-28]
	ldr	r1, [fp, #-24]
	mov	r0, r3
	bl	png_read_image
	sub	r1, fp, #32
	sub	r3, fp, #28
	mov	r2, #0
	mov	r0, r3
	bl	png_destroy_read_struct
	ldr	r3, [fp, #-24]
	mov	r0, r3
	sub	sp, fp, #8
	@ sp needed
	pop	{r4, fp, pc}
	.size	loadImageFromPNG, .-loadImageFromPNG
	.section	.rodata
	.align	2
.LC7:
	.ascii	"BLOCK %d @ [%02d, %02d]: SAD %d with motion (% 02d,"
	.ascii	" % 02d)\012\000"
	.align	2
.LC8:
	.ascii	"Completed in %f.\012\000"
	.text
	.align	2
	.global	motion
	.syntax unified
	.arm
	.fpu neon
	.type	motion, %function
motion:
	@ args = 0, pretend = 0, frame = 3584
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, fp, lr}
	add	fp, sp, #20
	sub	sp, sp, #3600
	str	r0, [fp, #-3592]
	str	r1, [fp, #-3596]
	str	r2, [fp, #-3600]
	str	r3, [fp, #-3604]
	bl	clock
	str	r0, [fp, #-60]
	ldr	r3, [fp, #-3600]
	add	r2, r3, #15
	cmp	r3, #0
	movlt	r3, r2
	movge	r3, r3
	asr	r3, r3, #4
	str	r3, [fp, #-64]
	ldr	r3, [fp, #-3604]
	add	r2, r3, #15
	cmp	r3, #0
	movlt	r3, r2
	movge	r3, r3
	asr	r3, r3, #4
	str	r3, [fp, #-68]
	ldr	r3, [fp, #-68]
	mov	r1, #4
	mov	r0, r3
	bl	calloc
	mov	r3, r0
	str	r3, [fp, #-72]
	ldr	r3, [fp, #-68]
	mov	r1, #4
	mov	r0, r3
	bl	calloc
	mov	r3, r0
	str	r3, [fp, #-76]
	mov	r3, #0
	str	r3, [fp, #-44]
	b	.L13
.L14:
	ldr	r0, [fp, #-64]
	ldr	r3, [fp, #-44]
	lsl	r3, r3, #2
	ldr	r2, [fp, #-72]
	add	r4, r2, r3
	mov	r1, #4
	bl	calloc
	mov	r3, r0
	str	r3, [r4]
	ldr	r0, [fp, #-64]
	ldr	r3, [fp, #-44]
	lsl	r3, r3, #2
	ldr	r2, [fp, #-76]
	add	r4, r2, r3
	mov	r1, #4
	bl	calloc
	mov	r3, r0
	str	r3, [r4]
	ldr	r3, [fp, #-44]
	add	r3, r3, #1
	str	r3, [fp, #-44]
.L13:
	ldr	r2, [fp, #-44]
	ldr	r3, [fp, #-68]
	cmp	r2, r3
	blt	.L14
	ldr	ip, [fp, #-64]
	ldr	lr, [fp, #-68]
	mov	r3, sp
	mov	r7, r3
	sub	r3, ip, #1
	str	r3, [fp, #-80]
	mov	r3, ip
	lsl	r5, r3, #1
	sub	r3, lr, #1
	str	r3, [fp, #-84]
	mov	r3, ip
	mov	r0, r3
	mov	r1, #0
	mov	r3, lr
	mov	r2, r3
	mov	r3, #0
	mul	r6, r2, r1
	mul	r4, r0, r3
	add	r4, r6, r4
	umull	r2, r3, r0, r2
	add	r1, r4, r3
	mov	r3, r1
	mov	r3, ip
	mov	r0, r3
	mov	r1, #0
	mov	r3, lr
	mov	r2, r3
	mov	r3, #0
	mul	r6, r2, r1
	mul	r4, r0, r3
	add	r4, r6, r4
	umull	r2, r3, r0, r2
	add	r1, r4, r3
	mov	r3, r1
	mov	r3, ip
	mov	r2, lr
	mul	r3, r2, r3
	lsl	r3, r3, #1
	add	r3, r3, #7
	lsr	r3, r3, #3
	lsl	r3, r3, #3
	sub	sp, sp, r3
	add	r3, sp, #16
	add	r3, r3, #1
	lsr	r3, r3, #1
	lsl	r3, r3, #1
	str	r3, [fp, #-88]
	ldr	r0, [fp, #-88]
	ldr	r3, [fp, #-64]
	ldr	r2, [fp, #-68]
	mul	r3, r2, r3
	lsl	r3, r3, #1
	mov	r2, r3
	mvn	r1, #-2147483648
	bl	memset
	mov	r3, #0
	str	r3, [fp, #-40]
	mov	r3, #0
	str	r3, [fp, #-36]
	mov	r3, #0
	str	r3, [fp, #-32]
	b	.L15
.L191:
	mov	r3, #0
	str	r3, [fp, #-40]
	mov	r3, #0
	str	r3, [fp, #-28]
	b	.L16
.L190:
	ldr	r3, [fp, #-32]
	cmp	r3, #0
	bne	.L17
	mov	r3, #0
	b	.L18
.L17:
	mvn	r3, #15
.L18:
	str	r3, [fp, #-92]
	ldr	r3, [fp, #-28]
	cmp	r3, #0
	bne	.L19
	mov	r3, #0
	b	.L20
.L19:
	mvn	r3, #15
.L20:
	str	r3, [fp, #-96]
	ldr	r3, [fp, #-68]
	sub	r3, r3, #1
	ldr	r2, [fp, #-32]
	cmp	r2, r3
	bne	.L21
	mov	r3, #0
	b	.L22
.L21:
	mov	r3, #16
.L22:
	str	r3, [fp, #-100]
	ldr	r3, [fp, #-64]
	sub	r3, r3, #1
	ldr	r2, [fp, #-28]
	cmp	r2, r3
	bne	.L23
	mov	r3, #0
	b	.L24
.L23:
	mov	r3, #16
.L24:
	str	r3, [fp, #-104]
	ldr	r3, [fp, #-96]
	str	r3, [fp, #-24]
	ldr	r3, [fp, #-92]
	str	r3, [fp, #-48]
	ldr	r3, [fp, #-36]
	lsl	r3, r3, #2
	ldr	r2, [fp, #-3596]
	add	r3, r2, r3
	ldr	r2, [r3]
	ldr	r3, [fp, #-40]
	add	r3, r2, r3
	str	r3, [fp, #-2148]
	ldr	r3, [fp, #-2148]
	vld1.8	{d16-d17}, [r3]
	vstr	d16, [fp, #-124]
	vstr	d17, [fp, #-116]
	ldr	r3, [fp, #-36]
	add	r3, r3, #1
	lsl	r3, r3, #2
	ldr	r2, [fp, #-3596]
	add	r3, r2, r3
	ldr	r2, [r3]
	ldr	r3, [fp, #-40]
	add	r3, r2, r3
	str	r3, [fp, #-2144]
	ldr	r3, [fp, #-2144]
	vld1.8	{d16-d17}, [r3]
	vstr	d16, [fp, #-140]
	vstr	d17, [fp, #-132]
	ldr	r3, [fp, #-36]
	add	r3, r3, #2
	lsl	r3, r3, #2
	ldr	r2, [fp, #-3596]
	add	r3, r2, r3
	ldr	r2, [r3]
	ldr	r3, [fp, #-40]
	add	r3, r2, r3
	str	r3, [fp, #-2140]
	ldr	r3, [fp, #-2140]
	vld1.8	{d16-d17}, [r3]
	vstr	d16, [fp, #-156]
	vstr	d17, [fp, #-148]
	ldr	r3, [fp, #-36]
	add	r3, r3, #3
	lsl	r3, r3, #2
	ldr	r2, [fp, #-3596]
	add	r3, r2, r3
	ldr	r2, [r3]
	ldr	r3, [fp, #-40]
	add	r3, r2, r3
	str	r3, [fp, #-2136]
	ldr	r3, [fp, #-2136]
	vld1.8	{d16-d17}, [r3]
	vstr	d16, [fp, #-172]
	vstr	d17, [fp, #-164]
	ldr	r3, [fp, #-36]
	add	r3, r3, #4
	lsl	r3, r3, #2
	ldr	r2, [fp, #-3596]
	add	r3, r2, r3
	ldr	r2, [r3]
	ldr	r3, [fp, #-40]
	add	r3, r2, r3
	str	r3, [fp, #-2132]
	ldr	r3, [fp, #-2132]
	vld1.8	{d16-d17}, [r3]
	vstr	d16, [fp, #-188]
	vstr	d17, [fp, #-180]
	ldr	r3, [fp, #-36]
	add	r3, r3, #5
	lsl	r3, r3, #2
	ldr	r2, [fp, #-3596]
	add	r3, r2, r3
	ldr	r2, [r3]
	ldr	r3, [fp, #-40]
	add	r3, r2, r3
	str	r3, [fp, #-2128]
	ldr	r3, [fp, #-2128]
	vld1.8	{d16-d17}, [r3]
	vstr	d16, [fp, #-204]
	vstr	d17, [fp, #-196]
	ldr	r3, [fp, #-36]
	add	r3, r3, #6
	lsl	r3, r3, #2
	ldr	r2, [fp, #-3596]
	add	r3, r2, r3
	ldr	r2, [r3]
	ldr	r3, [fp, #-40]
	add	r3, r2, r3
	str	r3, [fp, #-2124]
	ldr	r3, [fp, #-2124]
	vld1.8	{d16-d17}, [r3]
	vstr	d16, [fp, #-220]
	vstr	d17, [fp, #-212]
	ldr	r3, [fp, #-36]
	add	r3, r3, #7
	lsl	r3, r3, #2
	ldr	r2, [fp, #-3596]
	add	r3, r2, r3
	ldr	r2, [r3]
	ldr	r3, [fp, #-40]
	add	r3, r2, r3
	str	r3, [fp, #-2120]
	ldr	r3, [fp, #-2120]
	vld1.8	{d16-d17}, [r3]
	vstr	d16, [fp, #-236]
	vstr	d17, [fp, #-228]
	ldr	r3, [fp, #-36]
	add	r3, r3, #8
	lsl	r3, r3, #2
	ldr	r2, [fp, #-3596]
	add	r3, r2, r3
	ldr	r2, [r3]
	ldr	r3, [fp, #-40]
	add	r3, r2, r3
	str	r3, [fp, #-2116]
	ldr	r3, [fp, #-2116]
	vld1.8	{d16-d17}, [r3]
	vstr	d16, [fp, #-252]
	vstr	d17, [fp, #-244]
	ldr	r3, [fp, #-36]
	add	r3, r3, #9
	lsl	r3, r3, #2
	ldr	r2, [fp, #-3596]
	add	r3, r2, r3
	ldr	r2, [r3]
	ldr	r3, [fp, #-40]
	add	r3, r2, r3
	str	r3, [fp, #-2112]
	ldr	r3, [fp, #-2112]
	vld1.8	{d16-d17}, [r3]
	vstr	d16, [fp, #-268]
	vstr	d17, [fp, #-260]
	ldr	r3, [fp, #-36]
	add	r3, r3, #10
	lsl	r3, r3, #2
	ldr	r2, [fp, #-3596]
	add	r3, r2, r3
	ldr	r2, [r3]
	ldr	r3, [fp, #-40]
	add	r3, r2, r3
	str	r3, [fp, #-2108]
	ldr	r3, [fp, #-2108]
	vld1.8	{d16-d17}, [r3]
	vstr	d16, [fp, #-284]
	vstr	d17, [fp, #-276]
	ldr	r3, [fp, #-36]
	add	r3, r3, #11
	lsl	r3, r3, #2
	ldr	r2, [fp, #-3596]
	add	r3, r2, r3
	ldr	r2, [r3]
	ldr	r3, [fp, #-40]
	add	r3, r2, r3
	str	r3, [fp, #-2104]
	ldr	r3, [fp, #-2104]
	vld1.8	{d16-d17}, [r3]
	vstr	d16, [fp, #-300]
	vstr	d17, [fp, #-292]
	ldr	r3, [fp, #-36]
	add	r3, r3, #12
	lsl	r3, r3, #2
	ldr	r2, [fp, #-3596]
	add	r3, r2, r3
	ldr	r2, [r3]
	ldr	r3, [fp, #-40]
	add	r3, r2, r3
	str	r3, [fp, #-2100]
	ldr	r3, [fp, #-2100]
	vld1.8	{d16-d17}, [r3]
	vstr	d16, [fp, #-316]
	vstr	d17, [fp, #-308]
	ldr	r3, [fp, #-36]
	add	r3, r3, #13
	lsl	r3, r3, #2
	ldr	r2, [fp, #-3596]
	add	r3, r2, r3
	ldr	r2, [r3]
	ldr	r3, [fp, #-40]
	add	r3, r2, r3
	str	r3, [fp, #-2096]
	ldr	r3, [fp, #-2096]
	vld1.8	{d16-d17}, [r3]
	vstr	d16, [fp, #-332]
	vstr	d17, [fp, #-324]
	ldr	r3, [fp, #-36]
	add	r3, r3, #14
	lsl	r3, r3, #2
	ldr	r2, [fp, #-3596]
	add	r3, r2, r3
	ldr	r2, [r3]
	ldr	r3, [fp, #-40]
	add	r3, r2, r3
	str	r3, [fp, #-2092]
	ldr	r3, [fp, #-2092]
	vld1.8	{d16-d17}, [r3]
	vstr	d16, [fp, #-348]
	vstr	d17, [fp, #-340]
	ldr	r3, [fp, #-36]
	add	r3, r3, #15
	lsl	r3, r3, #2
	ldr	r2, [fp, #-3596]
	add	r3, r2, r3
	ldr	r2, [r3]
	ldr	r3, [fp, #-40]
	add	r3, r2, r3
	str	r3, [fp, #-2088]
	ldr	r3, [fp, #-2088]
	vld1.8	{d16-d17}, [r3]
	vstr	d16, [fp, #-364]
	vstr	d17, [fp, #-356]
	ldr	r3, [fp, #-36]
	lsl	r3, r3, #2
	ldr	r2, [fp, #-3592]
	add	r3, r2, r3
	ldr	r2, [r3]
	ldr	r3, [fp, #-40]
	add	r3, r2, r3
	str	r3, [fp, #-2084]
	ldr	r3, [fp, #-2084]
	vld1.8	{d16-d17}, [r3]
	vstr	d16, [fp, #-380]
	vstr	d17, [fp, #-372]
	ldr	r3, [fp, #-36]
	add	r3, r3, #1
	lsl	r3, r3, #2
	ldr	r2, [fp, #-3592]
	add	r3, r2, r3
	ldr	r2, [r3]
	ldr	r3, [fp, #-40]
	add	r3, r2, r3
	str	r3, [fp, #-2080]
	ldr	r3, [fp, #-2080]
	vld1.8	{d16-d17}, [r3]
	vstr	d16, [fp, #-396]
	vstr	d17, [fp, #-388]
	ldr	r3, [fp, #-36]
	add	r3, r3, #2
	lsl	r3, r3, #2
	ldr	r2, [fp, #-3592]
	add	r3, r2, r3
	ldr	r2, [r3]
	ldr	r3, [fp, #-40]
	add	r3, r2, r3
	str	r3, [fp, #-2076]
	ldr	r3, [fp, #-2076]
	vld1.8	{d16-d17}, [r3]
	vstr	d16, [fp, #-412]
	vstr	d17, [fp, #-404]
	ldr	r3, [fp, #-36]
	add	r3, r3, #3
	lsl	r3, r3, #2
	ldr	r2, [fp, #-3592]
	add	r3, r2, r3
	ldr	r2, [r3]
	ldr	r3, [fp, #-40]
	add	r3, r2, r3
	str	r3, [fp, #-2072]
	ldr	r3, [fp, #-2072]
	vld1.8	{d16-d17}, [r3]
	vstr	d16, [fp, #-428]
	vstr	d17, [fp, #-420]
	ldr	r3, [fp, #-36]
	add	r3, r3, #4
	lsl	r3, r3, #2
	ldr	r2, [fp, #-3592]
	add	r3, r2, r3
	ldr	r2, [r3]
	ldr	r3, [fp, #-40]
	add	r3, r2, r3
	str	r3, [fp, #-2068]
	ldr	r3, [fp, #-2068]
	vld1.8	{d16-d17}, [r3]
	vstr	d16, [fp, #-444]
	vstr	d17, [fp, #-436]
	ldr	r3, [fp, #-36]
	add	r3, r3, #5
	lsl	r3, r3, #2
	ldr	r2, [fp, #-3592]
	add	r3, r2, r3
	ldr	r2, [r3]
	ldr	r3, [fp, #-40]
	add	r3, r2, r3
	str	r3, [fp, #-2064]
	ldr	r3, [fp, #-2064]
	vld1.8	{d16-d17}, [r3]
	vstr	d16, [fp, #-460]
	vstr	d17, [fp, #-452]
	ldr	r3, [fp, #-36]
	add	r3, r3, #6
	lsl	r3, r3, #2
	ldr	r2, [fp, #-3592]
	add	r3, r2, r3
	ldr	r2, [r3]
	ldr	r3, [fp, #-40]
	add	r3, r2, r3
	str	r3, [fp, #-2060]
	ldr	r3, [fp, #-2060]
	vld1.8	{d16-d17}, [r3]
	vstr	d16, [fp, #-476]
	vstr	d17, [fp, #-468]
	ldr	r3, [fp, #-36]
	add	r3, r3, #7
	lsl	r3, r3, #2
	ldr	r2, [fp, #-3592]
	add	r3, r2, r3
	ldr	r2, [r3]
	ldr	r3, [fp, #-40]
	add	r3, r2, r3
	str	r3, [fp, #-2056]
	ldr	r3, [fp, #-2056]
	vld1.8	{d16-d17}, [r3]
	vstr	d16, [fp, #-492]
	vstr	d17, [fp, #-484]
	ldr	r3, [fp, #-36]
	add	r3, r3, #8
	lsl	r3, r3, #2
	ldr	r2, [fp, #-3592]
	add	r3, r2, r3
	ldr	r2, [r3]
	ldr	r3, [fp, #-40]
	add	r3, r2, r3
	str	r3, [fp, #-2052]
	ldr	r3, [fp, #-2052]
	vld1.8	{d16-d17}, [r3]
	vstr	d16, [fp, #-508]
	vstr	d17, [fp, #-500]
	ldr	r3, [fp, #-36]
	add	r3, r3, #9
	lsl	r3, r3, #2
	ldr	r2, [fp, #-3592]
	add	r3, r2, r3
	ldr	r2, [r3]
	ldr	r3, [fp, #-40]
	add	r3, r2, r3
	str	r3, [fp, #-2048]
	ldr	r3, [fp, #-2048]
	vld1.8	{d16-d17}, [r3]
	vstr	d16, [fp, #-524]
	vstr	d17, [fp, #-516]
	ldr	r3, [fp, #-36]
	add	r3, r3, #10
	lsl	r3, r3, #2
	ldr	r2, [fp, #-3592]
	add	r3, r2, r3
	ldr	r2, [r3]
	ldr	r3, [fp, #-40]
	add	r3, r2, r3
	str	r3, [fp, #-2044]
	ldr	r3, [fp, #-2044]
	vld1.8	{d16-d17}, [r3]
	vstr	d16, [fp, #-540]
	vstr	d17, [fp, #-532]
	ldr	r3, [fp, #-36]
	add	r3, r3, #11
	lsl	r3, r3, #2
	ldr	r2, [fp, #-3592]
	add	r3, r2, r3
	ldr	r2, [r3]
	ldr	r3, [fp, #-40]
	add	r3, r2, r3
	str	r3, [fp, #-2040]
	ldr	r3, [fp, #-2040]
	vld1.8	{d16-d17}, [r3]
	vstr	d16, [fp, #-556]
	vstr	d17, [fp, #-548]
	ldr	r3, [fp, #-36]
	add	r3, r3, #12
	lsl	r3, r3, #2
	ldr	r2, [fp, #-3592]
	add	r3, r2, r3
	ldr	r2, [r3]
	ldr	r3, [fp, #-40]
	add	r3, r2, r3
	str	r3, [fp, #-2036]
	ldr	r3, [fp, #-2036]
	vld1.8	{d16-d17}, [r3]
	vstr	d16, [fp, #-572]
	vstr	d17, [fp, #-564]
	ldr	r3, [fp, #-36]
	add	r3, r3, #13
	lsl	r3, r3, #2
	ldr	r2, [fp, #-3592]
	add	r3, r2, r3
	ldr	r2, [r3]
	ldr	r3, [fp, #-40]
	add	r3, r2, r3
	str	r3, [fp, #-2032]
	ldr	r3, [fp, #-2032]
	vld1.8	{d16-d17}, [r3]
	vstr	d16, [fp, #-588]
	vstr	d17, [fp, #-580]
	ldr	r3, [fp, #-36]
	add	r3, r3, #14
	lsl	r3, r3, #2
	ldr	r2, [fp, #-3592]
	add	r3, r2, r3
	ldr	r2, [r3]
	ldr	r3, [fp, #-40]
	add	r3, r2, r3
	str	r3, [fp, #-2028]
	ldr	r3, [fp, #-2028]
	vld1.8	{d16-d17}, [r3]
	vstr	d16, [fp, #-604]
	vstr	d17, [fp, #-596]
	ldr	r3, [fp, #-36]
	add	r3, r3, #15
	lsl	r3, r3, #2
	ldr	r2, [fp, #-3592]
	add	r3, r2, r3
	ldr	r2, [r3]
	ldr	r3, [fp, #-40]
	add	r3, r2, r3
	str	r3, [fp, #-2024]
	ldr	r3, [fp, #-2024]
	vld1.8	{d16-d17}, [r3]
	vstr	d16, [fp, #-620]
	vstr	d17, [fp, #-612]
	sub	r3, fp, #20
	sub	r3, r3, #1984
	vldr	d16, [fp, #-124]
	vldr	d17, [fp, #-116]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #2000
	vldr	d16, [fp, #-380]
	vldr	d17, [fp, #-372]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #1984
	vld1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #2000
	vld1.64	{d18-d19}, [r3:64]
	vabd.u8	q8, q8, q9
	sub	r3, fp, #20
	sub	r3, r3, #1968
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #1968
	vld1.64	{d16-d17}, [r3:64]
	vpaddl.u8	q8, q8
	vstr	d16, [fp, #-636]
	vstr	d17, [fp, #-628]
	sub	r3, fp, #20
	sub	r3, r3, #1936
	vldr	d16, [fp, #-140]
	vldr	d17, [fp, #-132]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #1952
	vldr	d16, [fp, #-396]
	vldr	d17, [fp, #-388]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #1936
	vld1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #1952
	vld1.64	{d18-d19}, [r3:64]
	vabd.u8	q8, q8, q9
	sub	r3, fp, #20
	sub	r3, r3, #1920
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #1920
	vld1.64	{d16-d17}, [r3:64]
	vpaddl.u8	q8, q8
	vmov	q9, q8  @ v8hi
	sub	r3, fp, #20
	sub	r3, r3, #1888
	vldr	d16, [fp, #-636]
	vldr	d17, [fp, #-628]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #1904
	vst1.64	{d18-d19}, [r3:64]
	sub	r3, fp, #20
	sub	r2, r3, #1888
	sub	r3, fp, #20
	sub	r3, r3, #1904
	vld1.64	{d18-d19}, [r2:64]
	vld1.64	{d16-d17}, [r3:64]
	vadd.i16	q8, q9, q8
	vstr	d16, [fp, #-636]
	vstr	d17, [fp, #-628]
	sub	r3, fp, #20
	sub	r3, r3, #1856
	vldr	d16, [fp, #-156]
	vldr	d17, [fp, #-148]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #1872
	vldr	d16, [fp, #-412]
	vldr	d17, [fp, #-404]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #1856
	vld1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #1872
	vld1.64	{d18-d19}, [r3:64]
	vabd.u8	q8, q8, q9
	sub	r3, fp, #20
	sub	r3, r3, #1840
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #1840
	vld1.64	{d16-d17}, [r3:64]
	vpaddl.u8	q8, q8
	vmov	q9, q8  @ v8hi
	sub	r3, fp, #20
	sub	r3, r3, #1808
	vldr	d16, [fp, #-636]
	vldr	d17, [fp, #-628]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #1824
	vst1.64	{d18-d19}, [r3:64]
	sub	r3, fp, #20
	sub	r2, r3, #1808
	sub	r3, fp, #20
	sub	r3, r3, #1824
	vld1.64	{d18-d19}, [r2:64]
	vld1.64	{d16-d17}, [r3:64]
	vadd.i16	q8, q9, q8
	vstr	d16, [fp, #-636]
	vstr	d17, [fp, #-628]
	sub	r3, fp, #20
	sub	r3, r3, #1776
	vldr	d16, [fp, #-172]
	vldr	d17, [fp, #-164]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #1792
	vldr	d16, [fp, #-428]
	vldr	d17, [fp, #-420]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #1776
	vld1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #1792
	vld1.64	{d18-d19}, [r3:64]
	vabd.u8	q8, q8, q9
	sub	r3, fp, #20
	sub	r3, r3, #1760
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #1760
	vld1.64	{d16-d17}, [r3:64]
	vpaddl.u8	q8, q8
	vmov	q9, q8  @ v8hi
	sub	r3, fp, #20
	sub	r3, r3, #1728
	vldr	d16, [fp, #-636]
	vldr	d17, [fp, #-628]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #1744
	vst1.64	{d18-d19}, [r3:64]
	sub	r3, fp, #20
	sub	r2, r3, #1728
	sub	r3, fp, #20
	sub	r3, r3, #1744
	vld1.64	{d18-d19}, [r2:64]
	vld1.64	{d16-d17}, [r3:64]
	vadd.i16	q8, q9, q8
	vstr	d16, [fp, #-636]
	vstr	d17, [fp, #-628]
	sub	r3, fp, #20
	sub	r3, r3, #1696
	vldr	d16, [fp, #-188]
	vldr	d17, [fp, #-180]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #1712
	vldr	d16, [fp, #-444]
	vldr	d17, [fp, #-436]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #1696
	vld1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #1712
	vld1.64	{d18-d19}, [r3:64]
	vabd.u8	q8, q8, q9
	sub	r3, fp, #20
	sub	r3, r3, #1680
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #1680
	vld1.64	{d16-d17}, [r3:64]
	vpaddl.u8	q8, q8
	vmov	q9, q8  @ v8hi
	sub	r3, fp, #20
	sub	r3, r3, #1648
	vldr	d16, [fp, #-636]
	vldr	d17, [fp, #-628]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #1664
	vst1.64	{d18-d19}, [r3:64]
	sub	r3, fp, #20
	sub	r2, r3, #1648
	sub	r3, fp, #20
	sub	r3, r3, #1664
	vld1.64	{d18-d19}, [r2:64]
	vld1.64	{d16-d17}, [r3:64]
	vadd.i16	q8, q9, q8
	vstr	d16, [fp, #-636]
	vstr	d17, [fp, #-628]
	sub	r3, fp, #20
	sub	r3, r3, #1616
	vldr	d16, [fp, #-204]
	vldr	d17, [fp, #-196]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #1632
	vldr	d16, [fp, #-460]
	vldr	d17, [fp, #-452]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #1616
	vld1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #1632
	vld1.64	{d18-d19}, [r3:64]
	vabd.u8	q8, q8, q9
	sub	r3, fp, #20
	sub	r3, r3, #1600
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #1600
	vld1.64	{d16-d17}, [r3:64]
	vpaddl.u8	q8, q8
	vmov	q9, q8  @ v8hi
	sub	r3, fp, #20
	sub	r3, r3, #1568
	vldr	d16, [fp, #-636]
	vldr	d17, [fp, #-628]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #1584
	vst1.64	{d18-d19}, [r3:64]
	sub	r3, fp, #20
	sub	r2, r3, #1568
	sub	r3, fp, #20
	sub	r3, r3, #1584
	vld1.64	{d18-d19}, [r2:64]
	vld1.64	{d16-d17}, [r3:64]
	vadd.i16	q8, q9, q8
	vstr	d16, [fp, #-636]
	vstr	d17, [fp, #-628]
	sub	r3, fp, #20
	sub	r3, r3, #1536
	vldr	d16, [fp, #-220]
	vldr	d17, [fp, #-212]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #1552
	vldr	d16, [fp, #-476]
	vldr	d17, [fp, #-468]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #1536
	vld1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #1552
	vld1.64	{d18-d19}, [r3:64]
	vabd.u8	q8, q8, q9
	sub	r3, fp, #20
	sub	r3, r3, #1520
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #1520
	vld1.64	{d16-d17}, [r3:64]
	vpaddl.u8	q8, q8
	vmov	q9, q8  @ v8hi
	sub	r3, fp, #20
	sub	r3, r3, #1488
	vldr	d16, [fp, #-636]
	vldr	d17, [fp, #-628]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #1504
	vst1.64	{d18-d19}, [r3:64]
	sub	r3, fp, #20
	sub	r2, r3, #1488
	sub	r3, fp, #20
	sub	r3, r3, #1504
	vld1.64	{d18-d19}, [r2:64]
	vld1.64	{d16-d17}, [r3:64]
	vadd.i16	q8, q9, q8
	vstr	d16, [fp, #-636]
	vstr	d17, [fp, #-628]
	sub	r3, fp, #20
	sub	r3, r3, #1456
	vldr	d16, [fp, #-236]
	vldr	d17, [fp, #-228]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #1472
	vldr	d16, [fp, #-492]
	vldr	d17, [fp, #-484]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #1456
	vld1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #1472
	vld1.64	{d18-d19}, [r3:64]
	vabd.u8	q8, q8, q9
	sub	r3, fp, #20
	sub	r3, r3, #1440
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #1440
	vld1.64	{d16-d17}, [r3:64]
	vpaddl.u8	q8, q8
	vmov	q9, q8  @ v8hi
	sub	r3, fp, #20
	sub	r3, r3, #1408
	vldr	d16, [fp, #-636]
	vldr	d17, [fp, #-628]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #1424
	vst1.64	{d18-d19}, [r3:64]
	sub	r3, fp, #20
	sub	r2, r3, #1408
	sub	r3, fp, #20
	sub	r3, r3, #1424
	vld1.64	{d18-d19}, [r2:64]
	vld1.64	{d16-d17}, [r3:64]
	vadd.i16	q8, q9, q8
	vstr	d16, [fp, #-636]
	vstr	d17, [fp, #-628]
	sub	r3, fp, #20
	sub	r3, r3, #1376
	vldr	d16, [fp, #-252]
	vldr	d17, [fp, #-244]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #1392
	vldr	d16, [fp, #-508]
	vldr	d17, [fp, #-500]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #1376
	vld1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #1392
	vld1.64	{d18-d19}, [r3:64]
	vabd.u8	q8, q8, q9
	sub	r3, fp, #20
	sub	r3, r3, #1360
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #1360
	vld1.64	{d16-d17}, [r3:64]
	vpaddl.u8	q8, q8
	vmov	q9, q8  @ v8hi
	sub	r3, fp, #20
	sub	r3, r3, #1328
	vldr	d16, [fp, #-636]
	vldr	d17, [fp, #-628]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #1344
	vst1.64	{d18-d19}, [r3:64]
	sub	r3, fp, #20
	sub	r2, r3, #1328
	sub	r3, fp, #20
	sub	r3, r3, #1344
	vld1.64	{d18-d19}, [r2:64]
	vld1.64	{d16-d17}, [r3:64]
	vadd.i16	q8, q9, q8
	vstr	d16, [fp, #-636]
	vstr	d17, [fp, #-628]
	sub	r3, fp, #20
	sub	r3, r3, #1296
	vldr	d16, [fp, #-268]
	vldr	d17, [fp, #-260]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #1312
	vldr	d16, [fp, #-524]
	vldr	d17, [fp, #-516]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #1296
	vld1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #1312
	vld1.64	{d18-d19}, [r3:64]
	vabd.u8	q8, q8, q9
	sub	r3, fp, #20
	sub	r3, r3, #1280
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #1280
	vld1.64	{d16-d17}, [r3:64]
	vpaddl.u8	q8, q8
	vmov	q9, q8  @ v8hi
	sub	r3, fp, #20
	sub	r3, r3, #1248
	vldr	d16, [fp, #-636]
	vldr	d17, [fp, #-628]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #1264
	vst1.64	{d18-d19}, [r3:64]
	sub	r3, fp, #20
	sub	r2, r3, #1248
	sub	r3, fp, #20
	sub	r3, r3, #1264
	vld1.64	{d18-d19}, [r2:64]
	vld1.64	{d16-d17}, [r3:64]
	vadd.i16	q8, q9, q8
	vstr	d16, [fp, #-636]
	vstr	d17, [fp, #-628]
	sub	r3, fp, #20
	sub	r3, r3, #1216
	vldr	d16, [fp, #-284]
	vldr	d17, [fp, #-276]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #1232
	vldr	d16, [fp, #-540]
	vldr	d17, [fp, #-532]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #1216
	vld1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #1232
	vld1.64	{d18-d19}, [r3:64]
	vabd.u8	q8, q8, q9
	sub	r3, fp, #20
	sub	r3, r3, #1200
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #1200
	vld1.64	{d16-d17}, [r3:64]
	vpaddl.u8	q8, q8
	vmov	q9, q8  @ v8hi
	sub	r3, fp, #20
	sub	r3, r3, #1168
	vldr	d16, [fp, #-636]
	vldr	d17, [fp, #-628]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #1184
	vst1.64	{d18-d19}, [r3:64]
	sub	r3, fp, #20
	sub	r2, r3, #1168
	sub	r3, fp, #20
	sub	r3, r3, #1184
	vld1.64	{d18-d19}, [r2:64]
	vld1.64	{d16-d17}, [r3:64]
	vadd.i16	q8, q9, q8
	vstr	d16, [fp, #-636]
	vstr	d17, [fp, #-628]
	sub	r3, fp, #20
	sub	r3, r3, #1136
	vldr	d16, [fp, #-300]
	vldr	d17, [fp, #-292]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #1152
	vldr	d16, [fp, #-556]
	vldr	d17, [fp, #-548]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #1136
	vld1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #1152
	vld1.64	{d18-d19}, [r3:64]
	vabd.u8	q8, q8, q9
	sub	r3, fp, #20
	sub	r3, r3, #1120
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #1120
	vld1.64	{d16-d17}, [r3:64]
	vpaddl.u8	q8, q8
	vmov	q9, q8  @ v8hi
	sub	r3, fp, #20
	sub	r3, r3, #1088
	vldr	d16, [fp, #-636]
	vldr	d17, [fp, #-628]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #1104
	vst1.64	{d18-d19}, [r3:64]
	sub	r3, fp, #20
	sub	r2, r3, #1088
	sub	r3, fp, #20
	sub	r3, r3, #1104
	vld1.64	{d18-d19}, [r2:64]
	vld1.64	{d16-d17}, [r3:64]
	vadd.i16	q8, q9, q8
	vstr	d16, [fp, #-636]
	vstr	d17, [fp, #-628]
	sub	r3, fp, #20
	sub	r3, r3, #1056
	vldr	d16, [fp, #-316]
	vldr	d17, [fp, #-308]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #1072
	vldr	d16, [fp, #-572]
	vldr	d17, [fp, #-564]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #1056
	vld1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #1072
	vld1.64	{d18-d19}, [r3:64]
	vabd.u8	q8, q8, q9
	sub	r3, fp, #20
	sub	r3, r3, #1040
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #1040
	vld1.64	{d16-d17}, [r3:64]
	vpaddl.u8	q8, q8
	vmov	q9, q8  @ v8hi
	vldr	d16, [fp, #-636]
	vldr	d17, [fp, #-628]
	sub	r3, fp, #1024
	sub	r3, r3, #4
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #1024
	vst1.64	{d18-d19}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #1024
	sub	r2, fp, #1024
	sub	r2, r2, #4
	vld1.64	{d18-d19}, [r2:64]
	vld1.64	{d16-d17}, [r3:64]
	vadd.i16	q8, q9, q8
	vstr	d16, [fp, #-636]
	vstr	d17, [fp, #-628]
	vldr	d16, [fp, #-332]
	vldr	d17, [fp, #-324]
	vstr	d16, [fp, #-996]
	vstr	d17, [fp, #-988]
	vldr	d16, [fp, #-588]
	vldr	d17, [fp, #-580]
	vstr	d16, [fp, #-1012]
	vstr	d17, [fp, #-1004]
	vldr	d16, [fp, #-996]
	vldr	d17, [fp, #-988]
	vldr	d18, [fp, #-1012]
	vldr	d19, [fp, #-1004]
	vabd.u8	q8, q8, q9
	vstr	d16, [fp, #-980]
	vstr	d17, [fp, #-972]
	vldr	d16, [fp, #-980]
	vldr	d17, [fp, #-972]
	vpaddl.u8	q8, q8
	vmov	q9, q8  @ v8hi
	vldr	d16, [fp, #-636]
	vldr	d17, [fp, #-628]
	vstr	d16, [fp, #-948]
	vstr	d17, [fp, #-940]
	vstr	d18, [fp, #-964]
	vstr	d19, [fp, #-956]
	vldr	d18, [fp, #-948]
	vldr	d19, [fp, #-940]
	vldr	d16, [fp, #-964]
	vldr	d17, [fp, #-956]
	vadd.i16	q8, q9, q8
	vstr	d16, [fp, #-636]
	vstr	d17, [fp, #-628]
	vldr	d16, [fp, #-348]
	vldr	d17, [fp, #-340]
	vstr	d16, [fp, #-916]
	vstr	d17, [fp, #-908]
	vldr	d16, [fp, #-604]
	vldr	d17, [fp, #-596]
	vstr	d16, [fp, #-932]
	vstr	d17, [fp, #-924]
	vldr	d16, [fp, #-916]
	vldr	d17, [fp, #-908]
	vldr	d18, [fp, #-932]
	vldr	d19, [fp, #-924]
	vabd.u8	q8, q8, q9
	vstr	d16, [fp, #-900]
	vstr	d17, [fp, #-892]
	vldr	d16, [fp, #-900]
	vldr	d17, [fp, #-892]
	vpaddl.u8	q8, q8
	vmov	q9, q8  @ v8hi
	vldr	d16, [fp, #-636]
	vldr	d17, [fp, #-628]
	vstr	d16, [fp, #-868]
	vstr	d17, [fp, #-860]
	vstr	d18, [fp, #-884]
	vstr	d19, [fp, #-876]
	vldr	d18, [fp, #-868]
	vldr	d19, [fp, #-860]
	vldr	d16, [fp, #-884]
	vldr	d17, [fp, #-876]
	vadd.i16	q8, q9, q8
	vstr	d16, [fp, #-636]
	vstr	d17, [fp, #-628]
	vldr	d16, [fp, #-364]
	vldr	d17, [fp, #-356]
	vstr	d16, [fp, #-836]
	vstr	d17, [fp, #-828]
	vldr	d16, [fp, #-620]
	vldr	d17, [fp, #-612]
	vstr	d16, [fp, #-852]
	vstr	d17, [fp, #-844]
	vldr	d16, [fp, #-836]
	vldr	d17, [fp, #-828]
	vldr	d18, [fp, #-852]
	vldr	d19, [fp, #-844]
	vabd.u8	q8, q8, q9
	vstr	d16, [fp, #-820]
	vstr	d17, [fp, #-812]
	vldr	d16, [fp, #-820]
	vldr	d17, [fp, #-812]
	vpaddl.u8	q8, q8
	vmov	q9, q8  @ v8hi
	vldr	d16, [fp, #-636]
	vldr	d17, [fp, #-628]
	vstr	d16, [fp, #-788]
	vstr	d17, [fp, #-780]
	vstr	d18, [fp, #-804]
	vstr	d19, [fp, #-796]
	vldr	d18, [fp, #-788]
	vldr	d19, [fp, #-780]
	vldr	d16, [fp, #-804]
	vldr	d17, [fp, #-796]
	vadd.i16	q8, q9, q8
	vstr	d16, [fp, #-636]
	vstr	d17, [fp, #-628]
	vldr	d16, [fp, #-636]
	vldr	d17, [fp, #-628]
	vstr	d16, [fp, #-772]
	vstr	d17, [fp, #-764]
	vldr	d16, [fp, #-772]
	vldr	d17, [fp, #-764]
	vmov.u16	r3, d16[0]
	uxth	r3, r3
	mov	r4, r3
	vldr	d16, [fp, #-636]
	vldr	d17, [fp, #-628]
	vstr	d16, [fp, #-756]
	vstr	d17, [fp, #-748]
	vldr	d16, [fp, #-756]
	vldr	d17, [fp, #-748]
	vmov.u16	r3, d16[1]
	uxth	r3, r3
	add	r3, r3, r4
	uxth	r4, r3
	vldr	d16, [fp, #-636]
	vldr	d17, [fp, #-628]
	vstr	d16, [fp, #-740]
	vstr	d17, [fp, #-732]
	vldr	d16, [fp, #-740]
	vldr	d17, [fp, #-732]
	vmov.u16	r3, d16[2]
	uxth	r3, r3
	add	r3, r3, r4
	uxth	r4, r3
	vldr	d16, [fp, #-636]
	vldr	d17, [fp, #-628]
	vstr	d16, [fp, #-724]
	vstr	d17, [fp, #-716]
	vldr	d16, [fp, #-724]
	vldr	d17, [fp, #-716]
	vmov.u16	r3, d16[3]
	uxth	r3, r3
	add	r3, r3, r4
	uxth	r4, r3
	vldr	d16, [fp, #-636]
	vldr	d17, [fp, #-628]
	vstr	d16, [fp, #-708]
	vstr	d17, [fp, #-700]
	vldr	d16, [fp, #-708]
	vldr	d17, [fp, #-700]
	vmov.u16	r3, d17[0]
	uxth	r3, r3
	add	r3, r3, r4
	uxth	r4, r3
	vldr	d16, [fp, #-636]
	vldr	d17, [fp, #-628]
	vstr	d16, [fp, #-692]
	vstr	d17, [fp, #-684]
	vldr	d16, [fp, #-692]
	vldr	d17, [fp, #-684]
	vmov.u16	r3, d17[1]
	uxth	r3, r3
	add	r3, r3, r4
	uxth	r4, r3
	vldr	d16, [fp, #-636]
	vldr	d17, [fp, #-628]
	vstr	d16, [fp, #-676]
	vstr	d17, [fp, #-668]
	vldr	d16, [fp, #-676]
	vldr	d17, [fp, #-668]
	vmov.u16	r3, d17[2]
	uxth	r3, r3
	add	r3, r3, r4
	uxth	r4, r3
	vldr	d16, [fp, #-636]
	vldr	d17, [fp, #-628]
	vstr	d16, [fp, #-660]
	vstr	d17, [fp, #-652]
	vldr	d16, [fp, #-660]
	vldr	d17, [fp, #-652]
	vmov.u16	r3, d17[3]
	uxth	r3, r3
	add	r3, r3, r4
	uxth	r4, r3
	lsr	r3, r5, #1
	ldr	r2, [fp, #-88]
	ldr	r1, [fp, #-32]
	mul	r1, r1, r3
	ldr	r3, [fp, #-28]
	add	r3, r1, r3
	lsl	r3, r3, #1
	add	r3, r2, r3
	ldrh	r3, [r3]
	cmp	r4, r3
	bcs	.L113
	lsr	r3, r5, #1
	ldr	r2, [fp, #-88]
	ldr	r1, [fp, #-32]
	mul	r1, r1, r3
	ldr	r3, [fp, #-28]
	add	r3, r1, r3
	lsl	r3, r3, #1
	add	r3, r2, r3
	strh	r4, [r3]	@ movhi
	ldr	r3, [fp, #-32]
	lsl	r3, r3, #2
	ldr	r2, [fp, #-72]
	add	r3, r2, r3
	ldr	r2, [r3]
	ldr	r3, [fp, #-28]
	lsl	r3, r3, #2
	add	r3, r2, r3
	mov	r2, #0
	str	r2, [r3]
	ldr	r3, [fp, #-32]
	lsl	r3, r3, #2
	ldr	r2, [fp, #-76]
	add	r3, r2, r3
	ldr	r2, [r3]
	ldr	r3, [fp, #-28]
	lsl	r3, r3, #2
	add	r3, r2, r3
	mov	r2, #0
	str	r2, [r3]
	cmp	r4, #0
	bne	.L113
	mov	r3, #17
	str	r3, [fp, #-48]
	mov	r3, #17
	str	r3, [fp, #-24]
	b	.L113
.L188:
	ldr	r3, [fp, #-24]
	cmp	r3, #0
	bne	.L115
	ldr	r3, [fp, #-48]
	cmp	r3, #0
	beq	.L196
.L115:
	ldr	r2, [fp, #-36]
	ldr	r3, [fp, #-48]
	add	r3, r2, r3
	lsl	r3, r3, #2
	ldr	r2, [fp, #-3592]
	add	r3, r2, r3
	ldr	r3, [r3]
	ldr	r1, [fp, #-40]
	ldr	r2, [fp, #-24]
	add	r2, r1, r2
	add	r3, r3, r2
	str	r3, [fp, #-3588]
	ldr	r3, [fp, #-3588]
	vld1.8	{d16-d17}, [r3]
	vstr	d16, [fp, #-380]
	vstr	d17, [fp, #-372]
	ldr	r2, [fp, #-36]
	ldr	r3, [fp, #-48]
	add	r3, r2, r3
	add	r3, r3, #1
	lsl	r3, r3, #2
	ldr	r2, [fp, #-3592]
	add	r3, r2, r3
	ldr	r3, [r3]
	ldr	r1, [fp, #-40]
	ldr	r2, [fp, #-24]
	add	r2, r1, r2
	add	r3, r3, r2
	str	r3, [fp, #-3584]
	ldr	r3, [fp, #-3584]
	vld1.8	{d16-d17}, [r3]
	vstr	d16, [fp, #-396]
	vstr	d17, [fp, #-388]
	ldr	r2, [fp, #-36]
	ldr	r3, [fp, #-48]
	add	r3, r2, r3
	add	r3, r3, #2
	lsl	r3, r3, #2
	ldr	r2, [fp, #-3592]
	add	r3, r2, r3
	ldr	r3, [r3]
	ldr	r1, [fp, #-40]
	ldr	r2, [fp, #-24]
	add	r2, r1, r2
	add	r3, r3, r2
	str	r3, [fp, #-3580]
	ldr	r3, [fp, #-3580]
	vld1.8	{d16-d17}, [r3]
	vstr	d16, [fp, #-412]
	vstr	d17, [fp, #-404]
	ldr	r2, [fp, #-36]
	ldr	r3, [fp, #-48]
	add	r3, r2, r3
	add	r3, r3, #3
	lsl	r3, r3, #2
	ldr	r2, [fp, #-3592]
	add	r3, r2, r3
	ldr	r3, [r3]
	ldr	r1, [fp, #-40]
	ldr	r2, [fp, #-24]
	add	r2, r1, r2
	add	r3, r3, r2
	str	r3, [fp, #-3576]
	ldr	r3, [fp, #-3576]
	vld1.8	{d16-d17}, [r3]
	vstr	d16, [fp, #-428]
	vstr	d17, [fp, #-420]
	ldr	r2, [fp, #-36]
	ldr	r3, [fp, #-48]
	add	r3, r2, r3
	add	r3, r3, #4
	lsl	r3, r3, #2
	ldr	r2, [fp, #-3592]
	add	r3, r2, r3
	ldr	r3, [r3]
	ldr	r1, [fp, #-40]
	ldr	r2, [fp, #-24]
	add	r2, r1, r2
	add	r3, r3, r2
	str	r3, [fp, #-3572]
	ldr	r3, [fp, #-3572]
	vld1.8	{d16-d17}, [r3]
	vstr	d16, [fp, #-444]
	vstr	d17, [fp, #-436]
	ldr	r2, [fp, #-36]
	ldr	r3, [fp, #-48]
	add	r3, r2, r3
	add	r3, r3, #5
	lsl	r3, r3, #2
	ldr	r2, [fp, #-3592]
	add	r3, r2, r3
	ldr	r3, [r3]
	ldr	r1, [fp, #-40]
	ldr	r2, [fp, #-24]
	add	r2, r1, r2
	add	r3, r3, r2
	str	r3, [fp, #-3568]
	ldr	r3, [fp, #-3568]
	vld1.8	{d16-d17}, [r3]
	vstr	d16, [fp, #-460]
	vstr	d17, [fp, #-452]
	ldr	r2, [fp, #-36]
	ldr	r3, [fp, #-48]
	add	r3, r2, r3
	add	r3, r3, #6
	lsl	r3, r3, #2
	ldr	r2, [fp, #-3592]
	add	r3, r2, r3
	ldr	r3, [r3]
	ldr	r1, [fp, #-40]
	ldr	r2, [fp, #-24]
	add	r2, r1, r2
	add	r3, r3, r2
	str	r3, [fp, #-3564]
	ldr	r3, [fp, #-3564]
	vld1.8	{d16-d17}, [r3]
	vstr	d16, [fp, #-476]
	vstr	d17, [fp, #-468]
	ldr	r2, [fp, #-36]
	ldr	r3, [fp, #-48]
	add	r3, r2, r3
	add	r3, r3, #7
	lsl	r3, r3, #2
	ldr	r2, [fp, #-3592]
	add	r3, r2, r3
	ldr	r3, [r3]
	ldr	r1, [fp, #-40]
	ldr	r2, [fp, #-24]
	add	r2, r1, r2
	add	r3, r3, r2
	str	r3, [fp, #-3560]
	ldr	r3, [fp, #-3560]
	vld1.8	{d16-d17}, [r3]
	vstr	d16, [fp, #-492]
	vstr	d17, [fp, #-484]
	ldr	r2, [fp, #-36]
	ldr	r3, [fp, #-48]
	add	r3, r2, r3
	add	r3, r3, #8
	lsl	r3, r3, #2
	ldr	r2, [fp, #-3592]
	add	r3, r2, r3
	ldr	r3, [r3]
	ldr	r1, [fp, #-40]
	ldr	r2, [fp, #-24]
	add	r2, r1, r2
	add	r3, r3, r2
	str	r3, [fp, #-3556]
	ldr	r3, [fp, #-3556]
	vld1.8	{d16-d17}, [r3]
	vstr	d16, [fp, #-508]
	vstr	d17, [fp, #-500]
	ldr	r2, [fp, #-36]
	ldr	r3, [fp, #-48]
	add	r3, r2, r3
	add	r3, r3, #9
	lsl	r3, r3, #2
	ldr	r2, [fp, #-3592]
	add	r3, r2, r3
	ldr	r3, [r3]
	ldr	r1, [fp, #-40]
	ldr	r2, [fp, #-24]
	add	r2, r1, r2
	add	r3, r3, r2
	str	r3, [fp, #-3552]
	ldr	r3, [fp, #-3552]
	vld1.8	{d16-d17}, [r3]
	vstr	d16, [fp, #-524]
	vstr	d17, [fp, #-516]
	ldr	r2, [fp, #-36]
	ldr	r3, [fp, #-48]
	add	r3, r2, r3
	add	r3, r3, #10
	lsl	r3, r3, #2
	ldr	r2, [fp, #-3592]
	add	r3, r2, r3
	ldr	r3, [r3]
	ldr	r1, [fp, #-40]
	ldr	r2, [fp, #-24]
	add	r2, r1, r2
	add	r3, r3, r2
	str	r3, [fp, #-3548]
	ldr	r3, [fp, #-3548]
	vld1.8	{d16-d17}, [r3]
	vstr	d16, [fp, #-540]
	vstr	d17, [fp, #-532]
	ldr	r2, [fp, #-36]
	ldr	r3, [fp, #-48]
	add	r3, r2, r3
	add	r3, r3, #11
	lsl	r3, r3, #2
	ldr	r2, [fp, #-3592]
	add	r3, r2, r3
	ldr	r3, [r3]
	ldr	r1, [fp, #-40]
	ldr	r2, [fp, #-24]
	add	r2, r1, r2
	add	r3, r3, r2
	str	r3, [fp, #-3544]
	ldr	r3, [fp, #-3544]
	vld1.8	{d16-d17}, [r3]
	vstr	d16, [fp, #-556]
	vstr	d17, [fp, #-548]
	ldr	r2, [fp, #-36]
	ldr	r3, [fp, #-48]
	add	r3, r2, r3
	add	r3, r3, #12
	lsl	r3, r3, #2
	ldr	r2, [fp, #-3592]
	add	r3, r2, r3
	ldr	r3, [r3]
	ldr	r1, [fp, #-40]
	ldr	r2, [fp, #-24]
	add	r2, r1, r2
	add	r3, r3, r2
	str	r3, [fp, #-3540]
	ldr	r3, [fp, #-3540]
	vld1.8	{d16-d17}, [r3]
	vstr	d16, [fp, #-572]
	vstr	d17, [fp, #-564]
	ldr	r2, [fp, #-36]
	ldr	r3, [fp, #-48]
	add	r3, r2, r3
	add	r3, r3, #13
	lsl	r3, r3, #2
	ldr	r2, [fp, #-3592]
	add	r3, r2, r3
	ldr	r3, [r3]
	ldr	r1, [fp, #-40]
	ldr	r2, [fp, #-24]
	add	r2, r1, r2
	add	r3, r3, r2
	str	r3, [fp, #-3536]
	ldr	r3, [fp, #-3536]
	vld1.8	{d16-d17}, [r3]
	vstr	d16, [fp, #-588]
	vstr	d17, [fp, #-580]
	ldr	r2, [fp, #-36]
	ldr	r3, [fp, #-48]
	add	r3, r2, r3
	add	r3, r3, #14
	lsl	r3, r3, #2
	ldr	r2, [fp, #-3592]
	add	r3, r2, r3
	ldr	r3, [r3]
	ldr	r1, [fp, #-40]
	ldr	r2, [fp, #-24]
	add	r2, r1, r2
	add	r3, r3, r2
	str	r3, [fp, #-3532]
	ldr	r3, [fp, #-3532]
	vld1.8	{d16-d17}, [r3]
	vstr	d16, [fp, #-604]
	vstr	d17, [fp, #-596]
	ldr	r2, [fp, #-36]
	ldr	r3, [fp, #-48]
	add	r3, r2, r3
	add	r3, r3, #15
	lsl	r3, r3, #2
	ldr	r2, [fp, #-3592]
	add	r3, r2, r3
	ldr	r3, [r3]
	ldr	r1, [fp, #-40]
	ldr	r2, [fp, #-24]
	add	r2, r1, r2
	add	r3, r3, r2
	str	r3, [fp, #-3528]
	ldr	r3, [fp, #-3528]
	vld1.8	{d16-d17}, [r3]
	vstr	d16, [fp, #-620]
	vstr	d17, [fp, #-612]
	sub	r3, fp, #20
	sub	r3, r3, #3488
	vldr	d16, [fp, #-124]
	vldr	d17, [fp, #-116]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #3504
	vldr	d16, [fp, #-380]
	vldr	d17, [fp, #-372]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #3488
	vld1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #3504
	vld1.64	{d18-d19}, [r3:64]
	vabd.u8	q8, q8, q9
	sub	r3, fp, #20
	sub	r3, r3, #3472
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #3472
	vld1.64	{d16-d17}, [r3:64]
	vpaddl.u8	q8, q8
	vstr	d16, [fp, #-636]
	vstr	d17, [fp, #-628]
	sub	r3, fp, #20
	sub	r3, r3, #3440
	vldr	d16, [fp, #-140]
	vldr	d17, [fp, #-132]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #3456
	vldr	d16, [fp, #-396]
	vldr	d17, [fp, #-388]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #3440
	vld1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #3456
	vld1.64	{d18-d19}, [r3:64]
	vabd.u8	q8, q8, q9
	sub	r3, fp, #20
	sub	r3, r3, #3424
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #3424
	vld1.64	{d16-d17}, [r3:64]
	vpaddl.u8	q8, q8
	vmov	q9, q8  @ v8hi
	sub	r3, fp, #20
	sub	r3, r3, #3392
	vldr	d16, [fp, #-636]
	vldr	d17, [fp, #-628]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #3408
	vst1.64	{d18-d19}, [r3:64]
	sub	r3, fp, #20
	sub	r2, r3, #3392
	sub	r3, fp, #20
	sub	r3, r3, #3408
	vld1.64	{d18-d19}, [r2:64]
	vld1.64	{d16-d17}, [r3:64]
	vadd.i16	q8, q9, q8
	vstr	d16, [fp, #-636]
	vstr	d17, [fp, #-628]
	sub	r3, fp, #20
	sub	r3, r3, #3360
	vldr	d16, [fp, #-156]
	vldr	d17, [fp, #-148]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #3376
	vldr	d16, [fp, #-412]
	vldr	d17, [fp, #-404]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #3360
	vld1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #3376
	vld1.64	{d18-d19}, [r3:64]
	vabd.u8	q8, q8, q9
	sub	r3, fp, #20
	sub	r3, r3, #3344
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #3344
	vld1.64	{d16-d17}, [r3:64]
	vpaddl.u8	q8, q8
	vmov	q9, q8  @ v8hi
	sub	r3, fp, #20
	sub	r3, r3, #3312
	vldr	d16, [fp, #-636]
	vldr	d17, [fp, #-628]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #3328
	vst1.64	{d18-d19}, [r3:64]
	sub	r3, fp, #20
	sub	r2, r3, #3312
	sub	r3, fp, #20
	sub	r3, r3, #3328
	vld1.64	{d18-d19}, [r2:64]
	vld1.64	{d16-d17}, [r3:64]
	vadd.i16	q8, q9, q8
	vstr	d16, [fp, #-636]
	vstr	d17, [fp, #-628]
	sub	r3, fp, #20
	sub	r3, r3, #3280
	vldr	d16, [fp, #-172]
	vldr	d17, [fp, #-164]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #3296
	vldr	d16, [fp, #-428]
	vldr	d17, [fp, #-420]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #3280
	vld1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #3296
	vld1.64	{d18-d19}, [r3:64]
	vabd.u8	q8, q8, q9
	sub	r3, fp, #20
	sub	r3, r3, #3264
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #3264
	vld1.64	{d16-d17}, [r3:64]
	vpaddl.u8	q8, q8
	vmov	q9, q8  @ v8hi
	sub	r3, fp, #20
	sub	r3, r3, #3232
	vldr	d16, [fp, #-636]
	vldr	d17, [fp, #-628]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #3248
	vst1.64	{d18-d19}, [r3:64]
	sub	r3, fp, #20
	sub	r2, r3, #3232
	sub	r3, fp, #20
	sub	r3, r3, #3248
	vld1.64	{d18-d19}, [r2:64]
	vld1.64	{d16-d17}, [r3:64]
	vadd.i16	q8, q9, q8
	vstr	d16, [fp, #-636]
	vstr	d17, [fp, #-628]
	sub	r3, fp, #20
	sub	r3, r3, #3200
	vldr	d16, [fp, #-188]
	vldr	d17, [fp, #-180]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #3216
	vldr	d16, [fp, #-444]
	vldr	d17, [fp, #-436]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #3200
	vld1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #3216
	vld1.64	{d18-d19}, [r3:64]
	vabd.u8	q8, q8, q9
	sub	r3, fp, #20
	sub	r3, r3, #3184
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #3184
	vld1.64	{d16-d17}, [r3:64]
	vpaddl.u8	q8, q8
	vmov	q9, q8  @ v8hi
	sub	r3, fp, #20
	sub	r3, r3, #3152
	vldr	d16, [fp, #-636]
	vldr	d17, [fp, #-628]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #3168
	vst1.64	{d18-d19}, [r3:64]
	sub	r3, fp, #20
	sub	r2, r3, #3152
	sub	r3, fp, #20
	sub	r3, r3, #3168
	vld1.64	{d18-d19}, [r2:64]
	vld1.64	{d16-d17}, [r3:64]
	vadd.i16	q8, q9, q8
	vstr	d16, [fp, #-636]
	vstr	d17, [fp, #-628]
	sub	r3, fp, #20
	sub	r3, r3, #3120
	vldr	d16, [fp, #-204]
	vldr	d17, [fp, #-196]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #3136
	vldr	d16, [fp, #-460]
	vldr	d17, [fp, #-452]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #3120
	vld1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #3136
	vld1.64	{d18-d19}, [r3:64]
	vabd.u8	q8, q8, q9
	sub	r3, fp, #20
	sub	r3, r3, #3104
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #3104
	vld1.64	{d16-d17}, [r3:64]
	vpaddl.u8	q8, q8
	vmov	q9, q8  @ v8hi
	sub	r3, fp, #20
	sub	r3, r3, #3072
	vldr	d16, [fp, #-636]
	vldr	d17, [fp, #-628]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #3088
	vst1.64	{d18-d19}, [r3:64]
	sub	r3, fp, #20
	sub	r2, r3, #3072
	sub	r3, fp, #20
	sub	r3, r3, #3088
	vld1.64	{d18-d19}, [r2:64]
	vld1.64	{d16-d17}, [r3:64]
	vadd.i16	q8, q9, q8
	vstr	d16, [fp, #-636]
	vstr	d17, [fp, #-628]
	sub	r3, fp, #20
	sub	r3, r3, #3040
	vldr	d16, [fp, #-220]
	vldr	d17, [fp, #-212]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #3056
	vldr	d16, [fp, #-476]
	vldr	d17, [fp, #-468]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #3040
	vld1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #3056
	vld1.64	{d18-d19}, [r3:64]
	vabd.u8	q8, q8, q9
	sub	r3, fp, #20
	sub	r3, r3, #3024
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #3024
	vld1.64	{d16-d17}, [r3:64]
	vpaddl.u8	q8, q8
	vmov	q9, q8  @ v8hi
	sub	r3, fp, #20
	sub	r3, r3, #2992
	vldr	d16, [fp, #-636]
	vldr	d17, [fp, #-628]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #3008
	vst1.64	{d18-d19}, [r3:64]
	sub	r3, fp, #20
	sub	r2, r3, #2992
	sub	r3, fp, #20
	sub	r3, r3, #3008
	vld1.64	{d18-d19}, [r2:64]
	vld1.64	{d16-d17}, [r3:64]
	vadd.i16	q8, q9, q8
	vstr	d16, [fp, #-636]
	vstr	d17, [fp, #-628]
	sub	r3, fp, #20
	sub	r3, r3, #2960
	vldr	d16, [fp, #-236]
	vldr	d17, [fp, #-228]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #2976
	vldr	d16, [fp, #-492]
	vldr	d17, [fp, #-484]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #2960
	vld1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #2976
	vld1.64	{d18-d19}, [r3:64]
	vabd.u8	q8, q8, q9
	sub	r3, fp, #20
	sub	r3, r3, #2944
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #2944
	vld1.64	{d16-d17}, [r3:64]
	vpaddl.u8	q8, q8
	vmov	q9, q8  @ v8hi
	sub	r3, fp, #20
	sub	r3, r3, #2912
	vldr	d16, [fp, #-636]
	vldr	d17, [fp, #-628]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #2928
	vst1.64	{d18-d19}, [r3:64]
	sub	r3, fp, #20
	sub	r2, r3, #2912
	sub	r3, fp, #20
	sub	r3, r3, #2928
	vld1.64	{d18-d19}, [r2:64]
	vld1.64	{d16-d17}, [r3:64]
	vadd.i16	q8, q9, q8
	vstr	d16, [fp, #-636]
	vstr	d17, [fp, #-628]
	sub	r3, fp, #20
	sub	r3, r3, #2880
	vldr	d16, [fp, #-252]
	vldr	d17, [fp, #-244]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #2896
	vldr	d16, [fp, #-508]
	vldr	d17, [fp, #-500]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #2880
	vld1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #2896
	vld1.64	{d18-d19}, [r3:64]
	vabd.u8	q8, q8, q9
	sub	r3, fp, #20
	sub	r3, r3, #2864
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #2864
	vld1.64	{d16-d17}, [r3:64]
	vpaddl.u8	q8, q8
	vmov	q9, q8  @ v8hi
	sub	r3, fp, #20
	sub	r3, r3, #2832
	vldr	d16, [fp, #-636]
	vldr	d17, [fp, #-628]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #2848
	vst1.64	{d18-d19}, [r3:64]
	sub	r3, fp, #20
	sub	r2, r3, #2832
	sub	r3, fp, #20
	sub	r3, r3, #2848
	vld1.64	{d18-d19}, [r2:64]
	vld1.64	{d16-d17}, [r3:64]
	vadd.i16	q8, q9, q8
	vstr	d16, [fp, #-636]
	vstr	d17, [fp, #-628]
	sub	r3, fp, #20
	sub	r3, r3, #2800
	vldr	d16, [fp, #-268]
	vldr	d17, [fp, #-260]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #2816
	vldr	d16, [fp, #-524]
	vldr	d17, [fp, #-516]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #2800
	vld1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #2816
	vld1.64	{d18-d19}, [r3:64]
	vabd.u8	q8, q8, q9
	sub	r3, fp, #20
	sub	r3, r3, #2784
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #2784
	vld1.64	{d16-d17}, [r3:64]
	vpaddl.u8	q8, q8
	vmov	q9, q8  @ v8hi
	sub	r3, fp, #20
	sub	r3, r3, #2752
	vldr	d16, [fp, #-636]
	vldr	d17, [fp, #-628]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #2768
	vst1.64	{d18-d19}, [r3:64]
	sub	r3, fp, #20
	sub	r2, r3, #2752
	sub	r3, fp, #20
	sub	r3, r3, #2768
	vld1.64	{d18-d19}, [r2:64]
	vld1.64	{d16-d17}, [r3:64]
	vadd.i16	q8, q9, q8
	vstr	d16, [fp, #-636]
	vstr	d17, [fp, #-628]
	sub	r3, fp, #20
	sub	r3, r3, #2720
	vldr	d16, [fp, #-284]
	vldr	d17, [fp, #-276]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #2736
	vldr	d16, [fp, #-540]
	vldr	d17, [fp, #-532]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #2720
	vld1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #2736
	vld1.64	{d18-d19}, [r3:64]
	vabd.u8	q8, q8, q9
	sub	r3, fp, #20
	sub	r3, r3, #2704
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #2704
	vld1.64	{d16-d17}, [r3:64]
	vpaddl.u8	q8, q8
	vmov	q9, q8  @ v8hi
	sub	r3, fp, #20
	sub	r3, r3, #2672
	vldr	d16, [fp, #-636]
	vldr	d17, [fp, #-628]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #2688
	vst1.64	{d18-d19}, [r3:64]
	sub	r3, fp, #20
	sub	r2, r3, #2672
	sub	r3, fp, #20
	sub	r3, r3, #2688
	vld1.64	{d18-d19}, [r2:64]
	vld1.64	{d16-d17}, [r3:64]
	vadd.i16	q8, q9, q8
	vstr	d16, [fp, #-636]
	vstr	d17, [fp, #-628]
	sub	r3, fp, #20
	sub	r3, r3, #2640
	vldr	d16, [fp, #-300]
	vldr	d17, [fp, #-292]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #2656
	vldr	d16, [fp, #-556]
	vldr	d17, [fp, #-548]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #2640
	vld1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #2656
	vld1.64	{d18-d19}, [r3:64]
	vabd.u8	q8, q8, q9
	sub	r3, fp, #20
	sub	r3, r3, #2624
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #2624
	vld1.64	{d16-d17}, [r3:64]
	vpaddl.u8	q8, q8
	vmov	q9, q8  @ v8hi
	sub	r3, fp, #20
	sub	r3, r3, #2592
	vldr	d16, [fp, #-636]
	vldr	d17, [fp, #-628]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #2608
	vst1.64	{d18-d19}, [r3:64]
	sub	r3, fp, #20
	sub	r2, r3, #2592
	sub	r3, fp, #20
	sub	r3, r3, #2608
	vld1.64	{d18-d19}, [r2:64]
	vld1.64	{d16-d17}, [r3:64]
	vadd.i16	q8, q9, q8
	vstr	d16, [fp, #-636]
	vstr	d17, [fp, #-628]
	sub	r3, fp, #20
	sub	r3, r3, #2560
	vldr	d16, [fp, #-316]
	vldr	d17, [fp, #-308]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #2576
	vldr	d16, [fp, #-572]
	vldr	d17, [fp, #-564]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #2560
	vld1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #2576
	vld1.64	{d18-d19}, [r3:64]
	vabd.u8	q8, q8, q9
	sub	r3, fp, #20
	sub	r3, r3, #2544
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #2544
	vld1.64	{d16-d17}, [r3:64]
	vpaddl.u8	q8, q8
	vmov	q9, q8  @ v8hi
	sub	r3, fp, #20
	sub	r3, r3, #2512
	vldr	d16, [fp, #-636]
	vldr	d17, [fp, #-628]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #2528
	vst1.64	{d18-d19}, [r3:64]
	sub	r3, fp, #20
	sub	r2, r3, #2512
	sub	r3, fp, #20
	sub	r3, r3, #2528
	vld1.64	{d18-d19}, [r2:64]
	vld1.64	{d16-d17}, [r3:64]
	vadd.i16	q8, q9, q8
	vstr	d16, [fp, #-636]
	vstr	d17, [fp, #-628]
	sub	r3, fp, #20
	sub	r3, r3, #2480
	vldr	d16, [fp, #-332]
	vldr	d17, [fp, #-324]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #2496
	vldr	d16, [fp, #-588]
	vldr	d17, [fp, #-580]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #2480
	vld1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #2496
	vld1.64	{d18-d19}, [r3:64]
	vabd.u8	q8, q8, q9
	sub	r3, fp, #20
	sub	r3, r3, #2464
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #2464
	vld1.64	{d16-d17}, [r3:64]
	vpaddl.u8	q8, q8
	vmov	q9, q8  @ v8hi
	sub	r3, fp, #20
	sub	r3, r3, #2432
	vldr	d16, [fp, #-636]
	vldr	d17, [fp, #-628]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #2448
	vst1.64	{d18-d19}, [r3:64]
	sub	r3, fp, #20
	sub	r2, r3, #2432
	sub	r3, fp, #20
	sub	r3, r3, #2448
	vld1.64	{d18-d19}, [r2:64]
	vld1.64	{d16-d17}, [r3:64]
	vadd.i16	q8, q9, q8
	vstr	d16, [fp, #-636]
	vstr	d17, [fp, #-628]
	sub	r3, fp, #20
	sub	r3, r3, #2400
	vldr	d16, [fp, #-348]
	vldr	d17, [fp, #-340]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #2416
	vldr	d16, [fp, #-604]
	vldr	d17, [fp, #-596]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #2400
	vld1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #2416
	vld1.64	{d18-d19}, [r3:64]
	vabd.u8	q8, q8, q9
	sub	r3, fp, #20
	sub	r3, r3, #2384
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #2384
	vld1.64	{d16-d17}, [r3:64]
	vpaddl.u8	q8, q8
	vmov	q9, q8  @ v8hi
	sub	r3, fp, #20
	sub	r3, r3, #2352
	vldr	d16, [fp, #-636]
	vldr	d17, [fp, #-628]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #2368
	vst1.64	{d18-d19}, [r3:64]
	sub	r3, fp, #20
	sub	r2, r3, #2352
	sub	r3, fp, #20
	sub	r3, r3, #2368
	vld1.64	{d18-d19}, [r2:64]
	vld1.64	{d16-d17}, [r3:64]
	vadd.i16	q8, q9, q8
	vstr	d16, [fp, #-636]
	vstr	d17, [fp, #-628]
	sub	r3, fp, #20
	sub	r3, r3, #2320
	vldr	d16, [fp, #-364]
	vldr	d17, [fp, #-356]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #2336
	vldr	d16, [fp, #-620]
	vldr	d17, [fp, #-612]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #2320
	vld1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #2336
	vld1.64	{d18-d19}, [r3:64]
	vabd.u8	q8, q8, q9
	sub	r3, fp, #20
	sub	r3, r3, #2304
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #2304
	vld1.64	{d16-d17}, [r3:64]
	vpaddl.u8	q8, q8
	vmov	q9, q8  @ v8hi
	sub	r3, fp, #20
	sub	r3, r3, #2272
	vldr	d16, [fp, #-636]
	vldr	d17, [fp, #-628]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #2288
	vst1.64	{d18-d19}, [r3:64]
	sub	r3, fp, #20
	sub	r2, r3, #2272
	sub	r3, fp, #20
	sub	r3, r3, #2288
	vld1.64	{d18-d19}, [r2:64]
	vld1.64	{d16-d17}, [r3:64]
	vadd.i16	q8, q9, q8
	vstr	d16, [fp, #-636]
	vstr	d17, [fp, #-628]
	sub	r3, fp, #20
	sub	r3, r3, #2256
	vldr	d16, [fp, #-636]
	vldr	d17, [fp, #-628]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #2256
	vld1.64	{d16-d17}, [r3:64]
	vmov.u16	r3, d16[0]
	uxth	r3, r3
	mov	r4, r3
	sub	r3, fp, #20
	sub	r3, r3, #2240
	vldr	d16, [fp, #-636]
	vldr	d17, [fp, #-628]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #2240
	vld1.64	{d16-d17}, [r3:64]
	vmov.u16	r3, d16[1]
	uxth	r3, r3
	add	r3, r3, r4
	uxth	r4, r3
	sub	r3, fp, #20
	sub	r3, r3, #2224
	vldr	d16, [fp, #-636]
	vldr	d17, [fp, #-628]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #2224
	vld1.64	{d16-d17}, [r3:64]
	vmov.u16	r3, d16[2]
	uxth	r3, r3
	add	r3, r3, r4
	uxth	r4, r3
	sub	r3, fp, #20
	sub	r3, r3, #2208
	vldr	d16, [fp, #-636]
	vldr	d17, [fp, #-628]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #2208
	vld1.64	{d16-d17}, [r3:64]
	vmov.u16	r3, d16[3]
	uxth	r3, r3
	add	r3, r3, r4
	uxth	r4, r3
	sub	r3, fp, #20
	sub	r3, r3, #2192
	vldr	d16, [fp, #-636]
	vldr	d17, [fp, #-628]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #2192
	vld1.64	{d16-d17}, [r3:64]
	vmov.u16	r3, d17[0]
	uxth	r3, r3
	add	r3, r3, r4
	uxth	r4, r3
	sub	r3, fp, #20
	sub	r3, r3, #2176
	vldr	d16, [fp, #-636]
	vldr	d17, [fp, #-628]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #2176
	vld1.64	{d16-d17}, [r3:64]
	vmov.u16	r3, d17[1]
	uxth	r3, r3
	add	r3, r3, r4
	uxth	r4, r3
	sub	r3, fp, #20
	sub	r3, r3, #2160
	vldr	d16, [fp, #-636]
	vldr	d17, [fp, #-628]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #2160
	vld1.64	{d16-d17}, [r3:64]
	vmov.u16	r3, d17[2]
	uxth	r3, r3
	add	r3, r3, r4
	uxth	r4, r3
	sub	r3, fp, #20
	sub	r3, r3, #2144
	vldr	d16, [fp, #-636]
	vldr	d17, [fp, #-628]
	vst1.64	{d16-d17}, [r3:64]
	sub	r3, fp, #20
	sub	r3, r3, #2144
	vld1.64	{d16-d17}, [r3:64]
	vmov.u16	r3, d17[3]
	uxth	r3, r3
	add	r3, r3, r4
	uxth	r4, r3
	lsr	r3, r5, #1
	ldr	r2, [fp, #-88]
	ldr	r1, [fp, #-32]
	mul	r1, r1, r3
	ldr	r3, [fp, #-28]
	add	r3, r1, r3
	lsl	r3, r3, #1
	add	r3, r2, r3
	ldrh	r3, [r3]
	cmp	r4, r3
	bcs	.L116
	lsr	r3, r5, #1
	ldr	r2, [fp, #-88]
	ldr	r1, [fp, #-32]
	mul	r1, r1, r3
	ldr	r3, [fp, #-28]
	add	r3, r1, r3
	lsl	r3, r3, #1
	add	r3, r2, r3
	strh	r4, [r3]	@ movhi
	ldr	r3, [fp, #-32]
	lsl	r3, r3, #2
	ldr	r2, [fp, #-72]
	add	r3, r2, r3
	ldr	r2, [r3]
	ldr	r3, [fp, #-28]
	lsl	r3, r3, #2
	add	r3, r2, r3
	ldr	r2, [fp, #-24]
	str	r2, [r3]
	ldr	r3, [fp, #-32]
	lsl	r3, r3, #2
	ldr	r2, [fp, #-76]
	add	r3, r2, r3
	ldr	r2, [r3]
	ldr	r3, [fp, #-28]
	lsl	r3, r3, #2
	add	r3, r2, r3
	ldr	r2, [fp, #-48]
	str	r2, [r3]
	cmp	r4, #0
	bne	.L116
	mov	r3, #17
	str	r3, [fp, #-48]
	mov	r3, #17
	str	r3, [fp, #-24]
	b	.L116
.L196:
	nop
.L116:
	ldr	r3, [fp, #-24]
	add	r3, r3, #1
	str	r3, [fp, #-24]
.L114:
	ldr	r2, [fp, #-24]
	ldr	r3, [fp, #-104]
	cmp	r2, r3
	blt	.L188
	ldr	r3, [fp, #-48]
	add	r3, r3, #1
	str	r3, [fp, #-48]
.L113:
	ldr	r2, [fp, #-48]
	ldr	r3, [fp, #-100]
	cmp	r2, r3
	blt	.L114
	ldr	r3, [fp, #-40]
	add	r3, r3, #16
	str	r3, [fp, #-40]
	ldr	r3, [fp, #-28]
	add	r3, r3, #1
	str	r3, [fp, #-28]
.L16:
	ldr	r2, [fp, #-28]
	ldr	r3, [fp, #-64]
	cmp	r2, r3
	blt	.L190
	ldr	r3, [fp, #-36]
	add	r3, r3, #16
	str	r3, [fp, #-36]
	ldr	r3, [fp, #-32]
	add	r3, r3, #1
	str	r3, [fp, #-32]
.L15:
	ldr	r2, [fp, #-32]
	ldr	r3, [fp, #-68]
	cmp	r2, r3
	blt	.L191
	bl	clock
	mov	r2, r0
	ldr	r3, [fp, #-60]
	sub	r3, r2, r3
	vmov	s15, r3	@ int
	vcvt.f64.s32	d17, s15
	vldr.64	d18, .L197
	vdiv.f64	d16, d17, d18
	vstr.64	d16, [fp, #-644]
	mov	r3, #0
	str	r3, [fp, #-52]
	b	.L192
.L195:
	mov	r3, #0
	str	r3, [fp, #-56]
	b	.L193
.L194:
	ldr	r3, [fp, #-52]
	ldr	r2, [fp, #-68]
	mul	r2, r2, r3
	ldr	r3, [fp, #-56]
	add	r0, r2, r3
	lsr	r3, r5, #1
	ldr	r2, [fp, #-88]
	ldr	r1, [fp, #-52]
	mul	r1, r1, r3
	ldr	r3, [fp, #-56]
	add	r3, r1, r3
	lsl	r3, r3, #1
	add	r3, r2, r3
	ldrh	r3, [r3]
	mov	ip, r3
	ldr	r3, [fp, #-52]
	lsl	r3, r3, #2
	ldr	r2, [fp, #-72]
	add	r3, r2, r3
	ldr	r2, [r3]
	ldr	r3, [fp, #-56]
	lsl	r3, r3, #2
	add	r3, r2, r3
	ldr	r3, [r3]
	ldr	r2, [fp, #-52]
	lsl	r2, r2, #2
	ldr	r1, [fp, #-76]
	add	r2, r1, r2
	ldr	r1, [r2]
	ldr	r2, [fp, #-56]
	lsl	r2, r2, #2
	add	r2, r1, r2
	ldr	r2, [r2]
	str	r2, [sp, #8]
	str	r3, [sp, #4]
	str	ip, [sp]
	ldr	r3, [fp, #-52]
	ldr	r2, [fp, #-56]
	mov	r1, r0
	movw	r0, #:lower16:.LC7
	movt	r0, #:upper16:.LC7
	bl	printf
	ldr	r3, [fp, #-56]
	add	r3, r3, #1
	str	r3, [fp, #-56]
.L193:
	ldr	r2, [fp, #-56]
	ldr	r3, [fp, #-64]
	cmp	r2, r3
	blt	.L194
	ldr	r3, [fp, #-52]
	add	r3, r3, #1
	str	r3, [fp, #-52]
.L192:
	ldr	r2, [fp, #-52]
	ldr	r3, [fp, #-68]
	cmp	r2, r3
	blt	.L195
	sub	r3, fp, #644
	ldrd	r2, [r3]
	movw	r0, #:lower16:.LC8
	movt	r0, #:upper16:.LC8
	bl	printf
	mov	sp, r7
	nop
	mov	r0, r3
	sub	sp, fp, #20
	@ sp needed
	pop	{r4, r5, r6, r7, fp, pc}
.L198:
	.align	3
.L197:
	.word	0
	.word	1093567616
	.size	motion, .-motion
	.ident	"GCC: (GNU) 8.2.1 20180801 (Red Hat 8.2.1-2)"
	.section	.note.GNU-stack,"",%progbits
