class UserMailer < ApplicationMailer
  default :from => "no-reply@locatorapp.com"

	def geocode_complete(user)
		@user = user
    	mail(:to => "#{@user.email}", :subject => "geocode completed!")
	end
end
