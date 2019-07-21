import re
import sys
import json

argv = sys.argv
current_buffer = argv[1]
point = argv[2]
target_ipynb = argv[3]


regexp_expression = r"```(?P<tag>[\w\W]+?)\n(?P<content>[\w\W]+?)```"
#regexp_expression = r"\`\`\`"#(?P<tag>[\w\W]+?)\n(?P<content>[\w\W]+?)```"

with open(current_buffer, 'r') as f:
  file_content = f.read()[(int(point) - 1):]
  print(regexp_expression)
  print(current_buffer)
  print(point)
  print(file_content)

  m = re.search(regexp_expression, file_content)
  source = [e+"\n" for e in m.group("content").split("\n") if e]
  print(source)

with open("/Users/sunjun/Desktop/dotemacs/template.ipynb", 'r') as load_f:
  load_dict = json.load(load_f)
  load_dict["cells"][0]["source"] = source


#with open("/tmp/template_cache.ipynb", 'w') as dump_f:
#  json.dump(load_dict,dump_f)

with open("/tmp/emacs_argument.json", 'w') as dump_json_arg:
  arg_json = {"target_ipynb" : target_ipynb, "source" : load_dict["cells"][0], "metadata" : load_dict["metadata"]}
  json.dump(arg_json, dump_json_arg)

print(arg_json["target_ipynb"])
print("done")
