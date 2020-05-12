#PURPOSE:  Compare the characters until 5 characters are reached or a mismatch
#
#INPUT:    The address of the string to search 
#	   The address of the first name
#
#OUTPUT:   Returns 1 if there is a match
#
#PROCESS:
#  Registers used:
#    %edi - character count
#    %al - current character
#    %edx - current character address

.type compare_strings, @function
.globl compare_strings

#This is where our one parameter is on the stack
.equ ST_STRING_START_ADDRESS, 8
.equ FIRSTNAME, 12
compare_strings:
pushl %ebp
movl  %esp, %ebp

#Counter starts at zero
movl  $0, %edi

#Starting address of data
movl  ST_STRING_START_ADDRESS(%ebp), %edx
movl  FIRSTNAME(%ebp), %ecx

count_loop_begin:
#Grab the current character
movb  (%edx), %al
movb  (%ecx), %bl

#Are the bytes equal?
cmpb  %bl, %al
#If no, we're done
jne    count_loop_end
#Otherwise, increment the counter and the pointers
incl  %edi
incl  %edx
incl  %ecx

cmpl $5, %edi   #if we reach five characters matched?
je end_match   

#Go back to the beginning of the loop
jmp   count_loop_begin

count_loop_end:
#We're done.  Set %eax to 0
#and return.
movl  $0, %eax
popl  %ebp
ret

end_match:
#We're done.  Set %eax to 1
#and return.
movl  $1, %eax
popl  %ebp
ret

