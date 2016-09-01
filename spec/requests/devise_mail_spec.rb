# -*- encoding : utf-8 -*-

require 'rails_helper'

describe "devise mail", :type => :request do

  before :each do
    ActionMailer::Base.deliveries = [] # reset list of mails
    Timecop.freeze(Time.now)
  end


  it "should send a mail to new registered user added by company-admin" do

    email = "new.registered-user@email.de"
    pw = "unknackbar123"

    expect {
      post "/users", {:user => {:firstname => "firstname", :lastname => "lastname",
                               :email => email, :password => pw,
                               :password_confirmation => pw}}
    }.to change(User, :count).by(1)

    expect(response).to redirect_to root_path

    user = User.where(:email => email).first
    expect(user).not_to be_nil
    expect(user.confirmed_at).to be_nil
    expect(user.encrypted_password).to be_present

    mails = ActionMailer::Base.deliveries
    expect(mails).not_to be_empty
    expect(mails.size).to eq(1)

    mail = mails[0]
    expect(I18n::l(mail.date)).to eq(I18n::l(DateTime.now))
    expect(mail.subject).to match(/#{I18n.t('app_name')} - #{I18n.t("devise.mailer.confirmation_instructions.subject")}/)
    expect(mail.from).to eq([MAIL])
    expect(mail.to).to eq([email])
    expect(mail.body).to match(/#{user.firstname}/u)
    expect(mail.body).to include("#{user_confirmation_path}?confirmation_token=")

  end

  it "should NOT send a mail if user is invalid" do

    email = "new.registered-user@email.de"
    pw = "unknackbar123"

    # no email
    expect {
      post "/users", {:user => {:firstname => "firstname", :lastname => "lastname",
                               :email => nil, :password => pw,
                               :password_confirmation => pw}}
    }.not_to change(User, :count)

    # no firstname
    expect {
      post "/users", {:user => {:firstname => "", :lastname => "lastname",
                               :email => email, :password => pw,
                               :password_confirmation => pw}}
    }.not_to change(User, :count)

    # no lastname
    expect {
      post "/users", {:user => {:firstname => "firstname", :lastname => "",
                               :email => email, :password => pw,
                               :password_confirmation => pw}}
    }.not_to change(User, :count)

    # no pw
    expect {
      post "/users", {:user => {:firstname => "firstname", :lastname => "",
                               :email => email, :password => nil,
                               :password_confirmation => pw}}
    }.not_to change(User, :count)

    # no pw check
    expect {
      post "/users", {:user => {:firstname => "firstname", :lastname => "",
                               :email => email, :password => pw,
                               :password_confirmation => nil}}
    }.not_to change(User, :count)

    expect(response).to be_success
    expect(response).to render_template('new')

    user = User.where(:email => email).first
    expect(user).to be_nil

    mails = ActionMailer::Base.deliveries
    expect(mails).to be_empty
    expect(mails.size).to eq(0)
  end


end
