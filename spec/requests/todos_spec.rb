require 'rails_helper'

RSpec.describe 'Todos API', type: :request do
  let!(:todos) { create_list(:todo, 10) }
  let(:todo_id) { todos.first.id }

  # GET /todos に関するテスト
  describe 'GET /todos' do
    # GETリクエストを送る
    before { get '/todos' }

    # 「GET /todos」を叩いたときレコードが空でなく，10個存在することを確認する
    it 'returns todos' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    # 「GET /todos」を叩いたときリクエストが正常であれば，ステータスコード200を返す
    it 'returns status 200' do
      expect(response).to have_http_status(200)
    end
  end

  # GET /todos/id に関するテスト
  describe 'GET /todos/:id' do
    # GETリクエストを送る
    before { get "/todos/#{todo_id}" }

    # レコードが存在する場合
    context 'when the record exists' do
      # 「GET /todos/:id」を叩いたとき該当IDのレコードが存在すれば，
      # そのレコードが空でなくidがtodo_idと同じか確認する
      it 'returns the todo' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(todo_id)
      end

      # 「GET /todos/:id」を叩いたときリクエストが正常であれば，ステータスコード200を返す
      it 'returns status 200' do
        expect(response).to have_http_status(200)
      end
    end

    # レコードが存在しない場合
    context 'when the record does not exist' do
      let(:todo_id) { 100 }

      # 「GET /todos/:id」を叩いたときに該当レコードがなければ，ステータスコード404を返す
      it 'returns status 404' do
        expect(response).to have_http_status(404)
      end

      # 「GET /todos/:id」を叩いたときに該当レコードがなければ，エラーメッセージを返す
      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Todo/)
      end
    end
  end

  # POST /todos に関するテスト
  describe 'POST /todos' do
    let(:valid_attributes) { { title: 'Learn Elm', created_by: '1' } }

    # 有効なリクエストの場合
    context 'when the request is valid' do
      before { post '/todos', params: valid_attributes }

      # 「POST /todos」を叩いたときリクエストが正常であれば，「Learn Elm」というtodoを作成できているか確認する
      it 'creates a todo' do
        expect(json['title']).to eq('Learn Elm')
      end

      # 「POST /todos」を叩いたときリクエストが正常であれば，ステータスコード201を返す
      it 'returns status 201' do
        expect(response).to have_http_status(201)
      end
    end

    # 無効なリクエストの場合
    context 'when the request is invalid' do
      before { post '/todos', params: { title: 'Foobar' } }

      # 「POST /todos」を叩いたときリクエストが異常であれば，ステータスコード422を返す
      it 'returns status 422' do
        expect(response).to have_http_status(422)
      end

      # 「POST /todos」を叩いたときリクエストが異常であれば，エラーメッセージを返す
      it 'returns a validation failure message' do
        expect(response.body).to match(/Validation failed: Created by can't be blank/)
      end
    end
  end

  # PUT /todos/:id に関するテスト
  describe 'PUT /todos/:id' do
    let(:valid_attributes) { { title: 'Shopping' } }

    # レコードが存在する場合
    context 'when the record exists' do
      before { put "/todos/#{todo_id}", params: valid_attributes }

      # 「PUT /todos/:id」を叩いたとき該当IDのレコードが存在すれば，それが空であることを確認する
      it 'updates the record' do
        expect(response.body).to be_empty
      end

      # 「PUT /todos/:id」を叩いたときリクエストが正常であれば，ステータスコード204を返す
      it 'returns status 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  # DELETE /todos/:id に関するテスト
  describe 'DELETE /todos/:id' do
    before { delete "/todos/#{todo_id}" }

    # 「DELETE /todos/:id」を叩いたときリクエストが正常であれば，ステータスコード204を返す
    it 'returns status 204' do
      expect(response).to have_http_status(204)
    end
  end
end
