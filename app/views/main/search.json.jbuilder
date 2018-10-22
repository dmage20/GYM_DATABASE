json.users do
  json.array!(@users) do |user|
    json.name user.name
    json.sender_id current_user.id
    json.recipient_id user.id
    json.url conversations_path(sender_id: current_user.id, recipient_id: user.id)
    # json.url url_for(conversations_path(sender_id: current_user.id, recipient_id: user.id), method: :post)
  end
end
