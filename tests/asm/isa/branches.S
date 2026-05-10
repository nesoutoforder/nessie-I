.section .text
.global main

main:
    li t0, 5
    li t1, 5
    beq t0, t1, beq_ok
    j fail

beq_ok:
    li t1, 7
    bne t0, t1, bne_ok
    j fail

bne_ok:
    li t0, -1
    li t1, 1
    blt t0, t1, blt_ok
    j fail

blt_ok:
    li t0, 10
    li t1, 3
    bge t0, t1, bge_ok
    j fail

bge_ok:
    li t0, -1
    li t1, 1
    bltu t1, t0, bltu_ok
    j fail

bltu_ok:
    li t0, -1
    li t1, 1
    bgeu t0, t1, bgeu_ok
    j fail

bgeu_ok:
    j pass

pass:
    li t0, 0x100
    li t1, 1
    sw t1, 0(t0)
1:
    j 1b

fail:
    li t0, 0x100
    li t1, 0xdead
    sw t1, 0(t0)
2:
    j 2b
