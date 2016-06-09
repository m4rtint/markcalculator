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
        @subject = Subject.where(term_id: params[:tid] ,id: params[:cid]).first

        #if url selected subject exists - show it.
            #If url doesn't exist - show the first subject in the term
            #If no subject exist - redirect to /term/:tid screen
        if @subject != nil
            @id = @subject.id
        elsif @subject_index.first != nil
            @id = @subject_index.first.id
        else
            return redirect_to :controller => 'term',
                            :action => 'show_terms',
                            :tid => params[:tid]
        end
        @grades = Grade.where(subject_id: @id)
    end

    def destroy
        cid = params[:cid]
        @grade = Grade.find(params[:id])
        @grade.destroy
        update_subject_grade(Grade.where(subject_id: cid),cid)
        redirect_to action: "show", id:cid
    end

    def post
        #TODO - validate values
        cid = params[:cid]
        cI = params[:courseItem]
        w = params[:worth].pop
        m = params[:mark].pop
        cM = w.to_f*(m.to_f/100)
        @grade = Grade.new(:courseItem => cI,:worth => w, :mark => m,:courseMark => cM, :subject_id => cid)

        if @grade.save
            update_subject_grade(Grade.where(subject_id: cid), cid)
            redirect_to action: "show", id:cid
        else
            render 'new'
        end
    end

    private
        def course_params
                params.require(:course).permit(:courseItem, :worth, :mark, :courseMark, :subject_id)
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
