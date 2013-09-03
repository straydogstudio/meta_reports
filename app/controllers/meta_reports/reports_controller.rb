require_dependency "meta_reports/application_controller"

module MetaReports
  class ReportsController < ApplicationController

    def index
      @reports = Report.order("meta_reports_reports.title") || []
    end

    def show
      logger.info "reports#show"
      if params[:id].to_s =~ /^\d+$/
        _report = Report.find(params[:id])
      elsif Report.respond_to?(params[:id])
        _report = Report.find_by_name(params[:id])
      else
        redirect_to meta_reports_url, notice: 'That report does not exist'
        return
      end
      @report = _report.run(params)
      template = {template: "meta_reports/reports/templates/" + (@report[:template] || "default") }

      respond_to do |format|
        format.html { render template }
        format.pdf { render template }
        format.xlsx { render template }
      end
      _report.view
    end

    def new
      @report = Report.new
    end

    def edit
      @report = Report.find params[:id]
    end

    def create
      @report = Report.new(params[:report])
      respond_to do |format|
        if @report.save
          flash[:notice] = 'Report was successfully created.'
          format.html { redirect_to(edit_report_path(@report)) }
        else
          format.html { render action: "new" }
        end
      end
    end

    def update
      @report = Report.find params[:id]
      respond_to do |format|
        if @report.update_attributes(params[:meta_report])
          flash[:notice] = 'Report was successfully updated.'
          format.html { redirect_to(edit_report_path(@report)) }
        else
          format.html { render action: "edit" }
        end
      end
    end

    def destroy
      @report.destroy
      
      respond_to do |format|
        format.html { redirect_to(meta_reports_url) }
      end
    end

    def file
      dir = params[:dir].to_sym
      authorize! :view_file, dir
      path = Report::FILE_DIRS[dir] + params[:file]
      if File.exists?(path)
        send_file path, type: "application/pdf", x_sendfile: true, disposition: 'inline'
      else
        puts "file doesn't exist: #{path}"
      end
    end

    def form
      if params[:id].to_s =~ /^\d+$/
        @report = Report.find(params[:id])
      elsif Report.respond_to?(params[:id])
        @report = Report.find_by_name(params[:id])
      else
        # @reports = Report.paginate(page: params[:page])
        redirect_to reports_url, notice: 'That report does not exist'
        return
      end
      authorize! :read, @report
      _layout = request.xhr? ? ((params[:modal] && params[:modal] == 'true') ? 'modal' : false) : true
      respond_to do |format|
        format.html { render "reports/forms/form", locals: {report: @report, modal: (_layout == 'modal')}, layout: _layout }
      end
    end
  end
end
