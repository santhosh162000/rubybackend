require 'pg'
require 'hanami/controller'
require 'json'

module DeleteProfile
    class DeleteProfile
        include ::Hanami::Action
        def call (env)
            response = request.body.read
            response = request.body.rewind
            response = request.body.read
            puts response
            deleteProfileDetails = JSON.parse(response)
            email = deleteProfileDetails['profileDetails']['email']
            puts email
            
            begin
                
                con = PG.connect :host => 'ec2-34-233-114-40.compute-1.amazonaws.com', :dbname => 'd7au413leaqaiu', :user => 'egacraervjiocu', :password => '49f88e5d0b81752e03a1ba593ddf1d5147c54de9a068a0309e7e457a21c3e1a6'
                exist = con.exec "DELETE FROM emp where email = '#{email}'"
                
                    puts "Profile Is Deleted"

                    deleted = "true"
                                        
                    response = {'deleted' => deleted}
                    
                    puts response
                    res = JSON.generate(response)

                    self.body = res              
                
            
            rescue PG::Error => e
            
                puts e.message 

                    updated = "false"
                                      
                    response = {'updated' => updated}
                    
                    puts response
                    res = JSON.generate(response)

                    self.body = res
                
            ensure
            
                con.close if con
                
            end
        end
    end
end 
