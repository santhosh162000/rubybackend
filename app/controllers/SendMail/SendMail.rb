require 'pg'
require 'hanami/controller'
require 'json'
require 'sendgrid-ruby'
include SendGrid 

module SendMail
    class SendMail
        include ::Hanami::Action
        def call (env)
            response = request.body.read
            request.body.rewind
            emailDetails = JSON.parse(response)
            puts emailDetails
            email = emailDetails['emailDetails']['email']

            begin
                con = PG.connect :host => 'ec2-34-233-114-40.compute-1.amazonaws.com', :dbname => 'd7au413leaqaiu', :user => 'egacraervjiocu', :password => '49f88e5d0b81752e03a1ba593ddf1d5147c54de9a068a0309e7e457a21c3e1a6'
                existingUser = con.exec "select exists (select * from emp where email='#{email}')"
                puts existingUser[0]["exists"]

                if existingUser[0]["exists"]==='t'
                    from = SendGrid::Email.new(email: 'emsappyvrk@gmail.com')
                    to = SendGrid::Email.new(email: email)
                    subject = 'Password Reset Code'
                    content = SendGrid::Content.new(type: 'text/html', value: 'The Password Reset Code is 123')
                    mail = SendGrid::Mail.new(from, subject, to, content)

                    sg = SendGrid::API.new(api_key: 'NRTmxilQds3jquVipRjV9YgmMmg4F_jJgtyD1Xm0')
                    response = sg.client.mail._('send').post(request_body: mail.to_json)

                    puts response.status_code
                    puts response.body
                    puts response.headers
                    

                        result = "Mail Sent"
                        response = {'result' => result}
                        
                        puts response
                        res = JSON.generate(response)

                        self.body = res
                else 
                    result = "Not Existing User"
                    response = {'result' => result}
                    
                    puts response
                    res = JSON.generate(response)

                    self.body = res
                end  
            
            rescue PG::Error => e
            
                puts e.message 

                puts "Emp Not Added"
                
            ensure
            
                con.close if con
                
            end
        end
    end
end 
