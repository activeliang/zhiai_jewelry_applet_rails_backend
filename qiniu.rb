#!/usr/bin/env ruby
require 'qiniu'
require 'pry'
Qiniu.establish_connection! access_key: 'xxxx-MlC3',
                            secret_key: 'IddfFH5iWsqUV04cBe0V-xxxxxx'
# 要测试的存储空间，并且这个资源名在存储空间中存在
bucket = 'huiyuwechat'




# 调用 list 接口，参数可以参考 http://developer.qiniu.com/code/v6/api/kodo-api/rs/list.html#list-specification
code, result, response_headers, s, d = Qiniu::Storage.list(Qiniu::Storage::ListPolicy.new(
    bucket,   # 存储空间
    10000,      # 列举的条目数
    ''        # 指定目录分隔符
))
# 打印出返回的状态码和信息
puts code
puts result
puts response_headers
# binding.pry

keys = result['items'].map{|x| { old: x['key'], new: x['key'].scan(/.+\/(.+)$/).last.last } rescue nil }.compact

binding.pry
keys.each do |item|
    # 移动文件
    Qiniu::Storage.move(
        bucket,         # 原存储空间
        item[:old],            # 原资源名
        bucket,     # 目标存储空间
        item[:new]         # 目标资源名
    )
end
