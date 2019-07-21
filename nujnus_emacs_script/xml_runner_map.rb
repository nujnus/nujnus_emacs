#-*- coding:utf-8 -*-
class RunnerMap
  TagTable = {
    "cat" =>   "cat <%= get_file_name %>",
    "ruby" =>   "ruby <%= get_file_name %>",
    "python" => "python <%= get_file_name %>",
    "ansible" =>"ansible <%= ENV['ansible_ssh_host'] %> ${ansible_ssh_host} -m script -a <%= get_file_name %>",
    "node" =>   "node <%= get_file_name %>",
    "spec" =>   "rspec --color -f p <%= get_file_name %> ",
    "html" =>   "google-chrome <%= get_file_name %>",
    "phtml" =>  "ruby /home/john/my_emacs_plugin/launcher.rb  google-chrome",
    "shell" =>  "zsh <%= get_file_name %>",
    "dot" =>    "dot -Tpng <%= get_file_name %>|display",
    "file" =>   "echo <%= get_file_name %> ",
    "ert" =>    "emacs -batch -l ert -l <%= get_file_name %> -f ert-run-tests-batch-and-exit",
    "raw" =>   "<%= get_file_name %> ",
    "pipe" => " | ",
    "progn" => " ; ",
    "and" => " && ",
    "or" => " || ",
    "dir" => " ; "
    #"pipe" =>  Proc.new do "分析获得所有子标签的命令;并用管道的方法串起来;" end
    #"and" =>  Proc.new do "分析获得所有子标签的命令;并用与的方式串起来;" end
    #"or" =>  Proc.new do "分析获得所有子标签的命令;并用或的方式串起来;" end
    #"progn" =>  Proc.new do "分析获得所有子标签的命令;然后仅仅只是程序性地依次执行;" end
  }
  #所有标签,最终组装完毕后,则each方式迭代递归执行标签.

  def initialize(file_name)
    @file_name = file_name.squeeze '/'
  end

  def get_file_name
    @file_name
  end

  def get_match_runner_template(tag)
    TagTable[tag] || raise("没有匹配的tag:!!!#{tag}!!!")  #如果返回nil,则报错.
  end


  def render_runner(runner_template)
    Erubis::Eruby.new(runner_template).result(binding)
  end

  def run_match_runner(runner)
    system runner
  end

end


