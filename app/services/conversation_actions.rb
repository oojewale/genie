module ConversationActions
  def send_otp(ctx, partial=false)
    otp = rand(10000000...100000000)
    user.otps.create(value: otp)
    TextMessage.send_text("You Secure Code: #{otp}", user.phone)
    return if partial
    prepare_payload(@key, true)
    send_to_watson
  end

  def temp_save_field(ctx)
    temp = TempUserUpdate.find_or_initalize_by(user: user)
    temp.update_attributes(ctx['field'] => ctx['value'])
    prepare_payload(@key, true)
    send_to_watson
  end

  def confirm_update(ctx)
    prepare_payload(@key, true)
    add_user
    add_context_field('update_msg', 'value')
    send_to_watson
  end

  def save_update(ctx)
    attr = TempUserUpdate.find_by(user: user).attributes
    attr.delete(:user_id)
    user.update_attributes(attr)
    prepare_payload(@key, true)
    send_to_watson
  end

  def get_location(ctx)
    begin
      gmaps = Navigation::Assistant.new
      gmaps.directions("Victory Island, Lagos", ctx['location'])
      @image = gmaps.get_image_url#["secure_url"]
      gmaps.parse.get_directions
    rescue
      prepare_payload(@key, "false")
      add_context_field("error_msg", "couldn't get the required directions")
      send_to_watson
    end
  end

  def confirm_check(ctx)
    # TODO: query database
    if true
      prepare_payload(@key, "yes")
      add_context_field("status", "status of check")
    else
      prepare_payload(@key, 'false')
    end
    add_user
    send_to_watson
  end

  def check_atm_status(ctx)
    prepare_payload(@key, 'yes')
    add_user
    add_context_field('card_type', "from Db")
    send_to_watson
  end

  def schedule_delivery(ctx)
    MeetingSchedulerService.new.create(user)
    prepare_payload(@key, 'yes')
    add_user
    add_context_field("address", "user.address")
    send_to_watson
  end

  def schedule_appointment(ctx)
    MeetingSchedulerService.new.create(user)
    prepare_payload(@key, 'yes')
    add_user
    send_to_watson
  end

  def atm_application(ctx)
    # TODO: save application to the db
    prepare_payload(@key, 'yes')
    add_context_field("card_type", ctx["card_type"])
    add_user
    send_to_watson
  end

  def update_alert(ctx)
    # TODO: save to database User.alerts.update ctx["value"] => enable or disable
    prepare_payload(@key, 'yes')
    add_user
    add_context_field('alert_types', 'Email notification and SMS notification')
    send_to_watson
  end

  def validate_receiver_account(ctx)
    acc = Account.includes(:user).find_by(account_num: ctx['account_no'])
    if acc
      TempTransaction.create_with(receiver: acc.user).find_or_create_by(sender: user)
      prepare_payload(@key, 'yes')
      add_context_field("receiver_name", acc.user.fullname)
      validation_status(true)
      add_user
    else
      validation_status(false)
    end
    send_to_watson
  end

  def save_amount_to_transfer(ctx)
    bal = user.accounts.first.balance
    if bal > ctx['amount']
      transc = TempTransaction.find_by(sender_id: user.id).update_attributes(amount: ctx['amount'])
      prepare_payload(@key, "yes")
      add_user
      add_context_field('amount', ctx['amount'])
      add_context_field('receiver_name', transc.receiver.fullname)
    else
      prepare_payload(@key, false)
      add_context_field("error_msg", "you have less than #{ctx['amount']} in your account. Your Account balance is #{bal}.")
      add_user
    end

    send_to_watson
  end

  def make_transaction(ctx)
    transc = TempTransaction.find_by(sender_id: user_id)
    transc.sender.accounts.first.decrement(:balance, transc.amount)
    transc.receiver.accounts.first.increment(:balance, transc.amount)
    transc.destroy

    prepare_payload(@key, 'yes')
    send_to_watson
  end

  def validate_account(ctx)
    acc = Account.includes(:user).find_by(account_num: ctx['account_no'])
    if acc
      @user = acc.user
      send_otp('', true)
      prepare_payload(@key, 'yes')
      update_context_user(user)
      validation_status(true)
      add_user
    else
      validation_status(false)
    end
    send_to_watson
  end

  def validate_otp(ctx)
    otp = user.otps.find_by(value: ctx['otp'])
    if otp
      add_user
      prepare_payload(@key, 'yes')
      validation_status(true)
      otp.destroy
    else
      validation_status(false)
    end
    send_to_watson
  end

  def get_statement(ctx)
    acc = user.get_statement
    prepare_payload(@key, 'yes')
    add_user
    add_context_field('statement', acc)
    send_to_watson
  end

  def validation_status(status)
    add_context_field('valid', status)
  end
end
