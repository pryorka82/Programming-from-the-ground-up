.include "linux.s"
.section .data
                                        #This is where it will be stored
        tmp_buffer:
                .ascii "\0\0\0\0\0\0\0\0\0\0\0"
	stringnum:
		.ascii "47\0"


.section .text
.globl _start
_start:

movl %esp, %ebp


pushl $stringnum 					#first push the string to the stack
call number2integer					#to convert it to an integer
addl $4, %esp



                                                        #Storage for the result
pushl $tmp_buffer
                                                        #Number to convert which was put into
pushl %eax						#%eax after calling number2integer
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
                                                                                                       
                                                                                                       
                                                                                                      
        
