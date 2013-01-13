# -*- encoding : utf-8 -*-

require "spec_helper"

describe "devise mail" do

  before :each do
    ActionMailer::Base.deliveries = [] # reset list of mails
    freeze_test_time
  end


  it "should send a mail to new registered user added by company-admin" do

    email = "new.registered-user@email.de"
    pw = "unknackbar123"

    lambda {
      post "/users", {:user => {:firstname => "firstname", :lastname => "lastname",
                               :email => email, :password => pw,
                               :password_confirmation => pw}}
    }.should change(User, :count).by(1)

    response.should redirect_to root_path

    user = User.where(:email => email).first
    user.should_not nil
    user.confirmed_at.should be_nil
    user.encrypted_password.should be_present

    mails = ActionMailer::Base.deliveries
    mails.should_not be_empty
    mails.size.should == 1

    mail = mails[0]
    I18n::l(mail.date).should == I18n::l(DateTime.now)
    mail.subject.should =~ /#{I18n.t('app_name')} - #{I18n.t("devise.mailer.confirmation_instructions.subject")}/
    mail.from.should == ["tippspiel@soemo.org"]
    mail.to.should == [email]
    mail.body.should =~ /#{user.firstname}/u
    mail.body.should include("#{user_confirmation_path}?confirmation_token=#{user.confirmation_token}")

  end

  it "should NOT send a mail if user is invalid" do

    email = "new.registered-user@email.de"
    pw = "unknackbar123"

    # no email
    lambda {
      post "/users", {:user => {:firstname => "firstname", :lastname => "lastname",
                               :email => nil, :password => pw,
                               :password_confirmation => pw}}
    }.should_not change(User, :count)

    # no firstname
    lambda {
      post "/users", {:user => {:firstname => "", :lastname => "lastname",
                               :email => email, :password => pw,
                               :password_confirmation => pw}}
    }.should_not change(User, :count)

    # no lastname
    lambda {
      post "/users", {:user => {:firstname => "firstname", :lastname => "",
                               :email => email, :password => pw,
                               :password_confirmation => pw}}
    }.should_not change(User, :count)

    # no pw
    lambda {
      post "/users", {:user => {:firstname => "firstname", :lastname => "",
                               :email => email, :password => nil,
                               :password_confirmation => pw}}
    }.should_not change(User, :count)

    # no pw check
    lambda {
      post "/users", {:user => {:firstname => "firstname", :lastname => "",
                               :email => email, :password => pw,
                               :password_confirmation => nil}}
    }.should_not change(User, :count)

    response.should be_success
    response.should render_template('new')

    user = User.where(:email => email).first
    user.should be_nil

    mails = ActionMailer::Base.deliveries
    mails.should be_empty
    mails.size.should == 0
  end


end
