import sys
import re
argv = sys.argv
filename =  argv[1]
line_position =  argv[2]
column_position =  argv[3]

#以后只要按需定制这个正则表达式就行了, 慢慢调整即可.
#sys.setdefaultencoding('utf8')
regexp_experssion = "[a-zA-Z1234567890\u4E00-\u9FA5\:\_\-\.\/]+"  #\u4E00-\u9FA5是中文

with open(filename) as fp:
  for i, line in enumerate(fp):
    #先找到和line_position匹配的行
    if i == int(line_position):
      #print(line[int(column_position)])
      column_point = int(column_position)
      r = re.compile(regexp_experssion)
      #从行首开始不断进行正则匹配
      for m in r.finditer(line):
        #print(m.start(), m.end(), m.group())
        #当column_point正好落在正则结果的start和end之间时,则匹配成功,打印结果
        if (m.start() <= column_point and m.end() > column_point  ):
           #print("match")
           print(m.group())
