class TermController < ApplicationController
    #Show page if user have terms but no subjects
    #All if statements redirect to another page if any other case other than - Term => 1, Subject = 0
    def show_terms
        #Show Terms of user
        @terms = Term.where(:user_id => current_user.id)

        #Does the user have any terms?
        if @terms.blank?
            #No terms - redirect to '/start'
            return redirect_to :controller => 'start',
                                :action => 'show'
        end

        #Check if :tid belongs to user - else load up first term on their list
        if !Term.where(:user_id => current_user.id, :id => params[:tid]).present?
            return redirect_to :controller => 'term',
                                :action => 'show_terms',
                                :tid => @terms.first.id
        end

        #If subject exists - redirect to main page 'term/:tid/courses/:cid'
        if subject = Subject.where(:term_id => params[:tid]).first
            return redirect_to :controller => 'grade',
                                :action => 'show',
                                :tid => params[:tid],
                                :cid => subject.id
        end
        #If User has Terms but no subject, None of If statements are true
    end

    def post_terms
        @term = Term.new(:name => params['termName'], :user_id => current_user.id)
        if @term.save
            return redirect_to :action => 'show_terms', :controller => 'term',  :tid => @term.id
        else
            flash[:warning] = "A Random Bug Occured, Please Try Again"
            return redirect_to '/start'
        end
    end

    def delete_terms
        #check if tid exists
        if !Term.where(:user_id => current_user.id,:id => params[:tid]).present?
            flash[:danger] = "Please delete only your own terms"
            return redirect_to "/start"
        end
        #Find the term to delete
        term = Term.find_by(id: params[:tid])

        #Check if term Name matches with Input
        if params[:termname] == term.name
            term.destroy
        else
            flash[:warning] = "Please Enter The Correct Name For The Term You Wish To Delete"
            return redirect_to "/settings"
        end

        #Get the first term ever
        @term_first = Term.first

        #if terms don't exist - go to start, else goto first term
        if @term_first == nil
            return redirect_to "/start"
        else
            return redirect_to :controller => 'term',
                            :action => 'show_terms',
                            :tid => @term_first.id
        end
    end

    def get_terms_to_delete
        #Show Terms of user
        @terms = Term.where(:user_id => current_user.id)

        #Does the user have any terms?
        if @terms.blank?
            #No terms - redirect to '/start'
            return redirect_to :controller => 'start',
                                :action => 'show'
        end
    end

end
