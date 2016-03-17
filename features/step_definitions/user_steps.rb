# By Tony. Steps needed for user testing

Given /^a valid user$/ do
  @user = User.create!({
             :email => "dummy@dummy.com",
             :password => "dummypass",
             :password_confirmation => "dummypass"
           })
end

# Given /^a logged in user$/ do
#   Given "a valid user"
#   visit "/users/sign_in"
#   fill_in "user_email", :with => "dummy@dummy.com"
#   fill_in "password", :with => "dummypass"
#   click_button "Log in"
# end