
;	11.9	根据cmp指令的比较结果（即cmp指令之下后，相关标志位的值）进行工作的指令

;						检测比较结果的条件转移指令
;"转移"指的是它能够修改IP，而"条件"指的是它可以根据某种条件，决定是否修改IP
;大多数条件转移指令都检测标志寄存器的相关标志位，根据检测的结果来决定是否
;修改IP。它们检测的是被cmp指令影响的那些，表示比较结果的标志位。这些条件转移
;指令通常都和cmp配合使用，就好像call和ret指令通常相配合使用一样

;因为cmp指令可以同时进行两种比较，所以根据cmp指令的比较结果进行转移的指令也分为
;两种，即根据无符号数的比较结果进行转移的条件转移指令（它们检测zf、cf的值）和根
;据有符号数的比较结果进行转移的条件转移指令（它们检测sf、of和zf的值）

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

		;下面是常用的根据无符号的比较结果进行转移的条件转移指令。
		
	;	指令					含义				检测的相关标志位
	
	;	je					等于则转移					zf=1
	;	jne					不等于则转移				zf=0
	
	;	jb					低于则转移					cf=1
	;	jnb					不低于则转移				cf=0
	
	;	ja					高于则转移					cf=0且zf=0
	;	jna					不高于则转移				cf=1或zf=1
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;（1）编程，统计data段中数值为8的字节的个数，用ax保存统计结果
assume cs:code,ds:data

data segment

	db 8,11,8,1,8,5,63,38
	
data ends

code segment

start:	mov ax,data
		mov ds,ax
		mov bx,0			;ds:bx指向第一个字节
		
		mov ax,0			;初始化累加器
		
		mov cx,8
		
	s:	cmp byte ptr [bx],8	;和8进行比较
		jne next			;如果不相等转到next，继续循环
		inc ax				;如果相等就将计数值加1
		
next:	inc bx
		loop s 				;程序执行后（ax）=3
		
code ends

end start

;也可以写成(2)
;		mov ax,data
;		mov ds,ax
;		mov bx,0
;		
;		mov ax,0
;		
;		mov cx,8
;		
;	s:	cmp byte ptr [bx],8
;		je ok 				;如果相等转到ok
;		jmp short next		;如果不相等就转到next，继续循环
;		
;	ok:	inc ax				;如果相等就将计数值加1
;	
;next:	inc bx
;		loop s 
		
	