.386 
.model flat,stdcall 
option casemap: none 
include C:\masm32\include\windows.inc 
include C:\masm32\include\kernel32.inc 
includelib C:\masm32\lib\kernel32.lib 
include C:\masm32\include\user32.inc 
includelib C:\masm32\lib\user32.lib 


.data 
msg1 db "Попробуй угадать случайное число от 1 до 100, у вас есть 3 попытки", 13, 10 
msg2 db "pobeda", 13, 10 
msg3 db "не правильно",13,10
msg4 db "bolshe",13,10
msg5 db "menshe",13,10
msg6 db "chiclo a ne bykva",13,10
msg7 db "Eto ne moe chislo! zasun ego sebe v uho",13,10
msg8 db "ne pravilno! neujeli dlya tvoego malenkogo mozga tak slojno!",13,10
msg9 db "Net! Ty voobshe pytaeshsya dumat?",13,10


buff    db 260 dup(?) 
dwRead  dd ? 
popitki dd 3
stdout dd ? 
stdin dd ? 
cWriten DWORD ?
cRead DWORD ? 
rand dd 53 
;cRead DWORD ? ; Dword(4 байта)

z dd 0 ; переменная для основного цикла 
l dd ? ; нужна для корректирования числа попыток при считывании 
a dd ?
.code 
start: 

invoke GetTickCount 
mov ebx, 100 
mov edx, 0 
div ebx 
mov rand, edx 


invoke GetStdHandle, -11 
mov stdout, eax 
invoke GetStdHandle, -10  
mov stdin, eax 

naz:
invoke CharToOem, ADDR msg1, ADDR msg1 
invoke WriteConsoleA, stdout,addr msg1, sizeof msg1, 0, 0 

cycle:
invoke ReadConsole, stdin, addr buff, sizeof buff, addr dwRead, 0


nashalo:
sub dwRead, 2                         
mov eax, 0                            
mov ecx, 0
translation:                          
mov bl, buff[ecx]                     
cmp bl,48                             
jge gg                                
gg:
cmp bl,57                              
jle gg1                                 
invoke WriteConsole, stdout, offset msg6, sizeof msg6, 0, 0 
mov l,1 
jmp perehod 
;jmp vehod                           
gg1:
sub bl, 48                            
imul eax,eax,10                         
mov byte ptr [a],bl                    
add eax,a                             
inc ecx                               
mov l,0     
 
cmp dwRead,ecx                          
jne translation                        

cmp rand,eax                        
jg bolshe                               
cmp rand,eax
jl menshe                                
cmp rand,eax
je ochibka  
cmp rand,eax
je win                              

perehod:
mov ecx,z                             
inc ecx                                           
sub ecx,l                    
mov z,ecx                                             
cmp popitki,ecx                        
jne cycle                           
jmp vehod

bolshe:
invoke WriteConsole, stdout, offset msg4 , sizeof msg4 , 0, 0
invoke WriteConsole, stdout, offset msg9 , sizeof msg9 , 0, 0
jmp perehod  
                     
menshe:
invoke WriteConsole, stdout, offset msg5, sizeof msg5, 0, 0
invoke WriteConsole, stdout, offset msg7 , sizeof msg7 , 0, 0
jmp perehod

ochibka:
invoke WriteConsole, stdout, offset msg6, sizeof msg6, 0, 0
jmp vehod
jmp perehod

win:
invoke WriteConsole, stdout, offset msg2, sizeof msg2, 0, 0
jmp perehod
                                 
vehod:
invoke ExitProcess, 0 
end start