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

        #Check if params are not null
        if params['termName'].blank? ||
            params['courseName'].blank? ||
            params['weight'].blank?
            flash[:danger] = "Please Don't Leave Any Field Blank"
            return render :controller => 'start',
                                :action => 'show'
        end

        @term = Term.new(:name => params['termName'],:user_id => @user_id.id)

        if @term.save
            @subject = Subject.new(:name => params['courseName'],:weight => params['weight'], :term_id => @term.id)
        else
            flash[:warning] = "A Random Bug Occured, Please Try Again"
            render 'welcome'
        end

        if @subject.save
            flash[:success] = "New Term and Subject Created"
            return redirect_to :controller => 'grade',
                            :action => 'show',
                            :tid => @term.id,
                            :cid => @subject.id
        else
            flash[:warning] = "A Random Bug Occured, Please Try Again"
            render 'welcome'
        end
    end
end
