def github_api
  @github ||= ::Github.new :oauth_token => node.oauth_token, :ssl => { verify: false }
end

def public_key
  @public_key ||= ::File.read("/Users/#{node.current_user}/.ssh/id_rsa.pub")
end