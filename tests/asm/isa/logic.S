.section .text
.global main

main:
    li t0, 0x0f0f
    li t1, 0x00ff

    and t2, t0, t1
    li t3, 0x000f
    bne t2, t3, fail

    or t2, t0, t1
    li t3, 0x0fff
    bne t2, t3, fail

    xor t2, t0, t1
    li t3, 0x0ff0
    bne t2, t3, fail

    xori t2, t1, 0x0f0
    li t3, 0x000f
    bne t2, t3, fail

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
    