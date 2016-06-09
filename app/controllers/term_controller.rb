class TermController < ApplicationController
    #Show page if user have terms but no subjects
    #Terms - Yes
    #Subjects - No
    def show_terms
        #Show Terms of user
        @terms = Term.where(:user_id => current_user.id)

        #Does the user have any terms?
        if @terms.blank?
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
        #If User has Terms but no subject, No If statements are true
    end

    def post_terms
        @term = Term.new(:name => params['termName'], :user_id => current_user.id)
        if @term.save
            return redirect_to :action => 'show_terms', :controller => 'term',  :tid => @term.id
        end
    end

    def delete_terms
        #Find the term to delete
        @term = Term.find_by(id: params[:tid])
        @term.destroy

        #Get the first term ever
        @term_first = Term.first

        #if terms don't exist - go to welcome, else goto first term
        if @term_first == nil
            return redirect_to "/welcome"
        else
            return redirect_to :controller => 'term',
                            :action => 'show_terms',
                            :tid => @term_first.id
        end
    end

end
