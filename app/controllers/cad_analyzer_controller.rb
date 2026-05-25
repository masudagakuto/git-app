class CadAnalyzerController < ApplicationController
  def index
  end

  def analyze
    unless params[:file].present?
      return render json: { error: 'ファイルが選択されていません' }, status: :bad_request
    end

    file = params[:file]
    unless file.original_filename.end_with?('.rpcd')
      return render json: { error: '.rpcdファイルのみ対応しています' }, status: :bad_request
    end

    begin
      file_content = file.read.force_encoding('UTF-8')

      analysis = OllamaService.analyze_cad(file_content, file.original_filename)

      render json: {
        filename: file.original_filename,
        analysis: analysis
      }
    rescue => e
      render json: { error: "解析エラー: #{e.message}" }, status: :internal_server_error
    end
  end
end
