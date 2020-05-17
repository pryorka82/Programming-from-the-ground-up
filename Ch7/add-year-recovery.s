.include "linux.s"
.include "record-def.s"

.section .data

	no_open_file_code:
		.ascii "0001: \0"
	no_open_file_msg:
		.ascii "Can’t Open Input File\0"

        no_open_file_msg_out:
                .ascii "Can’t Open Output File\0"
	prompt_msg:
		.ascii "Can't open file, try entering filename here:\0"
	no_read:
		.ascii "Can't read file\0"

input_file_name:
.ascii "test1.dat\0"

output_file_name:
.ascii "testout.dat\0"

.section .bss
.lcomm record_buffer, RECORD_SIZE
.lcomm file_name_buf, 20


#Stack offsets of local variables
.equ ST_INPUT_DESCRIPTOR, -4
.equ ST_OUTPUT_DESCRIPTOR, -8

.section .text
.globl _start
_start:
				#Copy stack pointer and make room for local variables

movl %esp, %ebp
subl $8, %esp
				#Open file for reading
movl $SYS_OPEN, %eax
movl $input_file_name, %ebx
movl $0, %ecx
movl $0666, %edx
int $LINUX_SYSCALL

cmpl $0, %eax				#Open file for writing
jge continue_processing


#Prompt for filename
movl $SYS_WRITE, %eax
movl $STDOUT, %ebx
movl $prompt_msg, %ecx
movl $45, %edx
int $LINUX_SYSCALL

#Receive filename entered
movl $SYS_READ, %eax
movl $STDIN, %ebx
movl $file_name_buf, %ecx
movl $50, %edx
int $LINUX_SYSCALL

pushl $file_name_buf
call count_chars
addl $4, %ebp

decl %eax
movb $0, file_name_buf(,%eax,1)


movl $SYS_OPEN, %eax
movl $file_name_buf, %ebx
movl $0, %ecx
movl $0666, %edx
int $LINUX_SYSCALL



cmpl $0, %eax
jge continue_processing

pushl $no_open_file_msg
pushl $no_open_file_code
call error_exit


continue_processing:
movl %eax, ST_INPUT_DESCRIPTOR(%ebp)

#OPEN OUTPUT FILE
movl $SYS_OPEN, %eax
movl $output_file_name, %ebx
movl $0101, %ecx
movl $0666, %edx
int $LINUX_SYSCALL


cmpl $0, %eax 		#if won't open, output error messages and exit
jge continue_processing1  #otherwise jump 

pushl $no_open_file_msg_out
pushl $no_open_file_code
call error_exit

continue_processing1:


movl %eax, ST_OUTPUT_DESCRIPTOR(%ebp)

loop_begin:
pushl ST_INPUT_DESCRIPTOR(%ebp)
pushl $record_buffer
call read_record
addl $8, %esp

	#Returns the number of bytes read.
	#If it isn’t the same number we
	#requested, then it’s either an
	#end-of-file, or an error, so we’re
	#quitting

cmpl $RECORD_SIZE, %eax
jne loop_end

	#Increment the age
incl record_buffer + RECORD_AGE

	#Write the record out

pushl ST_OUTPUT_DESCRIPTOR(%ebp)
pushl $record_buffer
call write_record
addl $8, %esp

jmp loop_begin

loop_end:

movl $SYS_EXIT, %eax
movl $0, %ebx
int $LINUX_SYSCALL
