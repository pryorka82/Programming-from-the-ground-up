.include "record-def.s"
.include "linux.s"

#PURPOSE:   This function reads a record from the file
#          descriptor
#
#INPUT:    The file descriptor and a buffer
#
#OUTPUT:   This function writes the data to the buffer
#          and returns a status code.
#
#STACK LOCAL VARIABLES
.section .data
        no_open_file_msg:
                .ascii "Error in read call\0"
	error_code:
                .ascii "0001:\0"




.equ ST_READ_BUFFER, 8
.equ ST_FILEDES, 12



.section .text
.globl read_record
.type read_record, @function
read_record:
pushl %ebp
movl  %esp, %ebp

pushl %ebx
movl  ST_FILEDES(%ebp), %ebx
movl  ST_READ_BUFFER(%ebp), %ecx
movl  $RECORD_SIZE, %edx
movl  $SYS_READ, %eax
int   $LINUX_SYSCALL

cmpl $0, %eax
jge continue_processing

pushl $no_open_file_msg
pushl $error_code
call error_exit

continue_processing:




#NOTE - %eax has the return value, which we will
#       give back to our calling program
popl  %ebx

movl  %ebp, %esp
popl  %ebp
ret
