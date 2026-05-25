class OllamaService
  OLLAMA_HOST = ENV['OLLAMA_HOST'] || 'http://localhost:11434'
  MODEL = 'llama2'

  def self.health_check
    client = HTTPClient.new
    client.connect_timeout = 5
    client.send_timeout = 5
    client.receive_timeout = 5

    url = "#{OLLAMA_HOST}/api/tags"
    response = client.get(url)

    if response.status == 200
      data = JSON.parse(response.body)
      models = data['models'] || []
      llama2_found = models.any? { |m| m['name']&.include?('llama2') }

      {
        status: 'connected',
        ollama_host: OLLAMA_HOST,
        models_available: models.map { |m| m['name'] },
        llama2_available: llama2_found
      }
    else
      { status: 'error', message: "HTTPステータス: #{response.status}" }
    end
  rescue Errno::ECONNREFUSED
    {
      status: 'error',
      message: "Ollamaに接続できません。#{OLLAMA_HOST} で ollama serve が起動しているか確認してください。"
    }
  rescue Timeout::Error
    {
      status: 'error',
      message: "Ollamaサーバータイムアウト。サーバーが応答していません。"
    }
  rescue => e
    {
      status: 'error',
      message: e.message
    }
  end

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
