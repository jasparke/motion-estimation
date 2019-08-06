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
	.file	"motion-unopt.c"
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
	@ args = 0, pretend = 0, frame = 120
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, fp, lr}
	add	fp, sp, #20
	sub	sp, sp, #136
	str	r0, [fp, #-128]
	str	r1, [fp, #-132]
	str	r2, [fp, #-136]
	str	r3, [fp, #-140]
	mov	r3, sp
	mov	r7, r3
	bl	clock
	str	r0, [fp, #-80]
	ldr	r3, [fp, #-136]
	add	r2, r3, #15
	cmp	r3, #0
	movlt	r3, r2
	movge	r3, r3
	asr	r3, r3, #4
	str	r3, [fp, #-84]
	ldr	r3, [fp, #-140]
	add	r2, r3, #15
	cmp	r3, #0
	movlt	r3, r2
	movge	r3, r3
	asr	r3, r3, #4
	str	r3, [fp, #-88]
	ldr	r3, [fp, #-84]
	sub	r3, r3, #1
	str	r3, [fp, #-92]
	ldr	r3, [fp, #-84]
	lsl	r6, r3, #2
	ldr	r3, [fp, #-88]
	sub	r3, r3, #1
	str	r3, [fp, #-96]
	ldr	r3, [fp, #-84]
	mov	r0, r3
	mov	r1, #0
	ldr	r3, [fp, #-88]
	mov	r2, r3
	mov	r3, #0
	mul	lr, r2, r1
	mul	ip, r0, r3
	add	ip, lr, ip
	umull	r2, r3, r0, r2
	add	r1, ip, r3
	mov	r3, r1
	ldr	r3, [fp, #-84]
	mov	r0, r3
	mov	r1, #0
	ldr	r3, [fp, #-88]
	mov	r2, r3
	mov	r3, #0
	mul	lr, r2, r1
	mul	ip, r0, r3
	add	ip, lr, ip
	umull	r2, r3, r0, r2
	add	r1, ip, r3
	mov	r3, r1
	ldr	r3, [fp, #-84]
	ldr	r2, [fp, #-88]
	mul	r3, r2, r3
	lsl	r3, r3, #2
	add	r3, r3, #7
	lsr	r3, r3, #3
	lsl	r3, r3, #3
	sub	sp, sp, r3
	add	r3, sp, #16
	add	r3, r3, #3
	lsr	r3, r3, #2
	lsl	r3, r3, #2
	str	r3, [fp, #-100]
	ldr	r3, [fp, #-84]
	sub	r3, r3, #1
	str	r3, [fp, #-104]
	ldr	r3, [fp, #-84]
	lsl	r4, r3, #3
	ldr	r3, [fp, #-88]
	sub	r3, r3, #1
	str	r3, [fp, #-108]
	ldr	r3, [fp, #-84]
	mov	r0, r3
	mov	r1, #0
	ldr	r3, [fp, #-88]
	mov	r2, r3
	mov	r3, #0
	mul	lr, r2, r1
	mul	ip, r0, r3
	add	ip, lr, ip
	umull	r2, r3, r0, r2
	add	r1, ip, r3
	mov	r3, r1
	ldr	r3, [fp, #-84]
	mov	r0, r3
	mov	r1, #0
	ldr	r3, [fp, #-88]
	mov	r2, r3
	mov	r3, #0
	mul	lr, r2, r1
	mul	ip, r0, r3
	add	ip, lr, ip
	umull	r2, r3, r0, r2
	add	r1, ip, r3
	mov	r3, r1
	ldr	r3, [fp, #-84]
	ldr	r2, [fp, #-88]
	mul	r3, r2, r3
	lsl	r3, r3, #3
	add	r3, r3, #7
	lsr	r3, r3, #3
	lsl	r3, r3, #3
	sub	sp, sp, r3
	add	r3, sp, #16
	add	r3, r3, #3
	lsr	r3, r3, #2
	lsl	r3, r3, #2
	str	r3, [fp, #-112]
	ldr	r0, [fp, #-100]
	ldr	r3, [fp, #-84]
	ldr	r2, [fp, #-88]
	mul	r3, r2, r3
	lsl	r3, r3, #2
	mov	r2, r3
	mov	r1, #0
	bl	memset
	ldr	r0, [fp, #-112]
	ldr	r3, [fp, #-84]
	ldr	r2, [fp, #-88]
	mul	r3, r2, r3
	lsl	r3, r3, #3
	mov	r2, r3
	mov	r1, #0
	bl	memset
	mov	r3, #0
	str	r3, [fp, #-60]
	mov	r3, #0
	str	r3, [fp, #-56]
	mov	r3, #0
	str	r3, [fp, #-52]
	b	.L13
.L32:
	mov	r3, #0
	str	r3, [fp, #-60]
	mov	r3, #0
	str	r3, [fp, #-48]
	b	.L14
.L31:
	mvn	r3, #-2147483648
	str	r3, [fp, #-44]
	mov	r3, #0
	str	r3, [fp, #-40]
	mov	r3, #0
	str	r3, [fp, #-36]
	mvn	r3, #15
	str	r3, [fp, #-32]
	b	.L15
.L30:
	mvn	r3, #15
	str	r3, [fp, #-28]
	b	.L16
.L29:
	ldr	r3, [fp, #-28]
	cmp	r3, #0
	bne	.L17
	ldr	r3, [fp, #-32]
	cmp	r3, #0
	beq	.L37
.L17:
	ldr	r2, [fp, #-56]
	ldr	r3, [fp, #-32]
	add	r3, r2, r3
	cmp	r3, #0
	blt	.L38
	ldr	r2, [fp, #-56]
	ldr	r3, [fp, #-32]
	add	r3, r2, r3
	add	r3, r3, #15
	ldr	r2, [fp, #-140]
	cmp	r2, r3
	ble	.L39
	ldr	r2, [fp, #-60]
	ldr	r3, [fp, #-28]
	add	r3, r2, r3
	cmp	r3, #0
	blt	.L40
	ldr	r2, [fp, #-60]
	ldr	r3, [fp, #-28]
	add	r3, r2, r3
	add	r3, r3, #15
	ldr	r2, [fp, #-140]
	cmp	r2, r3
	ble	.L41
	mov	r3, #0
	str	r3, [fp, #-24]
	mov	r3, #0
	str	r3, [fp, #-64]
	b	.L23
.L28:
	mov	r3, #0
	str	r3, [fp, #-68]
	b	.L24
.L27:
	ldr	r2, [fp, #-56]
	ldr	r3, [fp, #-64]
	add	r3, r2, r3
	lsl	r3, r3, #2
	ldr	r2, [fp, #-132]
	add	r3, r2, r3
	ldr	r3, [r3]
	ldr	r1, [fp, #-60]
	ldr	r2, [fp, #-68]
	add	r2, r1, r2
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	mov	r0, r3
	ldr	r2, [fp, #-56]
	ldr	r3, [fp, #-64]
	add	r2, r2, r3
	ldr	r3, [fp, #-32]
	add	r3, r2, r3
	lsl	r3, r3, #2
	ldr	r2, [fp, #-128]
	add	r3, r2, r3
	ldr	r3, [r3]
	ldr	r1, [fp, #-60]
	ldr	r2, [fp, #-68]
	add	r1, r1, r2
	ldr	r2, [fp, #-28]
	add	r2, r1, r2
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	sub	r5, r0, r3
	cmp	r5, #0
	bge	.L25
	ldr	r3, [fp, #-24]
	sub	r3, r3, r5
	str	r3, [fp, #-24]
	b	.L26
.L25:
	ldr	r3, [fp, #-24]
	add	r3, r3, r5
	str	r3, [fp, #-24]
.L26:
	ldr	r3, [fp, #-68]
	add	r3, r3, #1
	str	r3, [fp, #-68]
.L24:
	ldr	r3, [fp, #-68]
	cmp	r3, #15
	ble	.L27
	ldr	r3, [fp, #-64]
	add	r3, r3, #1
	str	r3, [fp, #-64]
.L23:
	ldr	r3, [fp, #-64]
	cmp	r3, #15
	ble	.L28
	ldr	r2, [fp, #-24]
	ldr	r3, [fp, #-44]
	cmp	r2, r3
	bge	.L18
	ldr	r3, [fp, #-24]
	str	r3, [fp, #-44]
	ldr	r3, [fp, #-28]
	str	r3, [fp, #-40]
	ldr	r3, [fp, #-32]
	str	r3, [fp, #-36]
	b	.L18
.L37:
	nop
	b	.L18
.L38:
	nop
	b	.L18
.L39:
	nop
	b	.L18
.L40:
	nop
	b	.L18
.L41:
	nop
.L18:
	ldr	r3, [fp, #-28]
	add	r3, r3, #1
	str	r3, [fp, #-28]
.L16:
	ldr	r3, [fp, #-28]
	cmp	r3, #15
	ble	.L29
	ldr	r3, [fp, #-32]
	add	r3, r3, #1
	str	r3, [fp, #-32]
.L15:
	ldr	r3, [fp, #-32]
	cmp	r3, #15
	ble	.L30
	lsr	r2, r6, #2
	ldr	r3, [fp, #-100]
	ldr	r1, [fp, #-52]
	mul	r1, r1, r2
	ldr	r2, [fp, #-48]
	add	r2, r1, r2
	ldr	r1, [fp, #-44]
	str	r1, [r3, r2, lsl #2]
	lsr	r2, r4, #2
	ldr	r3, [fp, #-112]
	ldr	r1, [fp, #-48]
	ldr	r0, [fp, #-52]
	mul	r2, r0, r2
	lsl	r1, r1, #1
	add	r2, r1, r2
	ldr	r1, [fp, #-40]
	str	r1, [r3, r2, lsl #2]
	lsr	r2, r4, #2
	ldr	r3, [fp, #-112]
	ldr	r1, [fp, #-48]
	ldr	r0, [fp, #-52]
	mul	r2, r0, r2
	lsl	r1, r1, #1
	add	r2, r1, r2
	add	r2, r2, #1
	ldr	r1, [fp, #-36]
	str	r1, [r3, r2, lsl #2]
	ldr	r3, [fp, #-60]
	add	r3, r3, #16
	str	r3, [fp, #-60]
	ldr	r3, [fp, #-48]
	add	r3, r3, #1
	str	r3, [fp, #-48]
.L14:
	ldr	r2, [fp, #-48]
	ldr	r3, [fp, #-84]
	cmp	r2, r3
	blt	.L31
	ldr	r3, [fp, #-56]
	add	r3, r3, #16
	str	r3, [fp, #-56]
	ldr	r3, [fp, #-52]
	add	r3, r3, #1
	str	r3, [fp, #-52]
.L13:
	ldr	r2, [fp, #-52]
	ldr	r3, [fp, #-88]
	cmp	r2, r3
	blt	.L32
	bl	clock
	mov	r2, r0
	ldr	r3, [fp, #-80]
	sub	r3, r2, r3
	vmov	s15, r3	@ int
	vcvt.f32.s32	s14, s15
	vldr.32	s13, .L42
	vdiv.f32	s15, s14, s13
	vcvt.f64.f32	d16, s15
	vstr.64	d16, [fp, #-124]
	mov	r3, #0
	str	r3, [fp, #-72]
	b	.L33
.L36:
	mov	r3, #0
	str	r3, [fp, #-76]
	b	.L34
.L35:
	ldr	r3, [fp, #-72]
	ldr	r2, [fp, #-88]
	mul	r2, r2, r3
	ldr	r3, [fp, #-76]
	add	r5, r2, r3
	lsr	r2, r6, #2
	ldr	r3, [fp, #-100]
	ldr	r1, [fp, #-72]
	mul	r1, r1, r2
	ldr	r2, [fp, #-76]
	add	r2, r1, r2
	ldr	r3, [r3, r2, lsl #2]
	lsr	r1, r4, #2
	ldr	r2, [fp, #-112]
	ldr	r0, [fp, #-76]
	ldr	ip, [fp, #-72]
	mul	r1, ip, r1
	lsl	r0, r0, #1
	add	r1, r0, r1
	ldr	r2, [r2, r1, lsl #2]
	lsr	r0, r4, #2
	ldr	r1, [fp, #-112]
	ldr	ip, [fp, #-76]
	ldr	lr, [fp, #-72]
	mul	r0, lr, r0
	lsl	ip, ip, #1
	add	r0, ip, r0
	add	r0, r0, #1
	ldr	r1, [r1, r0, lsl #2]
	str	r1, [sp, #8]
	str	r2, [sp, #4]
	str	r3, [sp]
	ldr	r3, [fp, #-72]
	ldr	r2, [fp, #-76]
	mov	r1, r5
	movw	r0, #:lower16:.LC7
	movt	r0, #:upper16:.LC7
	bl	printf
	ldr	r3, [fp, #-76]
	add	r3, r3, #1
	str	r3, [fp, #-76]
.L34:
	ldr	r2, [fp, #-76]
	ldr	r3, [fp, #-84]
	cmp	r2, r3
	blt	.L35
	ldr	r3, [fp, #-72]
	add	r3, r3, #1
	str	r3, [fp, #-72]
.L33:
	ldr	r2, [fp, #-72]
	ldr	r3, [fp, #-88]
	cmp	r2, r3
	blt	.L36
	ldrd	r2, [fp, #-124]
	movw	r0, #:lower16:.LC8
	movt	r0, #:upper16:.LC8
	bl	printf
	mov	sp, r7
	nop
	mov	r0, r3
	sub	sp, fp, #20
	@ sp needed
	pop	{r4, r5, r6, r7, fp, pc}
.L43:
	.align	2
.L42:
	.word	1232348160
	.size	motion, .-motion
	.section	.rodata
	.align	2
.LC9:
	.ascii	"Read image as %dx%d.\012\000"
	.text
	.align	2
	.global	testImageRead
	.syntax unified
	.arm
	.fpu neon
	.type	testImageRead, %function
testImageRead:
	@ args = 0, pretend = 0, frame = 24
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #24
	str	r0, [fp, #-16]
	str	r1, [fp, #-20]
	str	r2, [fp, #-24]
	ldr	r2, [fp, #-20]
	ldr	r1, [fp, #-24]
	movw	r0, #:lower16:.LC9
	movt	r0, #:upper16:.LC9
	bl	printf
	mov	r3, #0
	str	r3, [fp, #-8]
	b	.L45
.L50:
	mov	r3, #0
	str	r3, [fp, #-12]
	b	.L46
.L49:
	ldr	r3, [fp, #-8]
	lsl	r3, r3, #2
	ldr	r2, [fp, #-16]
	add	r3, r2, r3
	ldr	r2, [r3]
	ldr	r3, [fp, #-12]
	add	r3, r2, r3
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #154
	bhi	.L47
	mov	r0, #45
	bl	putchar
	b	.L48
.L47:
	mov	r0, #35
	bl	putchar
.L48:
	ldr	r3, [fp, #-12]
	add	r3, r3, #1
	str	r3, [fp, #-12]
.L46:
	ldr	r2, [fp, #-12]
	ldr	r3, [fp, #-24]
	cmp	r2, r3
	blt	.L49
	mov	r0, #10
	bl	putchar
	ldr	r3, [fp, #-8]
	add	r3, r3, #1
	str	r3, [fp, #-8]
.L45:
	ldr	r2, [fp, #-8]
	ldr	r3, [fp, #-20]
	cmp	r2, r3
	blt	.L50
	nop
	sub	sp, fp, #4
	@ sp needed
	pop	{fp, pc}
	.size	testImageRead, .-testImageRead
	.ident	"GCC: (GNU) 8.2.1 20180801 (Red Hat 8.2.1-2)"
	.section	.note.GNU-stack,"",%progbits
