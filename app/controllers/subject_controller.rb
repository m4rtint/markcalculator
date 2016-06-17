class SubjectController < ApplicationController

    #Grab all the Terms For the Top menu bar in '/Overall' page
    def overall_subjects
        #@terms = Term.where(:user_id => current_user.id)
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

    def post_subjects
        #Value validation
        #check if tid exists
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
        #Find the subject to delete according to the id
        @cid = Subject.find_by(id: params[:id])
            #TODO - check if the subject exists
        #save the term it's linked to
        tid = @cid.term_id
        #delete the model
        @cid.destroy

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
