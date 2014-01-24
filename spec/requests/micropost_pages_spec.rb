require 'spec_helper'

describe "Micropost pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "micropost creation" do
    before { visit root_path }

    describe "with invalid information" do

      it "should not create a micropost" do
        expect { click_button "Post" }.not_to change(Micropost, :count)
      end

      describe "error messages" do
        before { click_button "Post" }
        it { should have_content('error') } 
      end
    end

    describe "with valid information" do

      before { fill_in 'micropost_content', with: "Lorem ipsum" }
      it "should create a micropost" do
        expect { click_button "Post" }.to change(Micropost, :count).by(1)
      end
    end
  end

  describe "micropost destruction" do
    before { FactoryGirl.create(:micropost, user: user) }

    describe "as correct user" do
      before { visit root_path }

      it "should delete a micropost" do
        expect { click_link "delete" }.to change(Micropost, :count).by(-1)
      end
    end
  end

  # Test from section 10.5, exercise 1
  describe "micopost content" do

    describe "shows 0 microposts" do
      before do
        visit root_path
      end
      it { should have_content("0 microposts") }
    end

    describe "shows 1 micropost" do
      before do
        FactoryGirl.create(:micropost, user: user, created_at: 1.day.ago)
        visit root_path
      end
      it { should have_content("1 micropost") }
    end

    describe "shows multiple microposts" do
      before do
        FactoryGirl.create(:micropost, user: user, created_at: 1.day.ago)
        FactoryGirl.create(:micropost, user: user, created_at: 1.hour.ago)
        FactoryGirl.create(:micropost, user: user, created_at: 1.minute.ago)
        visit root_path 
      end
      it { should have_content("#{user.microposts.count} microposts") }
    end

  end

  # Test from section 10.5, exercise 2
  describe "micropost pagination on home page" do
    before do 
      31.times { FactoryGirl.create(:user) }
      31.times { FactoryGirl.create(:micropost, user: user) }
      visit root_path
    end
    it { should have_selector('div.pagination') }
  end

  # Test from section 10.5, exercise 4
  describe "no delete link for content created by other" do
    before do
      @user2 = FactoryGirl.create(:user)
      FactoryGirl.create(:micropost, user: user, created_at: 1.day.ago)
      FactoryGirl.create(:micropost, user: @user2, created_at: 1.day.ago)
    end

    describe "case 1, no links for user in when user2 visits their page" do
      before do
        sign_in @user2
       visit "/users/#{user.id}"
     end
      it { should_not have_link('delete') }
    end

    describe "case 2, no links for user2 in when user visits their page" do
      before do
        sign_in user
        visit "/users/#{@user2.id}"
      end
      it { should_not have_link('delete') }
    end

  end

end
