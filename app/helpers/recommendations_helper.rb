module RecommendationsHelper
	def sendRecommendation(email, user, placename, recommendation)
            domain = ENV['MAILGUN_DOMAIN']
            password = ENV['MAILGUN_API_KEY']
            username = 'api'
            url = "https://api.mailgun.net/v2/#{domain}/messages"

            params = {
                :from => "Mailgun Sandbox <postmaster@#{domain}>",
                :to => "#{email}",
                :subject => "#{user} just sent you a new recommendation",
                :html => "<h3>#{user} recommends #{placename}</h3>
                <br>
                <a href='http://localhost:3000'>#{recommendation}</a>"
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
