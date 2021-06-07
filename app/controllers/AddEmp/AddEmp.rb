require 'pg'
require 'hanami/controller'
require 'json'

module AddEmp
    class AddEmp
        include ::Hanami::Action
        def call (env)
            response = request.body.read
            request.body.rewind
            signupDetails = JSON.parse(response)
            name = signupDetails['signupDetails']['name']
            email = signupDetails['signupDetails']['email']
            password = signupDetails['signupDetails']['password']
            empcode = signupDetails['signupDetails']['empcode']
            address = signupDetails['signupDetails']['address']
            joiningdate = signupDetails['signupDetails']['joiningdate']
            begin
                con = PG.connect :host => 'ec2-34-233-114-40.compute-1.amazonaws.com', :dbname => 'd7au413leaqaiu', :user => 'egacraervjiocu', :password => '49f88e5d0b81752e03a1ba593ddf1d5147c54de9a068a0309e7e457a21c3e1a6'
                
                existingUser = con.exec "select exists (select * from emp where email='#{email}')"
                puts existingUser
                if existingUser[0]["exists"]==='f' 
                    exist = con.exec "INSERT INTO emp values ('#{name}', '#{email}', '#{password}', '#{empcode}', '#{address}', '#{joiningdate}')"
                    puts "Emp Added"
                    result = "Account Created"
                    response = {'result' => result}
                    
                    puts response
                    res = JSON.generate(response)

                    self.body = res
                else 
                    result = "Existing User"
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
