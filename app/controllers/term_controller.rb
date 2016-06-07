class TermController < ApplicationController
    def show_terms
        @terms = Term.all
        @subject = Subject.where(:term_id => params[:tid]).first
        if @subject != nil
            redirect_to :controller => 'grade',
                        :action => 'show',
                        :tid => params[:tid],
                        :cid => @subject.id
        end
    end

    def post_terms
        @term = Term.new(:name => params['termName'])
        if @term.save
            redirect_to :action => 'show_terms', :controller => 'term',  :tid => @term.id
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
            redirect_to "/welcome"
        else
            redirect_to :controller => 'term',
                        :action => 'show_terms',
                        :tid => @term_first.id
        end
    end

end
