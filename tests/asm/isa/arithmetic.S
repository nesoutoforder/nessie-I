.section .text
.global main

main:
    li t0, 10
    li t1, 20
    add t2, t0, t1
    li t3, 30
    bne t2, t3, fail

    sub t2, t1, t0
    li t3, 10
    bne t2, t3, fail

    addi t2, t2, 5
    li t3, 15
    bne t2, t3, fail

    li t0, -1
    li t1, 1
    add t2, t0, t1
    bnez t2, fail

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
    