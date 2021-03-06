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

        #Show all the grades
        @grades = Grade.where(subject_id: cid).order(:created_at)
    end

    #Deleting a grade
    #Data Validation - Check grade + subject id belong to user
    def destroy
        #Validation - Check if course id and grade id belongs to user.
        if check_id(params[:cid], params[:id])
            flash[:danger] = "Try not to delete data that does not belong to you"
            return redirect_to '/'
        end

        grade = Grade.where(:id => params[:id], :subject_id => params[:cid]).first
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

    #Editing a Grade
    #Data Validation - Check Grade + Subject id belong to user
    def update
        #Validation - Check if course id and grade id belongs to user
        if check_id(params[:cid],params[:id])
            flash[:danger] = "Try not to edit data that does not belong to you"
            return redirect_to '/'
        end

        #Get the grade active record that needs editing
        grade = Grade.where(:id => params[:id], :subject_id => params[:cid]).first

        #Edit active record
        grade.courseItem = params[:courseItem]
        grade.worth = params[:worth]
        grade.mark = params[:mark]
        grade.courseMark = "%.2f" % (params[:worth].to_f*(params[:mark].to_f/100))
        grade.subject_id = params[:cid]

        #Data Validation
        if !grade.valid?
            flash[:danger] = "Please Input Valid Values"
            return redirect_to '/'
        elsif grade.save
            update_subject_grade(Grade.where(subject_id: params[:cid]), params[:cid])
            return redirect_to action:"show", id:params[:cid]
        else
            flash[:warning] = "A Random Bug Occursed, Please Try Again"
            return redirect_to '/'
        end
    end

    # Posting a new courseItem grade on main page
    # Make sure cid belongs to user
    # Data Validation - Check Txt Field is not Blank
    def post
        # Make sure cid belongs to user
        if check_id(params[:cid])
            flash[:danger] = "Try not to post in places that doesn't belong to you"
            return redirect_to '/'
        end

        @grade = Grade.new(:courseItem => params[:courseItem],
                        :worth => params[:worth],
                        :mark => params[:mark],
                        :courseMark => "%.2f" % (params[:worth].to_f*(params[:mark].to_f/100)),
                        :subject_id => params[:cid])

        #Data Validation - Blank values
        if !@grade.valid?
            flash[:danger] = "Please Input Valid Values"
            return redirect_to '/'
        elsif @grade.save
            update_subject_grade(Grade.where(subject_id: params[:cid]), params[:cid])
            return redirect_to action: "show",
                                id:params[:cid]
        else
            flash[:warning] = "A Random Bug Occured, Please Try Again"
            return redirect_to '/'
        end
    end

    #Updates overall subject grade
    def update_subject_grade(all_grades,cid)
        currentMark = mark_per(all_grades.sum("worth"), all_grades.sum("courseMark"))
        Subject.update(cid, :currentMark => currentMark)
    end

    def mark_per(worth,mark)
        "%.2f" % (mark.to_f/worth.to_f*100)
    end
    helper_method :mark_per
end
