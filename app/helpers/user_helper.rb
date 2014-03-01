module UserHelper
  def subscribed_text
    current_user.subscribed? ? 'Unsubscribe' : 'Subscribe'
  end
end