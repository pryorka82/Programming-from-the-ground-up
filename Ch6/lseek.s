.include "linux.s"
.include "record-def.s"
.section .data
file_name:
.ascii "test.dat\0"

.section .bss
.lcomm record_buffer, RECORD_SIZE

#Stack offsets of local variables
.equ FILE_DESCRIPTOR, -4

.section .text
.globl _start
_start:
#Copy stack pointer and make room for local variables
movl  %esp, %ebp
subl  $8, %esp

#Open file for reading
movl  $5, %eax              #open file for read and write
movl  $file_name, %ebx
movl  $2, %ecx             #read-write access
movl  $0666, %edx
int   $LINUX_SYSCALL

movl  %eax, FILE_DESCRIPTOR(%ebp)


loop_begin:
pushl FILE_DESCRIPTOR(%ebp)
pushl $record_buffer
call  read_record
addl  $8, %esp

#Returns the number of bytes read.
#If it isn't the same number we
#requested, then it's either an
#end-of-file, or an error, so we're
#quitting
cmpl  $RECORD_SIZE, %eax
jne   loop_end

#Increment the age
incl  record_buffer + RECORD_AGE

#Change buffer pointer
movl $19, %eax    #sys_lseek call number
movl FILE_DESCRIPTOR(%ebp), %ebx
movl $1, %edx   # move from current position
movl $RECORD_SIZE, %ecx   #offset is the negative record size to move back
negl %ecx                 #same amount moved forward in previous call
int   $LINUX_SYSCALL



#Write the record out
pushl FILE_DESCRIPTOR(%ebp)
pushl $record_buffer
call  write_record
addl  $8, %esp

jmp   loop_begin

loop_end:
movl  $SYS_EXIT, %eax
movl  $0, %ebx
int   $LINUX_SYSCALL
