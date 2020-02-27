
;		16_3(1)	直接定址表

;现在，我们讨论用查表得方法编写相关程序的技巧
;编写子程序，以十六进制的形式在屏幕中间显示给定的字节型数据。

;分析：一个字节需要用两个十六进制数码来表示，所以，子程序需要在屏幕上显示两个ASCII字符。
;我们当然要用"0"、"1"、"2"、"3"、"4"、"5"、"6"、"7"、"8"、"9"、"A"、"B"、"C"、"D"
;"E"、"F"这16个字符来显示十六进制数码。

;我们可以将一个字节的高4位和低4位分开，分别用它们的值得到对应的数码字符。比如2Bh，
;可以得到高4位的值为2，低4位的值为11，那么如何用这两个数值得到对应的数码字符"2"和"B"呢？

;最简单的办法就是一个一个地比较，比如：
;如果数值为0，则显示"0"
;如果数值为1，则显示"1"
;.....................
;如果数值为11，则显示"B"

;可以看出，这样做，程序中要使用多条比较、转移指令。程序将比较长，混乱。
;显然，我们希望能够在数值0~15和字符"0"~"F"之间找到一种映射关系。这样用0~15间的任何
;数值，都可以通过这种映射关系直接得到"0"~"F"中对应的字符。

;数值0~9和"0"~"9"之间的映射关系是很明显的，即：
;数值+30h=对应字符的ASCII值
;0+30h="0"的ASCII值
;................

;但是，10~15和"A"~"F"之间的映射关系是：
;数值+37h=对应字符的ASCII值
;10+37h="A"的ASCII值
;...................

;可见，我们可以利用数值和字符之间的这种原本存在的映射关系，通过高4位和低4位值得到对应
;的字符码。但是由于映射关系的不同，我们在程序中必须进行一些比较，对于大于9的数值，
;我们要用不同的计算方法。

;这样做，虽然使程序得到了简化。但是，如果我们希望用更简捷的算法，就要考虑用同一种映射
;关系从数值得到字符码。所以，我们就不能利用0~9和"0"~"9"之间与10~15和""A~"F"之间原有
;的映射关系

;因为数值0~15和字符"0"~"F"之间没有一致的映射关系存在，所以，我们应该在它们之间建立新的
;映射关系。

;具体做法是，建立一张表，表中依次存储字符"0"~"F",我们可以通过数值0~15直接查找对应的字符
;子程序如下：

;用al传送要显示的数据

showbyte:	jmp short show
			table db '0123456789ABCDEF'		;字符表

	show:	push bx
			push es
			
			mov ah,al			;用al传送要显示的数据如：2Bh=0010 1011b
			shr ah,1
			shr ah,1
			shr ah,1
			shr ah,1			;右移4位，ah中得到高4位的值ah中为0000 0010b=2h
			and al,00001111b	;al中为低4位的值al的值为(二进制)0000 1011b=Bh(16进制)
			
			mov bl,ah
			mov bh,0
			mov ah,table[bx]	;用高4位的值2h作为相对于table的偏移，取得对应的字符
			
			mov bx,0b800h
			mov es,bx
			mov es:[160*12+40*2],ah		;放入显存
			
			mov bl,al
			mov bh,0
			mov al,table[bx]		;用低4位bh的值作为相对于table的偏移，Bh相当于11
			
			mov es:[160*12+40*2+2],al	;放入显存
		
			pop es
			pop bx
			
			ret

;可以看出，在子程序中，我们在数值0~15和字符"0"~"F"之间建立的映射关系，使我们可以用查表
;的方法根据给出的数据得到其在另一集合中的对应数据。这样做的目的一般来说有以下3个。
;(1)为了算法的清晰和简洁
;(2)为了加快运算速度
;(3)为了使程序易于扩充


;在上面的子程序中，我们更多的是为了算法的清晰和简洁，而采用了查表的方法。下面我们来看一
;下，为了加快运算速度而采用查表的方法的情况。	
			
