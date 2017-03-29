class SimpleLogger
  def self.log(message)
    puts message
  end
end

# This is here to create users from a rake task.
class UserCreationService
  def initialize(params, logger=SimpleLogger, randomizer=SecureRandom)
    @params = params
    @logger = logger
    @randomizer = randomizer
  end

  def save
    saved = user.save
    if saved
      logger.log("Api User Created")
      logger.log("================")
      logger.log("API KEY: #{user.api_key}")
      logger.log("API SECRET: #{unencrypted_api_secret}")
      logger.log("BE SURE TO STORE THE SECRET SECURELY")
      logger.log("WE DO NOT STORE UNENCRYPTED SECRETS")
      logger.log("WRITE IT DOWN NOW")
    else
      logger.log("USER WAS INVALID:")
      logger.log("ERRORS:")
      logger.log("#{user.errors.full_messages.join('\n')}")
    end
    saved
  end

  private

  def user
    @user ||= User.new(params.merge(password: unencrypted_api_secret, password_confirmation: unencrypted_api_secret))
  end

  attr_reader :params, :logger, :randomizer

  def unencrypted_api_secret
    @unencrypted_api_secret ||= randomizer.uuid.gsub("-", "")
  end
end
