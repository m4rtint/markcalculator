class Subject < ActiveRecord::Base
        belongs_to :term
        has_many :grade, :dependent => :delete_all
end
