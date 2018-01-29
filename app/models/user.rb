class User < ApplicationRecord
  # we are user add_index on email of users table
  # enforce uniqueness at the database level
  # and some database adapters use case-sensitive indices
  # To avoid the incompatibility for considering the strings "Fo@fo.com" and "fo@fo.com" to be distinct
  # we'll standardiz on all lower-case addresses before saving it to the database
  # the way to do with a callback
  before_save { email.downcase! }

  # Name validation
  validates :name, presence: true, length: { maximum: 50 }

  # use validations the attribute with the given regular expression(or regex)
  # Regex is the powerful for matching patterns in strings
  # 正規表達式在Email格式驗證上的應用
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }

  # A hashed password
  # so User has secure password
  # When included in a model as above, this one method adds the following functionality:
  # --The ability to save a securely hashed password_digest attribute to the database
  # --A pair of virtual attributes18 (password and password_confirmation), including presence validations upon object creation and a validation requiring that they match
  # --An authenticate method that returns the user when the password is correct (and false otherwise) 
  # 會將使用者submitted password進行hashed運算後的 value 存到database
  # 藉由這個hashed value來進行comparing
  # 而使用者本身真正的password將不會在資料庫中也不怕被盜取
  # reference: http://api.rubyonrails.org/classes/ActiveModel/SecurePassword/ClassMethods.html
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

  # Return the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end                                               
end
