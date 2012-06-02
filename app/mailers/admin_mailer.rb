class AdminMailer < ActionMailer::Base
  default :from => MAIL

  def result_grabber_email(error_msg_array, info_msg_array)
    @error_msg_array = error_msg_array
    @info_msg_array  = info_msg_array
    mail(:to => MAIL, :subject => "[Fussball Tippspiel] - Result Grabber Infos")
  end
end
