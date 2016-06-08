class Subject < ActiveRecord::Base
        belongs_to :term
        has_many :grade, :dependent => :destroy
end
