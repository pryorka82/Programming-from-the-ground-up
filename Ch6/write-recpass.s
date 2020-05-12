.include "linux.s"
.include "record-def.s"

.section .data

file_name:
.ascii "testpass.dat\0"

age:
.long 34

entfirst:  .ascii "Enter First Name\n"  #prompt for first name 17 char
entlast:   .ascii "Enter Last Name\n"   #prompt for last name 16 char
entaddress: .ascii "Enter Address\n"     #prompt for address 14 char


.section .bss
.lcomm BUFFER, RECORD_SIZE

.section .text

.globl _start
_start:

.equ ST_FILE_DESCRIPTOR, -4

#Copy the stack pointer to %ebp
movl %esp, %ebp
#Allocate space to hold the file descriptor
subl $4, %esp

#Open the file
movl  $SYS_OPEN, %eax
movl  $file_name, %ebx
movl  $0101, %ecx #This says to create if it
                 #doesn't exist, and open for
                  #writing
movl  $0666, %edx
int   $LINUX_SYSCALL

#Store the file descriptor away
movl  %eax, ST_FILE_DESCRIPTOR(%ebp)

#FIRST NAME PROMPT AND RECEIVE
#START PROMPT FOR FIRST NAME!!!!!!!!!!!!!!!!!!!!!!!!!!
movl   $17, %edx         #entfirst has 17 chars
movl   $STDOUT, %ebx      #write prompt to screen
movl   $SYS_WRITE, %eax	  #write system call
movl   $entfirst, %ecx      #load entfirst message
int    $LINUX_SYSCALL

#RECEIVE RESPONSE TYPED IN
movl   $40, %edx         #Size of first name field
movl   $STDIN, %ebx      #read response from screen
movl   $SYS_READ, %eax   #read system call
movl   $BUFFER + RECORD_FIRSTNAME, %ecx      #add first name to buffer
int    $LINUX_SYSCALL

#LAST NAME PROMPT AND RECEIVE
#START PROMPT FOR LAST NAME!!!!!!!!!!!!!!!!!!!!!!!!!!
movl   $16, %edx         #entfirst has 16 chars
movl   $STDOUT, %ebx      #write prompt to screen
movl   $SYS_WRITE, %eax   #write system call
movl   $entlast, %ecx      #load entfirst message
int    $LINUX_SYSCALL

#RECEIVE RESPONSE TYPED IN
movl   $40, %edx         #Size of last name field
movl   $STDIN, %ebx      #read response from screen
movl   $SYS_READ, %eax   #read system call
movl   $BUFFER + RECORD_LASTNAME, %ecx      #add last name to buffer
int    $LINUX_SYSCALL


#ADDRESS PROMPT AND RECEIVE
#START PROMPT FOR ADDRESS!!!!!!!!!!!!!!!!!!!!!!!!!!
movl   $14, %edx         #entfirst has 14 chars
movl   $STDOUT, %ebx      #write prompt to screen
movl   $SYS_WRITE, %eax   #write system call
movl   $entaddress, %ecx      #load entaddress message
int    $LINUX_SYSCALL

#RECEIVE RESPONSE TYPED IN
movl   $240, %edx         #Size of address field
movl   $STDIN, %ebx      #read response from screen
movl   $SYS_READ, %eax   #read system call
movl   $BUFFER + RECORD_ADDRESS, %ecx      #add address to buffer
int    $LINUX_SYSCALL

#ADD default age to buffer
movl $RECORD_AGE, %ecx
movl $age, BUFFER(,%ecx,1)

#write the buffer to the record
pushl ST_FILE_DESCRIPTOR(%ebp)
pushl $BUFFER
call  write_record
addl  $8, %esp

#Close the file descriptor
movl  $SYS_CLOSE, %eax
movl  ST_FILE_DESCRIPTOR(%ebp), %ebx
int   $LINUX_SYSCALL

#Exit the program
movl  $SYS_EXIT, %eax
movl  %edi, %ebx
int   $LINUX_SYSCALL
