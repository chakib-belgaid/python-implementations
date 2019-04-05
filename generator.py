import sys 
import re 
import os 
from shutil import copyfile


compilers=['shedskin','cython2','cython3','nuitka']
# compilers=[]
interpreters=["python2" ,"python3" ,"ipy" ,"jython" ,"activepython" ,"micropython" ,"pypy2" ,"pypy3" ,"graalpython" ,"numba2","numba3","intelpython2","intelpython3" ]

# def main(): 
#     # filename= sys.argv[0] 



# if __name__=="__main__" : 
#     main()


def get_implementations(filename = 'Makefile' ):
    with open(filename) as f : 
        fs="".join(f.readlines(),)
        # reg =re.compile( ,flags=re.MULTILINE) 
        l=re.findall(r'^prepare-.*:',fs,flags=re.M)
        # x=next(l)
        implems={}
        fs1=fs
        for i in l[::-1] : 
            name = i[8:-1]
            implems[name]=fs1.split(i)[1].strip()
            fs1=fs1.split(i)[0]
    return implems 

def generateBaseImage(path='dockerdfiles'):
    template= """
FROM bverhagen/pacman-aur-wrapper:yay  
RUN yay -Syu --noconfirm && {} 
    """
    implems = get_implementations() ;

    for i in  implems :
        with open(path+'/'+i+'.dk','w+') as f : 
            if i == 'pyston' :
                l= """ 
FROM bverhagen/pacman-aur-wrapper:yay
USER awesome
RUN yay -Syu --noconfirm && yay -S --noconfirm openssl-1.0 pyston 
USER root
RUN ln -s /usr/lib/libmpfr.so.6 /usr/lib/libmpfr.so.4 && ln -s  /usr/liblibreadline.so /   usr/lib/libreadline.so.6  
USER awesome
    """
            else :
                l= template.format(implems[i])
            f.write(l)
            print(i)

#0}=impelemtation {1}= benchmark  {2}=entrypoint 

def getEntryPoint(implem,bench):
    paths={   "python2":"/usr/bin/python2",
        "python3":"/usr/bin/python3",
        "numba2":"/usr/bin/python2",
        "numba3":"/usr/bin/python3",
        "ipy":"ipy",
        "jython":"jython",
        "micropython":"micropython",
        "pypy2":"/usr/bin/pypy",
        "pypy3":"/usr/bin/pypy3",
        "graalpython":"/usr/bin/graalpython",
        "numba":"/opt/anaconda/bin/python",
        "activepython":"/opt/ActivePython-3.6/bin/python3.6",
        "intelpython2":"/intelPython/intelpython2/bin/python",
        "intelpython3":"/intelPython/intelpython3/bin/python",
        "stacklesspython2":"/stackless/stackless-2715-export/python",
        "stacklesspython3":"/stackless/stackless-372-export/python",

    }
    if implem in   compilers : 
        return '"./'+bench+'"'
    elif implem in interpreters : 
        return '"'+paths[implem]+'","'+bench+'"'
    
    return "error"


def generateTestImages(implementations=compilers+interpreters, benchmark="tommti",args= ["intArithmetic","0","1"]): 
    
    path="stable/"+benchmark
    copyfile('dockerbuild.sh',path+'/dockerbuild.sh')
    os.chmod(path+'/dockerbuild.sh',0755)
    template="""
FROM chakibmed/{0}:1.0
WORKDIR /test
ADD pythonfiles/{1}.{0} {1}
ENTRYPOINT [{2}]
CMD {3}
    """
    for implem in implementations : 
        # print (implem) 
        with open(path+'/'+implem+'.dk','w+') as f :
            l=template.format(implem,benchmark,getEntryPoint(implem,benchmark),args)
            l=l.replace("'",'"')
            # print(l.replace("'",'"'))
            # return 
            f.write(l)








def generatelaucher(implementations=compilers+interpreters, benchmark="tommti",args= ["intArithmetic","0","1"]): 
    # print(implementations)
    # return 
    # implementations= [i.split('.')[1] for i in os.listdir("stable/"+benchmark) ]
    path="stable/"+benchmark
    filename='launcher.'+benchmark+'.sh'
    template= """
min=2 
max=120
step=20
sleepTime=120s

implementations=( \
"""
    for i in implementations : 
        # print(i)
        template= template+i + ' \\\n'

    template=template+""")

    functions=( \\
    {0}
    )
j=0
i={2} 
j=$((0))
tag="{1}"
# while true ; 
# do 
""".format(args[0],benchmark,args[-1])
    template=template+ 'for function in "${functions[@]}" ; '
    template=template+ """  
    do 
        j=$((0))
        while [ $j -lt 100 ] ; 
        do 
    """
    template=template+ 'for implem in ${implementations[@]};'
    template=template+ """
            do
                sleep $sleepTime 
                name=$tag"_"$implem"_"$function"_"$i"_"$j
                echo $implem  $function 5 $i  $j ;
                # docker pull chakibmed/icse_$implem:tommtiv1
                tester.sh -n $name chakibmed/$implem:$tag $function 5 $i  ;
                # echo  chakibmed/$implem:$tag $function 5 $i  ;
            done
        j=$((j+1))  
        done
    done

    # i=$((i + 10 ))
# done 

shutdown
        """
    # print (template)
    # return
    
    with open(path+'/'+filename,'w+') as f :    
        f.write(template)
    os.chmod(path+'/'+filename, 0755  )



def main(): 
    benchmark = sys.argv[1] if len (sys.argv) > 1 else 'tommti' 
    args = sys.argv[2:] if len(sys.argv) >2 else ["intArithmetic","0","1"]
    implementations= [i.split('.')[1] for i in os.listdir("stable/"+benchmark+'/pythonfiles') ]
    # print (implementations)
    # print(args)
    generateTestImages(implementations,benchmark,args)
    generatelaucher(implementations,benchmark,args)



if __name__=="__main__" : 
    main()
    

# generateTestImages()