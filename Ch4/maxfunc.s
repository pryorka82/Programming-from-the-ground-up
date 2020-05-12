# PURPOSE:  A modular approach of finding the maximum of lists

    .section .data
    # The data section has three lists for testing, change the code
    # highlighted in the text section to change the list passed.
data_1:
    .long 1, 2, 3, 4, 5, 6, 7, 8, 9, 0
data_2:
    .long 23, 45, 62, 13, 87, 54, 0
data_3:
    .long 1, 2, 3, 3, 3, 7, 6, 5, 8, 1, 1, 0

# VARIABLES:
# 1. %edi - Will be our index variable, to access the items
# 2. %ebx - The element we're looking at currently
# 3. %eax - The maximum value we've found so far
# 4. %ecx - To store the address of the list


    .section .text
    .globl _start
_start:
    # Push the address of the list we want to find the maximum of
    pushl   $data_3
    #             ^
    #             +---> Change this to select your list

    call    maximum
    addl    $4, %esp    # Reset the stack

    movl    %eax, %ebx
    movl    $1, %eax
    int     $0x80

    .type   maximum, @function
maximum:
    # Setup
    pushl   %ebp
    movl    %esp, %ebp

    # The initial setup:
    # Get the address of the list
    # Set the index to 0
    # Get the first item from the list
    # The first item is currently the largest
    movl    $0, %edi
    movl    8(%ebp), %ecx
    movl    (%ecx, %edi, 4), %ebx
    movl    %ebx, %eax

max_loop:
    cmpl    $0, %ebx
    je      exit_loop

    incl    %edi
    movl    (%ecx, %edi, 4), %ebx

    cmpl    %eax, %ebx
    jle     max_loop

    # %ebx is greater than %eax, therefore, update max
    movl    %ebx, %eax
    jmp     max_loop

exit_loop:
    # Tear down
    movl    %ebp, %esp
    popl    %ebp
    ret
