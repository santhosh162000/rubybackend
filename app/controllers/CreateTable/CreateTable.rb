require 'pg'
require 'hanami/controller'

module CreateTable
    class CreateTable
        include ::Hanami::Action
        def call (env)
            begin
                con = PG.connect :host => 'ec2-34-233-114-40.compute-1.amazonaws.com', :dbname => 'd7au413leaqaiu', :user => 'egacraervjiocu', :password => '49f88e5d0b81752e03a1ba593ddf1d5147c54de9a068a0309e7e457a21c3e1a6'
                exist = "SELECT EXISTS (SELECT FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'emp')"
                if exist=='true' 
                    con.exec "CREATE TABLE emp(Name VARCHAR(20), Email VARCHAR(30) PRIMARY KEY, Password VARCHAR(20), EmpCode VARCHAR(20), Address VARCHAR(50), JoiningDate  VARCHAR(20))"
                    puts "Table Created"
                else
                    puts "Table Exist"
                end
            
            rescue PG::Error => e
            
                puts e.message 
                
            ensure
            
                con.close if con
                
            end
        end
    end
end 
