class User < ApplicationRecord
  authenticates_with_sorcery!

  attr_accessor :password, :password_confirmation, :token
 CELLPHONE_RE = /\A(\+86|86)?1\d{10}\z/
  validates_presence_of :password, message: "密码不能为空",
   if: :need_validate_password
 validates_presence_of :password_confirmation, message: "密码确认不能为空",
   if: :need_validate_password
 validates_confirmation_of :password, message: "密码不一致",
   if: :need_validate_password
 validates_length_of :password, message: "密码最短为6位", minimum: 6,
   if: :need_validate_password
 validate :validate_phone, on: :create


  def admin?
    is_admin
  end

 private
 def need_validate_password
   self.new_record? ||
     (!self.password.nil? || !self.password_confirmation.nil?)
 end
 def validate_phone
     if self.phone.nil?
       self.errors.add :base, "手机号不能为空"
       return false
     else
         if !self.phone=~ CELLPHONE_RE
           self.errors.add :phone, "手机号格式不正确"
           return false
         end
         if User.find_by_phone(self.phone).present?
           self.errors.add :phone, "您输入的手机号已注册过，请直接登录"
         end
       return true
     end
 end


end
