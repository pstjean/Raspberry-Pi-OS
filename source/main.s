;@ tells assembler to run code in the ".init" section first
.section .init
.globl _start
_start:
;@ store 0x20200000 in register r0
;@ this is the address of the GPIO controller
ldr r0, =0x20200000

;@@@@ here we go: enable output to the 16th GPIO pin

;@ "move" 1 base 10 in register 1
mov r1,#1
;@ "logical shift left"
;@ shift the binary representation of the first argument
;@ (1 base 2) left by the second argument (18 base 10)
;@ = 100 0000 0000 0000 0000 base 2 or 262144 base 10
lsl r1,#18
;@ "store register"
;@ add 4 to the GPIO address (r0) and write the value in
;@ r1 to that location
str r1,[r0,#4]

;@@@@ now, we actually switch pin 16 off to turn on the LED

;@ again, "move" 1 base 10 in register 1
mov r1,#1
;@ = 1 0000 0000 0000 0000 base 2 or 65536 base 10 
lsl r1,#16
;@ address 40 to turn a pin off (28 would turn it on)
str r1,[r0,#40]

;@@@@ now we give the processor a task to do so it doesn't crash

;@ label the next line "loop$" the dollar sign is a convention
loop$:
;@ "branch" causes the line at the specified label to be
;@ executed
b loop$

