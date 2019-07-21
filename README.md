# dotemacs 使用说明:  (持续更新中)

## 命令

1. pdf: 将当前buffer对应的文件, 打印成/tmp目录下的 同前缀名的pdf
2. emacs: 在terminal的新tab中再次打开当前buffer.
3. dbg:  在ipython服务器中运行ipython_dbg_logger_init.nujnus
4. l[o]g:  快速根据光标所在word, 生成并插入log_dbg_var代码.
5. h[elp]: 通过jedi显示函数的帮助信息.
6. jgo: 挑战到代码定义处 jump to defination.
7. int: 在ipython执行选中的代码
8. v[is]: 输入code block的模板
9. d[ate]:  输入时间戳.
10. new: 生成新的同目录名前缀+时间戳的markdown文件.
11. ls:  显示当前目录及子目录下所有的md文件, 并用
12. ssh: 在192.168.3.57上的anaconda3-5.2.0环境中, 执行当前python文件.
13. n[b]: 在弹窗中显示192.168.3.57上的notebook
14. i: 插入nbscript的code block模版
15. py[thon]: 生成临时文件, 并打开新tab去编辑它
16. n[d]: 用notedown将xscript.rb预处理生成的/tmp文件转换成ipynb文件
17. t[mp]: 根据时间倒排显示emacs生成的各种临时文件
18. is[erver]: 启动ipython代理服务器

## link
1. ipython:  对应函数 ipython-run-script
2. nbscript: 
3. nb:       在web窗口打开notebook
4. visdom:   在web窗口打开visdom

## 函数和宏
1. get-ipython-script 获得当前point后的code block
2. sj/jedi-init-hook  初始化jedi, 比如启动自动补全, 以及配置自动补全的配色
3. pop-global-window  弹出特定tab中的指定窗口中, 显示文件, 并执行code
  4. pop-global-right-and-back  用pop-global-window右边弹出并返回原先窗口
   
5. write-response-other-window 用pop-global-right-and-back弹出窗口显示/tmp/emacs-ipython-temp, 并写入反馈的内容.
6. write-response 把参数内容写在当前光标下方.
  7. interpret-script 向ipython请求执行代码, 并显示反馈

8. send-to-ipython 通过curl向ipython发送base64化的代码.
  9. interpret-python 发送当前行代码
  10. interpret-python-region 发送选中区域的代码

11. build-ipynb-at-point  将本地code block 和 template.ipynb, 形成一个cell, 将这个cell以dict形式读出来,  放入一个要作为参数传递的/tmp/emacs_argument.json中, 供 "render_remote_ipynb.nujnus" 使用.
12. run-nujnus-script     运行nujnus脚本  #原理, 打开这个文件但不显示, 跳转到第0行, 执行run-link, 就像手动c-c c-o一样运行脚本一样的效果.


## 快捷键
1. 上下左右快速移动光标.  适合在宽度很大并超过屏幕的(toggle-truncate-lines )模式下使用;
```
"\C-l"
"\C-h"
"\C-j"
"\C-k"
```
2. 用.键触发, jedi的自动补全;
```
(kbd"\.")
```

3. 自动补全界面中光标的上下移动;
```
"\C-n"
"\C-n"
"\C-p"
"\C-p"
```

4. 在ipython执行选中的代码;
```
"C-x C-p"
```
4. 跳转到前后的code block;
```
"c"
"C"
```
--- 

## 非lisp脚本工具:

### nujnus 文件
1. ipython_dbg_logger_init.nujnus    在ipython中初始化dbg功能的代码.
2. render_remote_ipynb.nujnus        将从本地传到服务器上的/tmp/emacs_argument.json文件, 在服务器上和目标ipynb合并. 并通过nbconvert计算新产生的ipynb的输出.

### scpt 文件
1. emacs.scpt
2. shell-pc-jht-500g.scpt
3. shell.scpt

### shell 文件
1. curl_with_out_color.sh   向ipython代理服务器发送请求
2. touch_ipynb.sh           在192.168.3.57上创建一个ipynb文件
3. vimscript                vim功能接口, 用来生成markdown网页.

### python 文件
1. build_ipynb_at_point.py
2. notebook_remote.py       ipython代理服务器
3. thing_at_regexp.py       匹配光标所在的link的文字内容

### ipynb 模版
1. template.ipynb

### 远古的ruby文件
1. ruby_emacs_like.rb
2. xml_runner_map.rb
3. xscript.rb
