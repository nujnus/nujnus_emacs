#!/usr/bin/env ruby
#-*- coding:utf-8 -*-
require 'erubis'
require 'thor'
require_relative "xml_runner_map"
require_relative "ruby_emacs_like"

class Xml_Evaluator < Thor

  #匹配 <&ruby> xxxx<&ruby> 的形式.
  #@@xml_matcher =  /<\&([\w\W]+)>([\w\W]+)<\&\/\1>/

  desc 'parse meta info', '解析meta标签中的命令,并在调用其他script前运行' #这个也要改成```形式, 慢慢来.
  def get_cmd_to_run_before_all_others(file_name, current_point)
    regexp = /```(?<tag>[\w\W]+?)$(?<content>[\w\W]+?)```(?<other_content>[\w\W]+?)/

    f = File.read(file_name) #获得文件内容
    ff = f.slice(current_point.to_i..-1) #截取point后的, 注意要to_i, 不然是文字型的数字
    result = ff.match(regexp) || raise("cant find regexp:#{regexp}") #返回match结果

    if result["tag"] == "meta"  #匹配到meta就跳过
      puts result["content"]
    end
  end

  desc 'parse after info', 'run after all others'
  def get_cmd_to_run_after_all_others(file_name, current_point)
    regexp = /```(?<tag>[\w\W]+?)$(?<content>[\w\W]+?)```(?<other_content>[\w\W]+?)/

    f = File.read(file_name) #获得文件内容
    ff = f.slice(current_point.to_i..-1) #截取point后的, 注意要to_i, 不然是文字型的数字
    result = ff.match(regexp)
    if result and result["tag"] == "meta"  #匹配到meta就跳过
      ff = ff.slice(result.end(0)..-1)
      result = ff.match(regexp) 

      if result and result["tag"] == "python"  #匹配到meta就跳过
        ff = ff.slice(result.end(0)..-1)
        result = ff.match(regexp) 

        if result and result["tag"] == "after"  #匹配到meta就跳过
          puts result["content"]
          return 0
        else
          return 1
        end
      end
    elsif result and result["tag"] == "python"  #匹配到meta就跳过
      ff = ff.slice(result.end(0)..-1)
      result = ff.match(regexp) 

      if result and result["tag"] == "after"  #匹配到meta就跳过
        puts result["content"]
        return 0
      else
        return 1
      end
    elsif result and result["tag"] == "after"  #匹配到meta就跳过
      puts result["content"]
    else
      return 1
    end
  end


  desc 'get_cmd_to_run_the_script  file_name current_point', '解析xml,并生成script和执行它的cmd'
  def get_cmd_to_run_the_script(file_name, current_point)

    regexp = /```(?<tag>[\w\W]+?)$(?<content>[\w\W]+?)```/

    f = File.read(file_name) #获得文件内容
    ff = f.slice(current_point.to_i..-1) #截取point后的, 注意要to_i, 不然是文字型的数字
    result = ff.match(regexp) || raise("cant find regexp:#{regexp}") #返回match结果
    
    if result["tag"] == "meta"  #匹配到meta就跳过
      fff = ff.slice(result.end(0)..-1)
      result = fff.match(regexp) || raise("cant find regexp:#{regexp}") #返回match结果
    end

    tag = result["tag"]
    content = result["content"]

    command_stream  = make_a_script(tag, content)

    puts  command_stream[1]
  end


  #用于notedown生成notebook前的预处理
  desc 'get_cmd_to_run_all_scripts file_name', '将整个buffer中的code block生成成一个文件,返回调用方式'
  def pre_strain_code_block_for_notebook(file_name, custom_tag = "nd")
    puts pre_strain_code_block_tag(file_name, "nd", custom_tag)
  end

  #用于get_cmd_to_run_the_script_combined_all_block的预处理
  desc 'get_cmd_to_run_all_scripts file_name', '将整个buffer中的code block生成成一个文件,返回调用方式'
  def pre_strain_code_block_for_python(file_name, custom_tag = "python")
    puts pre_strain_code_block_tag(file_name, "python", custom_tag)
  end


  desc 'get_cmd_to_run_the_script_combined_all_block', '将整个buffer中的code block生成成一个文件,返回调用方式'
  def get_cmd_to_run_the_script_combined_all_block(file_name)

    regexp = /```$(?<content>[\w\W]+?)```/

    f = File.read(file_name) #获得文件内容
 
    contents = []
    contents << "#-*- coding:utf-8 -*-"
    contents << "# (python-mode)"

    start = 0

    while f = f.slice(start..-1) do
      if result = f.match(regexp) then
        start = result.end(0)
        contents << ("###################\n####code block#####\n###################")
        contents << (result["content"])
      else
        break
      end
    end
    content = contents.join("\n")


    tag = "raw"
    command_stream  = make_a_script(tag, content)
    puts  command_stream[1]
  end


private

  def make_a_script(tag, content)
    file_name = Ruby_Emacs_like::with_temp_file do |f|
      f.puts content
    end
    rmap = RunnerMap.new(file_name)
    runner = rmap.render_runner(rmap.get_match_runner_template(tag))
    [file_name,runner,content]
  end


  def pre_strain_code_block_tag(file_name, keep_tag, custom_tag)

    regexp = /```(?<tag>[\w\W]+?)$(?<content>[\w\W]+?)```/

    f = File.read(file_name) #获得文件内容
    contents = []
    content = []
    start = 0
    #暂时没想好怎么设计这个
    tag = "raw"

    while f = f.slice(start..-1) do
      if result = f.match(regexp) then
        contents <<  f.slice(0..(result.begin(0)-1))
        start = result.end(0) 
        tags = result["tag"].split("-")
        if tags.include? keep_tag and  tags.include? custom_tag then
          contents << "```#{(result["content"])}```"
        else
          contents << "```\n#baned code\n```"
        end
      else
      #尾巴
        contents << f
        break
      end
    end
    content = contents.join("\n")

    command_stream = make_a_script(tag, content)

    command_stream[1]
  end

end

Xml_Evaluator.start
