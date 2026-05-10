.section .text
.global main

main:
    li t0, 0x200

    li t1, 0x12345678
    sw t1, 0(t0)

    lw t2, 0(t0)
    bne t1, t2, fail

    li t1, 0xaaaa5555
    sw t1, 4(t0)

    lw t2, 4(t0)
    bne t1, t2, fail

    lw t3, 0(t0)
    li t4, 0x12345678
    bne t3, t4, fail

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
    