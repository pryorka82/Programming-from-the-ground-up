.include "linux.s"
.section .data
					#This is where it will be stored
	bob:
		.long 0b0101
	jon:
		.long 0b1111
	sue:
		.long 0b0110
	sally: 
		.long 0b0011

# 0b0001 = mexican food
# 0b0010 = italian food
# 0b0100 = chinese food
# 0b1000 = persian food

	food:
		.ascii "Mexican\0"

	dislike: 
		.ascii "They don't share this like\0"
.section .text
.globl _start
_start:

movl %esp, %ebp
							#Storage for the result


movl bob, %eax				#list two people to compare
movl jon, %edx

andl %eax, %edx				#find commonalities

andl $0b0001, %edx			#Mask with first bit, if want to test other	
					#bits then shift appropiately first

cmpl $0, %edx				#if the result is 0 then they don't share the like
je dont_share

movl $7, %edx				#Make the system call (notice all foods are 7 in length)
movl $SYS_WRITE, %eax
movl $STDOUT, %ebx
movl $food, %ecx
int $LINUX_SYSCALL

							#Write a carriage return
pushl $STDOUT
call write_newline

jmp finish	

dont_share:				#if the don't share the like then output the
					#dislike string which is 27 in length
movl $27, %edx
movl $SYS_WRITE, %eax
movl $STDOUT, %ebx
movl $dislike, %ecx
int $LINUX_SYSCALL

                                                        #Write a carriage return
pushl $STDOUT
call write_newline




finish:
					#Exit
movl $SYS_EXIT, %eax

movl $0, %ebx
int $LINUX_SYSCALL
