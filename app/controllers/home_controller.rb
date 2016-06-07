class HomeController < ApplicationController
    def show
        #grab the first term
        @term = Term.first

        #Go to welcome screen if no terms exists.
            #If not - go to first subject of first term
       if @term != nil
            @subject = Subject.where(:term_id => @term.id).first
            cid = 0
            if @subject != nil
                cid = @subject.id
            end
            redirect_to :controller => 'grade',
                        :action => 'show',
                        :tid => @term.id,
                        :cid =>cid
        end
    end

    def post_first_term
        #TODO - value validation for course weight
        @term = Term.new(:name => params['termName'])

        if @term.save
            @subject = Subject.new(:name => params['courseName'],:weight => params['weight'], :terms_id => @term.id)
        else
            render 'welcome'
        end

        if @subject.save
            redirect_to "/term/"+@term.id.to_s+"/courses/"+@subject.id.to_s
        else
            render 'welcome'
        end
    end
end
