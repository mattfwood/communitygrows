require 'spec_helper'
require 'rails_helper'

describe CommitteeController do 
	fixtures :users
    before(:each) do
        sign_in users(:tester)
        @committee = Committee.create!({name: "Nice", hidden: true, inactive: true})
		@test_admin = User.find_by(name: "Rspec_admin")
		@test_committee = Committee.find_by(name: "Nice")
    end
	describe 'new committee' do
		it 'renders the new committee template' do
			get :new_committee
			expect(response).to render_template("new_committee")
		end
# 		it 'redirects non-admin users' do
#             sign_in users(:user)
#             get :new_committee
#             expect(response).to redirect_to root_path
#             sign_out users(:user)
#         end
	end

	describe 'create committee' do
		it 'redirects to the committee index page' do
			post :create_committee, params: {committee: {name: "Good Committee"}}
			expect(response).to redirect_to(committee_index_path)
		end
		it 'should not allow a blank name field' do
			post :create_committee, params: {committee: {name: ""}}
			expect(flash[:notice]).to eq("Committee name field cannot be blank.")
			expect(response).to redirect_to(new_committee_path)
		end
		it 'should not allow an already used committee name field' do
			expect(Committee).to receive(:has_name?).with("Good Committee").and_return(true)
			post :create_committee, params: {committee: {name: "Good Committee"}}
			expect(flash[:notice]).to eq("Committee name provided already exists. Please enter a different name.")
			expect(response).to redirect_to(new_committee_path)
		end

		it 'creates a committee' do
			expect(Committee).to receive(:create!).with(name: "Good Committee", :hidden => true, :inactive => true)
            post :create_committee, params: {committee: {name: "Good Committee"}}
            expect(flash[:notice]).to eq("Committee Good Committee was successfully created!")
        end

        it 'redirects non-admin users' do
            sign_in users(:user)
            post :create_committee, params: {committee: {name: "Good Committee"}}
            expect(response).to redirect_to root_path
            sign_out users(:user)
        end
	end

	describe 'edit committee' do
		it 'renders the edit committee template' do
			get :edit_committee, params: {id: @test_committee.id}
			expect(response).to render_template("edit_committee")
		end
		it 'redirects non-admin users' do
            sign_in users(:user)
            get :edit_committee, params: {id: @test_committee.id}
            expect(response).to redirect_to root_path
            sign_out users(:user)
        end
	end

	describe 'update committee' do
		it 'redirects to the committee index page' do
			put :update_committee, params: {id: @test_committee.id, committee: {name: "Good Committee"}}
			expect(response).to redirect_to(committee_index_path)
		end

		it 'should not allow a blank name field' do
			put :update_committee, params: {id: @test_committee.id, committee: {name: ""}}
			expect(flash[:notice]).to eq("Please fill in the committee name field.")
			expect(response).to redirect_to(edit_committee_path)
		end
		it 'should not allow an already used committee name field' do
			expect(Committee).to receive(:has_name?).with("Nice").and_return true
			put :update_committee, params: {id: @test_committee.id, committee: {name: "Nice"}}
			expect(flash[:notice]).to eq("Committee name provided already exists. Please enter a different name.")
			expect(response).to redirect_to(edit_committee_path)
		end

		it 'updates the committee' do
            put :update_committee, params: {id: @test_committee.id, committee: {name: "Good Committee"}}
            expect(response).to redirect_to(committee_index_path)
        end

        it 'redirects non-admin users' do
            sign_in users(:user)
            put :update_committee, params: {id: @test_committee.id, committee: {name: "Good Committee"}}
            expect(response).to redirect_to root_path
            sign_out users(:user)
        end
	end

	describe 'delete committee' do
		it 'redirects to the committee index page' do
			delete :delete_committee, params: {id: @test_committee.id}
			expect(response).to redirect_to(committee_index_path)
		end

		it "shows a flash delete message when committee successfully deleted" do
            delete :delete_committee, params: {id: @test_committee.id}
            expect(flash[:notice]).to eq("Committee with name Nice deleted successfully.")
        end

        it 'redirects non-admin users' do
            sign_in users(:user)
            delete :delete_committee, params: {id: @test_committee.id}
            expect(response).to redirect_to root_path
            sign_out users(:user)
        end
	end

	describe 'hide committee' do
		it 'redirects to the committee index page' do
			get :action_committee, params: {id: @test_committee.id, do_action: 'hide'}
			expect(response).to redirect_to(committee_index_path)
		end

		it 'shows a flash message when committee successfully hidden' do
			get :action_committee, params: {id: @test_committee.id, do_action: 'hide'}
			expect(flash[:notice]).to eq("Nice successfully hidden.")
		end

		it 'sets the committee\'s hidden attribute to true' do
			expect_any_instance_of(Committee).to receive(:hide)
			get :action_committee, params: {id: @test_committee.id, do_action: 'hide'}
		end

		it 'redirects non-admin users' do
            sign_in users(:user)
            get :action_committee, params: {id: @test_committee.id, do_action: 'hide'}
            expect(response).to redirect_to root_path
            sign_out users(:user)
        end
	end

	describe 'show committee' do
		it 'redirects to the committee index page' do
			get :action_committee, params: {id: @test_committee.id, do_action: 'show'}
			expect(response).to redirect_to(committee_index_path)
		end

		it 'shows a flash message when committee successfully shown' do
			get :action_committee, params: {id: @test_committee.id, do_action: 'show'}
			expect(flash[:notice]).to eq("Nice successfully shown.")
		end

		it 'sets the committee\'s hidden attribute to false' do
			expect_any_instance_of(Committee).to receive(:show)
			get :action_committee, params: {id: @test_committee.id, do_action: 'show'}
		end

		it 'redirects non-admin users' do
            sign_in users(:user)
            get :action_committee, params: {id: @test_committee.id, do_action: 'show'}
            expect(response).to redirect_to root_path
            sign_out users(:user)
        end
	end
	
	
	describe 'activate committee' do
		it 'redirects to the committee index page' do
			get :action_committee, params: {id: @test_committee.id, do_action: 'active'}
			expect(response).to redirect_to(committee_index_path)
		end

		it 'shows a flash message when committee successfully active' do
			get :action_committee, params: {id: @test_committee.id, do_action: 'active'}
			expect(flash[:notice]).to eq("Nice successfully made active.")
		end

		it 'sets the committee\'s hidden attribute to true' do
			expect_any_instance_of(Committee).to receive(:activate)
			get :action_committee, params: {id: @test_committee.id, do_action: 'active'}
		end

		it 'redirects non-admin users' do
            sign_in users(:user)
            get :action_committee, params: {id: @test_committee.id, do_action: 'active'}
            expect(response).to redirect_to root_path
            sign_out users(:user)
        end
	end



	describe 'Inactivate committee' do
		it 'redirects to the committee index page' do
			get :action_committee, params: {id: @test_committee.id, do_action: 'inactive'}
			expect(response).to redirect_to(committee_index_path)
		end

		it 'shows a flash message when committee successfully inactive' do
			get :action_committee, params: {id: @test_committee.id, do_action: 'inactive'}
			expect(flash[:notice]).to eq("Nice successfully made inactive.")
		end

		it 'sets the committee\'s hidden attribute to false' do
			expect_any_instance_of(Committee).to receive(:inactivate)
			get :action_committee, params: {id: @test_committee.id, do_action: 'inactive'}
		end

		it 'redirects non-admin users' do
            sign_in users(:user)
            get :action_committee, params: {id: @test_committee.id, do_action: 'inactive'}
            expect(response).to redirect_to root_path
            sign_out users(:user)
        end
	end
	
	
	
	
	describe 'Add committee member' do

		it 'shows a flash message when member is successfully added to committee' do
			put :add_member, params: {id: @test_committee.id, user_id: @test_admin.id}
			expect(flash[:notice]).to eq("Rspec_admin successfully added to Nice.")
			put :remove_member, params: {id: @test_committee.id, user_id: @test_admin.id}
			expect(flash[:notice]).to eq("Rspec_admin successfully removed from Nice.")
		end
		
		it 'Only admins can add and delete committee members.' do
			sign_in users(:user)
			@test_user = User.find_by(name: "Rspec_user")
			put :add_member, params: {id: @test_committee.id, user_id: @test_user.id}
			expect(flash[:message]).to eq("Only admins can add committee members.")
			sign_in users(:tester)
			put :add_member, params: {id: @test_committee.id, user_id: @test_admin.id}
			sign_in users(:user)
			put :remove_member, params: {id: @test_committee.id, user_id: @test_admin.id}
			expect(flash[:message]).to eq("Only admins can remove committee members.")
		end

	end
	
end

