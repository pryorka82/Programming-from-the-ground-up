.include "linux.s"
.include "record-def.s"
#This program completes this section of "Going Further" from chapter 6
#Research the various error codes that can be returned by the system calls made
#in these programs. Pick one to rewrite, and add code that checks %eax for error
#conditions, and, if one is found, writes a message about it to STDERR and exit.

#The program is passed the name of the .dat file to open on the command line.

.section .data
#file_name:
#.ascii "loop.dat\0"  #change to the name of the file being read (loop.dat for
		     #writing 30 identical records)

errmsg: .ascii "Error in SYSCALL\n"   #general error message
errnofile: .ascii "No such file or directory\n"   #specific error code -2

.section .bss
.lcomm record_buffer, RECORD_SIZE

.section .text
#Main program
.globl _start
_start:
#These are the locations on the stack where
#we will store the input and output descriptors
#(FYI - we could have used memory addresses in
#a .data section instead)
.equ ST_INPUT_DESCRIPTOR, -4
.equ ST_OUTPUT_DESCRIPTOR, -8
.equ file_name, 8
#Copy the stack pointer to %ebp
movl %esp, %ebp
#Allocate space to hold the file descriptors
subl $8,  %esp

#Open the file
movl  $SYS_OPEN, %eax
movl  file_name(%ebp), %ebx
movl  $0, %ecx    #This says to open read-only
movl  $0666, %edx
int   $LINUX_SYSCALL

cmpl $0, %eax	#check for error codes (negative numbers)
jl write_error	#jump to write error if less than 0 

#Save file descriptor

movl  %eax, ST_INPUT_DESCRIPTOR(%ebp)

#Even though it's a constant, we are
#saving the output file descriptor in
#a local variable so that if we later
#decide that it isn't always going to
#be STDOUT, we can change it easily.
movl  $STDOUT, ST_OUTPUT_DESCRIPTOR(%ebp)

record_read_loop:
pushl ST_INPUT_DESCRIPTOR(%ebp)
pushl $record_buffer
call  read_record
addl  $8, %esp

#Returns the number of bytes read.
#If it isn't the same number we
#requested, then it's either an
#end-of-file, or an error, so we're
#quitting
cmpl  $RECORD_SIZE, %eax
jne   finished_reading

#Otherwise, print out the first name
#but first, we must know it's size
pushl  $RECORD_FIRSTNAME + record_buffer
call   count_chars
addl   $4, %esp
movl   %eax, %edx         #%eax contains the count returned from count_chars
movl   ST_OUTPUT_DESCRIPTOR(%ebp), %ebx
movl   $SYS_WRITE, %eax
movl   $RECORD_FIRSTNAME + record_buffer, %ecx
int    $LINUX_SYSCALL

pushl  ST_OUTPUT_DESCRIPTOR(%ebp)
call   write_newline
addl   $4, %esp

jmp    record_read_loop

finished_reading:
movl   $SYS_EXIT, %eax
movl   $0, %ebx
int    $LINUX_SYSCALL

write_error:
cmpl $-2, %eax   #check for error codes (negative numbers)
je write_specific_error  #jump to write error if less than 0 

movl   $25, %edx         #suficient space for possible error messages
movl   $STDERR, %ebx	 #write out to STDERR
movl   $SYS_WRITE, %eax
movl   $errmsg, %ecx	 #load general error message
int    $LINUX_SYSCALL
jmp finished_reading

write_specific_error:

movl   $25, %edx         #suficient space for possible error messages
movl   $STDERR, %ebx     #write out to STDERR
movl   $SYS_WRITE, %eax
movl   $errnofile, %ecx  #load no file error string
int    $LINUX_SYSCALL
jmp finished_reading
