#-*- coding:utf-8 -*-
module MyRedis
#   class PathEnv
#     def initialize(init_path)
#       @init_path = init_path+"_0"
#     end
#
#     def succ!
#       @init_path.succ!
#     end
#   end

require 'redis'
  class PathList
    def initialize(db_number, list_name)
      @list_name = list_name
      @db_number = db_number

      @redis = Redis.new
      @redis.select(@db_number)
    end
    def push (path)
      @redis.rpush(@list_name, path)
    end

    def [] (path)
      @redis.lindex(@list_name, path)
    end

    def clear
      @redis.select(@db_number)
      @redis.flushall
    end
  end
end

#  pl = PathList.new(2, "xml_evaluator_path_list")
#  pl.push "abc"
#  pl.push "dff"
#  puts pl[0]
#  puts pl[1]
#  pl.clear



module Ruby_Emacs_like
  def self.search_forward_regexp(current_file, current_point, regexp)
    f = File.read(current_file) #获得文件内容
    ff = f.slice(current_point..-1) #截取point后的
    ff.match(regexp) || raise("cant find regexp:#{regexp}") #返回match结果
  end

  def self.get_line_content(current_file, line_number)
    f = File.readlines(current_file) #获得文件内容
    l = f[((line_number.to_i) -1)]
  end

  def self.scan_line(current_file, regexp, after)
    f = File.readlines(current_file) #获得文件内容
    s = f.clone
    meta_scan_line(current_file, regexp).map{|l,m,i|
       "#{'-'*20}\n[[goto:#{File.basename(current_file)}::#{i+1}][#{(i+1).to_s.rjust(5)}]]\|\
 #{l}#{self.paragraph(s, i, after)}"}
  end

  def self.meta_scan_line(current_file, regexp)
    f = File.readlines(current_file) #获得文件内容
    s = f.clone
    #result = s.map.with_index.select{|l,i| (l.match regexp)}
    result = s.map{|l|[l,(l.match regexp)]}.map.with_index.select{|l_m,i| l_m[1] }.map{|l_m,i|l_m << i}
  end

  def self.paragraph(lines, from, length)
    if length
      head = from+1
      tail = from + length.to_i
      #(lines.slice(head,tail)).map{|l|" "*7+l}
      #"#{head}  #{tail} #{lines.size}"
      #(lines.slice(294,295))
      #lines[294]+lines[295]
      lines[head..tail].map{|l|" "*7+l}.join("")
    end
  end

  class WithTempDir
    def initialize(tmp_root)
      @root = tmp_root
    end
    def with_temp_file(&block)
      Ruby_Emacs_like::with_temp_file(@root, &block)
    end
  end
  def self.with_temp_dir(&block)
    tmp_root = "/tmp/EmacsTempDir_#{Time.now.to_f.to_s}"
    FileUtils.mkdir_p tmp_root
    Dir.chdir tmp_root
    yield(WithTempDir.new(tmp_root))
  end
#.instance_eval(&block)

  #=====================================
  def self.with_temp_file(root = "tmp")
    #---------------------写入临时文件
    tmpf = "/#{root}/EmacsTempFile_#{Time.now.strftime("%Y_%m_%d_%H_%M_%S")}" #{Time.now.to_f.to_s}
    File.open(tmpf, 'w+') do |r|
      yield r
    end
    tmpf
  end
end



