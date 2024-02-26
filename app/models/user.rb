class User < ApplicationRecord
    has_many :articles, dependent: :destroy
    has_many :comments
    has_many :likes

    has_many :friendships
    has_many :friends, through: :friendships
    has_many :inverse_friendships, class_name: "Friendship", foreign_key: "friend_id"
    has_many :inverse_friends, through: :inverse_friendships, source: :user
    
    # Rails built-in method that provides password encryption using bcrypt.
    has_secure_password
    
    validates :name, length: { in: 2..50 }
    validates :email, presence: true, uniqueness: true
    validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :username, presence: true, uniqueness: true
    
    validates :password,
        presence: true,
        length: { minimum: 8 },
                                if: -> { new_record? || !password.nil? }

    validate :password_format


    private
        def password_format
            # Using regular expression
            # if password.present? && !password.match(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$/)
            #     errors.add :password, "Must contain at least one uppercase letter, one lowercase letter, one number, and one special character"
            # end

            if password.present?
                is_uppercase = false
                is_lowercase = false
                is_number = false
                is_special = false
                
                password.each_char do |char|
                    if ('A'..'Z').include?(char)
                        is_uppercase = true
                    elsif ('a'..'z').include?(char)
                        is_lowercase = true
                    elsif ('0'..'9').include?(char)
                        is_number = true
                    else
                        is_special = true
                    end
                end

                unless is_uppercase
                    errors.add :password, "Must contain at least one uppercase letter"
                end
            
                unless is_lowercase
                    errors.add :password, "Must contain at least one lowercase letter"
                end
        
                unless is_number
                    errors.add :password, "Must contain at least one digit"
                end
        
                unless is_special
                    errors.add :password, "Must contain at least one special character"
                end
            end
        end
end
