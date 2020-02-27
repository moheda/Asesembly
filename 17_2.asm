
;		17_2	使用int 16h中断例程读取键盘缓冲区

;BIOS提供了int 16h中断例程供程序员调用。int 16h中断例程中包含了一个最重要的功能是从
;键盘缓冲区中读取一个键盘输入，该功能的编号为0.下面的指令从键盘缓冲区中读取一个键盘
;输入，并且将其从缓冲区中删除302 (314 / 354)pdf：
mov ah,0
int 16h
;结果：(ah)=扫描码。(al)=ASCII码

;我们接着上一节中的键盘输入过程，看一下int 16h如何读取键盘缓冲区。
;(1)执行
mov ah,0
int 16h
;后，ah中的内容为1Eh，al中的内容为61h(书上有图)
;执行多次上面的指令后，键盘缓冲区的值被删除完后为空
;int 16h中断例程检测键盘缓冲区，发现缓冲区空，则循环等待，直到缓冲区中有数据

;因此，int 16h中断例程的0号功能，进行如下工作：
;(1)检测键盘缓冲区是否有数据
;(2)没有则继续第1步
;(3)读取缓冲区第一个字单元中的键盘输入
;(4)将读取的扫描码送入ah.ASCII码送入al
;(5)将已读取的键盘输入从缓冲区中删除

;可见，BIOS的int 9中断例程和int 16h中断例程是一对相互配合的程序，int 9中断例程向键盘
;缓冲区中写入，int 16h从缓冲区中读出。它们写入和读出的时机不同，int 9中断例程是在有
;键按下的时候向键盘缓冲区中写入数据；而int 16h中断例程是在应用程序对其进行调用的时候
;将数据从键盘缓冲区中读出。
;我们在编写一般的处理键盘输入的程序的时候，可以调用int 16h从键盘缓冲区中读取键盘的输入

;-----------------------------------------------------------------------------------

;编程，接收用户的输入，输入"r"，将屏幕上的字符设置为红色；输入"g"，将屏幕上的字符设置
;为绿色；输入"b"，将屏幕上的字符设置为蓝色。程序如下：

assume cs:code

code segment

start:	mov ah,0			;在键盘缓冲区获取用户键盘的输入
		int 16h				;(ah)=扫描码。(al)=ASCII码
		
		mov ah,1		;?
		cmp al,'r'		;用户的输入与r比较
		je red			;相等则跳转到标号red处
		cmp al,'g'
		je green
		cmp al,'b'
		je blue
		jmp short sret
		
red:	shl ah,1		;?

green:	shl al,1		;?

blue:	mov bx,0b800h
		mov es,ax
		mov bx,1
		mov cx,2000
		
s:		and byte ptr es:[bx],11111000b
		or es:[bx],ah
		add bx,2
		loop s 
		
sret:	mov ax,4c00h
		int 21h
		
code ends

end start