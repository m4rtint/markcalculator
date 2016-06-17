class Subject < ActiveRecord::Base
        belongs_to :term
        has_many :grade, :dependent => :destroy
        validates :name, :currentMark, :weight, :term_id, presence: true
        validates :currentMark, :weight, :numericality => {:greater_than_or_equal_to => 0, only_float: true}
        validates :term_id, :numericality => {only_integer: true}
end
