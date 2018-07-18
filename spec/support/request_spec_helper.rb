module RequestSpecHelper
  # JSONファイルで返ってくるものをRubyのハッシュに変換する
  def json
    JSON.parse(response.body)
  end
end
