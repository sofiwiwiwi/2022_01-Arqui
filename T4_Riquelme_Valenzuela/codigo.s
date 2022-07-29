@INGRESAR INPUT AQUI    
.data
modo: .int 4
largo: .word 4
arreglo: .word 1, 2, 4, 3

.text
LDR r4, =modo
LDR r4, [r4]
CMP r4, #1
BEQ TRIANGLE
CMP r4, #2
BEQ HYP
CMP r4, #3
BEQ DISTANCE
CMP r4, #4
BEQ AVERAGE

TRIANGLE:
LDR r1, =largo
LDR r1, [r1]

LDR r2, =arreglo
MOV r7, #0
MOV r3, #0
MOV r5, #0
MOV r4, #0
MOV r8, r4
B looptest

loopstart:
LDR r6, [r2, r5]
MOV r7, r6
MUL r7, r7, r7
ADD r8, r8, r7 @resultado en r8
ADD r3, r3, #1
ADD r5, r5, #4


looptest:
CMP r3, r1
BLT loopstart
MOV r0, r8

BL squareroot
B DONE

squareroot:
MOV r1, #2
MOV r3, r0
MOV r6, r0
MOV r2, #0
PUSH {LR}
BL divide

MOV r4, r0
whilesqrt:
CMP r4, r2
BMI donesqrt
MOV r0, r6
MOV r1, r3
BL divide 
ADD r0,r3,r0
MOV r1, #2
BL divide
MOV r3, r0
ADD r2, #1
B whilesqrt
donesqrt:
MOV r0, r3
POP {PC}


HYP:
LDR r1, =largo
LDR r1, [r1]

LDR r2, =arreglo
MOV r7, #0
MOV r3, #0
MOV r5, #0
MOV r4, #0
MOV r8, r4
B looptest1

loopstart1:
LDR r6, [r2, r5]
PUSH {r6} 
ADD r3, r3, #1
ADD r5, r5, #4


looptest1:
CMP r3, r1
BLT loopstart1 
MOV r0, #0
MOV r1, #0
MOV r2, #0
POP {r1, r2}
MUL r1, r1
MUL r2, r2

CMP r1, r2
BGT hypotenuse
CMP r2, r1 
BGT side
doneadd:
BL squareroot
B DONE

hypotenuse:
ADD r0, r0, r1
SUB r0, r0, r2
B doneadd

side:
ADD r0, r0, r2
SUB r0, r0, r1
B doneadd

DISTANCE:
LDR   r1, =largo    
LDR   r1, [r1]         
LDR   r2, =arreglo                      
MOV   r3, #0            
MOV   r5, #0            
MOV   r4, #0            
B    looptest2          

loopstart2:
LDR   r6, [r2, r5]  
PUSH {r6}    

ADD   r3, r3, #1        
ADD   r5, r5, #4        

looptest2:
CMP   r3, r1            
BLT   loopstart2
MOV r0, #0
MOV r1, #0
MOV r2, #0
MOV r3, #0
MOV r4, #0
MOV r5, #0
MOV r6, #0

POP {r4, r3, r2, r1}    

SUB r6, r1, r3
SUB r7, r2, r4

MUL r6, r6
MUL r7, r7

ADD r0, r6, r7
BL squareroot
B DONE


AVERAGE:
LDR r1, =largo
LDR r1, [r1]

LDR r2, =arreglo
MOV r7, #0
MOV r3, #0
MOV r5, #0
MOV r4, #0
MOV r8, r4
MOV r9, r4
B looptest3

loopstart3:
LDR r6, [r2, r5]
MOV r7, r6
ADD r8, r8, r7
ADD r3, r3, #1
ADD r5, r5, #4


looptest3:
CMP r3, r1
BLT loopstart3
MOV r0, r8
MOV r7, #0
BL divide
B DONE

divide:
PUSH {LR}
MOV r7, #0
dividestart:
SUB r0, r0, r1@r0 dividido por r1
ADD r7, r7, #1 @resultado en r7
CMP r0, r1    @ r0 - r1 
BPL dividestart
MOV r0, r7

POP {PC}

DONE:
MOV r2, r0
MOV r0, #20
MOV r1, #3
BL printInt
WFI
.end