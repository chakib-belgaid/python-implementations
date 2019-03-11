import time
from math import *
from array import *
import sys
##lib--from numba import jit 

# import math

class LoException(Exception):
    pass
    
class HiException(Exception):
    pass
    


# class TommtiBenchmark:
    # startTime = 0
    # stopTime = 0
# elapsedTime = 0
selfi = { 
     "Lo" : 0 ,
      "Hi" : 0 ,
      "IM" : 139968.0 ,
      "IA" : 3877 ,
      "IC" : 29573 ,
      "last" : 42 ,
      "lSIZE" : 100 ,
      "mSIZE" : 25 } 


intMax = 50000
doubleMin = -25000
doubleMax = 25000
longMin = -25000
longMax = 25000
trigMax = 5000
ioMax = 600
warmup=500
mainloop=1000

    

##lib--@jit
def intArithmetic (selfi, intMax):
    intResult = 1
    i = 0
    while (i<intMax):
        intResult -= i
        i = i + 1
        intResult += i
        i = i + 1
        intResult *= i
        i = i + 1 
        intResult /= i
        i = i + 1
    return True
 		

##lib--@jit
def doubleArithmetic(selfi, doubleMin, doubleMax):
    doubleResult = doubleMin
    i = doubleMin
    while (i<doubleMax):
        doubleResult -= i
        i = i + 1
        doubleResult += i
        i = i + 1
        doubleResult *= i
        i = i + 1
        doubleResult /= i
        i = i + 1
    return True
 		

##lib--@jit
def longArithmetic(selfi, intMin, intMax):
    intResult = intMin
    i = intMin
    while (i<intMax):
        intResult -= i
        i = i + 1
        intResult += i
        i = i + 1
        intResult *= i
        i = i + 1
        intResult /= i
        i = i + 1
    return True
 		

##lib--@jit
def trig(selfi, trigMax):
    sine = 0.0
    cosine = 0.0
    tangent = 0.0
    logarithm = 0.0
    squareRoot = 0.0
    i = 1
    while (i<trigMax):
        sine = sin(i)
        cosine = cos(i)
        tangent = tan(i)
        logarithm = log(i, 10)
        squareRoot = sqrt(i)
        i = i + 1
    return True

##lib--@jit	 
def io(selfi, ioMax):
    filename = "/TestCSharp.txt"
    textLine = "abcdefghijklmnopqrstuvwxyz1234567890abcdefghijklmnopqrstuvwxyz1234567890abcdefgh\n"
    i = 0
    myLine = ""
    try:
        streamWriter = file(filename, 'w')
        while (i<=ioMax):
            i = i + 1
            streamWriter.write(textLine)
        streamWriter.close()
        i = 0
        # print("Reading file...")
        streamReader = file(filename, 'r')
        while(i<=ioMax):
            i = i + 1
            myLine = streamReader.readline()
    except:
        print("IOException")
    return True
 		

##lib--@jit
def marray(selfi, n):
    i = 0
    j = 0
    k = 0
    if (n<1):
        n = 1
    x = array('i')
    y = array('i')
    for i in range(n):
        x.append(i+1)
        y.append(0)
    for k in range(1000):
        j = n - 1
        while(j>=0):
            y[j] += x[j]
            j = j - 1
        k = k + 1
    return True

#lib--@jit	 
def SomeFunction(selfi, n):
    try:
        HiFunction(selfi,n)
    except:
        print("We shouldn't get there") 
#lib--@jit
def HiFunction(selfi, n):
    try:
        LoFunction(selfi,n)
    except HiException:
        selfi["Hi"] = selfi["Hi"] + 1 
#lib--@jit        
def LoFunction(selfi, n):
    try:
        Blowup(selfi,n)
    except LoException:
        selfi["Lo"] = selfi["Lo"] + 1 

#lib--@jit
def Blowup(selfi, n):
    if ((n & 1) == 0):
        raise LoException()
    else:
        raise HiException()

#lib--@jit
def exceptF(selfi, n):
    selfi["Lo"] = 0
    selfi["Hi"] = 0
    while (n!=0):
        SomeFunction(selfi,n)
        n = n - 1
    return True 

##lib--@jit
def hashtest(selfi, n):
    #X = dict()
    X = {}
    c = 0
    strTemp = "0x"
    if (n<1):
        n = 1
    i = 1
    while(i<n):
        try:
            X[str(hex(i))] = i
            i = i + 1
        except:
            pass
    i = n
    while(i>0):
        try:
            temp = X[str(strTemp) + str(i)]
            c = c + 1
        except:
            pass
        i = i - 1
    return True
 		

##lib--@jit
def hashes(selfi, n):
    #hash1 = dict()
    #hash2 = dict()
    hash1 = {}
    hash2 = {}
    i = 0
    j = 0
    for i in range(1000):
        key = "foo_" + str(i)
        hash1[key] = i
    i = 0
    for i in range(n):
        for j in range(1000):
            hash2["foo_" + str(j)] = hash1["foo_" + str(j)] = j
    key = "foo_" + str(n-1)
    return True
 		

##lib--@jit
def gen_random(selfi, max):
    selfi["last"] = (selfi["last"] * selfi["IA"] + selfi["IC"]) % selfi["IM"] 
    return max * selfi["last"] / selfi["IM"]
        
##lib--@jit
def heapsort2(selfi, ra, Length):
    l=0
    j=0
    ir=0
    i=0
    rra=0.0
    l = ((Length-1) >> 1) + 1
    ir = (Length-1)
    while (1):
        if (l > 1):
            l = l - 1
            rra = ra[l]
        else:
            rra = ra[ir]
            ra[ir] = ra[1]
            ir = ir - 1
            if (ir == 1):
                ra[1] = rra
                return				
        i = l
        j = l << 1
        while (j <= ir):
            if ((j < ir) and (ra[j] < ra[j+1])):
                j = j + 1
            if (rra < ra[j]):
                ra[i] = ra[j]
                i = j
                j += i
            else:
                j = ir + 1
        ra[i] = rra

##lib--@jit
def heapsort(selfi, count):
    ary = array('d')
    i = 0
    for i in range(count):
        ary.append(gen_random(selfi,1))
   
    heapsort2(selfi,ary, count)
    return True

##lib--@jit	 
def VectorTest(selfi):
    Li1 = []#array('i')
    i = 1
    Count = selfi["lSIZE"] + 1
    for i in range(selfi["lSIZE"] + 1):
        Li1.append(i)
    Li2 = []#array('i')#Li1
    i = 1
    for i in range(selfi["lSIZE"] + 1):
        Li2.append(Li1[i])
        
    Li3 = []#array('i')
    tCount = Count
    while (tCount > 0):
        Li3.append(Li2[0])
        Li2.pop(0)
        tCount = tCount - 1
    tCount = Count
    while (tCount > 0):
        Li2.append(Li3[tCount-1])
        Li3.pop()
        tCount = tCount - 1
    tmp = []#array('i')
    tCount = Count
    while (tCount > 0):
        tmp.insert(0, Li1[0])
        Li1.pop(0)
        tCount = tCount - 1
    Li1 = tmp
    if (Li1[0] != selfi["lSIZE"]):
        # print("first item of Li1 != lSIZE")
        return 0
    i = 0
    for i in range(Count):
        if (Li1[i] != Li2[i]):
            # print("Li1 and Li2 differ")
            return 0
    return Count

##lib--@jit
def vector(selfi, n):
    result = 0
    i = 0
    for i in range(n):
        result = VectorTest(selfi)
    return True
 		

##lib--@jit
def mkmatrix(selfi, rows, cols):
    count = 1
    m = [None]*rows
    i = 0
    j = 0
    for i in range(rows):
        m[i] = [None] * cols
        for j in range(cols):
            count = count + 1
            m[i][j] = count
    return m

##lib--@jit
def mmult(selfi, rows, cols, m1, m2, m3):
    i = 0
    j = 0
    k = 0
    for i in range(rows):
        for j in range(cols):
            val = 0
            for k in range(cols):
                val += m1[i][k] * m2[k][j]
            m3[i][j] = val

##lib--@jit
def matrixMultiply(selfi, n):
    m1 = mkmatrix(selfi,selfi["mSIZE"], selfi["mSIZE"])
    m2 = mkmatrix(selfi,selfi["mSIZE"], selfi["mSIZE"])
    mm = mkmatrix(selfi,selfi["mSIZE"], selfi["mSIZE"])
    i = 0
    if (n<1):
        n = 1
    for i in range(n):
        mmult(selfi,selfi["mSIZE"], selfi["mSIZE"], m1, m2, mm)
    return True
 		

##lib--@jit
def nestedLoop(selfi, n):
    a = 0
    b = 0
    c = 0
    d = 0
    e = 0
    f = 0
    x = 0
    if (n<1):
        n = 1
    for a in range(n):
        for b in range(n):
            for c in range(n):
                for d in range(n):
                    for e in range(n):
                        for f in range(n):
                            x=a+b+c+d+e+f
    return True
 		

##lib--@jit 
def stringConcat(selfi, N):
    if (N<1):
        N = 1
    sb = b"        "
    for i in range(N):
        sb = sb + b"."
    return True
 		
    

# parentdir = os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(os.__file__))))))
# os.sys.path.insert(0,parentdir) 
# from programParameters import obtainParameterValue




def __intArithmetic():
    # warmup 
    print("--++beginwarmup")
    for i in range(warmup): 
        intArithmetic(selfi,intMax)
    print("++--endwarmup")
    for i in range(mainloop) : 
        intArithmetic(selfi,intMax)
    

def __doubleArithmetic():
    # warmup 
    print("--++beginwarmup")
    for i in range(warmup): 
        doubleArithmetic(selfi,doubleMin, doubleMax)
    print("++--endwarmup")
    for i in range(mainloop) : 
        doubleArithmetic(selfi,doubleMin, doubleMax)
    

def __longArithmetic():
    # warmup 
    print("--++beginwarmup")
    for i in range(warmup): 
        longArithmetic(selfi,longMin, longMax)
    print("++--endwarmup")
    for i in range(mainloop) : 
        longArithmetic(selfi,longMin, longMax)
    

def __trig():
    # warmup 
    print("--++beginwarmup")
    for i in range(warmup): 
        trig(selfi,trigMax)
    print("++--endwarmup")
    for i in range(mainloop) : 
        trig(selfi,trigMax)
    

def __array():
    # warmup 
    print("--++beginwarmup")
    for i in range(warmup): 
        marray(selfi,10)
    print("++--endwarmup")
    for i in range(mainloop) : 
        marray(selfi,10)
    

def __hashtest():
    # warmup 
    print("--++beginwarmup")
    for i in range(warmup): 
        hashtest(selfi,2000)
    print("++--endwarmup")
    for i in range(mainloop) : 
        hashtest(selfi,2000)
    

def __hashes():
    # warmup 
    print("--++beginwarmup")
    for i in range(warmup):     # 
        hashes(selfi,10)
    print("++--endwarmup")
    for i in range(mainloop) : 
        hashes(selfi,10)
    

def __heapsort():
    # warmup 
    print("--++beginwarmup")
    for i in range(warmup): 
        heapsort(selfi,400)
    print("++--endwarmup")
    for i in range(mainloop) : 
        heapsort(selfi,400)
    

def __vector():
    # warmup 
    print("--++beginwarmup")
    for i in range(warmup): 
        vector(selfi,20)
    print("++--endwarmup")
    for i in range(mainloop) : 
        vector(selfi,20)
    

def __matrixMultiply():
    # warmup 
    print("--++beginwarmup")
    for i in range(warmup): 
            matrixMultiply(selfi,1)
    print("++--endwarmup")
    for i in range(mainloop) : 
        matrixMultiply(selfi,1)
    

def __nestedLoop():
    # warmup 
    print("--++beginwarmup")
    for i in range(warmup): 
        nestedLoop(selfi,5)
    print("++--endwarmup")
    for i in range(mainloop) : 
        nestedLoop(selfi,5)
    

def __stringConcat():
    # warmup 
    print("--++beginwarmup")
    for i in range(warmup): 
        stringConcat(selfi,40000)
    print("++--endwarmup")
    for i in range(mainloop) : 
        stringConcat(selfi,40000)
    

def __io():
    # warmup 
    print("--++beginwarmup")
    for i in range(warmup): 
        io(selfi,ioMax)
    print("++--endwarmup")
    for i in range(mainloop):
        io(selfi,ioMax) 
    

def __except():
    # warmup 
    print("--++beginwarmup")
    for i in range(warmup): 
        exceptF(selfi,1500)
    print("++--endwarmup")
    for i in range(mainloop) : 
        exceptF(selfi,1500)
    





if __name__ == "__main__": 
    warmup = 250*int(sys.argv[2]) if len(sys.argv ) >1 else 250  
    mainloop = 250*int(sys.argv[3]) if len(sys.argv ) >2 else 500    
    if len(sys.argv) >1 : 
        listbenchmarks = sys.argv[1].split(";")
        for bench in listbenchmarks : 
            if bench == "intArithmetic" : 
                __intArithmetic()
            elif bench == "doubleArithmetic" : 
                        __doubleArithmetic()
            elif bench == "longArithmetic" : 
                        __longArithmetic()
            elif bench == "trig" : 
                        __trig()
            elif bench == "array" : 
                        __array()
            elif bench == "hashtest" : 
                        __hashtest()
            elif bench == "hashes" : 
                        __hashes()       
            elif bench == "heapsort" : 
                        __heapsort()
            elif bench == "vector" : 
                        __vector()
            elif bench == "matrixMultiply" : 
                        __matrixMultiply()
            elif bench == "nestedLoop" : 
                        __nestedLoop()
            elif bench == "stringConcat" : 
                        __stringConcat()
            elif bench == "io" : 
                        __io()
            elif bench == "except" : 
                        __except()
            else : 
                print("error module not found ")
    else : 
        
        __intArithmetic()
        __doubleArithmetic()
        __longArithmetic()
        __trig()
        __array()
        __hashtest()
        __hashes()   
        __heapsort()
        __vector()
        __matrixMultiply()
        __nestedLoop()
        __stringConcat()
        __io()
        __except()


