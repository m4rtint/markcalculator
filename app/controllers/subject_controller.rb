class SubjectController < ApplicationController

    #Grab all the Terms For the Top menu bar in '/Overall' page
    def overall_subjects
        #Grab all terms for top menu
        if !@terms = Term.where(:user_id => current_user.id)
            return redirect_to :controller => 'start',
                               :action => 'show'
        end

        #Check if ':tid' belongs to user
            #Query Subject of that :tid
            # => else get 1st Term stats
        t = @terms.first.id
        if Term.where(:user_id => current_user.id, :id => params[:tid]).present?
            t = params[:tid]
        end
        @subject_index = Subject.where(term_id: t)
    end

    #Post new subject within a term
    def post_subjects
        #check if tid exists
        if !Term.where(:user_id => current_user.id,:id => params['tid']).present?
            return redirect_to "/start"
        end

        @subject = Subject.new(:name => params['courseName'],
                                :weight => params['weight'],
                                :term_id => params['tid'])
        if !@subject.valid?
            flash[:danger] = "Please Input Valid Values"
        elsif @subject.save
            redirect_to controller: 'grade',
                        action: :show ,
                        :tid => params['tid'].to_s,
                        :cid => @subject.id.to_s
        else
            flash[:warning] = "A Random Bug Occured, Please Try Again"
            render redirect_to action: "show",
                                id:0
        end
    end

    def delete_subjects
    #Check if the subject exists
        if check_id(params[:id])
            flash[:danger] = "Please Make sure subject belongs to you"
            return redirect_to '/'
        end
    #Delete Subject
        #Find the subject to delete according to the id
        @cid = Subject.find_by(id: params[:id])

        #save the term it's linked to
        tid = @cid.term_id
        #delete the model
        @cid.destroy

    #Redirect to term
        #find the id of the first subject
        @subject_first = Subject.where(:term_id => tid).first

        #if subject exist - go to first - else default to course - 0
        if @subject_first == nil
            subject_id = 0
        else
            subject_id = @subject_first.id
        end

        #redirect to first course
        redirect_to controller: 'grade',
                    action: 'show',
                    :tid => tid,
                    :cid => subject_id
    end

    def weight_overall_mark(subjects)
        weighted_mark = 0
        subjects.each do |s|
            weighted_mark += (s.currentMark * s.weight)
        end
        weighted_mark /= subjects.sum(:weight)
        return weighted_mark
    end
    helper_method :weight_overall_mark
end
