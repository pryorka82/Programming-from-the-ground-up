.include "linux.s"
.section .data
					#This is where it will be stored
	tmp_buffer:
		.ascii "\0\0\0\0\0\0\0\0\0\0\0"

 	prompt_msg:
                .ascii "Enter number:\0"

	value:
		.ascii "\0\0\0\0\0\0\0\0"


.section .text
.globl _start
_start:

movl %esp, %ebp


movl $SYS_WRITE, %eax
movl $STDOUT, %ebx
movl $prompt_msg, %ecx
movl $14, %edx
int $LINUX_SYSCALL

#Receive filename entered
movl $SYS_READ, %eax
movl $STDIN, %ebx
movl $value, %ecx
movl $8, %edx
int $LINUX_SYSCALL

pushl $value
call number2integer
addl $4, %esp


pushl $tmp_buffer
pushl %eax
call integer2string
addl $8, %esp



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
