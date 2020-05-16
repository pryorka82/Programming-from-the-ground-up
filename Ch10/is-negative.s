#PURPOSE: Convert an integer number to a decimal string
# for display
#
#INPUT: A buffer large enough to hold the largest
# possible number
# An integer to convert
#
#OUTPUT: The buffer will be overwritten with the
# decimal string
#
#Variables:
#
# %ecx will hold the count of characters processed
# %eax will hold the current value
# %edi will hold the base (10)
#
.equ ST_VALUE, 8

.globl isneg 
.type isneg, @function
isneg:

				#Normal function beginning
pushl %ebp
movl %esp, %ebp

movl ST_VALUE(%ebp), %eax  	#load number into %eax
shrl $31, %eax			#shift right so 32 digit is in first digit position

andl $0b00000000000000000000000000000001, %eax	#AND with 1 value to see if the result is 
						#1 or 0

cmpl $1, %eax			#if the result is one then the number is negative
jne zero_val

movl $0, %eax			#if the result was equal to 1 then the number
jmp finished			#was negative


zero_val:			#jumped here when the result was not 1 meaning
movl $1, %eax			#the number was positive

finished:


movl %ebp, %esp
popl %ebp
ret
