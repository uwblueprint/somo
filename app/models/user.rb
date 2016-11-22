class User < ActiveRecord::Base
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable,
	     :recoverable, :rememberable, :trackable, :validatable,
	     :omniauthable
	devise :omniauthable, omniauth_providers: [:google_oauth2]

	def self.from_omniauth(auth)
  		where(provider: auth[:provider], uid: auth[:uid]).first_or_create do |user|
    		user.name = auth[:info][:name]
    		user.email = auth[:info][:email]
  		end
	end

	def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
  		data = access_token.info
  		user = User.where(:provider => access_token.provider, :uid => access_token.uid ).first
  		if user
  			return user
  		else
	  		registered_user = User.where(:email => access_token.info.email).first
  			if registered_user
    			return registered_user
  			else
    			user = User.create(name: data["name"],
      			provider:access_token.provider,
      			email: data["email"],
      			uid: access_token.uid ,
      			password: Devise.friendly_token[0,20],
    			)
  			end
		end
	end
end
