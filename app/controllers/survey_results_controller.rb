class SurveyResultsController < BaseController

  def index
    survey = Surveys.find(params[:survey_id])
    respond_to do |format|
      format.csv { send_data survey.to_csv }
    end
  end
end
