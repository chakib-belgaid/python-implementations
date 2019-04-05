# The Computer Language Benchmarks Game
# http://shootout.alioth.debian.org/
#
# modified by Ian Osgood
# modified again by Heinrich Acker
# modified by Justin Peel
# modified by Mariano Chouza
# modified by Ashley Hewson
# modified by Valery Khamenya
# modified again by Mariano Chouza
from __future__ import unicode_literals
import sys, bisect, array


##lib--from numba import jit 

alu = (
   u'GGCCGGGCGCGGTGGCTCACGCCTGTAATCCCAGCACTTTGG'
   'GAGGCCGAGGCGGGCGGATCACCTGAGGTCAGGAGTTCGAGA'
   'CCAGCCTGGCCAACATGGTGAAACCCCGTCTCTACTAAAAAT'
   'ACAAAAATTAGCCGGGCGTGGTGGCGCGCGCCTGTAATCCCA'
   'GCTACTCGGGAGGCTGAGGCAGGAGAATCGCTTGAACCCGGG'
   'AGGCGGAGGTTGCAGTGAGCCGAGATCGCGCCACTGCACTCC'
   'AGCCTGGGCGACAGAGCGAGACTCCGTCTCAAAAA')

iub = zip('acgtBDHKMNRSVWY', [0.27, 0.12, 0.12, 0.27] + [0.02]*11)

homosapiens = [
    ('a', 0.3029549426680),
    ('c', 0.1979883004921),
    ('g', 0.1975473066391),
    ('t', 0.3015094502008),
]

IM = 139968
INITIAL_STATE = 42

##lib--@jit
def makeCumulative(table):
    P = []
    C = []
    prob = 0.
    for char, p in table:
        prob += p
        P += [prob]
        C += [char]
    return (P, C)

randomSeq = None
j = 0

##lib--@jit
def makeRandomSeq():
    global randomSeq
    ia = 3877; ic = 29573
    randomSeq = []
    s = INITIAL_STATE
    while True:
        s = (s * ia + ic) % IM
        randomSeq.append(s)
        if s == INITIAL_STATE:
            break

##lib--@jit
def makeLookupTable(table):
    bb = bisect.bisect
    probs, chars = makeCumulative(table)
    imf = float(IM)
    return array.array(str("u"), [chars[bb(probs, i / imf)] for i in range(IM)])

##lib--@jit
def repeatFasta(src, n):
    width = 60
    r = len(src)
    s = src + src + src[:n % r]
    sow = sys.stdout.write
    for j in range(n // width):
        i = j*width % r
        sow(s[i:i+width] + '\n')
    if n % width:
        sow(s[-(n % width):] + '\n')

##lib--@jit
def randomFasta(table, n):
    global randomSeq, j
    width = 60
    
    lut = makeLookupTable(table)
    luStr = ''.join(lut[randomSeq[j]] for j in range(IM))
    luStr += luStr[:width]

    lj = j
    sow = sys.stdout.write
    for i in range(n // width):
        sow(luStr[lj:lj+width] + '\n')
        lj = (lj + width) % IM
    j = lj
    if n % width:
        k = (j + (n % width)) % IM
        sow((luStr[j:k] if j < k else luStr[j:] + luStr[:k]) + '\n')
        j = k

def main(n):

    makeRandomSeq()

    print('>ONE Homo sapiens alu')
    repeatFasta(alu, n*2)

    print('>TWO IUB ambiguity codes')
    randomFasta(iub, n*3)

    print('>THREE Homo sapiens frequency')
    randomFasta(homosapiens, n*5)
    

if __name__ == '__main__':
    depth =int(sys.argv[1] ) if len(sys.argv ) > 1 else 2500000
    warmup = int(sys.argv[2]) if len(sys.argv ) > 2 else 0
    mainloop = int(sys.argv[3]) if len(sys.argv ) >3 else 1    
    # warmup 
    print(depth+warmup+mainloop)
    print("--++beginwarmup")
    for i in range(warmup): 
        main(depth)
    print("++--endwarmup")
    for i in range(mainloop) : 
        main(depth)
    


