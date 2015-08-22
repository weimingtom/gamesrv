# -*- coding: utf-8 -*-
from makescript.parse import *
import os
os.system("pwd")
code_outputpath = getenv("code_outputpath")
cmds = {
    0 : "parse all",
    1 : "python parse_card.py ../xls/card.xls " + os.path.join(code_outputpath,"card"),
    2 : "python parse_award.py ../xls/award.xls " + os.path.join(code_outputpath,"data"),
    3 : "python parse_huodong.py ../xls/huodong.xls " + os.path.join(code_outputpath,"data"),
}

def show_menu():
    for choice in sorted(cmds):
        print choice,":",cmds[choice]

def main():
    while True:
        show_menu()
        choice = raw_input("enter choice(q to quit):")
        print "choice:",choice
        if choice == "q":
            break
        elif choice.isdigit():
            choice = int(choice)
            if choice == 0:
                for i,cmd in cmds.iteritems():
                    if i != 0:
                        os.system(cmd)
            elif cmds.get(choice):
                os.system(cmds[choice])

if __name__ == "__main__":
    main()
