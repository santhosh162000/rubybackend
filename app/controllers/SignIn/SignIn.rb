require 'pg'
require 'hanami/controller'
require 'json'

module SignIn
    class SignIn
        include ::Hanami::Action
        def call (env)
            response = request.body.read
            request.body.rewind
            signinDetails = JSON.parse(response)
            email = signinDetails['signinDetails']['email']
            password = signinDetails['signinDetails']['password']
            
            begin
                con = PG.connect :host => 'ec2-34-233-114-40.compute-1.amazonaws.com', :dbname => 'd7au413leaqaiu', :user => 'egacraervjiocu', :password => '49f88e5d0b81752e03a1ba593ddf1d5147c54de9a068a0309e7e457a21c3e1a6'
                exist = con.exec "select exists (select * from emp where email='#{email}' and password='#{password}')"

                if exist[0]["exists"]=='t' 
                    puts "Existing User"
                    
                    empDetails = con.exec "select * from emp where email='#{email}' and password='#{password}'"

                    validation = "true"
                    name = empDetails[0]["name"]
                    email = empDetails[0]["email"]
                    password = empDetails[0]["password"]
                    empcode = empDetails[0]["empcode"]
                    address = empDetails[0]["address"]
                    joiningdate = empDetails[0]["joiningdate"]
                    
                    response = {'validation' => validation, 'name' => name, 'email' => email, 'password' => password, 'empcode' => empcode, 'address' => address, 'joiningdate' => joiningdate}
                    
                    puts response
                    res = JSON.generate(response)

                    self.body = res
                else
                    puts "Wrong User Details"
                    validation = "false"
                                      
                    response = {'validation' => validation}
                    
                    puts response
                    res = JSON.generate(response)

                    self.body = res
                end
                
            
            rescue PG::Error => e
            
                puts e.message 
                
            ensure
            
                con.close if con
                
            end
        end
    end
end 
