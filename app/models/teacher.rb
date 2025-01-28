class Teacher < ApplicationRecord
    validates :email, presence: true
end
