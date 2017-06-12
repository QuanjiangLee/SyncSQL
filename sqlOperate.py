#!/usr/bin/python
# -*- coding: UTF-8 -*-
import uuid
import os, re, sys
import time

'''
def is_time_type(date_str):
    try:
        if date_str:
            time.strptime(date_str, "%H:%M:%S")
            return True
    except:
        return False
'''
   
def run(file_name, write_filename):
    if not os.path.exists(file_name):
        return False

    fwp = open(write_filename, "wb+")
    frp= open(file_name, "rb")
 #   local_time = None
    fwp.write(("-- "+ (time.strftime("%Y-%m-%d %X", time.localtime())) + "\n").encode("utf-8"))
    while True:
        line = frp.readline()
        if not line:
            break

        line_list = line.decode("utf-8").split(" ")
#       if is_time_type(line_list[1]):
#            local_time = line_list[1]
#        else:
#            local_time = ""	
#            print(line_list[1])
        
        if re.search("UPDATE", line.decode("utf-8").upper()):
            ret_list = line.decode("utf-8").split("Query")
#            fwp.write(("-- " + local_time +"\n").encode("utf-8")) 
            fwp.write(((ret_list[1]).strip() + "; \n").encode("utf-8"))

        if re.search("INSERT", line.decode("utf-8").upper()):
            ret_list = line.decode("utf-8").split("Query")
#            fwp.write(("-- "+ local_time +"\n").encode("utf-8")) 
            fwp.write(((ret_list[1]).strip() + "; \n").encode("utf-8"))

        if re.search("DELETE", line.decode("utf-8").upper()):
            ret_list = line.decode("utf-8").split("Query")
#            fwp.write(("-- "+ local_time +"\n").encode("utf-8")) 
            fwp.write((( ret_list[1]).strip() + "; \n").encode("utf-8"))
    frp.close()
    fwp.close()
    return True

if __name__ == "__main__":
    file_name = sys.argv[1]
    outName = time.time()
    write_name = str(outName) + ".sql"
    res_run = run(file_name, write_name)
