# MetaReports/lib/concerns/models/post
 
module MetaReports::Concerns::Models::Report
  extend ActiveSupport::Concern
 
  # 'included do' causes the included code to be evaluated in the
  # context where it is included (post.rb), rather than be
  # executed in the module's context (blorgh/concerns/models/post).
  included do
  end
 
  module ClassMethods
    def run
    end

    def view
      'some class method string'
    end
  end
end