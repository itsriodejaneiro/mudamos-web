module WithEnvHelper
  # Sets env variables and executes the given block.
  #
  # The env is returned to the previous state after the block execution.
  #
  # @param kwargs [Hash<#to_s, #to_s>] the env variables
  def with_env(**kwargs, &block)
    old_envs = kwargs.each_with_object({}) do |(k, v), memo|
      env_name = to_env_name(k)

      memo[env_name] = ENV[env_name] if ENV.key?(env_name)
      ENV[env_name] = v.to_s
    end

    block.call
  ensure
    kwargs.each do |k, _v|
      env_name = to_env_name(k)

      if old_envs.key? env_name
        ENV[env_name] = old_envs[env_name]
      else
        ENV.delete env_name
      end
    end
  end

  private

  def to_env_name(key)
    key.to_s.upcase
  end
end
