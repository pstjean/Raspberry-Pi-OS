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
;@ label the next line so that we can branch to the beginning
onoff$:
;@ again, "move" 1 base 10 in register 1
mov r1,#1
;@ = 1 0000 0000 0000 0000 base 2 or 65536 base 10 
lsl r1,#16
;@ address 40 to turn a pin off (28 would turn it on)
str r1,[r0,#40]

;@@@@ wasting time to wait: we add a big number to register 2 and
;@ then we subtract 1, see if we've made it to 0 yet, and if not,
;@ we do it again

mov r2,#0x3F0000
;@ label
wait1$:
;@ subtract the second argument from the first
sub r2,#1
;@ compare the first argument with the second, stores the result
;@ of the comparison in the "current processor status" register
cmp r2,#0
;@ ne (not equal) suffix on the b (branch) command means "branch if
;@ the last comparison's result was that the values were not equal"
bne wait1$

;@@@@ now we turn off the LED
;@ again, "move" 1 base 10 in register 1
mov r1,#1
;@ = 1 0000 0000 0000 0000 base 2 or 65536 base 10 
lsl r1,#16
;@ address 28 to turn a pin on (and turn the LED off)
str r1,[r0,#28]

;@ here is our wait code again
mov r2,#0x3F0000
wait2$:
sub r2,#1
cmp r2,#0
bne wait2$

;@@@@ finally, we branch back to the code that turns on the LED
b onoff$
