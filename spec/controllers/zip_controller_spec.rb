require 'rails_helper'

describe ZipController do
  describe "When agent exists in database" do
    let(:params) do
        {
          zip: "12345"
        }
      end

    it "responds with 200 OK" do
      create_agent_in_database

      get :show, params, { format: :json }
      expect(response.status).to eql(200)
    end

    it "responds with json" do
      create_agent_in_database

      get :show, params, { format: :json }
      expect(response.content_type).to eq("application/json")
    end

    it "incudes the model in the response" do
      agent = create_agent_in_database
      get :show, params, { format: :json }

      json = JSON.parse(response.body)

      expect(json["name"]).to eql(agent.name)
      expect(json["street"]).to eql(agent.street)
      expect(json["zip"]).to eql(agent.zip)
      expect(json["city"]).to eql(agent.city)
      expect(json["opening_hours"]).to eql(agent.opening_hours)
    end

    def create_agent_in_database
      Agent.create({
        name: "Posten ICA",
        street: "storgatan 4",
        zip: "12345",
        city: "STOCKHOLM",
        opening_hours: "Må-Fr 8.00-21.00, Lö 8.00-19.00, Sö 9.00-19.00"
      })
    end
  end

  describe "When agent is missing in database" do
    context 'When the agent is updated' do
      let(:params) do
        {
          zip: "12345"
        }
      end

      it "responds with 200 OK" do
        mock_successful_agent_update

        get :show, params, { format: :json }
        expect(response.status).to eql(200)
      end

      it "responds with json" do
        mock_successful_agent_update

        get :show, params, { format: :json }
        expect(response.content_type).to eq("application/json")
      end

      it "incudes the model in the response" do
        mock_successful_agent_update
        agent = fetched_agent

        get :show, params, { format: :json }

        json = JSON.parse(response.body)

        expect(json["name"]).to eql(agent.name)
        expect(json["street"]).to eql(agent.street)
        expect(json["zip"]).to eql(agent.zip)
        expect(json["city"]).to eql(agent.city)
        expect(json["opening_hours"]).to eql(agent.opening_hours)
      end

      def mock_successful_agent_update
        expect_any_instance_of(SaveOrUpdateAgentForZipService).
          to receive(:process).
          and_return(fetched_agent)
      end

      def fetched_agent
        Agent.new({
          name: "Posten ICA",
          street: "storgatan 4",
          zip: "12345",
          city: "STOCKHOLM",
          opening_hours: "Må-Fr 8.00-21.00, Lö 8.00-19.00, Sö 9.00-19.00"
        })
      end
    end

    context 'When the agent update encounters an error' do
      let(:params) do
        {
          zip: "12345"
        }
      end

      it "responds with 503 Service Unavailable" do
        mock_webrunner_with_error

        get :show, params, { format: :json }
        expect(response.status).to eql(503)
      end

      def mock_webrunner_with_error
        allow_any_instance_of(SaveOrUpdateAgentForZipService).
          to receive(:process).
          and_raise
      end
    end
  end
end
