module OSB
  module Util
    def self.encrypt(value_to_encrypt)
      secret = Digest::SHA1.hexdigest("osb-dey-lashkarey-jagh-mag-bill-sarey")
      e = ActiveSupport::MessageEncryptor.new(secret)
      Base64.encode64(e.encrypt_and_sign(value_to_encrypt))
    end

    def self.decrypt(value_to_decrypt)
      secret = Digest::SHA1.hexdigest("osb-dey-lashkarey-jagh-mag-bill-sarey")
      e = ActiveSupport::MessageEncryptor.new(secret)
      e.decrypt_and_verify(Base64.decode64(value_to_decrypt))
    end
  end
end