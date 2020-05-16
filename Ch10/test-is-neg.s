.include "linux.s"
.section .data

	tmp_buffer:
		.ascii "\0\0\0\0\0\0\0\0\0\0\0"

	number:
		.long -12

.section .text
.globl _start
_start:

movl %esp, %ebp

							#Number to check
pushl number
call isneg
addl $4, %esp

pushl $tmp_buffer
pushl %eax
call integer2string
addl $12, %esp

							#Get the character count for our system call
pushl $tmp_buffer
call count_chars
addl $4, %esp
							#The count goes in %edx for SYS_WRITE
movl %eax, %edx
							#Make the system call
movl $SYS_WRITE, %eax
movl $STDOUT, %ebx
movl $tmp_buffer, %ecx
int $LINUX_SYSCALL

							#Write a carriage return
pushl $STDOUT
call write_newline
							#Exit
movl $SYS_EXIT, %eax

movl $0, %ebx
int $LINUX_SYSCALL
