.include "linux.s"
#PURPOSE: Convert an integer number to a decimal string
# for display
#
#INPUT: A number written in a string format 
# 
#
#OUTPUT: an integer
# 
#Variables:
#
# %ebx will hold the number of characters
# %eax will hold the string
# %esi will hold the integer value
# %edi will hold the base (10)
#
.equ STRINGNUM, 8

.globl number2integer
.type number2integer, @function
number2integer:
				#Normal function beginning
pushl %ebp
movl %esp, %ebp

movl STRINGNUM(%ebp), %eax				#Move string to %eax
							#Get the character count for our string
pushl %eax
call count_chars					#get character count for the string	
addl $4, %esp

#decl %eax		#TEST THIS LINE

movl %eax, %ebx						#Move character count into %ebx 
movl $0, %esi						#zero out our integer value
movl $1, %edi						#set operator to 1

movl STRINGNUM(%ebp), %eax                              #Move string to %eax

num2int_loop:

movl $0, %edx						#zero out the %edx register 
decl %ebx						#decrement the %ebx to point to the next digit
movb (%eax, %ebx, 1), %dl				#store first byte 
subb $'0', %dl						#get number value for the string


imull %edi, %edx					#multiply to get the value for the nth(%ebx) digit

addl %edx, %esi						#sum up integer value

imull $10, %edi						#multiply the operand by 10 to get operand
							#for next digit

cmpl $0, %ebx						#and if greater than 0 continue moving the	
jg num2int_loop						#characters


movl %esi, %eax						#put integer value into %eax


movl %ebp, %esp
popl %ebp
ret
