class SsService < ApplicationRecord

  def self.generate_service(ip)
    a = [*"a".."z"]
    b = [*8380..8460]
    ss_conf = String.new
    ss_json = ""
    password_a = []

    service_record = SsService.create service_ip: ip

    81.times do
      password_a << (a.sample + a.sample + a.sample + a.sample + a.sample + a.sample)
    end

    b.zip(password_a) do |b,s|
      ss_conf += "\"#{b}\"\: \"#{s}\","
      SsItem.create ss_service_id: service_record.id, port: b, password: s, re_code: SecureRandom.hex(16), qr_code: ("ss://" + (Base64.strict_encode64("rc4-md5:#{s}")).to_s + "@" + ip + ":" + b.to_s + "/?OTA=false" )
    end

    b.zip(password_a) do |b, s|
      ss_json += "{\"enable\" : true,\"password\" : \"#{s}\",\"method\" : \"rc4-md5\",\"remarks\" : \"kkk\",\"server\" : \"#{ip}\",\"kcptun\" : {\"nocomp\" : false,\"key\" : \"it is a secrect\",\"crypt\" : \"aes\",\"datashard\" : 10,\"mtu\" : 1350,\"mode\" : \"fast\",\"parityshard\" : 3,\"arguments\" : \"\"},\"enabled_kcptun\" : false,\"server_port\" : #{b},\"remarks_base64\" : \"5a2Q54+C\"},"
    end

    service_record.update ss_conf: ss_conf, ss_json: ss_json
  end

end
