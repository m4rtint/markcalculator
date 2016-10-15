class Grade < ActiveRecord::Base
    belongs_to :subject
    validates :courseItem, :worth, :mark, :courseMark, :subject_id, presence: true
    validates :mark, :courseMark, :numericality => {:greater_than_or_equal_to => 0, only_float: true}
    validates :worth, :numericality => {:greater_than_or_equal_to => 0, only_float: true}
    validates :subject_id, :numericality => {only_integer: true}
end
