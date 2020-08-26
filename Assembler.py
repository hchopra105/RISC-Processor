import re
##def DtoB(n):  
 ##   return bin(n).replace("0b", "")
def DtoB(num, wordsize):
    if num < 0:
        num = 2**wordsize+num
    base = bin(num)[2:]
    padding_size = wordsize - len(base)
    return '0' * padding_size + base

myfile=open("code.txt","r")
out=[]
lines=myfile.readlines()
f = open("D:\Sem_2\Processor\Project_1\Pipelined_risc\instr_bin.txt","w")

for i in lines:
    instr=re.split("[,\n ;]",i)
   ##############R type##########
    if (instr[0]=="nop"):
        out.append("1111000000000000"+"\n")
    elif (instr[0]=="add"):
        opcode="0000"
        rc=str(DtoB(int(instr[1][1:]),3))
        ra=str(DtoB(int(instr[2][1:]),3))
        rb=str(DtoB(int(instr[3][1:]),3))
        out.append(opcode+ra+rb+rc+"000"+"\n")
    elif (instr[0]=="adc"):
        opcode="0000"
        rc=str(DtoB(int(instr[1][1:]),3))
        ra=str(DtoB(int(instr[2][1:]),3))
        rb=str(DtoB(int(instr[3][1:]),3))
        out.append(opcode+ra+rb+rc+"010"+"\n")
    elif (instr[0]=="adz"):
        opcode="0000"
        rc=str(DtoB(int(instr[1][1:]),3))
        ra=str(DtoB(int(instr[2][1:]),3))
        rb=str(DtoB(int(instr[3][1:]),3))
        out.append(opcode+ra+rb+rc+"001"+"\n")       
    elif (instr[0]=="ndu"):
        opcode="0010"
        rc=str(DtoB(int(instr[1][1:]),3))
        ra=str(DtoB(int(instr[2][1:]),3))
        rb=str(DtoB(int(instr[3][1:]),3))
        out.append(opcode+ra+rb+rc+"000"+"\n")
    elif (instr[0]=="ndc"):
        opcode="0010"
        rc=str(DtoB(int(instr[1][1:]),3))
        ra=str(DtoB(int(instr[2][1:]),3))
        rb=str(DtoB(int(instr[3][1:]),3))
        out.append(opcode+ra+rb+rc+"010"+"\n")
    elif (instr[0]=="ndz"):
        opcode="0010"
        rc=str(DtoB(int(instr[1][1:]),3))
        ra=str(DtoB(int(instr[2][1:]),3))
        rb=str(DtoB(int(instr[3][1:]),3))
        out.append(opcode+ra+rb+rc+"001"+"\n")

   ########## Imm6 ##############
    elif (instr[0]=="adi"):
        opcode="0001"
        rb=str(DtoB(int(instr[1][1:]),3))
        ra=str(DtoB(int(instr[2][1:]),3))
        Imm6=str(DtoB(int(instr[3]),6))
        out.append(opcode+ra+rb+Imm6+"\n")
    elif (instr[0]=="lw"):
        opcode="0100"
        ra=str(DtoB(int(instr[1][1:]),3))
        rb=str(DtoB(int(instr[2][1:]),3))
        Imm6=str(DtoB(int(instr[3]),6))
        out.append(opcode+ra+rb+Imm6+"\n")
    elif (instr[0]=="sw"):
        opcode="0101"
        ra=str(DtoB(int(instr[1][1:]),3))
        rb=str(DtoB(int(instr[2][1:]),3))
        Imm6=str(DtoB(int(instr[3]),6))
        out.append(opcode+ra+rb+Imm6+"\n")
    elif (instr[0]=="beq"):
        opcode="1100"
        ra=str(DtoB(int(instr[1][1:]),3))
        rb=str(DtoB(int(instr[2][1:]),3))
        Imm6=str(DtoB(int(instr[3]),6))
        out.append(opcode+ra+rb+Imm6+"\n")
    elif (instr[0]=="jalr" and (instr[2][0]=="r")):
        opcode="1001"
        ra=str(DtoB(int(instr[1][1:]),3))
        rb=str(DtoB(int(instr[2][1:]),3))
        out.append(opcode+ra+rb+"000000"+"\n")    

    ########## Imm9 ###########    
    elif (instr[0]=="lhi"):

        opcode="0011"
        ra=str(DtoB(int(instr[1][1:]),3))
        #Imm9=str(DtoB(int(instr[2]),9))
        Imm9=instr[2]
        out.append(opcode+ra+Imm9+"\n")
    elif (instr[0]=="jalr"):
        opcode="1000"
        ra=str(DtoB(int(instr[1][1:]),3))
        Imm9=str(DtoB(int(instr[2]),9))
        out.append(opcode+ra+Imm9+"\n")    
    ############ LM SM #########
    elif (instr[0]=="lm"):
        opcode="0110"
        ra=str(DtoB(int(instr[1][1:]),3))
        Imm9=instr[2]
        out.append(opcode+ra+Imm9+"\n")
    elif (instr[0]=="sm"):
        opcode="0111"
        ra=str(DtoB(int(instr[1][1:]),3))
        Imm9=instr[2]
        out.append(opcode+ra+Imm9+"\n")   


f.writelines(out)
f.close()










        
