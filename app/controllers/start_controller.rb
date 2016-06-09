class StartController < ApplicationController
    #Starting point for any account
    #Terms - No
    #Subjects - No
    def show
        #grab the first term
        @term = Term.where(:user_id => current_user.id).first

        #Go to welcome screen if no terms exists.
            #If not - go to first subject of first term
       if @term != nil
            @subject = Subject.where(:term_id => @term.id).first
            cid = 0
            if @subject != nil
                cid = @subject.id
            end
            return redirect_to :controller => 'grade',
                            :action => 'show',
                            :tid => @term.id,
                            :cid => cid
        end
    end

    #Posting for the 1st term + 1st Subject
    #New 1st Term
    #New 1st Subject
    def post_first_term
        #Query userID that is posting new term
        @user_id  = User.where(:uid => current_user.uid).take

        #TODO - value validation for course weight
        @term = Term.new(:name => params['termName'],:user_id => @user_id.id)

        if @term.save
            @subject = Subject.new(:name => params['courseName'],:weight => params['weight'], :term_id => @term.id)
        else
            render 'welcome'
        end

        if @subject.save
            return redirect_to :controller => 'grade',
                            :action => 'show',
                            :tid => @term.id,
                            :cid => @subject.id
        else
            render 'welcome'
        end
    end
end
