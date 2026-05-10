.section .text
.global main

main:
    li t0, 5
    li t1, 7
    add t2, t0, t1

    li t3, 0x100
    li t4, 1
    sw t4, 0(t3)

1:
    j 1b
    