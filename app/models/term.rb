class Term < ActiveRecord::Base
     has_many :subject, :dependent => :delete_all
end 
