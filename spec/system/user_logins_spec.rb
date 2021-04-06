require 'rails_helper.rb'

RSpec.describe "the signin process", type: :feature do
  
  before :each do
    User.create(email: 'user@example.com', password: 'password')
  end

  it "signs me in" do
    visit '/users/sign_in'
    fill_in "user_email", with: 'user@example.com'
    fill_in "user_password", with: 'password'
    click_button 'Log in'
    expect(page).to have_content 'Signed in successfully.'
  end

end
