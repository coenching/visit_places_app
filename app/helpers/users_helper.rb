module UsersHelper
	def sendEmail(email)
            domain = ENV['MAILGUN_DOMAIN']
            password = ENV['MAILGUN_API_KEY']
            username = 'api'
            url = "https://api.mailgun.net/v2/#{domain}/messages"

            params = {
                :from => "Mailgun Sandbox <postmaster@#{domain}>",
                :to => "#{email}",
                :subject => "Welcome to Dream Places",
                :html => "<h2>You have just signed up to happiness.</h2><br><a href='http://localhost:3000'>Check it out now!</a>"
            }

            options = {
                method: :post,
                params: params,
                userpwd: "#{username}:#{password}"
            }

            request = Typhoeus::Request.new(url, options)

            response = request.run()
	end
end
