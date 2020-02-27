;前面的课程都是累加内存单元中的数据，并不关心数据本身。可现在要累加的是
;给定的数据。我们可以一个一个的加到ax寄存器中，但是我们希望可以用循环方法
;进行累加，所以在累加前，要将这些数据存储在一组地址连续的内存单元中

assume cs:code

code segment

		dw 0123h,0456h,0789h,0abch,0defh,0fedh,0cbah,0987h
		
		mov bx,0	;偏移地址
		mov ax,0	;累加器ax置0
		
		mov cx,8
		
	s:	add ax,cs:[bx]	;由于它们在代码段中，程序在运行时cs中存放代码段的段地址
						;所以可以从cs中得到它们的段地址，又因为用dw定义的数据处于代码段
						;的最开始，所以偏移地址为0，这8个数据就在代码段的偏移0、2、4
						;6、8、A、C、E处。程序运行时，它们的地址就是CS：0
						;CS:2、CS:4、CS:6、CS:8、CS：A、CS:C、CS:E处
						;由于8个字型数据是在code代码段中定义
						
						
		add bx,2		;传送的是字型数据，所以加2（两字节为一个字）
		loop s
		
		mov ax,4c00h
		int 21h
		
code ends

end