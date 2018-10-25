json.cache! user do
  json.id user.idsec
  json.call(user, :username, :email)
end
