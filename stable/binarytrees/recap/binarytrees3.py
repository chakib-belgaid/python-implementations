# The Computer Language Benchmarks Game
# http://benchmarksgame.alioth.debian.org/
#
# contributed by Antoine Pitrou
# modified by Dominique Wahli and Daniel Nanz
# modified by Joerg Baumann

import sys
import multiprocessing as mp
##lib--from numba import jit 

##lib--@jit
def make_tree(i, d):

    if d > 0:
        d -= 1
        return (i, make_tree(i, d), make_tree(i + 1, d))
    return (i, None, None)

##lib--@jit
def check_tree(node):

    (i, l, r) = node
    if l is None:
        return i
    else:
        return i + check_tree(l) - check_tree(r)

##lib--@jit
def make_check(itde, make=make_tree, check=check_tree):

    i, d = itde
    return check(make(i, d))

##lib--@jit
def get_argchunks(i, d, chunksize=5000):

    assert chunksize % 2 == 0
    chunk = []
    for k in range(1, i + 1):
        chunk.extend([(k, d), (-k, d)])
        if len(chunk) == chunksize:
            yield chunk
            chunk = []
    if len(chunk) > 0:
        yield chunk


def main(n, min_depth=4):

    max_depth = max(min_depth + 2, n)
    stretch_depth = max_depth + 1
    if mp.cpu_count() > 1:
        pool = mp.Pool()
        chunkmap = pool.map
    else:
        chunkmap = map

    print('stretch tree of depth {0}\t check: {1}'.format(
          stretch_depth, make_check((0, stretch_depth))))

    long_lived_tree = make_tree(0, max_depth)

    mmd = max_depth + min_depth
    for d in range(min_depth, stretch_depth, 2):
        i = 2 ** (mmd - d)
        cs = 0
        for argchunk in get_argchunks(i,d):
            cs += sum(chunkmap(make_check, argchunk))
        print('{0}\t trees of depth {1}\t check: {2}'.format(i * 2, d, cs))

    print('long lived tree of depth {0}\t check: {1}'.format(
          max_depth, check_tree(long_lived_tree)))


if __name__ == '__main__':
    depth =int(sys.argv[1] ) if len(sys.argv ) > 1 else 10
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
    

   
