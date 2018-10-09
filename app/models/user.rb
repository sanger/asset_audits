class User < ActiveResource::Base
  def self.login_from_user_code(user_code)
    begin
      Sequencescape::Api::V2::User.where(user_code: user_code).first&.login
    rescue JsonApiClient::Errors::ConnectionError
      nil
    end
  end
end
