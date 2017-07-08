class User < ApplicationRecord
  has_secure_password
  has_many :budgets

  attr_accessor :id, :first_name, :last_name, :email, :password_digest
  def initialize(input_hash)
    @id = input_hash["id"]
    @first_name = input_hash["first_name"]
    @last_name = input_hash["last_name"]
    @email = input_hash["email"]
    @password_digest = input_hash["password_digest"]
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def self.find(id)
    user_hash = Unirest.get("http://localhost:3001/api/v1/users/#{id}").body
    User.new(user_hash)
  end

  def self.find_by(email)
    api_users = Unirest.get('http://localhost:3001/api/v1/users').body
    api_users.each do |api_user|
      if api_user['email'] == email
        user = User.new(api_user)
        return user
      end
    end
  end

  def self.all
    users = []
    api_users = Unirest.get('http://localhost:3001/api/v1/users').body
    api_users.each do |api_user|
      users << User.new(api_user)
    end
    users
  end

  def update

  end

  def destroy
    Unirest.delete("http://localhost:3001/api/v1/users/#{id}", headers:{'Accept' => 'Application/json'} )
    
  end
end
