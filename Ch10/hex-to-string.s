#PURPOSE: Convert an hexadecimal number to a hexadecimal string
# for display
#
#INPUT: A buffer large enough to hold the largest
# possible number
# A hexadecimal integer to convert
#
#OUTPUT: The buffer will be overwritten with the
# hexadecimal string
#
#Variables:
#
# %ecx will hold the count of characters processed
# %eax will hold the current value
# %edi will hold the base (16)
#
.equ ST_VALUE, 8
.equ ST_BUFFER, 12

.globl hex2string
.type hex2string, @function
hex2string:

				#Normal function beginning
pushl %ebp
movl %esp, %ebp

							#Current character count
movl $0, %ecx
							#Move the value into position
movl ST_VALUE(%ebp), %eax
							#When we divide by 10, the 10
							#must be in a register or memory location
movl $16, %edi
conversion_loop:
							#Division is actually performed on the
							#combined %edx:%eax register, so first
							#clear out %edx
movl $0, %edx
							#Divide %edx:%eax (which are implied) by 10.
							#Store the quotient in %eax and the remainder
							#in %edx (both of which are implied).
divl %edi
							#Quotient is in the right place. %edx has
							#the remainder, which now needs to be converted
							#into a number. So, %edx has a number that is
							#0 through 9. You could also interpret this as
							#an index on the ASCII table starting from the
							#character ’0’. The ascii code for ’0’ plus zero
							#is still the ascii code for ’0’. The ascii code
							#for ’0’ plus 1 is the ascii code for the
							#character ’1’. Therefore, the following
							#instruction will give us the character for the
							#number stored in %edx
cmpl $10, %edx
jge over_hex						#if the remainder is 10 or over we will have to
							#add a different value to reach the hex characters
							#in the ascii table
addl $'0', %edx
jmp  continue

over_hex:

addl $'W', %edx						#if we have a 10 or over digit we need the hex
							#character which will require us to use "W"
							#added with %edx to reach the 'a' through 'f'
							#in the ascii table.

							#Now we will take this value and push it on the

continue:
							#stack. This way, when we are done, we can just
							#pop off the characters one-by-one and they will
							#be in the right order. Note that we are pushing
							#the whole register, but we only need the byte
							#in %dl (the last byte of the %edx register) for
							#the character.
pushl %edx
							#Increment the digit count
incl %ecx
							#Check to see if %eax is zero yet, go to next
							#step if so.
cmpl $0, %eax
je end_conversion_loop
							#%eax already has its new value.
jmp conversion_loop
end_conversion_loop:
							#The string is now on the stack, if we pop it
							#off a character at a time we can copy it into
							#the buffer and be done.
							#Get the pointer to the buffer in %edx
movl ST_BUFFER(%ebp), %edx
copy_reversing_loop:
							#We pushed a whole register, but we only need
							#the last byte. So we are going to pop off to
							#the entire %eax register, but then only move the
							#small part (%al) into the character string.
popl %eax
movb %al, (%edx)


							#Decreasing %ecx so we know when we are finished
decl %ecx
							#Increasing %edx so that it will be pointing to
							#the next byte
incl %edx
							#Check to see if we are finished
cmpl $0, %ecx
							#If so, jump to the end of the function
je end_copy_reversing_loop
							#Otherwise, repeat the loop
jmp copy_reversing_loop
end_copy_reversing_loop:
							#Done copying. Now write a null byte and return
movb $0, (%edx)

movl %ebp, %esp
popl %ebp
ret
