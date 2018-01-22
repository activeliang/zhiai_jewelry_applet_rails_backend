class SsService < ApplicationRecord

  has_many :items, class_name: SsItem
  has_many :empty_items, -> { where(is_send: false) }, class_name: SsItem

  def self.generate_service(ip)
    a = [*"a".."z"]
    b = [*8380..8540]
    ss_conf = String.new
    ss_json = ""
    password_a = []

    service_record = SsService.create service_ip: ip

    161.times do
      password_a << (a.sample + a.sample + a.sample + a.sample + a.sample + a.sample)
    end

    b.zip(password_a) do |b,s|
      ss_conf += "\"#{b}\"\: \"#{s}\","
      SsItem.create ss_service_id: service_record.id, port: b, password: s, re_code: SecureRandom.hex(16), qr_code: ("ss://" + (Base64.strict_encode64("rc4-md5:#{s}")).to_s + "@" + ip + ":" + b.to_s + "/?OTA=false" )
    end

    b.zip(password_a) do |b, s|
      ss_json += "{\"enable\" : true,\"password\" : \"#{s}\",\"method\" : \"rc4-md5\",\"remarks\" : \"kkk\",\"server\" : \"#{ip}\",\"kcptun\" : {\"nocomp\" : false,\"key\" : \"it is a secrect\",\"crypt\" : \"aes\",\"datashard\" : 10,\"mtu\" : 1350,\"mode\" : \"fast\",\"parityshard\" : 3,\"arguments\" : \"\"},\"enabled_kcptun\" : false,\"server_port\" : #{b},\"remarks_base64\" : \"5a2Q54+C\"},"
    end

    ss_conf = "{ \"server\":\"0.0.0.0\",\"port_password\": {" + ss_conf
    ss_conf = ss_conf.chop +   "}, \"local_address\":\"127.0.0.1\",\"local_port\":1080,\"method\":\"rc4-md5\",\"timeout\":300 }"


    ss_json = '{ "random" : false, "authPass" : null, "useOnlinePac" : false, "TTL" : 0, "global" : false, "reconnectTimes" : 3, "index" : 0, "proxyType" : 0, "proxyHost" : null, "authUser" : null, "proxyAuthPass" : null, "isDefault" : false, "pacUrl" : null, "configs" :' + ss_json + ', "proxyPort" : 0, "randomAlgorithm" : 0, "proxyEnable" : false, "enabled" : true, "autoban" : false, "proxyAuthUser" : null, "shareOverLan" : false, "localPort" : 1080 }'

    service_record.update ss_conf: ss_conf, ss_json: ss_json
  end

  def add_items(quantity)
    # binding.pry
    data = self.items.select('password, port, domain')
    json, port, password, domain, new_password = [], [], [], [], []
    ss_json = ""
    ss_conf = ""
    data.each do |d|
      port_i = d["port"]
      password_i = d["password"]
      domain_i = d["domain"]

      port << port_i
      password << password_i
      domain << d["domain"]
      ss_conf += "\"#{port_i}\"\: \"#{password_i}\","
      ss_json += "{\"enable\" : true,\"password\" : \"#{password_i}\",\"method\" : \"rc4-md5\",\"remarks\" : \"kkk\",\"server\" : \"#{domain_i}\",\"kcptun\" : {\"nocomp\" : false,\"key\" : \"it is a secrect\",\"crypt\" : \"aes\",\"datashard\" : 10,\"mtu\" : 1350,\"mode\" : \"fast\",\"parityshard\" : 3,\"arguments\" : \"\"},\"enabled_kcptun\" : false,\"server_port\" : 1.2.3.4,\"remarks_base64\" : \"5a2Q54+C\"},"
    end

    a = [*"a".."z"]
    # byebug
    puts quantity

    quantity.to_i.times do |t|
      new_password << (a.sample + a.sample + a.sample + a.sample + a.sample + a.sample)
    end
    puts new_password
    # binding.pry
    last_port = port.last.to_i
    new_port = (last_port..(last_port + quantity).to_i)

    puts "aaaaaaaaaaaaaaaaaaa"
    new_port.zip(new_password) do |b, s|
      ss_conf += "\"#{b}\"\: \"#{s}\","
      ss_json += "{\"enable\" : true,\"password\" : \"#{s}\",\"method\" : \"rc4-md5\",\"remarks\" : \"kkk\",\"server\" : \"#{s}\",\"kcptun\" : {\"nocomp\" : false,\"key\" : \"it is a secrect\",\"crypt\" : \"aes\",\"datashard\" : 10,\"mtu\" : 1350,\"mode\" : \"fast\",\"parityshard\" : 3,\"arguments\" : \"\"},\"enabled_kcptun\" : false,\"server_port\" : #{b},\"remarks_base64\" : \"5a2Q54+C\"},"

      SsItem.create ss_service_id: self.id, port: b, password: s, re_code: SecureRandom.hex(16), qr_code: ("ss://" + (Base64.strict_encode64("rc4-md5:#{s}")).to_s + "@" + '1.2.3.4' + ":" + b.to_s + "/?OTA=false" )
    end

    puts "jjj--------------------"

    ss_conf = "{ \"server\":\"0.0.0.0\",\"port_password\": {" + ss_conf
    ss_conf = ss_conf.chop +   "}, \"local_address\":\"127.0.0.1\",\"local_port\":1080,\"method\":\"rc4-md5\",\"timeout\":300 }"

    ss_json = '{ "random" : false, "authPass" : null, "useOnlinePac" : false, "TTL" : 0, "global" : false, "reconnectTimes" : 3, "index" : 0, "proxyType" : 0, "proxyHost" : null, "authUser" : null, "proxyAuthPass" : null, "isDefault" : false, "pacUrl" : null, "configs" :' + ss_json + ', "proxyPort" : 0, "randomAlgorithm" : 0, "proxyEnable" : false, "enabled" : true, "autoban" : false, "proxyAuthUser" : null, "shareOverLan" : false, "localPort" : 1080 }'

    self.update ss_conf: ss_conf, ss_json: ss_json

  end

end
