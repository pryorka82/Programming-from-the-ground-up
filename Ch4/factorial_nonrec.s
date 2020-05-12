#PURPOSE - Give a number, this program computes the factorial. For
# 	   example, the factorial of 3 is 3 * 2 * 1, = 6.
#This program shows how to call a function recursively.

.section .data

#This program has no global data

.section .text

.globl _start
.globl factorial #this is unneeded unless we want to share 
		 #this function among other programs
_start:
pushl $5	#The factorial takes one argument - the number we want
		#a factorial of.  So, it gets pushed
call factorial  #run the factorial function
addl $4, %esp   #Scrubs the parameter that was pushed on the stack

movl %eax, %ebx #factorial returns the answer in %eax, but we want it
		#in %ebx to sent it as our exit status

movl $1, %eax 	#call the kernel's exit function
int $0x80

#This is the actual function definition
.type factorial, @function
factorial:
pushl %ebp	#standard function stuff - we have to restore %ebp to its
		#prior state before returning, so we have to push it
movl %esp, %ebp #This is because we don't want to modify the stack pointer
		#so we use %ebp
movl 8(%ebp), %ebx #This moves the first argument to %ebx
		   # 4(%ebp) holds the return address, and
		   # 8(%ebp) holds the first parameter
movl %ebx, %eax   #move the value to %eax as well

fac_loop:
cmpl $1, %ebx	#If the number is 1, that is our base case, and we simply
		#return (1 is already in %eax as the return value
je end_factorial
decl %ebx	#otherwise, decrease the value
imull %ebx, %eax #multiply the values and store in %eax
jmp fac_loop

end_factorial:
movl %ebp, %esp #restore the stack pointer
popl %ebp	#have to restore %ebp and %esp to where they were before the
		#function started 
ret		#return to the function (this pops the return value too



