class GradeController < ApplicationController
    def show
    #Show all the terms - top Menu bar
    #Check for any terms
        @terms = Term.where(:user_id => current_user.id)
        if @terms.blank?
            return redirect_to :controller => 'start',
                               :action => 'show'

        #Check if Term user belongs to the user - else get first term
        elsif !Term.where(:user_id => current_user.id, :id => params[:tid]).present?
            return redirect_to :controller => 'term',
                        :action => 'show_terms',
                        :tid => @terms.first.id
        end

        #Show all subject within the term - second Menu Bar
        @subject_index = Subject.where(term_id: params[:tid])


        #Grab :cid/:tid selected specific subject grades.
        subject = Subject.where(term_id: params[:tid] ,id: params[:cid]).first

        #if url selected subject exists - show it.
            #If url doesn't exist - show the first subject in the term
            #If no subject exist - redirect to /term/:tid screen
        if subject != nil
            cid = subject.id
        elsif @subject_index.first != nil
            cid = @subject_index.first.id
        else
            return redirect_to :controller => 'term',
                            :action => 'show_terms',
                            :tid => params[:tid]
        end
        @grades = Grade.where(subject_id: cid)
    end

    #Deleting a grade
    #Data Validation - Check grade + subject id belong to user
    def destroy
        #Validation - Check if course id and grade id belongs to user.
        grade = Grade.where(:id => params[:id], :subject_id => params[:cid]).first
        subjectCheck = Subject.where(:id => params[:cid]).first

        #Check if params[:cid] and params[:id] are empty
        if subjectCheck.blank? || grade.blank?||
            !Term.where(:user_id => current_user.id, :id => subjectCheck.term_id).present?
                flash[:danger] = "Try not to delete data that does not belong to you"
                return redirect_to '/'
        end

        #Check if destroy works
        if grade.destroy
            update_subject_grade(Grade.where(subject_id: params[:cid]),params[:cid])
            redirect_to action: "show", id:params[:cid]
        else
            flash[:warning] = "A Random Bug Occured, Please Try Again"
            redirect_to action: "show",
                                id:0
        end
    end

    # Posting a new courseItem grade on main page
    # Data Validation - Check Txt Field is not Blank
    # Make sure cid belongs to user
    def post
        @grade = Grade.new(:courseItem => params[:courseItem],
                        :worth => params[:worth],
                        :mark => params[:mark],
                        :courseMark => "%.2f" % (params[:worth].to_f*(params[:mark].to_f/100)),
                        :subject_id => params[:cid])

        #Data Validation - Blank values
        if !@grade.valid?
            flash[:danger] = "Please Input Valid Values"
            return redirect_to action: "show",
                                id:0
        elsif @grade.save
            update_subject_grade(Grade.where(subject_id: params[:cid]), params[:cid])
            return redirect_to action: "show",
                                id:params[:cid]
        else
            flash[:warning] = "A Random Bug Occured, Please Try Again"
            return redirect_to action: "show",
                                id:0
        end
    end

    def update_subject_grade(all_grades,cid)
        currentMark = mark_per(all_grades.sum("worth"), all_grades.sum("courseMark"))
        Subject.update(cid, :currentMark => currentMark)
    end

    def mark_per(worth,mark)
        "%.2f" % (mark.to_f/worth.to_f*100)
    end
    helper_method :mark_per
end
