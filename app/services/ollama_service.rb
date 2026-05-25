class OllamaService
  OLLAMA_HOST = ENV['OLLAMA_HOST'] || 'http://localhost:11434'
  MODEL = 'llama2'

  def self.analyze_cad(file_content, filename)
    prompt = build_prompt(file_content, filename)
    call_ollama(prompt)
  end

  private

  def self.build_prompt(file_content, filename)
    <<~PROMPT
      次のRootproCADファイルを解析してください。

      ファイル名: #{filename}

      ファイル内容:
      #{file_content}

      以下の点について分析してください:
      1. このCADファイルに含まれている要素（図形、テキストなど）
      2. 図面の構成と概要
      3. 改善提案がある場合はその内容
      4. 修正が必要な箇所がある場合はその内容

      分析結果を日本語で詳しく説明してください。
    PROMPT
  end

  def self.call_ollama(prompt)
    client = HTTPClient.new
    url = "#{OLLAMA_HOST}/api/generate"

    request_body = {
      model: MODEL,
      prompt: prompt,
      stream: false
    }.to_json

    response = client.post(
      url,
      request_body,
      { 'Content-Type' => 'application/json' }
    )

    if response.status == 200
      result = JSON.parse(response.body)
      result['response'] || 'レスポンスを取得できませんでした'
    else
      raise "Ollamaエラー: ステータス #{response.status}"
    end
  rescue Timeout::Error
    raise 'Ollamaサーバーにタイムアウトしました。サーバーが起動しているか確認してください。'
  rescue Errno::ECONNREFUSED
    raise 'Ollamaサーバーに接続できません。http://localhost:11434 で起動しているか確認してください。'
  rescue JSON::ParserError
    raise 'Ollamaのレスポンスが無効です'
  end
end
